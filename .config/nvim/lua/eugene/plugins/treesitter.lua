return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag" },
	config = function()
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({
			sync_install = false,
			auto_install = true,
			highlight = { enable = true },
			ensure_installed = { "lua" },
			ignore_install = { "org" },
			indent = { enable = true },
			autotag = { enable = true },
			enable = true,
			modules = {},
		})
	end,
}
