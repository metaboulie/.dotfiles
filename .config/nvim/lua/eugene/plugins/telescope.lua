return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = { path_display = { "smart" } },
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Fuzzy find keymaps" })
		keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find, { desc = "Current Buffer Fuzzy Find" })
		keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep" })
		keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
	end,
}
