local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

---comes from none-ls.nvim. i can't figure out how to actually import the types
---@class ConditionalUtils
---@field has_file fun(patterns: ...): boolean checks if file exists
---@field root_has_file fun(patterns: ...): boolean checks if file exists at root level
---@field root_has_file_matches fun(pattern: string): boolean checks if pattern matches a file at root level
---@field root_matches fun(pattern: string): boolean checks if root matches pattern

---gets the package.json
---@param utils ConditionalUtils
---@returns table?
local function parse_package_json(utils)
	if utils.root_has_file("package.json") then
		local file = io.open("package.json")
		if not file then
			return nil
		end
		local content = file:read("*all")
		file:close()

		local parsed = vim.json.decode(content)

		return parsed
	end
end

return {
	"nvimtools/none-ls.nvim",
	lazy = true,
	event = "VeryLazy",
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

				require("none-ls-shellcheck.diagnostics").with({
					diagnostics_format = "[#{c}] #{m} (#{s})",
				}),
				require("none-ls-shellcheck.code_actions"),

				null_ls.builtins.diagnostics.rubocop.with({
					condition = function(utils)
						return utils.root_has_file({ ".rubocop.yml" })
					end,
				}),
				null_ls.builtins.formatting.prettier.with({
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

						local pjson = parse_package_json(utils)
						return pjson and pjson.prettier ~= nil
					end,
				}),
				require("none-ls.code_actions.eslint_d").with({}),
				require("none-ls.formatting.eslint_d"),
				require("none-ls.diagnostics.eslint_d"),
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
