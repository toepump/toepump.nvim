return {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
        picker = {
            enabled = true,
            win = {
                input = {
                    keys = {
                        -- send to quick fix list for ctrl-q
                        ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
                    },
                },
            },
        },
        explorer = {
            enabled = true,
            replace_netrw = true, -- This is the default, but good to be explicit
        },
        scroll = {},
        zen = {},
    },
    config = function(_, opts)
        require('snacks').setup(opts)

        -- snacks.explorer toggle open/close
        -- Map a key to toggle the explorer
        vim.keymap.set('n', '<leader>t', function()
            Snacks.explorer()
        end, { desc = '[T]oggle Snacks Explorer' })

        vim.keymap.set('n', '<leader>z', function()
            Snacks.zen()
        end, { desc = 'Toggle Zen Mode' })

        local function wrap_function(action)
            return function()
                Snacks.picker[action]()
            end
        end

        local maps = {
            { '<leader>sh', 'help', '[S]earch [H]elp' },
            { '<leader>sk', 'keymaps', '[S]earch [K]eymaps' },
            { '<leader>sf', 'files', '[S]earch [F]iles' },
            { '<leader>sw', 'grep_word', '[S]earch current [W]ord' },
            { '<leader>sg', 'grep', '[S]earch by [G]rep' },
            { '<leader>sd', 'diagnostics_buffer', '[S]earch Document [D]iagnostics' },
            { '<leader>sr', 'resume', '[S]earch [R]esume' }, -- Persists cursor!
            { '<leader>s.', 'recent', '[S]earch Recent Files' },
            { '<leader><leader>', 'buffers', '[ ] Find existing buffers' },
            { '<leader>sj', 'jumps', '[S]earch [J]ump List' },
        }

        -- create the keymaps with the safety wrapper
        for _, m in ipairs(maps) do
            vim.keymap.set('n', m[1], wrap_function(m[2]), { desc = m[3] })
        end
    end,
}
