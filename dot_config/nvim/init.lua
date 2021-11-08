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

vim.o.completeopt = "menuone,noselect"

-- set up custom keybindings
require('keymap')

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
   'neovim/nvim-lspconfig',
   config = function() require('lsp') end,
  }

  use {
   'junegunn/fzf.vim',
   requires = '/usr/local/opt/fzf',
   config = function()
     local k = require('util.keymap')
     k.nnoremap('<leader>b', ':Buffers<CR>', { silent = true })
     k.nnoremap('<leader>F', ':Files<CR>', { silent = true })
     k.nnoremap('<leader>f', ':GitFiles<CR>', { silent = true })
     k.nnoremap('<leader>rw', ':exec "Rg " . expand("<cword>")<cr>', { silent = true })
     k.nnoremap('<leader>rg', ':Rg ')
   end,
  }

  use {
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup { }
    end
  }

  use {
    'hrsh7th/nvim-compe',
    config = function()
      require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
          border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
        };
      }
      local k = require('util.keymap')
      k.inoremap('<C-Space>', 'compe#complete()', { silent = true, expr = true })
      k.inoremap('<CR>', 'compe#confirm("<CR>")', { silent = true, expr = true })
      k.inoremap('<C-e>', 'compe#close("<C-e>")', { silent = true, expr = true })
      k.inoremap('<C-f>', 'compe#scroll({ "delta": +4 })', { silent = true, expr = true })
      k.inoremap('<C-d>', 'compe#scroll({ "delta": d4 })', { silent = true, expr = true })
    end
  }

  use {
    -- "folke/trouble.nvim",
    "~/projects/folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        auto_close = true,
        mode = "lsp_document_diagnostics",
      }
      local k = require('util.keymap')
      k.nnoremap("<leader>xx", "<cmd>Trouble<cr>", { silent = true })
      k.nnoremap("<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", { silent = true })
      k.nnoremap("<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<cr>", { silent = true })
      k.nnoremap("<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true })
      k.nnoremap("<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true })
      k.nnoremap("gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true })
      k.nnoremap("gd", "<cmd>TroubleToggle lsp_definitions<cr>", { silent = true })
    end
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function()
      require("lualine").setup {
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', { "diagnostics", sources = { "nvim_lsp" } } },
          lualine_c = { { 'filename', path = 1, file_status = true } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        }
      }
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup {
        current_line_blame = true
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'vim-test/vim-test',
    config = function()
      local k = require('util.keymap')
      k.tmap("<C-o>", [[<C-\><C-n>]])
      vim.cmd[[
        let test#strategy = "neovim"
        let test#neovim#term_position = "vert"
      ]]

      k.nnoremap('tn', '<cmd>TestNearest<cr>', { silent = true })
      k.nnoremap('tf', '<cmd>TestFile<cr>', { silent = true })
      k.nnoremap('tl', '<cmd>TestLast<cr>', { silent = true })
      k.nnoremap('tv', '<cmd>TestVisit<cr>', { silent = true })
    end
  }

  use 'tpope/vim-rails'
  use 'tpope/vim-surround'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-commentary'
  use 'sheerun/vim-polyglot'
  use 'AndrewRadev/splitjoin.vim'
  use 'tpope/vim-repeat'
  use 'machakann/vim-highlightedyank'

end)
