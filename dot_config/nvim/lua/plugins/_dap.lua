return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "suketa/nvim-dap-ruby",
      "jbyuki/one-small-step-for-vimkind",
    },
    lazy = true,
    keys = { "<leader>d" },
    config = function()
      local dap = require("dap")
      dap.set_log_level("TRACE")

      require("nvim-dap-virtual-text").setup({})
      require("dap-ruby").setup()

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "(debug) toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "(debug) continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "(debug) step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "(debug) step into" })

      dap.adapters.cppdbg = {
        id = "cppdbg",
        name = "vscode-cpptools",
        type = "executable",
        command = "OpenDebugAD7",
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input({
              prompt = "Path to executable: ",
              default = vim.fn.getcwd() .. "/",
              completion = "file",
            })
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          MIMode = "lldb",
        },
      }

      local js = {
        id = "cppdbg",
        name = "vscode-cpptools",
        type = "executable",
        command = "OpenDebugAD7",
      }
      dap.adapters.javascript = js
      dap.adapters.typescript = js
      dap.adapters.typescriptreact = js
      dap.adapters.javascriptreact = js

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        }
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end

      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
          cmp.config.sources({
            { name = "dap" },
          }),
        })
      end

      vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
  }
}
