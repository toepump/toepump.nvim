return {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        -- Mason must be loaded before its dependents so we need to set it up here.
        -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
        { 'mason-org/mason.nvim', opts = {} },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        -- { 'j-hui/fidget.nvim', opts = {} },

        -- Allows extra capabilities provided by blink.cmp
        'saghen/blink.cmp',
    },
    config = function()
        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
                map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                map('grr', function()
                    Snacks.picker.lsp_references()
                end, '[G]oto [R]eferences')
                map('gri', function()
                    Snacks.picker.lsp_implementations()
                end, '[G]oto [I]mplementation')
                map('grd', function()
                    Snacks.picker.lsp_definitions()
                end, '[G]oto [D]efinition')
                map('gO', function()
                    Snacks.picker.lsp_symbols()
                end, 'Open Document Symbols')
                map('gW', function()
                    Snacks.picker.lsp_workspace_symbols()
                end, 'Open Workspace Symbols')
                map('grt', function()
                    Snacks.picker.lsp_type_definitions()
                end, '[G]oto [T]ype Definition')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end
            end,
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
            } or {},
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        }

        -- NOTE: blink.cmp capabilities don't need to be set here. On nvim 0.11+ blink.cmp registers them
        -- for every server itself via vim.lsp.config('*', ...) (see blink.cmp/plugin/blink-cmp.lua)

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
            --
            -- Some languages (like typescript) have entire language plugins that can be useful:
            --    https://github.com/pmizio/typescript-tools.nvim
            --
            -- But for many setups, the LSP (`ts_ls`) will work just fine
            ts_ls = {},
            tailwindcss = {},
            lua_ls = {
                -- cmd = { ... },
                -- filetypes = { ... },
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
            glsl_analyzer = {
                filetypes = { 'glsl', 'gdshader' },
            },
            jsonls = {},
            -- css, scss, less
            cssls = {
                -- ignore unknown at-rules so tailwind's @tailwind / @apply / @layer don't get flagged
                settings = {
                    css = { validate = true, lint = { unknownAtRules = 'ignore' } },
                    scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
                    less = { validate = true, lint = { unknownAtRules = 'ignore' } },
                },
            },
            somesass_ls = {}, -- scss + indented .sass (cross-file @use/@import, mixins, variables)
        }

        -- Ensure the servers and tools above are installed
        --
        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua', -- Used to format Lua code
            'prettierd', -- Used to format js/ts/css/scss
            'stylelint', -- Used to lint css/scss
            'djlint', -- Used to format html
            'gdtoolkit', -- Provides gdformat and gdlint for gdscript
            'clang-format', -- Used to format gdshader
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        -- Apply the overrides from the servers table above. This has to happen before mason-lspconfig.setup,
        -- since that's what calls vim.lsp.enable() on each installed server (mason-lspconfig v2 `automatic_enable`).
        -- Anything not set here falls back to nvim-lspconfig's defaults for that server.
        for name, config in pairs(servers) do
            if next(config) then
                vim.lsp.config(name, config)
            end
        end

        require('mason-lspconfig').setup {
            ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        }

        -- special case for gdscript LSP using nvim native config/enable rather than the above mason-lspconfig
        vim.lsp.config.gdscript = {
            name = 'godot',
            cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
        }
        vim.lsp.enable 'gdscript'
    end,
}
