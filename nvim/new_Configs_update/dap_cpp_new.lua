return {
  -- ========== DAP (Debug Adapter Protocol) ==========
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },

    keys = {
      -- Standard Keymaps
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
        desc = "Debug: Conditional",
      },
      {
        "<leader>dc",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Debug: Clear All",
      },
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
        desc = "Debug: Eval",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Debug: Hover",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Debug: REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug: Run Last",
      },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ======================================================================
      -- AUTO-DETECTION: Check for System GDB to save space (School PC)
      -- ======================================================================
      local has_system_gdb = vim.fn.executable("/usr/bin/gdb") == 1 or vim.fn.executable("gdb") == 1
      local adapter_type = "cppdbg" -- Default to Mason

      if has_system_gdb then
        adapter_type = "gdb" -- Switch to System GDB
        -- Define GDB Adapter
        dap.adapters.gdb = {
          type = "executable",
          command = "gdb", -- Assumes in PATH or /usr/bin/gdb
          args = { "-i", "dap" },
        }
      end

      -- Ensure cppdbg is defined (if falling back or using Mason)
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }

      -- ========== CONFIGURATIONS ==========
      dap.configurations.c = {
        {
          name = string.format("Launch (Using %s)", adapter_type:upper()),
          type = adapter_type, -- Dynamically chosen
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
          type = adapter_type,
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
          type = adapter_type,
          request = "attach",
          processId = require("dap.utils").pick_process,
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- Use same for C++
      dap.configurations.cpp = dap.configurations.c

      -- UI Setup
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
              { id = "scopes", size = 0.33 },
              { id = "breakpoints", size = 0.17 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = { max_height = nil, max_width = nil, border = "rounded", mappings = { close = { "q", "<Esc>" } } },
        windows = { indent = 1 },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Virtual Text & Signs
      require("nvim-dap-virtual-text").setup({ enabled = true })
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DiagnosticHint", linehl = "DapStoppedLine" })
    end,
  },

  -- ========== MASON DAP (Auto-install debuggers) ==========
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      -- Check for system GDB again to decide installation
      local has_system_gdb = vim.fn.executable("/usr/bin/gdb") == 1 or vim.fn.executable("gdb") == 1

      opts.ensure_installed = opts.ensure_installed or {}

      if has_system_gdb then
        -- If we have System GDB, we do NOT need to download cppdbg
        -- We remove it from provision list
        for i, tool in ipairs(opts.ensure_installed) do
          if tool == "cppdbg" then
            table.remove(opts.ensure_installed, i)
            break
          end
        end
      else
        -- Only install if we DON'T have a system debugger
        if not vim.tbl_contains(opts.ensure_installed, "cppdbg") then
          table.insert(opts.ensure_installed, "cppdbg")
        end
      end

      -- Don't force auto-install if we are relying on system tools
      opts.automatic_installation = not has_system_gdb
    end,
  },
}
