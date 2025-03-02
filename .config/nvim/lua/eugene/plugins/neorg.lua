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
								notes = "~/eugene",
								journal = "~/metaboulie",
								dev = "~/metaboulie",
								blog = "~/metaboulie",
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

			-- set keymaps
			local keymap = vim.keymap

			keymap.set("n", "<leader>njt", ":Neorg journal today<CR>", {
				desc = "Open journal for today",
			})
			keymap.set("n", "<leader>njy", ":Neorg journal yesterday<CR>", {
				silent = true,
				noremap = true,
				desc = "Open journal for yesterday",
			})
			keymap.set("n", "<leader>njm", ":Neorg journal tomorrow<CR>", {
				silent = true,
				noremap = true,
				desc = "Open journal for tomorrow",
			})
			keymap.set("n", "<leader>njo", ":Neorg journal toc open<CR>", {
				silent = true,
				noremap = true,
				desc = "Open journal table of contents",
			})

			-- Binding Keys for Norg Files Only
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = "norg",
				callback = function()
					-- Task status keymaps
					keymap.set("n", "<leader>tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", {
						buffer = true,
						silent = true,
						desc = "Toggle task status",
					})
					keymap.set("n", "<leader>nn", "<Plug>(neorg.dirman.new-note)", {
						silent = true,
						desc = "Create new note",
					})
				end,
			})
		end,
	},
}
