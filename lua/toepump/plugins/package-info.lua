vim.api.nvim_set_keymap('n', '<leader>ns', "<cmd>lua require('package-info').show()<cr>", { silent = true, noremap = true, desc = 'Show Package Info' })
vim.api.nvim_set_keymap(
    'n',
    '<leader>np',
    "<cmd>lua require('package-info').change_version()<cr>",
    { silent = true, noremap = true, desc = 'Change Package Version' }
)
vim.api.nvim_set_keymap(
    'n',
    '<leader>ni',
    "<cmd>lua require('package-info').install()<cr>",
    { silent = true, noremap = true, desc = 'Install Package Dependency' }
)
return {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = { 'json' }, -- or just "json"
    config = function()
        require('package-info').setup()
    end,
}
