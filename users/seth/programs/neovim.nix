{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      alejandra
      codespell
      deadnix
      llvmPackages_15.clang
      llvmPackages_15.libclang
      nodePackages.alex
      nodePackages.bash-language-server
      nodePackages.prettier
      nodePackages.pyright
      pylint
      rust-analyzer
      rustfmt
      statix
      stylua
      sumneko-lua-language-server
      yapf
    ];
    plugins = with pkgs.vimPlugins; [
      barbar-nvim
      catppuccin-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp_luasnip
      cmp-path
      cmp-vsnip
      editorconfig-nvim
      gitsigns-nvim
      leap-nvim
      lualine-nvim
      luasnip
      nvim-cmp
      nvim-lspconfig
      null-ls-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      plenary-nvim
      telescope-nvim
      trouble-nvim
      vim-vsnip
    ];
    extraLuaConfig = ''
         local cmd = vim.cmd
         local opt = vim.opt


         -- text options
         opt.tabstop = 2
         opt.shiftwidth = 2
         opt.expandtab = false
         opt.smartindent = true
         opt.wrap = false


         -- appearance
         opt.syntax = "on"
         cmd("filetype plugin indent on")
         opt.termguicolors = true

         -- filetypes
         local filetypes = {
         	filename = {
         		PKGBUILD = "text",
         		[".makepkg.conf"] = "text",
         	},
         }

         vim.filetype.add(filetypes)


         -- plugin config
         ---- catppuccin
         local compile_path = vim.fn.stdpath("cache") .. "/catppuccin-nvim"
         vim.fn.mkdir(compile_path, "p")
         vim.opt.runtimepath:append(compile_path)

         require("catppuccin").setup({
         	compile_path = compile_path,
         	flavour = "mocha", -- mocha, macchiato, frappe, latte
         	integrations = {
         		barbar = true,
         		cmp = true,
         		gitsigns = true,
         		leap = true,
         		native_lsp = {
         			enabled = true,
         		},
         		nvimtree = true,
         		treesitter_context = true,
         		treesitter = true,
         		telescope = true,
         		lsp_trouble = true,
         	},
         	no_italic = true,
         })
         vim.api.nvim_command("colorscheme catppuccin")

         ---- bufferline
         require("bufferline").setup({
         	animation = true,
         	auto_hide = true,
         	highlights = require("catppuccin.groups.integrations.bufferline").get(),
         	icons = true,
         	maximum_padding = 2,
         	semantic_letters = true,
         })

         ---- cmp
         local cmp = require("cmp")
         local luasnip = require("luasnip")
         local mapping = cmp.mapping

         local has_words_before = function()
         	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
         	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
         end

         local feedkey = function(key, mode)
         	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
         end
      local cmp_on_attach = function(_, bufnr)
         		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
         	end

         local capabilities = require("cmp_nvim_lsp").default_capabilities()
         capabilities.textDocument.completion.completionItem.snippetSupport = true

         require("cmp").setup({
         	snippet = {
         		expand = function(args)
         			vim.fn["vsnip#anonymous"](args.body)
         			luasnip.lsp_expand(args.body)
         		end,
         	},

         	mapping = mapping.preset.insert({
         		["<Tab>"] = cmp.mapping(function(fallback)
         			if cmp.visible() then
         				cmp.select_next_item()
         			elseif luasnip.expand_or_jumpable() then
         				luasnip.expand_or_jump()
         			elseif vim.fn["vsnip#available"](1) == 1 then
         				feedkey("<Plug>(vsnip-expand-or-jump)", "")
         			elseif has_words_before() then
         				cmp.complete()
         			else
         				fallback()
         			end
         		end, { "i", "s" }),
         		["<S-Tab>"] = cmp.mapping(function(fallback)
         			if cmp.visible() then
         				cmp.select_prev_item()
         			elseif luasnip.jumpable(-1) then
         				luasnip.jump(-1)
         			elseif vim.fn["vsnip#available"](-1) == 1 then
         				feedkey("<Plug>(vsnip-jump-prev)", "")
         			else
         				fallback()
         			end
         		end, { "i", "s" }),
         	}),

         	sources = cmp.config.sources({
         		{ name = "nvim_lsp" },
         		{ name = "luasnip" },
         		{ name = "vsnip" },
         		{ name = "buffer" },
         		{ name = "path" },
         	}),

         	capabilities = capabilities,

         	on_attach = cmp_on_attach,
         })

         ---- gitsigns
         require("gitsigns").setup({})

         ---- leap
         require("leap").add_default_mappings()

         ---- lsp sources
         local null_ls = require("null-ls")
         local diagnostics = null_ls.builtins.diagnostics
         local formatting = null_ls.builtins.formatting

         local sources = {
         	lsp_servers = { "rust_analyzer", "pyright", "bashls", "clangd" },
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
         }

         --- lsp config
         local all_config = {
         	capabilities = capabilities,
         	on_attach = cmp_on_attach,
         }

         local servers = {}
         for _, server in ipairs(sources.lsp_servers) do
         	servers[server] = all_config
         end

         servers["lua_ls"] = {
         	capabilities = capabilities,
         	on_attach = cmp_on_attach,
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

         ---- lualine
         require("lualine").setup({
         	options = {
         		theme = "catppuccin",
         	},
         	extensions = { "nvim-tree" },
         })

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

         ---- nvim-tree
         require("nvim-tree").setup({})

         ---- treesitter
         require("nvim-treesitter.configs").setup({
         	auto_install = false,
         	highlight = {
         		enable = true,
         		additional_vim_regex_highlighting = false,
         	},
         })

         ---- trouble
         require("trouble").setup({})


         -- keybinds
         local opts = { noremap = true, silent = true }
         local set = function(mode, key, vimcmd)
         	vim.keymap.set(mode, key, vimcmd, opts)
         end


         set("n", "<leader>t", function()
         	vim.cmd("NvimTreeToggle")
         end)

         for i = 1, 9 do
         	set("n", "<leader>" .. i, function()
         		local vimcmd = "BufferGoto " .. i
         		vim.cmd(vimcmd)
         	end)
         end

         set("n", "<leader>p", function()
         	vim.cmd("BufferPick")
         end)

         set("n", "<leader>q", function()
         	vim.cmd("BufferClose")
         end)

         set("n", "<space>e", vim.diagnostic.open_float)
         set("n", "[d", vim.diagnostic.goto_prev)
         set("n", "]d", vim.diagnostic.goto_next)
         set("n", "<space>q", vim.diagnostic.setloclist)

         set("n", "<space>f", function()
         	vim.cmd("Telescope")
         end)

         set("n", "<space>t", function()
         	vim.cmd("TroubleToggle")
         end)
    '';
  };
}
