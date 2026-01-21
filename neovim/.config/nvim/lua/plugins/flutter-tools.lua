return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
    'hrsh7th/cmp-nvim-lsp', -- Required for auto-import capabilities
  },
  config = function()
    -- Create the capabilities for auto-import (completions)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_ok then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    require("flutter-tools").setup({
      ui = {
        -- Show the border around the UI
        border = "rounded",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      -- Essential for Flutter: helps identify which closing } belongs to which widget
      closing_tags = {
        highlight = "Comment",
        prefix = "// ",
        enabled = true,
      },
      lsp = {
        capabilities = capabilities, -- Pass cmp capabilities for auto-import
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr, noremap = true, silent = true }

          -- 1. Code Actions (Your request: <leader>ga)
          vim.keymap.set({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Flutter Code Action" }))

          -- 2. Jump to Errors (Your request: <leader>gn / <leader>gp)
          -- Logic adapted to only target severity.ERROR
          vim.keymap.set("n", "<leader>gn", function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
          end, vim.tbl_extend("force", opts, { desc = "Next Error" }))

          vim.keymap.set("n", "<leader>gp", function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
          end, vim.tbl_extend("force", opts, { desc = "Previous Error" }))

          -- Standard LSP Navigation (Consistency with your other files)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, opts)
        end,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/.pub-cache"),
            vim.fn.expand("/opt/flutter/"),
          },
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
          updateImportsOnRename = true, -- Auto-update imports when moving files
        }
      }
    })
  end,
}
