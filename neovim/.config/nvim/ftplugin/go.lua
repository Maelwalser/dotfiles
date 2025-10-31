vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false

-- Example: Keymap to run go tests in the current package
vim.keymap.set("n", "<leader>tt", "<cmd>!go test -v ./...<CR>", { buffer = true, noremap = true, silent = true, desc = "Go Test Package" })
vim.keymap.set("n", "<leader>tc", "<cmd>!go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out<CR>", { buffer = true, noremap = true, silent = true, desc = "Go Test Coverage" })

