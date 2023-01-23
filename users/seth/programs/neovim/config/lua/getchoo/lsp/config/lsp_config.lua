--
-- setup lsp_config
--

local cmp = require("getchoo.lsp.config.cmp")
local sources = require("getchoo.lsp.config.sources")

local M = {}

local on_attach = function(client, bufnr)
	cmp.on_attach(client, bufnr)
end

local all_config = {
	capabilities = cmp.capabilities,
	on_attach = on_attach,
}

local servers = {}
for _, server in ipairs(sources.lsp_servers) do
	servers[server] = all_config
end

servers["sumneko_lua"] = {
	capabilities = cmp.capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}

M.servers = servers

return M
