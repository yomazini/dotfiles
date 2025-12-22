return {
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      connections = {
        ssh_configs = {
          vim.fn.expand("$HOME") .. "/.ssh/config",
          "/etc/ssh/ssh_config",
        },
        sshfs_args = {
          "-o reconnect",
          "-o ConnectTimeout=5",
          "-o ServerAliveInterval=15",
          "-o dir_cache=yes",
          "-o auto_cache",
          "-o Ciphers=aes128-ctr",
        },
      },
      mounts = {
        base_dir = vim.fn.expand("$HOME") .. "/.sshfs_mounts",
        unmount_on_exit = true,
      },
      handlers = {
        on_connect = {
          change_dir = true,
        },
        on_disconnect = {
          clean_mount_folders = true,
        },
      },
      ui = {
        confirm = {
          connect = true,
          change_dir = false,
        },
      },
    },
    config = function(_, opts)
      require("remote-sshfs").setup(opts)
      -- Load Telescope Extension
      require("telescope").load_extension("remote-sshfs")

      -- Keymaps
      local api = require("remote-sshfs.api")
      vim.keymap.set("n", "<leader>rc", api.connect, { desc = "Remote: Connect" })
      vim.keymap.set("n", "<leader>rd", api.disconnect, { desc = "Remote: Disconnect" })
      vim.keymap.set("n", "<leader>rf", api.find_files, { desc = "Remote: Find Files" })
      vim.keymap.set("n", "<leader>rg", api.live_grep, { desc = "Remote: Grep (Caution!)" })
    end,
  },
}
