local nvim_lsp = require("lspconfig")
local util = require("lspconfig.util")
local ms = require("vim.lsp.protocol").Methods

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

-- vim.lsp.set_log_level("debug")

vim.lsp.handlers[ms.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
	local opts = {
		buffer = bufnr,
	}

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set(
		"n",
		"<leader>lc",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", opts, { desc = "show lsp code actions" })
	)

	vim.keymap.set(
		"n",
		"<leader>lr",
		vim.lsp.buf.rename,
		vim.tbl_extend("force", opts, { desc = "rename the item under the cursor" })
	)

	vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "format the file" }))
	vim.keymap.set("v", "F", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "format the range" }))

	if client.supports_method(ms.textDocument_formatting) then
		vim.api.nvim_clear_autocmds({ group = formatting_group, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = formatting_group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end
end

nvim_lsp.kotlin_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lsp.sorbet").setup(on_attach, capabilities)

nvim_lsp.flow.setup({
	on_attach = on_attach,
	on_new_config = function(new_config, new_root_dir)
		new_config.cmd = { new_root_dir .. "/node_modules/.bin/flow", "lsp" }
	end,
	capabilities = capabilities,
})

nvim_lsp.ts_ls.setup({
	settings = {
		diagnostics = {
			ignoredCodes = { 80006 },
		},
	},
	filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormatting = false
		client.server_capabilities.documentRangeFormatting = false

		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

nvim_lsp.rust_analyzer.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormatting = false
		client.server_capabilities.documentRangeFormatting = false
		client.server_capabilities.documentFormattingProvider = false

		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

nvim_lsp.sourcekit.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.clangd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.syntax_tree.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	-- we only wanna run this in a directory with a .streerc
	root_dir = util.root_pattern(".streerc"),
})

nvim_lsp.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.taplo.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
