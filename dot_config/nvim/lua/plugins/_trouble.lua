return {
	"folke/trouble.nvim",
	-- "~/projects/folke/trouble.nvim",
	dependencies = "kyazdani42/nvim-web-devicons",
	config = function()
		local trouble = require("trouble")

		trouble.setup({
			auto_close = true,
			mode = "document_diagnostics",
			auto_jump = { "lsp_definitions" },
		})

		local toggle_mode = function(mode)
			return function()
				trouble.toggle({ mode = mode })
			end
		end

		vim.keymap.set("n", "<leader>tt", trouble.toggle, { desc = "toggle trouble" })
		vim.keymap.set(
			"n",
			"<leader>tw",
			toggle_mode("workspace_diagnostics"),
			{ desc = "toggle workspace diagnostics" }
		)
		vim.keymap.set("n", "<leader>td", toggle_mode("document_diagnostics"), { desc = "toggle document diagnostics" })
		vim.keymap.set("n", "<leader>tq", toggle_mode("quickfix"), { desc = "toggle quickfix" })
		vim.keymap.set("n", "<leader>tl", toggle_mode("loclist"), { desc = "toggle loclist" })
		vim.keymap.set("n", "gR", toggle_mode("lsp_references"), { desc = "show lsp references" })
		vim.keymap.set("n", "gd", toggle_mode("lsp_definitions"), { desc = "show lsp definitions" })
	end,
}
