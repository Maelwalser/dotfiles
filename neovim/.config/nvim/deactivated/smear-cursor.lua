return {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
        -- PERFORMANCE: Window-only mode is fastest
        options = {
            mode = "window"
        }
    },
    config = function()
        require("smear_cursor").setup({
            stiffness = 0.8,
            trailing_stiffness = 0.6,    -- Default: 0.4, higher = less trailing
            stiffness_insert_mode = 0.7, -- Faster in insert mode
            trailing_stiffness_insert_mode = 0.7,
            -- PERFORMANCE: Reduce update frequency for better performance
            time_interval = 20, -- milliseconds (default: 17, higher = less CPU)

            smear_terminal_mode = true,
            frequency = 30,      -- More frequent updates for smoother/snappier feel
            hlgroup = "NonText", -- Often a subtle grey

            -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
            -- Smears will blend better on all backgrounds
            legacy_computing_symbols_support = true,
            -- PERFORMANCE: Shorter animation distances
            distance_stop_animating = 0.3, -- Stop animation sooner (default: 0.1)

            min_horizontal_distance_smear = 2,
            min_vertical_distance_smear = 2,

            smear_to_cmd = true,
            smear_between_buffers = true,
            smear_between_neighbor_lines = true, -- Keep for better UX
            scroll_buffer_space = true,

            smear_insert_mode = true,

            trailing_exponent = 2,

            cursor_color = "#d3cdc3",

            smear_horizontally = true,
            smear_vertically = true,
            smear_diagonally = true,

            never_draw_over_target = true,
            -- Smear cursor when moving within line or to neighbor lines.
            -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control

            disabled_buftypes = { "terminal", "nofile", "quickfix", "prompt", "help" },
            filetypes_disabled = {
                "snacks_terminal",
                "lazy",
                "neo-tree",
                "NvimTree",
                "Trouble",
                "mason",
                "telescope",
                "alpha",
                "dashboard",
                "help",
                "terminal",
            },
        })
    end
}
