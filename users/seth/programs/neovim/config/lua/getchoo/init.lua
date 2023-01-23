--
-- setup plugins
--

require("getchoo.plugins")

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

require("bufferline").setup(M.bufferline)
require("lualine").setup(M.lualine)
require("nvim-tree").setup(M.tree)

if vim.g.use_lsp_plugins then
	require("getchoo.ftdetect")
	require("getchoo.lsp")
end

require("getchoo.keymap")

return M
