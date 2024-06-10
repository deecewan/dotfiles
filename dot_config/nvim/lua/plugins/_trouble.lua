local trouble = require("trouble")

return {
	"folke/trouble.nvim",
	-- "~/projects/folke/trouble.nvim",
	lazy = true,
	dependencies = "kyazdani42/nvim-web-devicons",
	cmd = { "Trouble" },
	keys = {
		"<leader>t",
		"gd",
		"gR",
	},
	config = function()
		trouble.setup()

    ---@param opts string | table
    ---@return function
		local toggle_trouble = function(opts)
      local config
      if type(opts) == "string" then
        config = { mode = opts }
      else
        config = opts
      end


			return function()
				trouble.toggle(config)
			end
		end

		vim.keymap.set("n", "<leader>tt", toggle_trouble("diagnostics"), { desc = "toggle trouble workspace diagnostics" })
		vim.keymap.set("n", "<leader>td", toggle_trouble({ mode = "diagnostics", filter = { buf = 0 } }), { desc = "toggle document diagnostics" })
		vim.keymap.set("n", "<leader>tq", toggle_trouble("quickfix"), { desc = "toggle quickfix" })
		vim.keymap.set("n", "<leader>tl", toggle_trouble("loclist"), { desc = "toggle loclist" })
		vim.keymap.set("n", "gR", toggle_trouble("lsp_references"), { desc = "show lsp references" })
		vim.keymap.set("n", "gd", toggle_trouble("lsp_definitions"), { desc = "show lsp definitions" })
	end,
}
