return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	-- Two important keymaps to use while in Telescope are:
	--  - Insert mode: <c-/>
	--  - Normal mode: ?
	--
	-- This opens a window that shows you all of the keymaps for the current
	-- Telescope picker. This is really useful to discover what Telescope can
	-- do as well as how to actually do it!

	-- [[ Configure Telescope ]]
	-- See `:help telescope` and `:help telescope.setup()`
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Fuzzy find keymaps" })
		keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fsd", builtin.live_grep, { desc = "Telescope live grep" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
		keymap.set("n", "<leader>fq", builtin.treesitter, { desc = "Lists from treesitter queries" })
		keymap.set("n", "<leader>fg", builtin.git_commits, { desc = "Lists git commits" })
		keymap.set("n", "<leader>fc", builtin.commands, { desc = "Lists available commands" })
		keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Lists diagnostics" })
		keymap.set("n", "<leader>fsb", builtin.current_buffer_fuzzy_find, { desc = "Current Buffer Fuzzy Find" })
		keymap.set("n", "<leader>fss", builtin.lsp_document_symbols, { desc = "Lists available symbols" })
		keymap.set("n", "<leader>fm", builtin.marks, { desc = "List marks" })
		keymap.set(
			"n",
			"<leader>fld",
			builtin.lsp_definitions,
			{ desc = "Goto the definition of the word under curosr" }
		)
		keymap.set("n", "<leader>flr", builtin.lsp_references, { desc = "LSP refs for word under cursor" })

		keymap.set(
			"n",
			"<leader>flt",
			builtin.lsp_type_definitions,
			{ desc = "Goto the definition of the type of the word under cursor" }
		)
		keymap.set(
			"n",
			"<leader>fli",
			builtin.lsp_implementations,
			{ desc = "Goto the implementation of the word under the cursor" }
		)
	end,
}
