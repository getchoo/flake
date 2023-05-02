---- cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
local mapping = cmp.mapping

require("cmp").setup({
	completion = {
		completeopt = "menu,menuone,noinsert",
	},

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = mapping.preset.insert({
		["<C-n>"] = mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-b>"] = mapping.scroll_docs(-4),
		["<C-f>"] = mapping.scroll_docs(4),
		["<C-Space>"] = mapping.complete(),
		["<C-e>"] = mapping.abort(),
		["<CR>"] = mapping.confirm({ select = true }),
		["<S-CR>"] = mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	}),
})

---- fidget
require("fidget").setup()

---- lsp sources
local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local sources = {
	lsp_servers = {
		"bashls",
		"clangd",
		"nil_ls",
		"pyright",
		"rust_analyzer",
		"tsserver",
		--"tailwindcss",
		"nimls",
	},
	null_ls = {
		diagnostics.actionlint,
		diagnostics.alex,
		diagnostics.codespell,
		diagnostics.deadnix,
		diagnostics.eslint,
		diagnostics.pylint,
		diagnostics.shellcheck,
		diagnostics.statix,
		formatting.alejandra,
		formatting.beautysh,
		formatting.codespell,
		formatting.just,
		formatting.nimpretty,
		formatting.prettier,
		formatting.rustfmt,
		formatting.shellharden,
		formatting.stylua,
		formatting.yapf,
	},
}

--- lsp config
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local all_config = {
	capabilities = capabilities,
}

local servers = {}
for _, server in ipairs(sources.lsp_servers) do
	servers[server] = all_config
end

servers["lua_ls"] = {
	capabilities = capabilities,
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

for server, settings in pairs(servers) do
	require("lspconfig")[server].setup(settings)
end

---- null-ls
-- auto-format
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
				lsp_formatting(bufnr)
			end,
		})
	end
end

require("null-ls").setup({
	on_attach = formatting_on_attach,
	sources = sources.null_ls,
})

---- trouble
require("trouble").setup()
