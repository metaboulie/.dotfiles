return {
	-- https://github.com/stevearc/conform.nvim
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "BufWritePre" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				yaml = { "yamlfmt" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				toml = { "taplo" },
				haskell = { "fourmolu" },
				python = { "ruff" },
				html = { "prettierd" },
				css = { "prettierd" },
				markdown = { "prettierd" },
			},
			format_on_save = { lsp_fallback = true, async = false, timeout_ms = 1000 },
		})
	end,
}
