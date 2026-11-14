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

## Dependencies

The complete lists are in [`packages.txt`](packages.txt) (official repos) and [`packages-aur.txt`](packages-aur.txt) (AUR). Here's what each group is for:

| Group | Packages | Used by |
|---|---|---|
| Compositor | `niri`, `xwayland-satellite`, `xdg-desktop-portal-gnome`, `xdg-desktop-portal-gtk`, `polkit-gnome` | niri; X11 apps; screen sharing and file pickers; password prompts |
| Desktop | `waybar`, `fuzzel`, `mako`, `swaylock`, `swayidle`, `swaybg`, `wl-clipboard`, `brightnessctl`, `xdg-user-dirs` | Bar, launcher, notifications, lock/idle, wallpaper, clipboard (Neovim `unnamedplus`), brightness keys |
| Audio | `pipewire`, `pipewire-pulse`, `wireplumber`, `pavucontrol` | Volume keys (`wpctl`), waybar volume click |
| Network | `networkmanager` | waybar network click (`nmtui`) |
| Fonts | `ttf-jetbrains-mono-nerd`, `ttf-iosevka-nerd`, `cantarell-fonts`, `noto-fonts`, `noto-fonts-emoji` | Alacritty, waybar, fuzzel, mako, GTK |
| Theming | `nwg-look`, `rose-pine-gtk-theme-full` (AUR) | GTK theme `RosePine-Main-BL` |
| Shell | `zsh`, `starship`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `eza`, `bat`, `zoxide`, `fzf`, `pyenv`, `yt-dlp` | `.zshrc` aliases and plugins |
| Archives | `unzip`, `unrar`, `7zip`, `cabextract`, `cpio` | The `extract` function |
| Neovim | `neovim` (0.11+), `git`, `base-devel`, `tree-sitter-cli`, `ripgrep`, `fd`, `nodejs`, `npm`, `python`, `python-pip`, `luarocks` | lazy.nvim, treesitter parsers, Telescope, telescope-fzf-native, Mason servers (`ts_ls`, `bashls`, `pylsp`, `lua_ls`, `rust_analyzer`) |
| LaTeX | `texlive-basic`, `texlive-latex`, `texlive-latexrecommended`, `texlive-latexextra`, `texlive-binextra` (latexmk), `zathura`, `zathura-pdf-mupdf` | VimTeX compile and PDF viewer |
| Doom Emacs | `emacs-wayland`, `aspell`, `aspell-en`, `aspell-es`, `languagetool`, `shellcheck` | Doom, `spell`, `grammar`, `sh` modules |
| Apps | `thunderbird`, `libreoffice-fresh`, `gimp`, `inkscape`, `keepassxc`; AUR: `waterfox-bin`, `spacefm`, `goodvibes` | `Mod+` app shortcuts |

Not packaged, so install these by hand:
- **Icon theme `Rose-Pine-Moon`** and **cursor theme `Sunity-cursors`**. Extract them into `~/.local/share/icons/`, or pick other themes in `nwg-look` and update `.config/gtk-*/settings.ini` and the `cursor` block in the niri config.
- **Doom Emacs** (step 6 below).

## Installation

Start from a working Arch install with a regular user, `sudo` and an internet connection.

**1. Install an AUR helper** (skip this if you already have `paru` or `yay`):
```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin && makepkg -si
```

**2. Clone the repo:**
```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**3. Install the packages:**
```sh
sudo pacman -Syu --needed - < <(grep -v '^#' packages.txt | grep -v '^$')
paru -S --needed - < <(grep -v '^#' packages-aur.txt | grep -v '^$')
```

**4. Install the icon and cursor themes** listed above.

**5. Link the dotfiles:**
```sh
./install.sh
```
This script:
- symlinks every config into `~` (anything already there is moved to `~/.dotfiles-backup/<date>/`);
- installs the bundled fonts;
- creates `~/Pictures/Screenshots`, `~/Projects` and `~/org`;
- sets your home path in the niri wallpaper line;
- enables PipeWire and NetworkManager, and disables connman if it's running;
- makes zsh your login shell.

**6. Install Doom Emacs:**
```sh
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
doom sync
doom doctor
```
When `doom install` asks to generate an envvar file, say yes. Your Doom config is already linked at `~/.config/doom`.

**7. Add a wallpaper** at `~/Pictures/wallpaper.png`, or change the `swaybg` line in `~/.config/niri/config.kdl`.

**8. Start niri:** log out, then log in on **tty1**. `.zprofile` runs `niri-session`. Then:
```sh
niri validate          # config check
niri msg outputs       # list monitors, then add output blocks to the config if needed
```

**9. Set up Neovim:** run `nvim`. lazy.nvim installs the plugins, treesitter builds its parsers, and Mason installs the language servers (this takes a minute). Then run:
```vim
:checkhealth
:Mason
```

**10. Set up Python (optional):**
```sh
pyenv install 3.13
pyenv global 3.13
```

### Check that everything works
- [ ] `Mod+Return` opens Alacritty with the Tokyo Night colors.
- [ ] `Mod+D` opens fuzzel.
- [ ] The workspace and battery modules show up in waybar.
- [ ] The volume and brightness keys work.
- [ ] `notify-send hi` shows a mako notification.
- [ ] `Super+Alt+L` locks the screen.
- [ ] `Ctrl+Alt+P` saves a screenshot to `~/Pictures/Screenshots`.
- [ ] `z <dir>` jumps to a directory, and `ls` shows eza output.
- [ ] In Neovim, `:LspInfo` lists a server on a `.lua`, `.py` or `.ts` file.
- [ ] `Mod+E` opens Emacs.

## Troubleshooting
- **niri doesn't start from tty1:** run `niri-session` by hand and read the errors. `niri validate` also checks the config.
- **No sound:** run `systemctl --user status wireplumber`.
- **GTK theme isn't applied:** open `nwg-look` and pick `RosePine-Main-BL`. That also updates gsettings for GTK 4 apps.
- **Treesitter errors in Neovim:** check that `tree-sitter --version` works, then run `:TSUpdate`.
- **Waterfox doesn't open:** the AUR binary may be named differently. Check with `which waterfox` and update the `Mod+W` bind.
