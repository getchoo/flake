--
-- sources for lsp
--

local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local M = {
	lsp_servers = { "rust_analyzer", "pyright", "bashls" },
	null_ls = {
		diagnostics.alex,
		diagnostics.codespell,
		diagnostics.deadnix,
		diagnostics.pylint,
		diagnostics.statix,
		formatting.alejandra,
		formatting.codespell,
		formatting.prettier,
		formatting.rustfmt,
		formatting.stylua,
		formatting.yapf,
	},
	mason = {
		"alex",
		"codespell",
		"prettier",
		"pylint",
		"stylua",
		"yapf",
	},
}

return M
