---- catppuccin
local compile_path = vim.fn.stdpath("cache") .. "/catppuccin-nvim"
vim.fn.mkdir(compile_path, "p")
vim.opt.runtimepath:append(compile_path)

require("catppuccin").setup({
	compile_path = compile_path,
	flavour = "mocha", -- mocha, macchiato, frappe, latte
	integrations = {
		cmp = true,
		flash = true,
		gitsigns = true,
		native_lsp = {
			enabled = true,
		},
		neotree = true,
		treesitter_context = true,
		treesitter = true,
		telescope = true,
		lsp_trouble = true,
	},
	no_italic = true,
})
vim.api.nvim_command("colorscheme catppuccin")

---- bufferline
require("bufferline").setup({
	options = {
		always_show_bufferline = false,
		highlights = require("catppuccin.groups.integrations.bufferline").get(),
		diagnostics = "nvim_lsp",
		mode = "buffers",
		numbers = "ordinal",
		separator_style = "slant",
		offsets = {
			{
				filetype = "neo-tree",
				text = "neo-tree",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
})

---- gitsigns
require("gitsigns").setup()

---- indent-blankline.nvim
require("ibl").setup({
	exclude = {
		filetype = {
			"help",
			"neo-tree",
			"Trouble",
			"lazy",
			"mason",
			"notify",
			"toggleterm",
		},
	},

	indent = {
		char = "│",
		tab_char = "│",
	},

	scope = { enabled = false },
})

---- lualine
require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
	extensions = { "neo-tree", "trouble" },
})

---- mini.nvim
require("mini.pairs").setup({})
require("mini.indentscope").setup({
	options = { try_as_border = true },
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"neo-tree",
		"Trouble",
		"lazy",
		"mason",
		"notify",
		"toggleterm",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

---- nvim-tree
require("neo-tree").setup({
	sources = { "filesystem", "buffers", "git_status", "document_symbols" },
	open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
	},
})

---- which-key
require("which-key").setup({
	plugins = { spelling = true },
})
