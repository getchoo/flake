--
-- setup plugins
--

local M = {}

M.bufferline = {
	animation = true,
	auto_hide = true,
	icons = true,
	maximum_padding = 2,
	semantic_letters = true,
}

M.catppuccin = {
	flavour = "mocha", -- mocha, macchiato, frappe, latte
	integrations = {
		barbar = true,
		gitsigns = true,
		lightspeed = true,
		cmp = true,
		nvimtree = true,
		treesitter_context = true,
		treesitter = true,
		telescope = true,
		lsp_trouble = true,
	},
	no_italic = true,
}

M.lualine = {
	options = {
		theme = "catppuccin",
	},
	extensions = { "nvim-tree" },
}

M.tree = {}

require("bufferline").setup(M.bufferline)
require("catppuccin").setup(M.catppuccin)
require("lualine").setup(M.lualine)
require("nvim-tree").setup(M.tree)

if vim.g.use_lsp_plugins then
	require("getchoo.ftdetect")
	require("getchoo.lsp")
end

require("getchoo.keymap")

return M
