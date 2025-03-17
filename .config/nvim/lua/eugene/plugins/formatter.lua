return {
	-- https://github.com/stevearc/conform.nvim
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "BufWritePre" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				json = { "prettier" },
				yaml = { "prettier" },
				lua = { "stylua" },
				python = { "ruff" },
				rust = { "rustfmt" },
				toml = { "taplo" },
				haskell = { "fourmolu" },
			},
			format_on_save = { lsp_fallback = true, async = false, timeout_ms = 1000 },
		})
	end,
}
