-- config for mason tools
local sources = require("getchoo.lsp.config.sources")

local M = {}

M.mason_tool_installer = {
	ensure_installed = sources.mason,
}

M.mason_lspconfig = {
	automatic_installation = true,
}

return M
