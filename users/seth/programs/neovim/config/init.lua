--
-- getchoo's neovim config (but in lua :p)
--

local cmd = vim.cmd
local opt = vim.opt

vim.g.use_lsp_plugins = true;

require("getchoo")

-- text options
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = false
opt.smartindent = true
opt.wrap = false

-- appearance
opt.syntax = "on"
cmd("filetype plugin indent on")
opt.termguicolors = true
vim.api.nvim_command("colorscheme catppuccin")
