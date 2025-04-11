return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag" },
	config = function()
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({ -- enable syntax highlighting
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			ensure_installed = { "rust", "haskell", "lua", "python", "julia", "nim", "c" },
			ignore_install = { "org" },
			indent = { enable = true },
			autotag = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			modules = {},
		})
	end,
}
