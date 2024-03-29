local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
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

        null_ls.builtins.diagnostics.shellcheck.with({
          diagnostics_format = "[#{c}] #{m} (#{s})",
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
        null_ls.builtins.code_actions.eslint.with({}),
        null_ls.builtins.formatting.eslint_d.with({}),
        null_ls.builtins.diagnostics.eslint.with({}),
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
