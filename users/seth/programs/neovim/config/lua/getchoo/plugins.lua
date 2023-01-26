--
-- plugins for neovim
--

local fn = vim.fn
local cmd = vim.cmd

local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(packer_path)) > 0 then
	Packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		packer_path,
	})
	cmd("packadd packer.nvim")
end

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- comsetic plugins
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- mocha, macchiato, frappe, latte
				integrations = {
					barbar = true,
					gitsigns = true,
					lightspeed = true,
					cmp = true,
					nvimtree = true,
					treesitter_context = true,
					treesitter = true,
					telescope = true,
					lsp_trouble = true,
				},
				no_italic = true,
			})
			vim.api.nvim_command("colorscheme catppuccin")
		end,
	})

	if Packer_bootstrap then
		require("packer").sync()
	end
end)
