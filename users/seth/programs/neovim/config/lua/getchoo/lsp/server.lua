--
-- initialize lsp servers
--

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local config = require("getchoo.lsp.config")

null_ls.setup(config.null_ls)
cmp.setup(config.cmp)

for server, settings in pairs(config.lsp_servers) do
	lspconfig[server].setup(settings)
end
