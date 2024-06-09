return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"rcarriga/cmp-dap",
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			native_menu = false,
			preselect = cmp.PreselectMode.None,
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "crates" },
			}, {
				{
					name = "buffer",
					option = {
						get_bufnrs = function()
							return vim.api.nvim_list_bufs()
						end,
					},
				},
			}),
		})

		cmp.setup.filetype("lua", {
			cmp.config.sources({
				{ name = "nvim_lua" },
				{ name = "lazydev", group_index = 0 },
			}),
		})
	end,
}
