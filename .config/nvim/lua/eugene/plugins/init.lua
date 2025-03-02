return {
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen,
				default_mappings = true,
        -- stylua: ignore
				mappings = {
					i = { j = { k = "<Esc>", j = "<Esc>", }, },
					c = { j = { k = "<Esc>", j = "<Esc>", }, },
					t = { j = { k = "<C-\\><C-n>", }, },
					v = { j = { k = "<Esc>", }, },
					s = { j = { k = "<Esc>", }, },
				},
				-- stylua: enable
			})
		end,
	},
	{ "wakatime/vim-wakatime", lazy = false },
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
	{
		"OXY2DEV/helpview.nvim",
		lazy = false,
		config = function()
			require("helpview").setup({
				renderers = {},

				preview = {
					enable = true,
					enable_hybrid_mode = true,

					modes = { "n", "c", "no" },
					hybrid_modes = {},
					linewise_hybrid_mode = false,

					filetypes = { "help" },
					ignore_previews = {},
					ignore_buftypes = {},
					condition = nil,

					max_buf_lines = 500,
					draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
					edit_range = { 0, 0 },

					debounce = 150,
					callbacks = {},

					icon_provider = "mini",

					splitview_winopts = { split = "right" },
					preview_winopts = { width = math.floor(80) },
				},

				vimdoc = {
					arguments = {},
					code_blocks = {},
					headings = {},
					highlight_groups = {},
					horizontal_rules = {},
					inline_codes = {},
					keycodes = {},
					modelines = {},
					notes = {},
					optionlinks = {},
					tags = {},
					taglinks = {},
					urls = {},
				},
			})
		end,
	},
}
