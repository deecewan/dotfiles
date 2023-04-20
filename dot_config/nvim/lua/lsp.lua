local nvim_lsp = require("lspconfig")

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

-- vim.lsp.set_log_level("debug")

local on_attach = function(_, bufnr)
	local opts = {
		buffer = bufnr,
	}

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

-- vim.lsp.start({
--   name = 'pretty-ts-errors',
--   cmd = {'name-of-language-server-executable'},
--   root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
-- })

nvim_lsp.kotlin_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.sorbet.setup({
	cmd = { "srb", "tc", "--lsp", "-vvv" },
	root_dir = nvim_lsp.util.root_pattern("sorbet", "Gemfile"),
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		highlightUntyped = true,
	},
})

nvim_lsp.flow.setup({
	on_attach = on_attach,
	on_new_config = function(new_config, new_root_dir)
		new_config.cmd = { new_root_dir .. "/node_modules/.bin/flow", "lsp" }
	end,
	capabilities = capabilities,
})

nvim_lsp.tsserver.setup({
	cmd = {
		"typescript-language-server",
		"--stdio",
		"--log-level=4",
		"--tsserver-log-file=/Users/david/ts-log.log",
		"--tsserver-log-verbosity=verbose",
	},
	settings = {
		diagnostics = {
			ignoredCodes = { 80006 },
		},
	},
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
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

nvim_lsp.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					vim.api.nvim_get_runtime_file("", true),
					vim.fn.expand("~/.config/nvim"),
				},
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
