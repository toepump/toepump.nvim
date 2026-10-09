return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local treesitter = require 'nvim-treesitter'
        treesitter.setup()

        -- toepump: run <leader>bp autcmd while in a file (see init lua) to identify the Parser and Filetype
        -- install the following Parser:
        treesitter.install {
            'bash',
            'c',
            'diff',
            'html',
            'lua',
            'luadoc',
            'markdown',
            'markdown_inline',
            'query',
            'vim',
            'vimdoc',
            'gdscript',
            'gdshader',
            'tsx',
            'javascript',
            'json',
            'css',
            'scss',
        }

        -- Filetypes to start the above parsers for (these may not match the parsers, but most of the time do. To be sure... again, run <leader>bp in the file in question)
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                'bash',
                'c',
                'diff',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'gdscript',
                'gdshader', -- + gdshaderinc (mapped to gdshader in toepump/filetypes.lua)
                'javascript',
                'typescriptreact',
                'json',
                'css',
                'scss',
                -- no 'sass' here: there is no treesitter parser for it, vim's built-in sass syntax handles highlighting
            },
            callback = function()
                -- syntax highlighting, provided by Neovim
                vim.treesitter.start()
                -- folds, provided by Neovim (commented out because folds confusing)
                -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                -- vim.wo.foldmethod = 'expr'
                -- indentation, provided by nvim-treesitter
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
