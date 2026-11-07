return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			hint = { enable = true, paramType = true },
			diagnostics = {
				disable = { "incomplete-signature-doc", "trailing-space" },
			},
		},
	},
}
