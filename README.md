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
| Shell | zsh + starship | `.zshenv` (environment, PATH), `.zprofile` (login), `.zshrc` (interactive), `.config/starship.toml` |
| Editors | Neovim (lazy.nvim), Doom Emacs | `.config/nvim/`, `.config/doom/` |
| GTK theme | GTK 2/3/4 settings | `.config/gtk-3.0/`, `.config/gtk-4.0/`, `.gtkrc-2.0`, `.icons/` |
| Qt theme | Kvantum + qt5ct/qt6ct | `.config/Kvantum/`, `.config/qt5ct/`, `.config/qt6ct/` |
| Portals | xdg-desktop-portal (file pickers through GTK, screencasting through GNOME) | `.config/xdg-desktop-portal/niri-portals.conf` |
| Autostart | XDG autostart entries, run by `niri-session` | `.config/autostart/` (hides the duplicate `nm-applet`) |
| Fonts | JetBrains Mono / Iosevka Nerd Font (packages); CatV, Feather, Grape Nuts (bundled) | `.local/share/fonts/` |

## Features

- **niri**
  - Spanish (`es`) keyboard layout.
  - Touchpad tap-to-click, natural scrolling, and disable-while-typing.
  - Focus follows the mouse.
  - 8px gaps and a 2px Tokyo Night focus ring.
  - Rounded corners and a translucent alacritty.
  - Preset column widths (1/3, 1/2, 2/3).
- **Autostart:** waybar, mako, swaybg, swayidle, the Emacs daemon, the network tray applet and the clipboard history watcher, from the niri config. `niri-session` also runs the standard XDG autostart entries, which is how the Bluetooth applet starts.
- **File pickers:** "Open file" dialogs from portal-using apps (Flatpaks, Firefox-based browsers) use the GTK file chooser, because GNOME's portal would need Nautilus.
- **Idle:** locks after 10 minutes, turns monitors off after 15, and locks before sleep.
- **Screenshots:** built into niri, saved to `~/Pictures/Screenshots`.
- **Waybar:**
  - Left: battery, CPU, memory, disk.
  - Center: niri workspaces.
  - Right: network (click opens `nmtui`), volume (click opens pavucontrol), power profile (click cycles power-saver / balanced / performance), clock with a calendar tooltip, tray.
  - Tray: Wi-Fi menu (`nm-applet`) and Bluetooth (`blueman`).
- **Login:** niri starts automatically when you log in on tty1 (`.zprofile`), which also unblocks Wi-Fi. Your login password unlocks the GNOME keyring, so apps can save passwords.
- **Wayland-native apps:** Electron and Qt apps run natively on Wayland.
- **Zsh:**
  - Vi mode.
  - Neovim as editor and man pager.
  - Tab completion with a menu, case-insensitive.
  - Environment and `PATH` set in `.zshenv`, so apps launched from niri see them too.
  - XDG directories.
  - An `extract` function for archives.
  - Starship prompt.
- **Neovim:**
  - Native LSP (`vim.lsp.config`, Neovim 0.12+), with servers installed through Mason, plus nvim-cmp and LuaSnip.
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
| `Mod+N` | Double Commander |
| `Mod+P` | KeePassXC |
| `Mod+V` | Clipboard history (fuzzel) |
| `Mod+R` | Goodvibes (radio) |
| `Mod+Escape` | Lock screen |

### Windows
| Key | Action |
|---|---|
| `Mod+Q` | Close window |
| `Mod+Shift+Q` | Force-kill the window's process (frozen apps) |
| `Mod+F` / `Mod+Shift+F` | Maximize column / fullscreen |
| `Mod+T` | Toggle floating |
| `Mod+Tab` | Overview |
| `Mod+H` / `Mod+L` (or arrows) | Focus column left / right |
| `Mod+J` / `Mod+K` (or `Down` / `Up`) | Focus window or workspace down / up |
| `Mod+Alt+H/J/K/L` | Move window or column |
| `Mod+Shift+H/L` | Column width −/+ 10% |
| `Mod+Shift+J/K` | Window height +/− 10% |
| `Mod+[` / `Mod+]` | Pull window into / push out of column |
| `Mod+Space` | Cycle preset column widths |
| `Mod+C` | Center column |

### Workspaces and system
| Key | Action |
|---|---|
| `Mod+1…9`, `Mod+º` | Go to workspace 1–9, 10 |
| `Mod+Shift+1…9`, `Mod+Shift+º` | Move column to workspace 1–9, 10 |
| `Mod+Scroll` | Previous / next workspace |
| `Ctrl+Alt+P` | Screenshot (select area) |
| `Print` / `Alt+Print` | Screenshot screen / window |
| Volume, mic-mute, brightness keys | `wpctl` / `brightnessctl` |
| Play / pause / next / previous keys | `playerctl` (any media player) |
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

## Customizing keybindings

### niri (window manager)
Bindings live in the `binds { }` block of `~/.config/niri/config.kdl`. niri reloads the file as soon as you save it, so there's nothing to restart. Run `niri validate` if a change doesn't take effect; a broken file keeps the last working config and shows an error.

Each line is `<keys> { <action>; }`:
```kdl
binds {
    // Launch an app
    Mod+B { spawn "firefox"; }

    // Arguments are separate strings
    Mod+Shift+Return { spawn "alacritty" "-e" "btop"; }

    // Shell syntax (pipes, $VARS, ~) needs sh -c
    Mod+Shift+S { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }

    // Built-in actions
    Mod+C { center-column; }

    // Media keys, still working on the lock screen
    XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }

    // Repeat-limited (good for mouse wheel binds)
    Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
}
```

- **Modifiers:** `Mod` is Super. You can also use `Super`, `Ctrl`, `Alt` and `Shift`, combined with `+`.
- **Key names** follow xkb. Run `wev` (`sudo pacman -S wev`) and press a key to see its name, e.g. `Return`, `Print`, `XF86AudioMute`, `Comma`.
- **Changing a key:** edit the key on the left. A key can only be bound once; if two lines use the same key, `niri validate` reports it.
- **Removing a bind:** delete the line.
- **All actions:** `niri msg action --help` lists them, and the [niri wiki](https://github.com/YaLTeR/niri/wiki/Configuration:-Key-Bindings) documents them.
- **Using Alt as Mod:** add `mod-key "Alt"` to the `input { }` block. That's useful when running niri nested inside another session.
- **Hotkey overlay:** `Mod+Shift+/` shows the bindings. Add `hotkey-overlay-title="My title"` after the key to give a bind a readable name in it.

After changing binds, update the keybinding tables in this README too.

### Waybar click actions
Clicks on bar modules are set in `~/.config/waybar/config.jsonc` with `on-click`, `on-click-right` and `on-scroll-up` / `on-scroll-down`:
```jsonc
"clock": { "format": "{:%H:%M}", "on-click": "gnome-calendar" }
```
Restart the bar to apply: `pkill waybar; waybar &`.

### Neovim
Global maps are in `~/.config/nvim/lua/core/remaps.lua`. Plugin maps sit next to each plugin's config in `~/.config/nvim/lua/plugins/config/` (e.g. `telescope.lua`, `harpoon.lua`). LSP maps are in the `LspAttach` block of `lsp.lua`, and completion keys are in `cmp.lua`.
```lua
-- mode, keys, action, options
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
```
- Modes: `n` normal, `i` insert, `v` visual, `t` terminal.
- The leader is `Space`, set at the top of `remaps.lua`. Change `vim.g.mapleader` to use another key.
- Check whether a key is free with `:verbose nmap <key>`.
- List everything with `:Telescope keymaps`.
- Restart Neovim after editing.

### Alacritty
Add a `[keyboard]` section to `~/.config/alacritty/alacritty.toml`. Alacritty reloads it live.
```toml
[keyboard]
bindings = [
  { key = "N", mods = "Control|Shift", action = "SpawnNewInstance" },
  { key = "K", mods = "Control|Shift", action = "ClearHistory" },
  { key = "Return", mods = "Control|Shift", command = { program = "alacritty", args = ["--working-directory", "."] } },
]
```
`man 5 alacritty` lists every action and key name.

### Doom Emacs
Doom uses Evil (vim keys), and `SPC` is the leader. Add bindings with `map!` in `~/.config/doom/config.el`, then run `SPC h r r` (or restart Emacs):
```elisp
(map! :leader
      :desc "Save file" "w" #'save-buffer)
(map! :n "C-h" #'evil-window-left
      :n "C-l" #'evil-window-right)
```
`SPC h k` then a key shows what it's bound to.

### zsh
The shell uses vi mode (`bindkey -v` in `~/.zshrc`). Add your own bindings after that line:
```zsh
bindkey '^R' history-incremental-search-backward   # Ctrl+R
bindkey -M viins '^E' autosuggest-accept          # Ctrl+E accepts the suggestion
```
Run `bindkey` with no arguments to list the current ones. To find a key's code, run `cat`, press the key, then `Ctrl+C`. Open a new terminal or run `source ~/.zshrc` to apply.

## Dependencies

The complete lists are in [`packages.txt`](packages.txt) (official repos) and [`packages-aur.txt`](packages-aur.txt) (AUR). Here's what each group is for:

| Group | Packages | Used by |
|---|---|---|
| Compositor | `niri`, `xwayland-satellite`, `xdg-desktop-portal-gnome`, `xdg-desktop-portal-gtk`, `polkit-gnome` | niri; X11 apps; screen sharing and file pickers; password prompts |
| Desktop | `waybar`, `fuzzel`, `mako`, `swaylock`, `swayidle`, `swaybg`, `wl-clipboard`, `brightnessctl`, `playerctl`, `xdg-user-dirs` | Bar, launcher, notifications, lock/idle, wallpaper, clipboard (Neovim `unnamedplus`), brightness keys |
| Audio | `pipewire`, `pipewire-pulse`, `wireplumber`, `pavucontrol` | Volume keys (`wpctl`), waybar volume click |
| Network | `networkmanager`, `network-manager-applet` | waybar network click (`nmtui`), Wi-Fi tray menu |
| Bluetooth | `bluez`, `bluez-utils`, `blueman` | Bluetooth service and tray applet |
| Keyring | `gnome-keyring`, `libsecret`, `seahorse` | Saved passwords for Thunderbird, browsers, git; `seahorse` to manage them |
| Power | `power-profiles-daemon` | waybar power-profile button |
| Clipboard / scripts | `cliphist`, `jq` | `Mod+V` history; `Mod+Shift+Q` force-kill |
| Fonts | `ttf-jetbrains-mono-nerd`, `ttf-iosevka-nerd`, `ttf-nerd-fonts-symbols-mono` (Doom icons), `cantarell-fonts`, `noto-fonts`, `noto-fonts-emoji` | Alacritty, waybar, fuzzel, mako, GTK. CatV, Feather and Grape Nuts aren't packaged, so they stay in `.local/share/fonts/` |
| Qt theming | `kvantum`, `kvantum-qt5`, `qt5ct`, `qt6ct`, `qt5-wayland`, `qt6-wayland` | Same Rose Pine look and icons for Qt apps (Double Commander, KeePassXC) |
| Theming | `nwg-look`, `sassc`, `gnome-themes-extra`; AUR: `sunity-cursors-git`, `gtk-engine-murrine` | GTK tools and theme build dependencies; cursor theme `Sunity-cursors` |
| Shell | `zsh`, `starship`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `eza`, `bat`, `zoxide`, `fzf`, `pyenv`, `yt-dlp` | `.zshrc` aliases and plugins |
| Archives | `unzip`, `unrar`, `7zip`, `cabextract`, `cpio` | The `extract` function |
| Neovim | `neovim` (0.12+, needed by nvim-treesitter's main branch), `git`, `base-devel`, `tree-sitter-cli`, `ripgrep`, `fd`, `nodejs`, `npm`, `python`, `python-pip`, `luarocks` | lazy.nvim, treesitter parsers, Telescope, telescope-fzf-native, Mason servers (`ts_ls`, `bashls`, `pylsp`, `lua_ls`, `rust_analyzer`) |
| LaTeX | `texlive-basic`, `texlive-latex`, `texlive-latexrecommended`, `texlive-latexextra`, `texlive-binextra` (latexmk), `zathura`, `zathura-pdf-mupdf` | VimTeX compile and PDF viewer |
| Doom Emacs | `emacs-wayland`, `aspell`, `aspell-en`, `aspell-es`, `languagetool`, `shellcheck` | Doom, `spell`, `grammar`, `sh` modules |
| AUR safety | AUR: `trustsight` | Risk-scores AUR updates before you install them ([repo](https://github.com/emiliano-go/trustsight)) |
| Apps | `thunderbird`, `libreoffice-fresh`, `gimp`, `inkscape`, `keepassxc`, `doublecmd-qt5`; AUR: `waterfox-bin`, `goodvibes` | `Mod+` app shortcuts |

Not packaged, so install these by hand:
- **GTK theme `Rosepine-Dark`** and **icon theme `Rose-Pine-Moon`** (step 5 below).
- **Doom Emacs** (step 6 below).

## Installation

### Quick install
On a working Arch install with a regular user and `sudo`:
```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
~/dotfiles/full-install.sh
```
It runs every step below in order and asks for your password when needed (sudo, `chsh`, package confirmations). If an AUR package fails, the script warns you and keeps going. You can run it again safely. When it finishes, add a wallpaper and log in on tty1.

### Manual install

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

This installs TrustSight from the AUR. From then on, run `trustsight` before `paru -Syu` to review pending AUR updates for risky changes.

**4. Link the dotfiles:**
```sh
./install.sh
```
This script:
- symlinks every config into `~` (anything already there is moved to `~/.dotfiles-backup/<date>/`);
- installs the bundled fonts;
- creates `~/Pictures/Screenshots`, `~/Projects` and `~/org`;
- enables PipeWire, NetworkManager, Bluetooth, power profiles and the GNOME keyring, and disables connman if it's running;
- adds `pam_gnome_keyring` to `/etc/pam.d/login` so your login password unlocks the keyring;
- makes zsh your login shell.

**5. Install the GTK and icon themes.** Both come from [Fausto-Korpsvart/Rose-Pine-GTK-Theme](https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme). It isn't in the AUR; `rose-pine-gtk-theme-full` there is a different theme.
```sh
git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git /tmp/rose-pine-gtk
cd /tmp/rose-pine-gtk/themes
./install.sh -c dark -l      # builds ~/.themes/Rosepine-Dark; -l also sets it for GTK 4 / libadwaita apps
mkdir -p ~/.local/share/icons
cp -r /tmp/rose-pine-gtk/icons/Rose-Pine-Moon ~/.local/share/icons/
gtk-update-icon-cache -f ~/.local/share/icons/Rose-Pine-Moon
cd ~/dotfiles
```
The cursor theme `Sunity-cursors` comes from the AUR package `sunity-cursors-git` (installed in step 3). To install it by hand instead:
```sh
git clone --depth 1 https://github.com/alvatip/Sunity-cursors.git /tmp/sunity
mkdir -p ~/.icons
tar -xzf /tmp/sunity/archives/Sunity-cursors.tar.gz -C ~/.icons/
```

Install the matching Qt theme from [rose-pine/kvantum](https://github.com/rose-pine/kvantum). The configs already select it (`rose-pine-foam`, with `Rose-Pine-Moon` icons via qt5ct/qt6ct, and niri sets `QT_QPA_PLATFORMTHEME`):
```sh
git clone --depth 1 https://github.com/rose-pine/kvantum.git /tmp/rose-pine-kvantum
mkdir -p ~/.config/Kvantum
tar -xzf /tmp/rose-pine-kvantum/dist/rose-pine-foam.tar.gz -C ~/.config/Kvantum/
```
To try another accent (`rose-pine-iris`, `rose-pine-moon-rose` …), extract it the same way and pick it in `kvantummanager`.

Then apply everything for GTK 4 / libadwaita apps, which ignore `settings.ini` on Wayland:
```sh
gsettings set org.gnome.desktop.interface gtk-theme 'Rosepine-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Rose-Pine-Moon'
gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

**6. Install Doom Emacs:**
```sh
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install --env
doom sync
doom doctor
```
`--env` generates Doom's envvar file, so Emacs sees the `PATH` from `.zshenv`. Your Doom config is already linked at `~/.config/doom`.

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
- [ ] `Mod+Escape` locks the screen.
- [ ] `Ctrl+Alt+P` saves a screenshot to `~/Pictures/Screenshots`.
- [ ] `z <dir>` jumps to a directory, and `ls` shows eza output.
- [ ] In Neovim, `:LspInfo` lists a server on a `.lua`, `.py` or `.ts` file.
- [ ] `Mod+E` opens Emacs.

## Troubleshooting
- **niri doesn't start from tty1:** run `niri-session` by hand and read the errors. `niri validate` also checks the config.
- **No sound:** run `systemctl --user status wireplumber`.
- **GTK theme isn't applied:** check that `ls ~/.themes` lists `Rosepine-Dark`, then run the `gsettings` commands from step 4 again, or pick the theme in `nwg-look`.
- **Qt apps look unthemed:** check `echo $QT_QPA_PLATFORMTHEME` shows `qt5ct:qt6ct` inside niri, and that `ls ~/.config/Kvantum` lists `rose-pine-foam`. Open `qt6ct` (or `qt5ct` for Double Commander) and check that Style is `kvantum`.
- **niri ignores your config and uses its defaults:** a duplicate keybinding or a typo stops niri loading `config.kdl`. Run `niri validate` to see the line.
- **`Mod+º` does nothing:** run `wev`, press the º key and check the keysym it prints. If it isn't `masculine`, use that name in the two workspace-10 binds.
- **Apps keep asking for a keyring password:** the login unlock isn't working. Check that `grep pam_gnome_keyring /etc/pam.d/login` shows two lines. If the keyring was created with a different password, delete `~/.local/share/keyrings/login.keyring` and log in again.
- **Neovim says nvim-treesitter needs a newer version:** the `main` branch needs Neovim 0.12+. Check with `nvim --version`.
- **Two network or Bluetooth icons in the tray:** an app started both from the niri config and from its XDG autostart entry. Run `ls /etc/xdg/autostart ~/.config/autostart` and either remove its `spawn-at-startup` line or hide the entry with a `Hidden=true` file in `~/.config/autostart/`.
- **Cursor is the default one:** check that `ls ~/.icons /usr/share/icons | grep Sunity` finds the theme, then log out and back in.
- **Treesitter errors in Neovim:** check that `tree-sitter --version` works, then run `:TSUpdate`.
- **Waterfox doesn't open:** the AUR binary may be named differently. Check with `which waterfox` and update the `Mod+W` bind.
