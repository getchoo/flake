--
-- config for regular plugins
--

local M = {}

M.bufferline = {
	animation = true,
	auto_hide = true,
	icons = true,
	maximum_padding = 2,
	semantic_letters = true,
}

M.lualine = {
	options = {
		theme = "catppuccin",
	},
	extensions = { "nvim-tree" },
}

M.tree = {}

require("getchoo.keymap")
return M
