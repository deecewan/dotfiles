local nvim_lsp = require('lspconfig')

-- vim.lsp.set_log_level("debug")

local on_attach = function (client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

nvim_lsp.kotlin_language_server.setup{
  cmd = { "/Users/david/Downloads/server/bin/kotlin-language-server" },
  on_attach = on_attach,
}

nvim_lsp.sorbet.setup{
  cmd = { "srb", "tc", "--lsp", "-vvv" },
  root_dir = nvim_lsp.util.root_pattern("sorbet", "Gemfile"),
  on_attach = on_attach,
}

nvim_lsp.flow.setup{
  on_attach = on_attach,
  on_new_config = function (new_config, new_root_dir)
    new_config.cmd = { new_root_dir .. "/node_modules/.bin/flow", "lsp" }
  end
}

nvim_lsp.tsserver.setup{
  -- cmd = { "typescript-language-server", "--stdio", "--log-level=4", "--tsserver-log-file=/Users/david/ts-log.log", "--tsserver-log-verbosity=verbose" },
  settings = {
    diagnostics = {
      ignoredCodes = { 80006 }
    }
  },
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  on_attach = function (client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
}

nvim_lsp.rust_analyzer.setup{
  on_attach = function (client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    on_attach(client, bufnr)
  end,
}

nvim_lsp.sourcekit.setup {
  on_attach = on_attach,
}
