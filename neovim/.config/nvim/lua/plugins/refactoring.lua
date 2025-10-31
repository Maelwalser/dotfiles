return {
    'theprimeagen/refactoring.nvim',
    dependencies = {
        {'nvim-lua/plenary.nvim'},
        {'nvim-treesitter/nvim-treesitter'}
    },
    keys = {
        {
            '<leader>ri',
            function()
                require('refactoring').refactor('Inline Variable')
            end,
            mode = 'v',
            noremap = true,
            silent = true,
            desc = 'Refactor: Inline Variable'
        },
        -- Example of how to add more refactorings that will also be lazy-loaded
        -- {
        --     '<leader>re',
        --     function()
        --         require('refactoring').refactor('Extract Function')
        --     end,
        --     mode = 'v',
        --     noremap = true,
        --     silent = true,
        --     desc = 'Refactor: Extract Function'
        -- }
    },
    config = function()
        require('refactoring').setup({})
    end,
}
