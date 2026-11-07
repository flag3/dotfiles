local ts_settings = {
	updateImportsOnFileMove = { enabled = "always" },
	suggest = { completeFunctionCalls = true },
	inlayHints = {
		enumMemberValues = { enabled = true },
		functionLikeReturnTypes = { enabled = true },
		parameterNames = { enabled = "literals" },
		parameterTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
	languages = { "vue" },
	configNamespace = "typescript",
}

return {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		complete_function_calls = true,
		vtsls = {
			autoUseWorkspaceTsdk = true,
			enableMoveToFileCodeAction = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = { enableServerSideFuzzyMatch = true },
			},
			tsserver = { globalPlugins = { vue_plugin } },
		},
		typescript = ts_settings,
		javascript = ts_settings,
	},
}
