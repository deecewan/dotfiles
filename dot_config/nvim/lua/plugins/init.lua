--- @type LazySpec
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,  -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "neovim/nvim-lspconfig",
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
    lazy = false, -- load this plugin immediately
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
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      check_syntax_error = false,
    },
    keys = {
      {
        "gJ",
        function()
          require("treesj").join()
        end,
        desc = "Join lines",
      },
      {
        "gS",
        function()
          require("treesj").split()
        end,
        desc = "Split lines",
      },
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
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "fladson/vim-kitty",
    ft = "kitty",
  },
  {
    "zbirenbaum/copilot.lua",
    opts = { {} },
  },
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
  {
    "xvzc/chezmoi.nvim",
  },
  {
    "L3MON4D3/LuaSnip",
  },
  { "xzbdmw/colorful-menu.nvim" },
  {
    "saghen/blink.cmp",
    dependencies = { "xzbdmw/colorful-menu.nvim", "kyazdani42/nvim-web-devicons", "onsails/lspkind.nvim" },
    tag = "v1.7.0",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "enter" },
      completion = {
        documentation = { auto_show = true, window = { border = "rounded" } },
        list = { selection = { preselect = false } },
        menu = {
          border = "rounded",
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },
  {
    "ej-shafran/compile-mode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    config = function()
      ---@module 'compile-mode.config.meta'
      ---@type CompileModeOpts
      vim.g.compile_mode = {
        input_word_completion = true,
        bang_expansion = true,
        baleia_setup = true,
      }
    end,
  },
}
