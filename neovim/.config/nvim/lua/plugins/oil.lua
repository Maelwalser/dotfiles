return {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    require("oil").setup({
      keymaps = {
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-v>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        
        -- Preserve your window navigation keys
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,

        ["q"] = "actions.close",
      },
      default_file_explorer = true,
      columns = {
        "icon",
      },
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      view_options = {
        show_hidden = true,
      },
    })

    -- Global function to toggle the sidebar
    _G.toggle_oil_sidebar = function()
      local sidebar_win = nil

      -- Find existing sidebar window (marked with oil_sidebar flag)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ok, is_sidebar = pcall(vim.api.nvim_win_get_var, win, 'oil_sidebar')
        if ok and is_sidebar then
          sidebar_win = win
          break
        end
      end

      -- If sidebar exists, close it (but only if it's not the last window)
      if sidebar_win then
        local win_count = #vim.api.nvim_list_wins()
        if win_count > 1 then
          vim.api.nvim_win_close(sidebar_win, false)
        else
          -- If it's the last window, just switch to a different buffer
          vim.cmd("enew")
        end
        return
      end

      -- Remember the current window to return focus if needed
      local original_win = vim.api.nvim_get_current_win()

      -- Open oil sidebar
      vim.cmd("vsplit")
      vim.cmd("wincmd H")
      vim.cmd("vertical resize 30")
      require("oil").open(vim.fn.getcwd())

      -- Set up the custom keymap ONLY for this sidebar window
      local new_sidebar_win = vim.api.nvim_get_current_win()
      local sidebar_buf = vim.api.nvim_win_get_buf(new_sidebar_win)

      -- Store a flag to identify this as a sidebar window
      vim.api.nvim_win_set_var(new_sidebar_win, 'oil_sidebar', true)

      -- If we were originally in an oil window, return focus to it
      local original_buf = vim.api.nvim_win_get_buf(original_win)
      local original_buf_name = vim.api.nvim_buf_get_name(original_buf)
      if original_buf_name:match("^oil://") then
        vim.api.nvim_set_current_win(original_win)
      end

      -- Set up buffer-local keymap for the sidebar
      vim.keymap.set("n", "<CR>", function()
        -- Get the entry under cursor
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if not entry then
          return
        end

        -- If it's a directory, navigate into it
        if entry.type == "directory" then
          oil.select()
          return
        end

        -- If it's a file, open it in the main window (only for sidebar)
        local current_win = vim.api.nvim_get_current_win()
        local ok, is_sidebar = pcall(vim.api.nvim_win_get_var, current_win, 'oil_sidebar')

        if ok and is_sidebar then
          local filepath = oil.get_current_dir() .. entry.name

          -- Find the main window (not the oil sidebar)
          local main_win = nil

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            -- Skip the current sidebar window
            if win ~= current_win then
              local win_ok, win_is_sidebar = pcall(vim.api.nvim_win_get_var, win, 'oil_sidebar')
              -- If this window is not marked as a sidebar, it's a main window
              if not (win_ok and win_is_sidebar) then
                main_win = win
                break
              end
            end
          end

          -- If we found a main window, switch to it and open the file
          if main_win then
            vim.api.nvim_set_current_win(main_win)
            vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
          else
            -- Fallback: create a new window to the right if no main window found
            vim.cmd('wincmd l') -- Move right (this should create a split if we're at the rightmost)
            vim.cmd('vnew') -- Create a new vertical split
            vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
          end
        else
          -- For non-sidebar oil windows, use default behavior
          oil.select()
        end
      end, { buffer = sidebar_buf, desc = "Open file in main window" })
    end

    vim.keymap.set("n", "<leader>e", "<CMD>lua _G.toggle_oil_sidebar()<CR>", { desc = "Toggle file explorer" })
  end,
}
