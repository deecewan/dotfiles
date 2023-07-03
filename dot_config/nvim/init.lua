-- follow the leader
vim.g.mapleader = " "

vim.o.confirm = true

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
-- turn on undofile for heaps long undos
vim.o.undofile = true
-- show preview of replacements
vim.o.inccommand = "nosplit"

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- vim.o.completeopt = "menuone,noselect"

-- set up custom keybindings
vim.keymap.set("n", "<leader><space>", "<C-^>", {})

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

require("ft")

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
		"kevinhwang91/nvim-ufo",
		requires = {
			"kevinhwang91/promise-async",
		},
		after = {
			-- ufo must load after lsp config so we can be sure it's set up correctly
			"nvim-lspconfig",
		},
		config = function()
			local ufo = require("ufo")
			ufo.setup()

			vim.keymap.set("n", "zR", ufo.openAllFolds)
			vim.keymap.set("n", "zM", ufo.closeAllFolds)
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", run = "make" } },
		config = function()
			local telescope = require("telescope")
			telescope.setup()
			telescope.load_extension("fzf")

			local builtin = require("telescope.builtin")

			local find_files = function()
				vim.fn.system("git rev-parse --is-inside-work-tree")
				if vim.v.shell_error == 0 then
					builtin.git_files({ show_untracked = true, cwd = vim.fn.getcwd() })
				else
					builtin.find_files({})
				end
			end

			local find_hidden = function()
				builtin.find_files({
					find_command = { "rg", "--files", "--no-ignore", "--hidden", "--glob", "!**/.git/*" },
				})
			end

			local find_string = function()
				-- local input = vim.fn.input("Search > ")

				builtin.live_grep({ debounce = 3000 })
			end

			vim.keymap.set("n", "<leader>fa", builtin.resume, { desc = "resume last picker" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "show buffers" })
			vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "show all commands" })
			vim.keymap.set("n", "<leader>ff", find_files, { desc = "find files" })
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "rg" })
			vim.keymap.set("n", "<leader>fg", find_string, { desc = "rg" })
			vim.keymap.set("n", "<leader>fh", find_hidden, { desc = "find hidden files" })
			vim.keymap.set("n", "<leader>fm", function()
				builtin.man_pages({ sections = { "ALL" } })
			end, { desc = "Open the manual" })
			vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "rg for string under cursor" })
		end,
		keys = {
			"<leader>f",
		},
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
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
		end,
	})

	use({
		"mfussenegger/nvim-dap",
		requires = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"suketa/nvim-dap-ruby",
		},
		keys = { "<leader>d" },
		config = function()
			local dap = require("dap")
			dap.set_log_level("TRACE")

			require("nvim-dap-virtual-text").setup({})
			require("dap-ruby").setup()

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "(debug) toggle breakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "(debug) continue" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "(debug) step over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "(debug) step into" })

			dap.adapters.cppdbg = {
				id = "cppdbg",
				name = "vscode-cpptools",
				type = "executable",
				command = "OpenDebugAD7",
			}

			dap.configurations.rust = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input({
							prompt = "Path to executable: ",
							default = vim.fn.getcwd() .. "/",
							completion = "file",
						})
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
					MIMode = "lldb",
				},
			}

			local js = {
				id = "cppdbg",
				name = "vscode-cpptools",
				type = "executable",
				command = "OpenDebugAD7",
			}
			dap.adapters.javascript = js
			dap.adapters.typescript = js
			dap.adapters.typescriptreact = js
			dap.adapters.javascriptreact = js

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

			local ok, cmp = pcall(require, "cmp")
			if ok then
				cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
					cmp.config.sources({
						{ name = "dap" },
					}),
				})
			end
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
		config = function()
			local luasnip = require("luasnip")

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				luasnip.jump(1)
			end)
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				luasnip.jump(-1)
			end)
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			{ "rcarriga/cmp-dap", opt = true },
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				native_menu = false,
				preselect = cmp.PreselectMode.None,
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
			local trouble = require("trouble")

			trouble.setup({
				auto_close = true,
				mode = "document_diagnostics",
				auto_jump = { "lsp_definitions" },
			})

			local toggle_mode = function(mode)
				return function()
					trouble.toggle({ mode = mode })
				end
			end

			vim.keymap.set("n", "<leader>tt", trouble.toggle, { desc = "toggle trouble" })
			vim.keymap.set(
				"n",
				"<leader>tw",
				toggle_mode("workspace_diagnostics"),
				{ desc = "toggle workspace diagnostics" }
			)
			vim.keymap.set(
				"n",
				"<leader>td",
				toggle_mode("document_diagnostics"),
				{ desc = "toggle document diagnostics" }
			)
			vim.keymap.set("n", "<leader>tq", toggle_mode("quickfix"), { desc = "toggle quickfix" })
			vim.keymap.set("n", "<leader>tl", toggle_mode("loclist"), { desc = "toggle loclist" })
			vim.keymap.set("n", "gR", toggle_mode("lsp_references"), { desc = "show lsp references" })
			vim.keymap.set("n", "gd", toggle_mode("lsp_definitions"), { desc = "show lsp definitions" })
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
					lualine_c = { { "filename", path = 4, file_status = true } },
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

			vim.keymap.set("n", "<leader>g", vim.cmd.Neogit)
		end,
		keys = {
			"<leader>g",
			-- ["<leader>g"] = vim.cmd.Neogit,
		},
	})

	-- there doesn't seem to be a slim grammar for treesitter
	use("slim-template/vim-slim")
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

	use({ "NoahTheDuke/vim-just" })

	use({
		"vim-test/vim-test",
		config = function()
			vim.keymap.set("t", "<C-o>", [[<C-\><C-n>]])

			vim.cmd([[
        let test#strategy = "neovim"
        let test#neovim#term_position = "vert"
      ]])

			vim.keymap.set("n", "tn", vim.cmd.TestNearest, { desc = "Run test under cursor" })
			vim.keymap.set("n", "tf", vim.cmd.TestFile, { desc = "Run all tests in file" })
			vim.keymap.set("n", "tl", vim.cmd.TestLast, { desc = "Re-run last test" })
			vim.keymap.set("n", "tv", vim.cmd.TestVisit, { desc = "Open last-run test" })
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
								vim.lsp.buf.format({
									bufnr = bufnr,
									filter = function(format_client)
										return format_client.name == "null-ls"
									end,
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
					null_ls.builtins.formatting.eslint.with({}),
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
	})

	use("tpope/vim-rails")
	use("tpope/vim-surround")
	use("tpope/vim-eunuch")
	use("tpope/vim-commentary")
	use("AndrewRadev/splitjoin.vim")
	use("tpope/vim-repeat")
	use("alker0/chezmoi.vim")
	-- use("gpanders/editorconfig.nvim")
	use({
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true },
			})
		end,
	})

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
			local should_install = false

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

				"chrome-debug-adapter",
				"cpptools",
				"js-debug-adapter",
			})
		end,
	})
end)
