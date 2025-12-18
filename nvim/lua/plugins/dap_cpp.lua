-- ============================================================================
-- Complete C/C++ Debugging Setup for LazyVim
-- GDB + DAP (Debug Adapter Protocol) + UI
-- ============================================================================

return {
  -- ========== DAP (Debug Adapter Protocol) ==========
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI Components
      "rcarriga/nvim-dap-ui", -- Beautiful debug UI
      "theHamsta/nvim-dap-virtual-text", -- Show variable values inline
      "nvim-telescope/telescope-dap.nvim", -- Telescope integration

      -- C/C++ Adapter
      "jay-babu/mason-nvim-dap.nvim", -- Auto-install debuggers via Mason
    },

    keys = {
      -- ========== ESSENTIAL SHORTCUTS (Memorize These!) ==========
      -- Start/Stop
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Debug: Terminate",
      },

      -- Breakpoints
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Conditional Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Debug: Clear All Breakpoints",
      },

      -- UI
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Debug: Evaluate Expression",
        mode = { "n", "v" },
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Debug: Hover Variables",
      },

      -- Navigation
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Debug: Open REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug: Run Last",
      },

      -- Telescope Integration
      { "<leader>df", "<cmd>Telescope dap frames<cr>", desc = "Debug: Frames" },
      { "<leader>dv", "<cmd>Telescope dap variables<cr>", desc = "Debug: Variables" },
      { "<leader>dC", "<cmd>Telescope dap commands<cr>", desc = "Debug: Commands" },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ========== C/C++ ADAPTER CONFIGURATION ==========
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7", -- Installed via Mason
      }

      -- GDB Adapter (Alternative)
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      -- ========== C/C++ DEBUG CONFIGURATIONS ==========
      dap.configurations.c = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        {
          name = "Launch with arguments",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        },
        {
          name = "Attach to process",
          type = "cppdbg",
          request = "attach",
          processId = require("dap.utils").pick_process,
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- Use same config for C++
      dap.configurations.cpp = dap.configurations.c

      -- ========== DAP UI SETUP ==========
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.33 }, -- Variables
              { id = "breakpoints", size = 0.17 },
              { id = "stacks", size = 0.25 }, -- Call stack
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 }, -- Debug console
              { id = "console", size = 0.5 }, -- Program output
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
      })

      -- ========== AUTO OPEN/CLOSE UI ==========
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ========== VIRTUAL TEXT (Show variable values inline) ==========
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = "<module",
        virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- ========== SIGNS (Breakpoint icons) ==========
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "🟡", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "▶️", texthl = "DiagnosticHint", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "DiagnosticError", linehl = "", numhl = "" })

      -- ========== TELESCOPE INTEGRATION ==========
      require("telescope").load_extension("dap")
    end,
  },

  -- ========== MASON DAP (Auto-install debuggers) ==========
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason.nvim" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true, -- Auto-install debuggers
      handlers = {},
      ensure_installed = {
        "cppdbg", -- C/C++ debugger
      },
    },
  },
}
