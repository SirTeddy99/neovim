# Installation

For ubuntu

```bash
# Update and git and make
sudo apt update
sudo apt install git make

# Clone your config (it will use master branch by default)
git clone https://github.com/SirTeddy99/neovim.git ~/.config/nvim

# Go to the directory
cd ~/.config/nvim

# Run the Makefile
make install
```


 # Git with fugitive

[Doc for fugitive](https//github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt)

- `\<leader>gs` Go into git mode (fugitive)

## Git add, commit, and push

- `s` Add current file
- `cc` Commit (opens commit file for message input)
- `P` Push
- `co\<leader>` Checkout (set command to `Git checkout` )

## Git diff with fugitive

### Git diff before push

- `dp` Ordinary diff (above window)
- `dd` Side-by-side diff
- `=` Diff in same window

### Git diff open window, when ready to push

- `o` Open horizontally
- `gO` Open vertically

### Exit commands

- `bd` Close current window (if screwed and not exiting Neovim)
- `q` Close current window (normal exit, close Neovim if no other windows)
- `Ctrl+w o` Close all windows but the current one

### Stash commands (create a "local" branch)

- `czz` Stash changes
- `czA` Force pop both changes from stash
- `gu` Use the diff on the left
- `gh` Use the diff on the right

## Jumping and manipulation

### C command

- `ci"` Remove text inside ""
- `ciw` Remove word
- `ca"` Remove "" when inside

### Edit all words

- `<space>s` setup %s type of manupilation

### Jumping

- `gd` Go to definition
- `f"` Jump to the first "
- `F"` Jump backwards to "
- `Ctrl+d` denne hopper page down

### Search

- `*` Search for word in document (cursor must be on the word)

### Autofix

- `\<leader>vca` Autofix with LSP (needs proper setup)
- `=` Auto indents

## go-code

- `gd` Go to definition
- `K` Show hover information
- `<leader>vws` Search workspace symbols
- `<leader>vd` Show line diagnostics
- `[d` Go to next diagnostic
- `]d` Go to previous diagnostic
- `<leader>vca` Code actions
- `<leader>vrr` Find references
- `<leader>vrn` Rename symbol
- `<C-h>` Show signature help

## Visual-block

[Link to doc](https://neovim.io/doc/user/visual.html)

- `ctrl+v` and hjkl to mark - `gv` mark same area again
- `c` change text - `d` delete - `y` yank - `<`rm tab - `>`add tab
- `crtl + c` eller `esc` for å legge til endringene du har skrevet

## Jump to terminal and back

- `crtl + z` go to terminal
- `fg + enter` to return to nvim

## splitt view

open "find files"

- `ctrl + v` (vertical splitt)
- `ctrl + h` (horizontal splitt)
- `Ctrl-w r` This will rotate the windows in a circular manner.
- `Ctrl-w +` to increase the height of the current window.
- `Ctrl-w -` to decrease the height.
- `Ctrl-w >` to increase the width.
- `Ctrl-w <` to decrease the width.

## linters used

  Installed
    ◍ goimports
    ◍ golangci-lint
    ◍ gopls
    ◍ jq
    ◍ lua-language-server lua_ls
    ◍ revive
    ◍ rust-analyzer rust_analyzer
    ◍ shellcheck
    ◍ staticcheck
    ◍ terraform-ls terraformls
    ◍ tflint
