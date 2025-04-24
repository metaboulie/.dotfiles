return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
		config = function()
			local flash = require("flash")
			flash.setup({ modes = { char = { keys = {} } } })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({ check_ts = true, ts_config = { lua = { "string" } } })
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	"nvim-lua/plenary.nvim",
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			local surround = require("mini.surround")
			surround.setup({})
		end,
	},
	{
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
	},
}
