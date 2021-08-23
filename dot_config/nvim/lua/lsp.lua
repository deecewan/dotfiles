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

  -- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

 vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
end

nvim_lsp.sorbet.setup{
  cmd = { "srb", "tc", "--lsp", "--no-config", "--dir", ".", "--ignore=/spec", "--ignore=/node_modules" },
  root_dir = nvim_lsp.util.root_pattern("sorbet", "Gemfile"),
  on_attach = on_attach,
  on_new_config = function (new_config, new_root_dir)
    new_config.cmd = { "srb", "tc", "--lsp", "--no-config", "--dir", new_root_dir, "--ignore=/spec", "--ignore=/node_modules" }
  end
}

nvim_lsp.flow.setup{
  on_attach = on_attach,
  on_new_config = function (new_config, new_root_dir)
    new_config.cmd = { new_root_dir .. "/node_modules/.bin/flow", "lsp" }
  end
}

nvim_lsp.tsserver.setup{
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  on_attach = on_attach,
}

nvim_lsp.diagnosticls.setup{
  filetypes = { "ruby", "javascript", "sh", "bash" },
  -- this needs to be kept up to date with all the rootPatterns below
  root_dir = nvim_lsp.util.root_pattern(".git"),
  init_options = {
    filetypes = {
      javascript = { "eslint", "prettier" },
      ruby = { "rubocop", "prettier" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    },
    formatFiletypes = {
      javascript = 'prettier',
      ruby = { "rubocop", "prettier" },
    },
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "./node_modules/.bin/eslint",
        rootPatterns = { ".eslintrc", ".eslintrc.js" },
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json",
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${ruleId}]",
          security = "severity",
        },
        securities = {
          [2] = "error",
          [1] = "warning",
        },
      },
      rubocop = {
        sourceName = "rubocop",
        rootPatterns = { ".rubocop.yml" },
        command = "rubocop",
        args = {
          "--stdin",
          "%filepath",
          "--format",
          "json",
        },
        parseJson = {
          errorsRoot = "files.[0].offenses",
          line = "location.start_line",
          column = "location.start_column",
          endLine = "location.last_line",
          endColumn = "location.last_column",
          message = "${message} [${cop_name}]",
          security = "severity",
        },
        securities = {
          fatal = "error",
          error = "error",
          warning = "warning",
          convention = "info",
          refactor = "info",
          info = "info",
        },
      },
      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = { "-x", "--format", "json", "-" },
        sourceName = "shellcheck",
        parseJson = {
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${code}]",
          security = "level"
        },
        securities = {
          error = "error",
          warning = "warning",
          info = "info",
          style = "hint",
        },
      },
    },
    formatters = {
      prettier = {
        command = './node_modules/.bin/prettier',
        rootPatterns = { ".prettierrc.json" },
        args = { '--stdin-filepath', '%filename' },
      }
    }
  },
}
