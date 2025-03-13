return {
	{
		"vim-crystal/vim-crystal",
		ft = "crystal",
		init = function()
			vim.g.crystal_auto_format = 1
			vim.g.crystal_enable_completion = 1
		end,
		config = function()
			-- Auto-format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.cr",
				callback = function()
					vim.cmd("CrystalFormat")
				end,
			})
		end,
	},
}
