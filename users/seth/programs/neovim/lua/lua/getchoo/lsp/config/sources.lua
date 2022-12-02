local null_ls = require("null-ls")
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local M = {
	lsp_servers = { "rust_analyzer", "pyright", "bashls" },
	null_ls = {
		code_actions.statix,
		diagnostics.alex,
		diagnostics.codespell,
		diagnostics.statix,
		diagnostics.deadnix,
		diagnostics.flake8,
		formatting.alejandra,
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
