return {
    'ibhagwan/fzf-lua',
    event = 'VimEnter',
    config = function()
        local fzf = require 'fzf-lua'

        -- 1. Global setting to persist search state/cursor when using "resume"
        fzf.setup {
            resume = true,
            keymap = {
                fzf = {
                    ['ctrl-q'] = 'select-all+accept', -- send to quick fix list for ctrl-q
                },
            },
        }

        -- fzf_safe: A traffic controller for fzf-lua to prevent winfixbuf (nvim 0.10 feature to lock buffers to windows) crashes.
        -- 1. Closes mini.files to prevent UI layout conflicts.
        -- 2. Checks if the current window is "fixed" (winfixbuf) or a special UI (buftype).
        -- 3. If restricted, hops to the previous window or forces a split to create a safe landing spot for the file.
        local function fzf_safe(action)
            return function()
                if package.loaded['mini.files'] then
                    require('mini.files').close()
                end

                -- Safety check for winfixbuf/special buffers
                if vim.wo.winfixbuf or vim.bo.buftype ~= '' then
                    vim.cmd 'wincmd p'
                end
                if vim.wo.winfixbuf or vim.bo.buftype ~= '' then
                    vim.cmd 'vsplit'
                end

                fzf[action]()
            end
        end

        local maps = {
            { '<leader>sh', 'helptags', '[S]earch [H]elp' },
            { '<leader>sk', 'keymaps', '[S]earch [K]eymaps' },
            { '<leader>sf', 'files', '[S]earch [F]iles' },
            { '<leader>sw', 'grep_cword', '[S]earch current [W]ord' },
            { '<leader>sg', 'live_grep', '[S]earch by [G]rep' },
            { '<leader>sd', 'diagnostics_document', '[S]earch Document [D]iagnostics' },
            { '<leader>sr', 'resume', '[S]earch [R]esume' }, -- Persists cursor!
            { '<leader>s.', 'oldfiles', '[S]earch Recent Files' },
            { '<leader><leader>', 'buffers', '[ ] Find existing buffers' },
            { '<leader>sj', 'jumps', '[S]earch [J]ump List' },
        }

        -- create the keymaps wiht the safety wrapper
        for _, m in ipairs(maps) do
            vim.keymap.set('n', m[1], fzf_safe(m[2]), { desc = m[3] })
        end
    end,
}
