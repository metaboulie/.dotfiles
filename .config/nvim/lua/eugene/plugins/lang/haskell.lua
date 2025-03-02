vim.g.haskell_tools = {
	---@type haskell-tools.tools.Opts
	tools = {
		-- TODO: setup up hoogle for telescope
		-- https://github.com/MrcJkb/haskell-tools.nvim?tab=readme-ov-file#telescope-extension
		-- https://github.com/luc-tielen/telescope_hoogle
		hoogle = {
			mode = "auto",
		},
		definition = {
			-- Configure |vim.lsp.definition| to fall back to hoogle search
			hoogle_signature_fallback = false,
		},
		repl = {
			-- Use cabal instead of stack
			prefer = function()
				return vim.fn.executable("cabal") == 1 and "cabal" or "stack"
			end,
		},
	},
	---@type haskell-tools.lsp.ClientOpts
	--- To view the default settings, run `haskell-language-server generate-default-config`
	hls = {
		auto_attach = true,
		---@type (fun(client:number,bufnr:number,ht:HaskellTools)) Callback that is invoked when the client attaches to a buffer.
		---@see vim.lsp.start
		on_attach = function(_, _, _)
			-- Set keybindings, etc. here.
		end,
	},
	---@type haskell-tools.dap.Opts
	--- TODO: setup haskell-debug-adapter
	--- https://github.com/phoityne/haskell-debug-adapter/
	--- https://github.com/mfussenegger/nvim-dap
	--- https://github.com/MrcJkb/haskell-tools.nvim?tab=readme-ov-file#create-haskell-debug-adapter-launch-configurations
	dap = {},
}

return {
	-- https://github.com/mrcjkb/haskell-tools.nvim
	"mrcjkb/haskell-tools.nvim",
	version = "^4", -- Recommended
	lazy = false, -- This plugin is already lazy
}

-- Other configuration instructions
-- How to disable individual code lenses
-- https://github.com/MrcJkb/haskell-tools.nvim?tab=readme-ov-file#how-to-disable-individual-code-lenses
