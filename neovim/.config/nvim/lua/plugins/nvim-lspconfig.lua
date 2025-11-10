return {
	-- LSP Configuration
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	dependencies = {
		-- LSP Management
		{ "williamboman/mason.nvim",                   cmd = "Mason", build = ":MasonUpdate" },
		{ "williamboman/mason-lspconfig.nvim",         lazy = true },

		-- Auto-Install LSPs, linters, formatters, debuggers
		{ "WhoIsSethDaniel/mason-tool-installer.nvim", lazy = true },

		-- Useful status updates for LSP
		{ "j-hui/fidget.nvim",                         opts = {},     lazy = true },

		-- Additional lua configuration, makes nvim stuff amazing!
		{ "folke/neodev.nvim",                         opts = {},     ft = "lua" },

		{ "SmiteshP/nvim-navic",                       lazy = true },
	},
	config = function()
		require("mason").setup({
			PATH = "prepend",
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
				border = "rounded",
				width = 0.8,
				height = 0.8,
			},
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		})

		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Common on_attach function
		local common_on_attach = function(client, bufnr)
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

			local opts = { buffer = bufnr, noremap = true, silent = true }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

			-- Keybindings from your init.lua (LSP section)
			vim.keymap.set("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
			vim.keymap.set("n", "<leader>gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
			vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			vim.keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
			vim.keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
			vim.keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
			vim.keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
			vim.keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.jump({count=-1, float=true})<CR>", opts)
			vim.keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>", opts)
			vim.keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)

			if client.server_capabilities.documentSymbolProvider then
				local navic_ok, navic = pcall(require, "nvim-navic")
				if navic_ok then
					local is_navic_attached = false
					for _, existing_client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
						if navic.is_attached(bufnr, existing_client.id) then
							is_navic_attached = true
							break
						end
					end
					if not is_navic_attached then
						navic.attach(client, bufnr)
					end
				end
			end
		end

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = {
				"jdtls",
				"lua_ls",
				"pyright",
				"gopls",
				"bashls",
				"cssls",
				"html",
				"marksman",
				"sqlls",
				"tailwindcss",
				"yamlls",
				"templ",
				"jsonls",
				"ruff",
				"vtsls",
			},
			auto_installation = true,
			handlers = {
				["vtsls"] = function()
					lspconfig.vtsls.setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
						root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
					})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["jdtls"] = function() end,
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
					})
				end,
			},
		})

		if pcall(require, "fidget") then
			require("fidget").setup({})
		end

		local open_floating_preview_orig = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return open_floating_preview_orig(contents, syntax, opts, ...)
		end

		local mason_tool_installer = require("mason-tool-installer")
		mason_tool_installer.setup({
			ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"eslint_d",
				"jsonlint",
				"yamllint",
				"yamlfix",
				"jq",
				"shfmt",
				"prettier",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}
