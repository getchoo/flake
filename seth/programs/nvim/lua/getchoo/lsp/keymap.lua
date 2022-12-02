--
-- keymaps for lsp
--

local opts = { noremap = true, silent = true }
local set = function(mode, key, cmd)
	vim.keymap.set(mode, key, cmd, opts)
end

set("n", "<space>e", vim.diagnostic.open_float)
set("n", "[d", vim.diagnostic.goto_prev)
set("n", "]d", vim.diagnostic.goto_next)
set("n", "<space>q", vim.diagnostic.setloclist)

set("n", "<space>f", function()
	vim.cmd("Telescope")
end)

set("n", "<space>t", function()
	vim.cmd("TroubleToggle")
end)
