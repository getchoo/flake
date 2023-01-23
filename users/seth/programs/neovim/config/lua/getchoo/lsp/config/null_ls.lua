--
-- config for null_ls
--

local sources = require("getchoo.lsp.config.sources")

local M = {}

-- only use null-ls for formatting
-- for neovim >= 8
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local formatting_on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				-- for neovim < 8
				---- local params = require("vim.lsp.util").make_formatting_params({})
				---- client.request("textDocument/formatting", params, nil, bufnr)
				lsp_formatting(bufnr) -- neovim >= 8
			end,
		})
	end
end

M.config = {
	on_attach = formatting_on_attach,
	sources = sources.null_ls,
}

return M
