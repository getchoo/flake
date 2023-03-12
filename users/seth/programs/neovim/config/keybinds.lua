local opts = { noremap = true, silent = true }
local set = function(mode, key, vimcmd)
	vim.keymap.set(mode, key, vimcmd, opts)
end

set("n", "<leader>t", function()
	vim.cmd("NvimTreeToggle")
end)

for i = 1, 9 do
	set("n", "<leader>" .. i, function()
		local vimcmd = "BufferGoto " .. i
		vim.cmd(vimcmd)
	end)
end

set("n", "<leader>p", function()
	vim.cmd("BufferPick")
end)

set("n", "<leader>q", function()
	vim.cmd("BufferClose")
end)

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
