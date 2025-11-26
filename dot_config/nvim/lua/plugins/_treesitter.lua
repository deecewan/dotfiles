return {
	{ "rafcamlet/nvim-luapad" },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local installable = {
				"bash",
				"css",
				"graphql",
				"html",
				"java",
				"javascript",
				"json",
				"json5",
				"jsonc",
				"kotlin",
				"lua",
				"markdown",
				"ruby",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"yaml",
				"markdown_inline",
			}

			local to_install = {}
			for _, lang in ipairs(installable) do
				if not require("nvim-treesitter").get_installed(lang) then
					table.insert(to_install, lang)
				end
			end

			require("nvim-treesitter").install({})
		end,
	},
	"IndianBoy42/tree-sitter-just",
}
