local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "gbprod/none-ls-shellcheck.nvim", "nvimtools/none-ls-extras.nvim" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			debug = true,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(format_client)
									return format_client.name == "null-ls"
								end,
								timeout = 10000,
							})
						end,
					})
				end
			end,
			sources = {
				-- null_ls.builtins.formatting.rustfmt,
				null_ls.builtins.formatting.stylua,

				require('none-ls-shellcheck.diagnostics').with({
					diagnostics_format = "[#{c}] #{m} (#{s})",
				}),
        require("none-ls-shellcheck.code_actions"),

				null_ls.builtins.formatting.rubocop.with({
					condition = function(utils)
						return utils.root_has_file({ ".rubocop.yml" })
					end,
				}),

				null_ls.builtins.diagnostics.rubocop.with({
					condition = function(utils)
						return utils.root_has_file({ ".rubocop.yml" })
					end,
				}),
				null_ls.builtins.formatting.prettier.with({
					extra_filetypes = { "ruby" },
					condition = function(utils)
						-- https://prettier.io/docs/en/configuration.html
						local has_file = utils.root_has_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.json5",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettier.config.js",
							".prettier.config.cjs",
							".prettierrc.toml",
						})

						if has_file then
							return has_file
						end

						if utils.root_has_file("package.json") then
							local file = io.open("package.json")
							if not file then
								return false
							end
							local content = file:read("*all")
							file:close()

							local parsed = vim.json.decode(content)

							if not parsed then
								return false
							end

							return parsed["prettier"] ~= nil
						end
					end,
				}),
				require("none-ls.code_actions.eslint_d").with({}),
				require("none-ls.formatting.eslint_d").with({}),
				require("none-ls.diagnostics.eslint_d").with({}),
				null_ls.builtins.diagnostics.selene.with({
					extra_args = {
						"--config",
						vim.fn.expand("~/.config/nvim/selene.toml"),
					},
				}),
			},
		})
	end,
}
