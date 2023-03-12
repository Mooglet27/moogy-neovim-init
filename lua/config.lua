local g = vim.g
local o = vim.opt

-- Leader character
g.mapleader      = ' '
g.maplocalleader = ','

-- Line Numbers, relative for hoping
o.number         = true
o.relativenumber = true

-- Tabs
o.expandtab   = true -- Tabs. Are. Evil.
o.tabstop     = 4    -- Number of spaces a tab counts for 
o.softtabstop = 4    -- Number of spaces tabs feeeels like (editing)
o.shiftwidth  = 4    -- Effective width ¯\_(ツ)_/¯

-- Indent
o.smartindent = true
o.wrap        = false -- me no like wrap

-- Only hightlight current search
o.hlsearch  = false
o.incsearch = true

-- Keep scroll offset from cursor
o.scrolloff     = 8
o.sidescrolloff = 12

-- Some Visual stuff
o.termguicolors = true -- Pretty colors (24-bit)
o.signcolumn    = 'yes'
o.updatetime    = 50
o.colorcolumn   = '100'



