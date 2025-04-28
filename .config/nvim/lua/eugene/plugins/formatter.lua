return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "BufWritePre" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				yaml = { "yamlfmt" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				toml = { "taplo" },
			},
			format_on_save = { lsp_fallback = true, async = false, timeout_ms = 1000 },
		})
	end,
}
