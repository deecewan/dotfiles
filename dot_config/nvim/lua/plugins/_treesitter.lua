return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- One of "all", "maintained" (parsers with maintainers), or a list of languages
			ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
				"rust",
				"bash",
				"lua",
				"graphql",
				"css",
				"html",
				"java",
				"json",
				"json5",
				"jsonc",
				"kotlin",
				"markdown",
				"ruby",
				"vim",
				"yaml",
			},
			-- Install languages synchronously (only applied to `ensure_installed`)
			sync_install = false,
			indent = {
				enable = true,
			},
			highlight = {
				enable = true,
			},
		})
	end,
}
