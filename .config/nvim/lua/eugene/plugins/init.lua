return {
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen,
				default_mappings = true,
				mappings = {
					i = { j = { k = "<Esc>", j = "<Esc>" } },
					c = { j = { k = "<Esc>", j = "<Esc>" } },
					t = { j = { k = "<C-\\><C-n>" } },
					v = { j = { k = "<Esc>" } },
					s = { j = { k = "<Esc>" } },
				},
			})
		end,
	},
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	{
		-- https://github.com/stevearc/dressing.nvim
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
			vim.o.background = "dark"
			vim.cmd([[colorscheme gruvbox]])
		end,
		opts = ...,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"mvllow/modes.nvim",
		tag = "v0.2.1",
		config = function()
			require("modes").setup({
				colors = {
					bg = "", -- Optional bg param, defaults to Normal hl group
					copy = "#f5c359",
					delete = "#c75c6a",
					insert = "#78ccc5",
					visual = "#9745be",
				},

				-- Set opacity for cursorline and number background
				line_opacity = 0.33,

				-- Enable cursor highlights
				set_cursor = true,

				-- Enable cursorline initially, and disable cursorline for inactive windows
				-- or ignored filetypes
				set_cursorline = true,

				-- Enable line number highlights to match cursorline
				set_number = true,

				-- Disable modes highlights in specified filetypes
				-- Please PR commonly ignored filetypes
				ignore_filetypes = { "NvimTree", "TelescopePrompt" },
			})
		end,
	},
}
