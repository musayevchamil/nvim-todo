# nvim-todo 📝

A lightweight Neovim plugin to manage TODOs inside Neovim.

## Features

* Add TODOs with `:TodoAdd`
* List TODOs in a floating window with `:TodoList`
* Delete TODOs with `:TodoDelete`
* Toggle TODOs done/undone with `:TodoToggle`
* Fuzzy-find & CRUD in Telescope picker with `:TodoTelescope`

## Installation

### with packer.nvim

```lua
use {
  "musayevchamil/nvim-todo",
  requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    require("nvim-todo")
  end,
}
```

### with lazy.nvim

```lua
{
  "musayevchamil/nvim-todo",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = true,
}
```

## Usage

* `:TodoList`           Show all TODOs in a floating window
![image](https://github.com/user-attachments/assets/65f270a2-e069-4562-aaaf-b633a4fbcac0)

  * `:TodoAdd`            Prompt & add a new item
  * `:TodoDelete`         Prompt for number & delete an item
  * `:TodoToggle`         Prompt for number & toggle done/undone


* `:TodoTelescope`      Open Telescope picker:
![image](https://github.com/user-attachments/assets/dbd1ecb8-79c6-4451-9efc-a19fb1bb33f0)

  * `<CR>` to confirm/select (no-op)
  * `<C-t>` to toggle status
  * `<C-d>` to delete item

## Project-local Files

If inside a Git repository, TODOs are stored in `<project>/.nvim_todo`. Otherwise, they are saved in Neovim's data directory (`stdpath("data")/todos.txt`).

## Configuration

No additional setup is required—commands become available automatically when you load the plugin:

```lua
require("nvim-todo")
```

## License

MIT © [musayevchamil](https://github.com/musayevchamil)
