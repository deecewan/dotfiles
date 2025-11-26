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
-- set my preferred text width
vim.o.textwidth = 80
-- turn on undofile for heaps long undos
vim.o.undofile = true
-- show preview of replacements
vim.o.inccommand = "nosplit"

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.winborder = "rounded"

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

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    import = "plugins",
  },
})

require("ft")
require("keymap")
require("lsp")
