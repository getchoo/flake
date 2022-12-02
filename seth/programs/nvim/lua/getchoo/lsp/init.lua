--
-- setup lsp environment
--
require("getchoo.lsp.server")
require("getchoo.lsp.keymap")
local config = require("getchoo.lsp.config")

require("gitsigns").setup()
require("nvim-treesitter.configs").setup(config.treesitter)
require("trouble").setup(config.trouble)
