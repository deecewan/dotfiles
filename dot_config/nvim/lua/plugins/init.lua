--- @type LazySpec
return {
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			"neovim/nvim-lspconfig",
		},
		config = true,
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "close all folds",
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = true,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			keywords = {
				TODO = { icon = " ", color = "info" },
			},
			highlight = {
				keyword = "bg",
				pattern = [[.*<(KEYWORDS)>(\(.*\))?\s*:]],
			},
			search = {
				pattern = [[\b(KEYWORDS)(\(.*\))?:]],
			},
		},
	},
	{
		"saecki/crates.nvim",
		tag = "v0.3.0",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufRead Cargo.toml" },
		opts = {
			null_ls = {
				enabled = true,
				name = "crates.nvim",
			},
		},
	},
	{
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
	},
	{
		"folke/lazydev.nvim",
		dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- load the home directory
				vim.fn.expand("~/.config/nvim"),
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
			integrations = {
				lspconfig = true,
				cmp = true,
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		-- tag = "legacy",
		opts = {
			notification = {
				override_vim_notify = true,
			},
		},
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", "folke/tokyonight.nvim" },
		opts = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", { "diagnostics", sources = { "nvim_lsp" } } },
				lualine_c = { { "filename", path = 4, file_status = true } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			theme = "tokyonight",
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			current_line_blame = true,
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
	},
	{
		"TimUntersberger/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		opts = {
			integrations = { diffview = true },
		},
		keys = {
			{ "<leader>g", ":Neogit<CR>" },
		},
	},
	-- {
	-- 	"vim-test/vim-test",
	-- 	init = function()
	-- 		vim.cmd([[
	--        let test#strategy = "neovim_sticky"
	--        let test#neovim#term_position = "vert"
	--        let g:test#neovim_sticky#kill_previous = 1  " Try to abort previous run
	--        let g:test#preserve_screen = 0  " Clear screen from previous run
	--        let test#neovim_sticky#reopen_window = 1 " Reopen terminal split if not visible
	--
	--        let test#javascript#jest#options = "--config jest.integration.config.js"
	--
	--      ]])
	-- 	end,
	-- 	keys = {
	-- 		{ "<C-o>", [[<C-\><C-n>]], mode = "t" },
	-- 		{ "tn", ":TestNearest<CR>", desc = "Run test under cursor" },
	-- 		{ "tf", ":TestFile<CR>", desc = "Run all tests in file" },
	-- 		{ "tl", ":TestLast<CR>", desc = "Re-run last test" },
	-- 		{ "tv", ":TestVisit<CR>", desc = "Open last-run test" },
	-- 	},
	-- },
	{
		"AndrewRadev/splitjoin.vim",
		submodules = false,
		keys = {
			{ "gS", ":SplitjoinSplit<CR>" },
			{ "gJ", ":SplitjoinJoin<CR>" },
		},
	},
	{
		"stevearc/oil.nvim",
		lazy = false,
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = true,
			cleanup_delay_ms = false,
			columns = {
				"type",
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			buf_options = {
				buflisted = true,
				bufhidden = "hide",
			},
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			keymaps = {
				["<C-v>"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Open the entry in a vertical split",
				},
				["<Esc>"] = { "actions.close", mode = "n", desc = "close Oil and return to buffer" },
			},
			view_options = {
				show_hidden = true,
			},
		},
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},
	{
		"github/copilot.vim",
	},
}
