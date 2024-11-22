-- Start here are plugin that you, Mikey, setup yourself!
return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Optional, for file icons
  },
  config = function()
    require('nvim-tree').setup {
      -- Custom configurations go here
      -- e.g., auto_close = true, diagnostics = { enable = true },
    }
  end,
}
