require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		-- servers (9.2)
		"pyright",
		"ruff",
		"gopls",
		"clangd",
		"vue-language-server",
		"astro-language-server",
		"html-lsp",
		"json-lsp",
		"yaml-language-server",
		"marksman",
		"taplo",
		"texlab",
		"tinymist",
		"terraform-ls",
		"tflint",
		"dockerfile-language-server",
		"docker-compose-language-service",
		"biome",
		-- formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
		-- formatters (9.2)
		"gofumpt",
		"goimports",
		"latexindent",
	},
	auto_update = false,
	run_on_start = true,
})

vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
	},
})

vim.lsp.enable({ "eslint", "oxlint", "lua_ls", "cssls", "vtsls", "tailwindcss", "rust_analyzer" })
vim.lsp.enable({
	"pyright",
	"ruff",
	"gopls",
	"clangd",
	"vue_ls",
	"astro",
	"html",
	"jsonls",
	"yamlls",
	"marksman",
	"taplo",
	"texlab",
	"tinymist",
	"terraformls",
	"tflint",
	"dockerls",
	"docker_compose_language_service",
	"biome",
})

local diag = User.icons.diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = { prefix = "●", source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diag.Error,
			[vim.diagnostic.severity.WARN] = diag.Warn,
			[vim.diagnostic.severity.INFO] = diag.Info,
			[vim.diagnostic.severity.HINT] = diag.Hint,
		},
	},
})
