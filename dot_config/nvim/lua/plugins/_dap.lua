return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "suketa/nvim-dap-ruby",
  },
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
  end,
}
