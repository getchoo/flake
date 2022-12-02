--
-- keymaps for general plugins
--

local opts = { noremap = true, silent = true }
local set = function(mode, key, cmd)
	vim.keymap.set(mode, key, cmd, opts)
end

set("n", "<leader>t", function()
	vim.cmd("NvimTreeToggle")
end)

for i = 1, 9 do
	set("n", "<leader>" .. i, function()
		local cmd = "BufferGoto " .. i
		vim.cmd(cmd)
	end)
end

set("n", "<leader>p", function()
	vim.cmd("BufferPick")
end)

set("n", "<leader>q", function()
	vim.cmd("BufferClose")
end)
