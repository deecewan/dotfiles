return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()

		local reg = require("mason-registry")
		local should_install = true

		---@param name string
		local install_if_missing = function(name)
			if not should_install then
				return
			end
			if not reg.is_installed(name) then
				local ok, package = pcall(reg.get_package, name)

				if ok then
					vim.notify(("[mason] installing %s"):format(name))
					package:install()
				end
			end
		end

		---@param names string[]
		local ensure_installed = function(names)
			for n = 1, #names do
				local name = names[n]
				install_if_missing(name)
			end
		end

		ensure_installed({
			"selene",
			"stylua",
			"lua-language-server",

			"cpptools",
			"js-debug-adapter",
			"taplo",
		})
	end,
}
