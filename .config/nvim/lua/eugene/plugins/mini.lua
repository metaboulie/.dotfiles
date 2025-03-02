return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		local surround = require("mini.surround")
		surround.setup({})
	end,
}
