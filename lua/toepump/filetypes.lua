-- This file defines any filetypes that aren't automatically correctly identified by neovim
vim.filetype.add {
    extension = {
        save = 'json',
        -- Godot shader include files: neovim has no detection for these, and there is no separate
        -- `gdshaderinc` parser, so reuse the gdshader filetype/parser.
        gdshaderinc = 'gdshader',
    },
}
