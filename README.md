# toepump.nvim

> [!NOTE]
> This is my neovim configuration repository.
> If you're me, it is recommended to install via the toepump/dotfiles repo (see instructions there).
> Note: this config was originally based on the wonderful kickstart.nvim but has since diverged dramatically.
> Check out kickstart.nvim to have a nice clean starting point to learn neovim.

## Summary:

Below is the overall setup of my configuration.

- `init.lua` - entrypoint and native vim configuration (options, keymaps, autocommands).
- `lua/` - holds all plugins and scripts
    - toepump
        - `plugins/` - dir holding all `lazy.nvim` managed plugins
            - `lsp/` - all LSP related plugins
                - `conform.lua` - auto formatting (uses lsp as fallback if linter not present)
                - `lazydev.lua` - provides lsp configuration for nvim config specifically (nvim apis) 
                - `blink.lua` - provides smart autocompletion based on LSP
                - `lint.lua` - automates linting using linter tools provided via Mason (works with `conform.nvim`)
                - `nvim-lspconfig.lua` - sets up LSPs via Mason LSP package manager which makes it easy to install/update LSPs and other tools like linters. LSPs are essential as they provide hover hints, go-to commands, etc. and actual semantic understanding of the code base.
            - `colorscheme.lua` - catppuccin color scheme
            - `git-blame.lua` - shows virtual text for git blame
            - `git-signs.lua` - shows git signs in the gutter
            - `mini.lua` - collection of minimal plugins with cohesiave philosphy.
                - `mini.icons` - provides icons for GUI and mocks the popular `nvim_web_devicons` for compatibility
                - `mini.ai` - provides smart text interation like `ci(` to change inside parantheses, etc.
                - `mini.surround` - provides shortcuts for editing surrounding brackets/parantehese/quotes
                - `mini.pairs` - provides auto closing brackets when typing opening brackets
                - `mini.files` - file navigator
                - `mini.statusline` - status line
            - `noice.lua` - provides nice GUI for cmdline, notifications, some virtual text, etc
            - `nvim-treesitter.lua` - provides intelligent syntax highlighting and indenting 
            - `package-info.lua` - shows latest npm package virtual text and some shortcuts to manage 
            - `fzf-lua.lua` - very fast fuzzy finder with a preview ui and shortcuts
            - `which-key` - provides the popup to show contextual shortcuts so you don't have to memorize
        - `lazy.lua` - initalizes `lazy.nvim` and loads plugins from `plugins/` directory
        - `filetypes.lua` - overrides vim's automatic filetype detections to manually mapped filetypes if needed
        - `godot.lua` - setup for godot to work with nvim as an external editor

## Installation

### Compataible Neovim Versions

This config only works with `neovim 0.12.x` and is not guaranteed for older versions without tweaks.

### Install External Dependencies

To automatically install these, see [Install Recipes](#install-recipes), then continue from [Install toepump.nvim Configuration](#install-toepumpnvim-configuration)

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation),
  [fd-find](https://github.com/sharkdp/fd#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

### Install toepump.nvim Configuration

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Clone toepump.nvim

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/toepump/toepump.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

> [!TIP]
> run `:checkhealth` from within `neovim` to see if your environment is missing major dependencies. Errors should be addressed while warnings may often be ignored depending on your use case.


### Install Recipes

<details><summary>macos Install Steps</summary>

Note that `gcc` and `make` might already be installed for xcode

```
brew install gcc make git ripgrep fd fzf unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd fzf unzip neovim
```
</details>
