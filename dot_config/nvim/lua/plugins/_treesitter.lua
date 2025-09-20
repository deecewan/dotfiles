return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
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
			})
		end,
	},
	"IndianBoy42/tree-sitter-just",
}
