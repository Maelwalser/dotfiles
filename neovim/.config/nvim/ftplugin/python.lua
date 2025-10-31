-- Python conventionally uses 4 spaces for indentation
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- Example: Keymap for running the current file with the venv python
vim.keymap.set("n", "<leader>pr", function()
  local venv_python = os.getenv("VIRTUAL_ENV")
  local python_exe = "python"
  if venv_python and venv_python ~= "" then
    python_exe = venv_python .. "/bin/python" -- Adjust for Windows
  end
  vim.cmd("!" .. python_exe .. " %")
end, { buffer = true, noremap = true, silent = false, desc = "Python Run File" })
