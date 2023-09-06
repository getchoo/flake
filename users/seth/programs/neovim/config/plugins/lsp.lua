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
		{ name = "async_path" },
		{ name = "buffer" },
	}),
})

---- gitsigns
require("gitsigns").setup()

---- fidget
require("fidget").setup()

---- lsp sources
local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local sources = {
	lsp_servers = {
		["bashls"] = "bash-language-server",
		["clangd"] = "clangd",
		["eslint"] = "eslint",
		["nil_ls"] = "nil",
		["pyright"] = "pyright-langserver",
		["rust_analyzer"] = "rust-analyzer",
		["tsserver"] = "typescript-language-server",
	},
	null_ls = {
		diagnostics.actionlint,
		diagnostics.alex,
		diagnostics.codespell,
		diagnostics.deadnix,
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
local capabilities = vim.tbl_deep_extend(
	"force",
	require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	{ workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
)

local all_config = {
	capabilities = capabilities,
}

local servers = {}
for server, binary in pairs(sources.lsp_servers) do
	if vim.fn.executable(binary) == 1 then
		servers[server] = all_config
	end
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

require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring()
				or vim.bo.context_commentstring
		end,
	},
})

require("null-ls").setup({
	on_attach = formatting_on_attach,
	sources = sources.null_ls,
})

require("nvim-treesitter.configs").setup({
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})

---- trouble
require("trouble").setup()
