local nvim_lsp = require("lspconfig")
local completion_caps = require("cmp_nvim_lsp").default_capabilities()

-- vim.lsp.set_log_level("debug")

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
end

nvim_lsp.kotlin_language_server.setup({
	on_attach = on_attach,
	capabilities = completion_caps,
})

nvim_lsp.sorbet.setup({
	cmd = { "srb", "tc", "--lsp", "-vvv" },
	root_dir = nvim_lsp.util.root_pattern("sorbet", "Gemfile"),
	on_attach = on_attach,
	capabilities = completion_caps,
})

nvim_lsp.flow.setup({
	on_attach = on_attach,
	on_new_config = function(new_config, new_root_dir)
		new_config.cmd = { new_root_dir .. "/node_modules/.bin/flow", "lsp" }
	end,
	capabilities = completion_caps,
})

nvim_lsp.tsserver.setup({
	-- cmd = { "typescript-language-server", "--stdio", "--log-level=4", "--tsserver-log-file=/Users/david/ts-log.log", "--tsserver-log-verbosity=verbose" },
	settings = {
		diagnostics = {
			ignoredCodes = { 80006 },
		},
	},
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false

		on_attach(client, bufnr)
	end,
	capabilities = completion_caps,
})

nvim_lsp.rust_analyzer.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false

		on_attach(client, bufnr)
	end,
	capabilities = completion_caps,
})

nvim_lsp.sourcekit.setup({
	on_attach = on_attach,
	capabilities = completion_caps,
})

nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = completion_caps,
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
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
