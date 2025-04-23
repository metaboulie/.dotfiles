return {
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		config = function()
			local neorg = require("neorg")
			neorg.setup({
				load = {
					["core.defaults"] = { config = { disable = { "core.pivot" } } },
					["core.esupports.metagen"] = { config = { author = "eugene" } },
					["core.esupports.hop"] = {},
					["core.keybinds"] = { config = { default_keybinds = true } },
					["core.completion"] = { config = { engine = "nvim-cmp" } },
					["core.integrations.nvim-cmp"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								journal = "~/metaboulie",
								dev = "~/deepBoredom",
							},
							default_workspace = "journal",
							open_last_workspace = false,
						},
					},
					["core.summary"] = {},
				},
			})
			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
			local keymap = vim.keymap
			keymap.set("n", "<leader>njt", ":Neorg journal today<CR>", {
				desc = "Open journal for today",
			})
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = "norg",
				callback = function()
					keymap.set("n", "<leader>tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", {
						buffer = true,
						silent = true,
						desc = "Toggle task status",
					})
				end,
			})
		end,
	},
}
