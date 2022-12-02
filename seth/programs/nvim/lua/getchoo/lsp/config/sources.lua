local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local M = {
	lsp_servers = { "rust_analyzer", "pyright", "bashls" },
	null_ls = {
		diagnostics.alex,
		diagnostics.codespell,
		diagnostics.flake8,
		formatting.black,
		formatting.codespell,
		formatting.prettier,
		formatting.rustfmt,
		formatting.stylua,
	},
	mason = {
		"alex",
		"black",
		"codespell",
		"flake8",
		"prettier",
		"stylua",
	},
}

return M
