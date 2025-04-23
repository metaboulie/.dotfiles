return {
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			local neogit = require("neogit")
			neogit.setup({ graph_style = "kitty" })

			local keymap = vim.keymap
			keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
			keymap.set("n", "<leader>nc", "<cmd>NeogitCommit<CR>", { desc = "Open Neogit Commit" })
			keymap.set("n", "<leader>nl", "<cmd>NeogitLogCurrent<CR>", { desc = "Open Neogit log buffer" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "*" },
				change = { text = "~" },
				delete = { text = "-" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
}
