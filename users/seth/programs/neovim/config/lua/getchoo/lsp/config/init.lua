--
-- load all lsp configs
--

local cmp = require("getchoo.lsp.config.cmp")
local lsp_config = require("getchoo.lsp.config.lsp_config")
local null_ls = require("getchoo.lsp.config.null_ls")

local M = {}

M.cmp = cmp.config

M.lsp_servers = lsp_config.servers

M.null_ls = null_ls.config

M.treesitter = {
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

M.trouble = {}

return M
