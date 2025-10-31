vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false -- Go typically uses tabs

-- Example: Keymap to run go tests in the current package
vim.keymap.set("n", "<leader>tt", "<cmd>!go test -v ./...<CR>", { buffer = true, noremap = true, silent = true, desc = "Go Test Package" })
vim.keymap.set("n", "<leader>tc", "<cmd>!go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out<CR>", { buffer = true, noremap = true, silent = true, desc = "Go Test Coverage" })

-- If using ray-x/go.nvim, it provides commands like :GoTest, :GoCoverage etc.
-- vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { buffer = true, desc = "Go Test (go.nvim)"
