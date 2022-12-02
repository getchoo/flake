-- load custom file types

local filetypes = {
	filename = {
		PKGBUILD = "text",
		[".makepkg.conf"] = "text",
	},
}

vim.filetype.add(filetypes)
