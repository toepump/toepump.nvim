return { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_format = 'fallback' }
            end,
            mode = '',
            desc = '[F]ormat buffer',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end
        end,
        formatters_by_ft = {
            lua = { 'stylua' },
            gdscript = { 'gdformat' },
            gdshader = { 'gdshader_clang_format' }, -- also covers .gdshaderinc (see toepump/filetypes.lua)
            html = { 'djlint' },
            -- You can use 'stop_after_first' to run the first available formatter from the list
            javascript = { 'prettierd', 'prettier', stop_after_first = true },
            typescript = { 'prettierd', 'prettier', stop_after_first = true },
            javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            css = { 'prettierd', 'prettier', stop_after_first = true },
            scss = { 'prettierd', 'prettier', stop_after_first = true },
            less = { 'prettierd', 'prettier', stop_after_first = true },
        },
        formatters = {
            -- There's no dedicated Godot shader formatter, and glsl_analyzer's LSP formatting mangles
            -- uniform hints (e.g. `hint_range(0.0, 1.0)= 1.0 ;`). clang-format in GLSL mode handles
            -- Godot shader syntax fine; the style below follows Godot's conventions (tabs, K&R braces).
            gdshader_clang_format = {
                command = 'clang-format',
                args = {
                    '--assume-filename=shader.glsl',
                    '--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: ForIndentation, ColumnLimit: 0, AllowShortFunctionsOnASingleLine: Inline, AllowShortIfStatementsOnASingleLine: Never, AllowShortBlocksOnASingleLine: Never, SortIncludes: Never}',
                },
                stdin = true,
            },
        },
    },
}
