local util = {}

local map = function(mode, key_combo, effect, opts)
  if not opts then opts = {} end

  vim.api.nvim_set_keymap(mode, key_combo, effect, opts)
end

local noremap = function(mode, key_combo, effect, opts)
  if not opts then opts = {} end
  opts['noremap'] = true

  map(mode, key_combo, effect, opts)
end

util.nmap = function(key_combo, effect, opts)
  map('n', key_combo, effect, opts)
end

util.nnoremap = function(key_combo, effect, opts)
  noremap('n', key_combo, effect, opts)
end

util.imap = function(key_combo, effect, opts)
  map('i', key_combo, effect, opts)
end

util.inoremap = function(key_combo, effect, opts)
  noremap('i', key_combo, effect, opts)
end

util.tmap = function(key_combo, effect, opts)
  map('t', key_combo, effect, opts)
end

util.tnoremap = function(key_combo, effect, opts)
  noremap('t', key_combo, effect, opts)
end

return util
