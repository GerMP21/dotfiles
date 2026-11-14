# dotfiles

Arch Linux + [niri](https://github.com/YaLTeR/niri) (Wayland) setup with a Tokyo Night theme.

## Components

| Role | Tool | Config |
|---|---|---|
| Window manager | niri (scrollable tiling) | `.config/niri/config.kdl` |
| Bar | waybar | `.config/waybar/` |
| Launcher | fuzzel | `.config/fuzzel/fuzzel.ini` |
| Notifications | mako | `.config/mako/config` |
| Lock / idle | swaylock + swayidle | `.config/swaylock/config` |
| Wallpaper | swaybg | set in niri config |
| Terminal | alacritty | `.config/alacritty/` |
| Shell | zsh + starship | `.zshrc`, `.zprofile`, `.config/starship.toml` |
| Editors | Neovim (lazy.nvim), Doom Emacs | `.config/nvim/`, `.config/doom/` |
| GTK theme | GTK 2/3 settings | `.config/gtk-3.0/`, `.gtkrc-2.0`, `.icons/` |
| Fonts | JetBrains Mono / Iosevka Nerd Font, CatV, Feather, Grape Nuts | `.local/share/fonts/` |

## Features

- **niri**
  - Spanish (`es`) keyboard layout.
  - Touchpad tap-to-click, natural scrolling, and disable-while-typing.
  - Focus follows the mouse.
  - 8px gaps and a 2px Tokyo Night focus ring.
  - Rounded corners and a translucent alacritty.
  - Preset column widths (1/3, 1/2, 2/3).
- **Autostart:** waybar, mako, swaybg, swayidle and the Emacs daemon.
- **Idle:** locks after 10 minutes, turns monitors off after 15, and locks before sleep.
- **Screenshots:** built into niri, saved to `~/Pictures/Screenshots`.
- **Waybar:**
  - Left: battery, CPU, memory, disk.
  - Center: niri workspaces.
  - Right: network (click opens `nmtui`), volume (click opens pavucontrol), clock with a calendar tooltip, tray.
- **Login:** niri starts automatically when you log in on tty1 (`.zprofile`).
- **Wayland-native apps:** Electron and Qt apps run natively on Wayland.
- **Zsh:**
  - Vi mode.
  - Neovim as editor and man pager.
  - XDG directories.
  - An `extract` function for archives.
  - Starship prompt.
- **Neovim:**
  - Native LSP (`vim.lsp.config`, Neovim 0.11+), with servers installed through Mason, plus nvim-cmp and LuaSnip.
  - Treesitter.
  - Telescope with fzf and zoxide.
  - Harpoon, fugitive and undotree.
  - VimTeX and VimWiki.
  - Kanagawa colorscheme.

## Keybindings

`Mod` is the Super key. `Mod+Shift+/` shows every binding.

### Apps
| Key | Action |
|---|---|
| `Mod+Return` | Alacritty |
| `Mod+D` | fuzzel launcher |
| `Mod+E` | Emacs (client) |
| `Mod+W` | Waterfox |
| `Mod+M` | Thunderbird |
| `Mod+O` | LibreOffice |
| `Mod+G` | GIMP |
| `Mod+I` | Inkscape |
| `Mod+N` | SpaceFM |
| `Mod+K` | KeePassXC |
| `Mod+R` | Goodvibes (radio) |
| `Super+Alt+L` | Lock screen |

### Windows
| Key | Action |
|---|---|
| `Mod+Q` | Close window |
| `Mod+F` / `Mod+Shift+F` | Maximize column / fullscreen |
| `Mod+T` | Toggle floating |
| `Mod+Tab` | Overview |
| `Mod+H` / `Mod+L` (or arrows) | Focus column left / right |
| `Mod+J` / `Mod+Down`, `Mod+Up` | Focus window or workspace down / up |
| `Mod+Alt+H/J/K/L` | Move window or column |
| `Mod+Shift+H/L` | Column width −/+ 10% |
| `Mod+Shift+J/K` | Window height +/− 10% |
| `Mod+[` / `Mod+]` | Pull window into / push out of column |
| `Mod+Space` | Cycle preset column widths |
| `Mod+C` | Center column |

### Workspaces and system
| Key | Action |
|---|---|
| `Mod+1…9` | Go to workspace |
| `Mod+Shift+1…9` | Move column to workspace |
| `Mod+Scroll` | Previous / next workspace |
| `Ctrl+Alt+P` | Screenshot (select area) |
| `Print` / `Alt+Print` | Screenshot screen / window |
| Volume / brightness keys | `wpctl` / `brightnessctl` |
| `Mod+Shift+P` | Monitors off |
| `Mod+Alt+Q` | Quit niri |

### Neovim
Leader is `Space`.

| Key | Action |
|---|---|
| `<leader>pd` | File explorer (netrw) |
| `<leader>ff` / `<leader>fg` | Telescope: find files / git files |
| `<leader>ps` | Telescope: grep for a string |
| `<leader>fz` | Telescope: zoxide directories (`C-f` find files inside) |
| `<leader>a` / `C-e` | Harpoon: mark file / toggle menu |
| `<leader>1`…`<leader>4` | Harpoon: jump to file 1–4 |
| `<leader>gs` | Fugitive git status |
| `<leader>p` / `<leader>P` / `<leader>t` | In fugitive: push / pull --rebase / `push -u origin` |
| `<leader>u` | Undotree |
| `gd` | Go to definition |
| `gn` / `gp` | Next / previous diagnostic |
| `<leader>ca` | Code action |
| `<leader>rr` / `<leader>rn` | References / rename |
| `C-n` / `C-p` / `C-y` / `C-Space` / `C-e` | Completion: next / previous / confirm / open / close |
| `C-h` `C-j` `C-k` `C-l` | Move between splits |
| `C-Arrows` | Resize splits |
| `<` / `>` (visual) | Indent and keep selection |

### Alacritty
| Key | Action |
|---|---|
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | Font bigger / smaller / reset |
| Middle click | Paste selection |

## Installation

```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo pacman -S --needed - < <(grep -v '^#' packages.txt)
cp -r .config .local .icons .zshrc .zprofile .gtkrc-2.0 ~/
fc-cache -f
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

Then log in on tty1 and niri starts.

### After installing
- Set your wallpaper path in the `swaybg` line of `~/.config/niri/config.kdl`.
- Run `niri msg outputs` and add `output` blocks for your monitors.
- Check the config with `niri validate`.
- Install Doom Emacs separately, then run `doom sync` and `doom doctor`.
- Open Neovim once so lazy.nvim installs plugins, then run `:checkhealth`.
