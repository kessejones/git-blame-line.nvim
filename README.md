# git-blame-line

This plugin is inspired by vscode's Gitlens extension.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'kessejones/git-blame-line.nvim'
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'kessejones/git-blame-line.nvim',
    requires = {
        { 'https://github.com/sindrets/diffview.nvim', opt = true } -- This is optional
    }
}
```

## Setup

git-blame-line needs to be initialized with the setup function.

For example:

```lua
require('git-blame-line').setup({
    git = {
        default_message = 'Not committed yet',
        blame_format = '%an - %ar - %s' -- see https://git-scm.com/docs/pretty-formats
    },
    view = {
        left_padding_size = 5,
        enable_cursor_hold = false
    }
})
```

It will always be considered the default value for options not defined in the setup function

## Usage

- `GitBlameLineShow` - show commit information of the line
- `GitBlameLineClear` - hide text displayed by GitBlameLineShow command
- `GitBlameLineToggle` - show/hide commit information of the line

## Diffview Integration

You can use the `diffview` plugin to open the current line commit diff popup.

Using diffview:

```lua
require('git-blame-line').open_diffview()
```

## Contributing

We welcome any kind of contribution.  
Please, look at the Issues page to see the current backlog, new suggestions, and bugs to work.

## License

Distributed under the same terms as Neovim itself.
