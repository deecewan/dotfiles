-- follow the leader
vim.g.mapleader = " "

-- allow pretty colors in the terminal
vim.o.termguicolors = true
-- allow hidden buffers - can background a changed buffer
vim.o.hidden = true
-- a tab looks like 2 spaces
vim.o.tabstop = 2
-- we move forward + backward by 2 spaces at a time
vim.o.shiftwidth = 2
-- convert the <Tab> to spaces
vim.o.expandtab = true
-- show numbers relatively
vim.o.relativenumber = true
-- show the current line absolutely
vim.o.number = true
-- set sensible split defaults
vim.o.splitbelow = true
vim.o.splitright = true
-- set code columns
vim.o.cc = "80,100"
-- fold based on syntax
vim.o.foldmethod = "syntax"
-- turn on undofile for heaps long undos
vim.o.undofile = true
-- start with folds disabled (enabled with zc)
vim.o.foldenable = false
-- show preview of replacements
vim.o.inccommand = "nosplit"

-- vim.o.completeopt = "menuone,noselect"

-- set up custom keybindings
require("keymap")

-- Strip trailing whitespaces on save
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", command = "%s/\\s\\+$//e" })

-- Strip double blank lines in ruby on save
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.rb", command = "%s/\\n\\n\\n\\+/\r\r/e" })

-- Strip eof newlines
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", command = "%s/\\n\\+\\%$//e" })

-- Highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

local homebrew_prefix = "/usr/local"
if jit.arch == "arm64" then
	homebrew_prefix = "/opt/homebrew"
end

vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
	})

	use({
		"junegunn/fzf.vim",
		requires = homebrew_prefix .. "/opt/fzf",
		config = function()
			local k = require("util.keymap")
			k.nnoremap("<leader>b", ":Buffers<CR>", { silent = true })
			k.nnoremap("<leader>F", ":Files<CR>", { silent = true })
			k.nnoremap("<leader>f", ":GitFiles<CR>", { silent = true })

			vim.cmd([[
     command! -bang -nargs=* Rh
       \ call fzf#vim#grep(
       \   'rg --hidden --glob !.git/ --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
       \   fzf#vim#with_preview(), <bang>0)
     ]])

			k.nnoremap("<leader>rw", ':exec "Rh " . expand("<cword>")<cr>', { silent = true })
			k.nnoremap("<leader>rg", ":Rh ")
		end,
	})

	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})

	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				keywords = {
					TODO = { icon = " ", color = "info" },
				},
			})
		end,
	})

	use({
		"saecki/crates.nvim",
		tag = "v0.3.0",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup()
		end,
	})

	use({
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			dap.configurations.rust = {
				type = "executable",
				command = "/Users/david/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
			}
		end,
	})

	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	})

	use({ "L3MON4D3/LuaSnip" })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
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
					{ name = "buffer" },
				}),
			})

			cmp.setup.filetype("lua", {
				cmp.config.sources({
					{ name = "nvim_lua" },
				}),
			})
		end,
	})

	use({
		"folke/trouble.nvim",
		-- "~/projects/folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				auto_close = true,
				mode = "document_diagnostics",
				auto_jump = { "lsp_definitions" },
			})

			local k = require("util.keymap")
			k.nnoremap("<leader>xx", "<cmd>Trouble<cr>", { silent = true })
			k.nnoremap("<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true })
			k.nnoremap("<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true })
			k.nnoremap("<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true })
			k.nnoremap("<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true })
			k.nnoremap("gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true })
			-- k.nnoremap("gd", "<cmd>TroubleToggle lsp_definitions<cr>", { silent = true })
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", "folke/tokyonight.nvim" },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", { "diagnostics", sources = { "nvim_lsp" } } },
					lualine_c = { { "filename", path = 1, file_status = true } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				theme = "tokyonight",
			})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	})

	use({
		"sindrets/diffview.nvim",
		requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
	})

	use({
		"TimUntersberger/neogit",
		requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		config = function()
			require("neogit").setup({
				integrations = { diffview = true },
			})

			local k = require("util.keymap")
			k.nnoremap("<leader>g", "<cmd>Neogit<cr>")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- One of "all", "maintained" (parsers with maintainers), or a list of languages
				ensure_installed = {
					"javascript",
					"typescript",
					"tsx",
					"rust",
					"bash",
					"lua",
					"graphql",
					"css",
					"html",
					"java",
					"json",
					"json5",
					"jsonc",
					"kotlin",
					"markdown",
					"ruby",
					"vim",
					"yaml",
				},

				-- Install languages synchronously (only applied to `ensure_installed`)
				sync_install = false,

				indent = {
					enable = true,
				},

				highlight = {
					enable = true,
				},
			})
		end,
	})

	use({
		"vim-test/vim-test",
		config = function()
			local k = require("util.keymap")
			k.tmap("<C-o>", [[<C-\><C-n>]])
			vim.cmd([[
        let test#strategy = "neovim"
        let test#neovim#term_position = "vert"
      ]])

			k.nnoremap("tn", "<cmd>TestNearest<cr>", { silent = true })
			k.nnoremap("tf", "<cmd>TestFile<cr>", { silent = true })
			k.nnoremap("tl", "<cmd>TestLast<cr>", { silent = true })
			k.nnoremap("tv", "<cmd>TestVisit<cr>", { silent = true })
		end,
	})

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
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
								vim.lsp.buf.format({ name = "null-ls", async = false })
							end,
						})
					end
				end,
				sources = {
					null_ls.builtins.formatting.rustfmt,
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

								return parsed["prettier"] ~= nil
							end
						end,
					}),
					null_ls.builtins.code_actions.eslint.with({}),
					null_ls.builtins.formatting.eslint.with({}),
					null_ls.builtins.diagnostics.eslint.with({}),
					null_ls.builtins.diagnostics.selene,
				},
			})
		end,
	})

	use({
		"nathom/filetype.nvim",
		config = function()
			local ft = require("filetype")

			ft.setup({
				overrides = {
					literal = {
						Fastfile = "ruby",
						Pluginfile = "ruby",
						Matchfile = "ruby",
						Appfile = "ruby",
					},
				},
			})
		end,
	})

	use("tpope/vim-rails")
	use("tpope/vim-surround")
	use("tpope/vim-eunuch")
	use("tpope/vim-commentary")
	use("AndrewRadev/splitjoin.vim")
	use("tpope/vim-repeat")
	use("gpanders/editorconfig.nvim")

	use({
		"folke/tokyonight.nvim",
		config = function()
			vim.g.tokyonight_style = "night"

			vim.cmd([[colorscheme tokyonight]])
		end,
	})

	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	use({
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	})

	use({
		"williamboman/mason.nvim",
		requires = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			local reg = require("mason-registry")

			---@param name string
			local install_if_missing = function(name)
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

				"chrome-debug-adapter",
			})
		end,
	})
end)
