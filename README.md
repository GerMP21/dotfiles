# dotfiles

[CachyOS](https://cachyos.org) + [niri](https://github.com/YaLTeR/niri) (Wayland) setup with a Tokyo Night theme, made for a CachyOS install with the niri desktop, tested on a ThinkPad T480.

On top of what CachyOS installs, it adds:
- a niri config with Spanish/English keyboard layouts and vim-style keys;
- Noctalia (the shell CachyOS ships) set up to match: bar, launcher, notifications, lock screen and idle;
- zsh with starship, Neovim, Doom Emacs, and Rose Pine GTK/Qt themes;
- scripts that install the packages, link the files, set up the desktop and the editors, and check the result.

**Quick start**, on a fresh CachyOS install with the niri desktop (details in [Installation](#installation)):
```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
~/dotfiles/install-packages.sh   # packages
~/dotfiles/setup-dotfiles.sh     # link the configs into ~, copy the fonts
~/dotfiles/setup-desktop.sh      # themes, folders, services, zsh as login shell
~/dotfiles/setup-editors.sh      # Doom Emacs and Neovim plugins (the slow one)
~/dotfiles/verify.sh             # check everything
```

## Contents
- [Repository layout](#repository-layout)
- [What you get](#what-you-get): components and features
- [Keybindings](#keybindings)
- [Customizing](#customizing): keys, Noctalia, Doom modules, Neovim
- [Dependencies](#dependencies)
- [Installation](#installation)
  - [Part 1: Install CachyOS](#part-1--install-cachyos-encrypted-with-niri)
  - [Part 2: Install the dotfiles](#part-2--install-the-dotfiles)
  - [Part 3: Check the install and first login](#part-3--check-the-install-and-first-login)
  - [Part 4: Keeping it up to date](#part-4--keeping-it-up-to-date)
- [The scripts in detail](#the-scripts-in-detail)
- [Testing in a virtual machine first](#testing-in-a-virtual-machine-first)
- [Going back to your old setup](#going-back-to-your-old-setup)
- [Troubleshooting](#troubleshooting)

## Repository layout

```
dotfiles/
├── home/                   everything that goes into ~, laid out as in ~
│   ├── .zshenv .zprofile .zshrc .gtkrc-2.0
│   ├── .icons/default/     default cursor theme
│   ├── .config/            niri, noctalia, nvim, doom, gtk-*, Kvantum, qt5ct, qt6ct,
│   │                       xdg-desktop-portal, ardour-x (Openbox for Ardour), starship.toml
│   └── .local/            share/: fonts (copied), wallpaper, goodvibes radio stations
│                           bin/keybinds: the Mod+Shift+H cheat sheet
│                           bin/ardour-x: starts Ardour in its own X server (Mod+Shift+D)
├── packages.txt            packages from the CachyOS/Arch repos (pacman)
├── packages-aur.txt        packages from the AUR (paru)
├── packages-pipx.txt       Python tools (pipx)
├── install-packages.sh     installs the three lists
├── setup-dotfiles.sh       links home/ into ~ and copies the fonts; nothing else
├── setup-desktop.sh        themes, folders, services, zsh as login shell
├── setup-editors.sh        Doom Emacs, Neovim plugins, parsers and language servers
├── setup-login-screen.sh   optional: SDDM login theme, background and profile picture
├── system/sddm/            the login theme (tokyo-night/), background and avatar.jpg
└── verify.sh               checks all of the above, plus the boot setup; changes nothing
```

`home/.config/niri` becomes `~/.config/niri`, and so on. `setup-dotfiles.sh` **symlinks** everything from `home/` into `~`, so editing a file in `~/.config` edits it in the repo, and `git diff` shows your changes. Only the fonts are **copied**. That's all `setup-dotfiles.sh` does: no downloads, no sudo. The themes and Doom Emacs aren't in the repo; `setup-desktop.sh` and `setup-editors.sh` download them.

## What you get

### Components
| Role | Tool | Config |
|---|---|---|
| Window manager | niri (scrollable tiling) | `home/.config/niri/config.kdl` |
| Shell | [Noctalia](https://docs.noctalia.dev) (installed by CachyOS): bar, launcher, clipboard history, notifications, volume/brightness popups, control center, lock screen, idle, wallpaper, password prompts | `home/.config/noctalia/config.toml` |
| Login screen | SDDM (installed by CachyOS) with a Tokyo Night theme: background, square profile picture, clock | `system/sddm/`, installed by `setup-login-screen.sh` (optional) |
| Wallpaper | Raphael's *The School of Athens* (public domain), shown by Noctalia | `home/.local/share/backgrounds/wallpaper.jpg` |
| Terminal | Alacritty (installed by CachyOS, with CachyOS's config) | `~/.config/alacritty/alacritty.toml`, not in this repo |
| Shell | zsh + starship | `home/.zshenv` (environment, PATH), `home/.zprofile` (login), `home/.zshrc` (interactive), `home/.config/starship.toml` |
| Editors | Neovim (lazy.nvim), Doom Emacs | `home/.config/nvim/`, `home/.config/doom/` |
| GTK theme | Rose Pine (`Rosepine-Dark`, `Rose-Pine-Moon` icons, `Sunity-cursors`) | `home/.config/gtk-3.0/`, `home/.config/gtk-4.0/`, `home/.gtkrc-2.0`, `home/.icons/` |
| Qt theme | Kvantum `rose-pine-foam` + qt5ct/qt6ct | `home/.config/Kvantum/`, `home/.config/qt5ct/`, `home/.config/qt6ct/` |
| Portals | xdg-desktop-portal (file pickers through GTK, screencasting through GNOME) | `home/.config/xdg-desktop-portal/niri-portals.conf` |
| Fonts | JetBrains Mono / Iosevka Nerd Font (packages); CatV, Feather, Grape Nuts (bundled); the generic `monospace` font set to JetBrainsMono Nerd Font | `home/.local/share/fonts/`, `home/.config/fontconfig/fonts.conf` |

### Features
- **niri**
  - Spanish (`es`) and English (`us`) keyboard layouts: Spanish is the default, `Mod+Ctrl+Space` switches, and the bar shows the current one.
  - Touchpad tap-to-click, natural scrolling, and disable-while-typing.
  - Focus follows the mouse.
  - 8px gaps, a 2px Tokyo Night focus ring and rounded corners.
  - Preset column widths (1/3, 1/2, 2/3).
  - A flat Tokyo Night background in the overview (`Mod+Tab`).
  - Starts Noctalia and the Emacs daemon at login.
  - `Mod+Shift+H` shows a compact cheat sheet of every binding in columns, read live from the config; niri's own overlay doesn't pop up at login.
- **Noctalia** (Tokyo Night palette, JetBrains Mono font):
  - Bar left: launcher, battery, CPU, RAM, disk.
  - Bar center: niri workspaces.
  - Bar right: keyboard layout (`es` / `us`), network, Bluetooth, volume, power profile, clock, tray, notifications, control center, session menu.
  - Clicking network, Bluetooth or volume opens its panel. The control center (`Mod+A`) has Wi-Fi, Bluetooth, audio and power settings in one place.
  - Launcher (`Mod+D`) with a calculator (`/calc`) and emoji (`/emo`), and clipboard history (`Mod+V`).
  - Popups for volume and brightness changes, and password prompts when an app needs admin rights.
  - Changes made in its Settings window (`Mod+Shift+A`) are saved to `~/.local/state/noctalia/settings.toml` and override `config.toml`.
- **Idle:** Noctalia locks after 10 minutes, turns monitors off after 15, and suspends after 5 hours (`[idle.behavior.*]` in `config.toml`). It locks before any suspend, including closing the lid, which suspends right away (systemd's default). The lock screen takes your login password.
- **Login:** the SDDM login screen starts the niri session. Your login password unlocks the GNOME keyring, so apps can save passwords. `.zprofile` also unblocks Wi-Fi.
- **Terminal:** Alacritty with CachyOS's config (translucent, Nord colors), which the CachyOS install put in `~/.config/alacritty/alacritty.toml`.
- **Screenshots:** built into niri, saved to `~/Pictures/Screenshots`.
- **File pickers:** "Open file" dialogs from portal-using apps (Flatpaks, Firefox-based browsers) use the GTK file chooser, because GNOME's portal would need Nautilus.
- **Wayland-native apps:** Electron and Qt apps run natively on Wayland. Qt apps without the Wayland plugin fall back to X11 through xwayland-satellite.
- **Zsh:**
  - Vi mode.
  - Neovim as editor and man pager.
  - Tab completion with a menu, case-insensitive.
  - Environment and `PATH` set in `.zshenv`, so apps launched from niri see them too.
  - XDG directories.
  - An `extract` function for archives.
  - Starship prompt, zoxide (`z`), eza (`ls`), bat (`cat`), autosuggestions and syntax highlighting.
  - Every tool is optional: if one is missing, `ls`, `cat` and the prompt keep working without errors.
- **Neovim:**
  - Native LSP (`vim.lsp.config`, Neovim 0.12+), with servers installed through Mason, plus nvim-cmp and LuaSnip.
  - Treesitter.
  - Telescope with fzf and zoxide.
  - Harpoon, fugitive and undotree.
  - VimWiki.
  - Kanagawa colorscheme.
- **Doom Emacs:** Evil (vim keys), LSP, Magit, Org, spell and grammar checking, and 27 language modules (see [Doom modules](#doom-emacs-modules)).

## Keybindings

`Mod` is the Super key. `Mod+Shift+H` opens a compact cheat sheet with every niri binding in columns (any key closes it). Keys that share modifiers are joined, so `Mod+H/←` means `Mod+H` or `Mod+←`. It reads `~/.config/niri/config.kdl` each time, so it always matches your config. niri's own key overlay no longer pops up at login.

### Apps
| Key | Action |
|---|---|
| `Mod+Return` | Alacritty (terminal) |
| `Mod+E` | Emacs (client) |
| `Mod+W` | Firefox |
| `Mod+O` | Obsidian (notes) |
| `Mod+Shift+O` | LibreOffice |
| `Mod+G` | GIMP |
| `Mod+N` | Double Commander |
| `Mod+M` | Thunar (second file manager) |
| `Mod+P` | KeePassXC |
| `Mod+C` | VSCodium |
| `Mod+X` | Claude Desktop |
| `Mod+R` | Goodvibes (radio) |
| `Mod+Shift+T` | TuxGuitar |
| `Mod+Shift+S` | Discord |
| `Mod+Shift+I` | Audacity |
| `Mod+Shift+D` | Ardour, in its own X server so its menus work ([why](#ardour-in-its-own-x-server)) |
| `Mod+S` | Steam |
| `Mod+Y` | YGO Omega (from `~/Documents/Games/YGO Omega`) |

Thunderbird and Inkscape have no key; open them from the launcher.

### Noctalia
| Key | Action |
|---|---|
| `Mod+D` | Launcher (apps; `/calc`, `/emo` for the calculator and emoji) |
| `Mod+V` | Clipboard history |
| `Mod+A` | Control center |
| `Mod+Shift+A` | Noctalia settings |
| `Mod+Escape` | Lock screen |
| Volume, mic-mute, brightness and media keys | Change the value and show a popup (also on the lock screen) |

### Windows
| Key | Action |
|---|---|
| `Mod+Q` | Close window |
| `Mod+Shift+Q` | Force-kill the window's process (frozen apps) |
| `Mod+F` / `Mod+Shift+F` | Maximize column / fullscreen |
| `Mod+Ctrl+F` | Widen column to fill the free space |
| `Mod+T` | Toggle floating |
| `Mod+Tab` | Overview |
| `Mod+H` / `Mod+L` (or `Left` / `Right`) | Focus column left / right |
| `Mod+J` / `Mod+K` (or `Down` / `Up`) | Focus window or workspace down / up |
| `Mod+Home` / `Mod+End` | Focus first / last column |
| `Mod+Alt+H` / `Mod+Alt+L` (or `Left` / `Right`) | Move column left / right |
| `Mod+Alt+J` / `Mod+Alt+K` (or `Down` / `Up`) | Move window down / up, on to the next workspace at the edge |
| `Mod+Ctrl+Home` / `Mod+Ctrl+End` | Move column to first / last |
| `Mod+-` / `Mod++` | Column width −/+ 10% |
| `Mod+Shift+-` / `Mod+Shift++` | Window height −/+ 10% |
| `Mod+Ctrl+H` / `Mod+Ctrl+L` (or `Left` / `Right`) | Move window into the column on the left / right, or out of its column |
| `Mod+,` / `Mod+.` | Pull the window on the right into this column / push the bottom window out |
| `Mod+Space` | Cycle preset column widths |
| `Mod+Ctrl+Space` | Switch keyboard layout: Spanish ↔ English |
| `Mod+Shift+C` | Center column |
| `Mod+Ctrl+Escape` | Get your shortcuts back when a fullscreen app or a VM has grabbed the keyboard |

`+` has its own key on the Spanish layout and is `Shift+=` on English; both are bound, so `Mod++` works on either.

### Workspaces and system
| Key | Action |
|---|---|
| `Mod+1…9`, `Mod+º` (`` Mod+` `` on English) | Go to workspace 1–9, 10 |
| `Mod+Shift+1…9`, `Mod+Shift+º` (`` Mod+Shift+` `` on English) | Move column to workspace 1–9, 10 |
| `Mod+Scroll` | Previous / next workspace |
| `Ctrl+Alt+P` | Screenshot (select area) |
| `Print` / `Alt+Print` | Screenshot screen / window |
| `Mod+Shift+P` | Monitors off |
| `Mod+Alt+Q` | Quit niri (log out; asks to confirm) |

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
Alacritty's keys with CachyOS's config:

| Key | Action |
|---|---|
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl++` / `Ctrl+-` / `Ctrl+0` | Font bigger / smaller / reset |
| `Shift+PageUp` / `Shift+PageDown`, `Shift+Home` / `Shift+End` | Scroll back / forward, to the top / bottom |
| `Ctrl+Shift+F` / `Ctrl+Shift+B` | Search the scrollback forward / backward |
| `Ctrl+Shift+N` | New terminal in the same folder |
| `Ctrl+Shift+Space` | Vi mode (select and copy with the keyboard) |

## Customizing

Edit the files in `~/.config` (they're links into `~/dotfiles/home/`), then commit them from `~/dotfiles`. After changing keys, update the keybinding tables above too.

### niri keys
Bindings live in the `binds { }` block of `~/.config/niri/config.kdl`. niri reloads the file as soon as you save it, so there's nothing to restart. Run `niri validate` if a change doesn't take effect; a broken file keeps the last working config and shows an error.

Each line is `<keys> { <action>; }`:
```kdl
binds {
    // Launch an app
    Mod+B { spawn "firefox"; }

    // Arguments are separate strings
    Mod+Ctrl+Return { spawn "alacritty" "-e" "btop"; }

    // Shell syntax (pipes, $VARS, ~) needs sh -c
    Mod+Ctrl+S { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }

    // Built-in actions
    Mod+Shift+C { center-column; }

    // Media keys, still working on the lock screen
    XF86AudioPlay allow-when-locked=true { spawn "noctalia" "msg" "media" "toggle"; }

    // Repeat-limited (good for mouse wheel binds)
    Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
}
```

- **Modifiers:** `Mod` is Super. You can also use `Super`, `Ctrl`, `Alt` and `Shift`, combined with `+`.
- **Key names** follow xkb. Run `wev` (`sudo pacman -S wev`) and press a key to see its name, e.g. `Return`, `Print`, `XF86AudioMute`, `Comma`.
- **Spanish keyboard:** niri matches the key's symbol on the current layout, and falls back to the English layout when that symbol isn't a plain character. Keys that need AltGr on Spanish, such as `[` and `]`, can't be bound reliably; use letters, digits or `,` `.` `-` `+` instead.
- **Changing a key:** edit the key on the left. A key can only be bound once; if two lines use the same key, `niri validate` reports it.
- **Removing a bind:** delete the line.
- **All actions:** `niri msg action --help` lists them, and the [niri wiki](https://github.com/YaLTeR/niri/wiki/Configuration:-Key-Bindings) documents them.
- **Using Alt as Mod:** add `mod-key "Alt"` to the `input { }` block. That's useful when running niri nested inside another session.
- **Cheat sheet (`Mod+Shift+H`):** the script `~/.local/bin/keybinds` reads the `binds { }` block and shows it in columns, so new binds appear in it without changes:
  - a comment after a blank line starts a section, and the text before the first `:`, `(`, `.` or `,` is its heading (`// Apps`, `// Media and brightness, …`); comments right after a bind are notes and are skipped;
  - a bind's description is its `hotkey-overlay-title`, or else its action (`focus-column-left` → "Focus column left"):
    ```kdl
    Mod+B hotkey-overlay-title="Browser" { spawn "firefox"; }
    ```
  - keys with the same description share a line, keys with the same modifiers are joined (`Mod+H/←`), and runs like `Mod+1` … `Mod+9` become one (`Mod+1–9`);
  - it uses as few columns as fit the window's height, each only as wide as its content, and shortens descriptions only when the window is too narrow.

  It opens in a floating Alacritty window (the `keybinds` window rule in `config.kdl`). Run `keybinds` in any terminal to see it there. niri's own overlay is no longer bound, and `hotkey-overlay { skip-at-startup }` in `config.kdl` stops it appearing at login; `niri msg action show-hotkey-overlay` still opens it.

### Noctalia
- **Settings:** `~/.config/noctalia/config.toml` sets the theme, wallpaper, idle timeouts and bar layout. Its comments say what each part does; every option is documented at [docs.noctalia.dev](https://docs.noctalia.dev). Check it with `noctalia config validate`.
- **Settings window:** changes made in Noctalia's Settings window (`Mod+Shift+A`) go to `~/.local/state/noctalia/settings.toml`, not the repo, and win over `config.toml`. If an edit to `config.toml` seems ignored, look there.
- **Bar widgets:** the `start`, `center` and `end` lists in `[bar.default]` pick and order them. Bar clicks are set per widget; see the [bar actions docs](https://docs.noctalia.dev/noctalia/bar/actions/).
- **Keys:** Noctalia's panels use fixed keys (arrows, Enter, Escape), set in the `[keybinds]` section. Anything Noctalia can do from a key is a `noctalia msg` command, which you bind in niri; `noctalia msg --help` lists them:
  ```kdl
  Mod+Shift+N { spawn "noctalia" "msg" "notification-clear-history"; }
  ```

### Doom Emacs modules
Modules are switched on and off in `~/.config/doom/init.el`: a line starting with `;;` is off. After changing it, run `doom sync` and restart Emacs. Every module you switch off is less for `doom install` and `doom upgrade` to download and compile, so switching off unused languages makes installs much faster.

Language modules that are on (27): `cc` (C/C++), `csharp`, `dart`, `elixir`, `elm`, `emacs-lisp`, `go`, `graphql`, `haskell`, `json`, `java`, `javascript`, `julia`, `kotlin`, `markdown`, `nim`, `ocaml`, `org`, `php`, `python`, `rust`, `scala`, `sh`, `swift`, `web`, `yaml`, `zig`.

Switched off on purpose: `clojure`, `common-lisp`, `lean`, `lua`, `nix`, `raku`, `solidity` and `latex`. The `grammar` checker needs LanguageTool, which brings in Java; switch it off and drop `languagetool` from `packages.txt` if you don't use it.

Doom keys: Doom uses Evil (vim keys), and `SPC` is the leader. Add bindings with `map!` in `~/.config/doom/config.el`, then run `SPC h r r` (or restart Emacs):
```elisp
(map! :leader
      :desc "Save file" "w" #'save-buffer)
(map! :n "C-h" #'evil-window-left
      :n "C-l" #'evil-window-right)
```
`SPC h k` then a key shows what it's bound to.

### Neovim
- **Keys:** global maps are in `~/.config/nvim/lua/core/remaps.lua`. Plugin maps sit next to each plugin's config in `~/.config/nvim/lua/plugins/config/` (e.g. `telescope.lua`, `harpoon.lua`). LSP maps are in the `LspAttach` block of `lsp.lua`, and completion keys are in `cmp.lua`.
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
- **Plugins:** listed in `~/.config/nvim/lua/plugins/init.lua`. Add or remove an entry, then run `:Lazy sync`.
- **Treesitter parsers:** listed in `~/.config/nvim/lua/plugins/config/ts_parsers.lua`: bash, lua, python, javascript, typescript, rust, c, markdown, vim, vimdoc and query. Each one compiles when installed; add a language there and run `:TSUpdate`.
- **Language servers:** `setup-editors.sh` installs bash, Python, TypeScript, Rust and Lua servers through Mason. Add more with `:Mason`.

### Alacritty
Alacritty reads `~/.config/alacritty/alacritty.toml`, which CachyOS created; it isn't in this repo. That file already has a `[keyboard]` section, so add your keys to its `bindings` list rather than writing a second `[keyboard]` (that would be an error):
```toml
[keyboard]
bindings = [
  # ...the entries already there...
  { key = "T", mods = "Control|Shift", action = "SpawnNewInstance" },
]
```
`man 5 alacritty` lists every action and option. Alacritty reloads the file as soon as you save it.

### zsh
The shell uses vi mode (`bindkey -v` in `~/.zshrc`). Add your own bindings after that line:
```zsh
bindkey '^R' history-incremental-search-backward   # Ctrl+R
bindkey -M viins '^E' autosuggest-accept          # Ctrl+E accepts the suggestion
```
Run `bindkey` with no arguments to list the current ones. To find a key's code, run `cat`, press the key, then `Ctrl+C`. Open a new terminal or run `source ~/.zshrc` to apply. Environment variables and `PATH` go in `~/.zshenv`, so apps started from niri see them too.

## Dependencies

The lists are in [`packages.txt`](packages.txt) (CachyOS and Arch repos), [`packages-aur.txt`](packages-aur.txt) (AUR) and [`packages-pipx.txt`](packages-pipx.txt) (Python tools, installed with pipx). They only hold what a CachyOS install with the niri desktop doesn't already have. To add a package, put its name on its own line in the right list and run `install-packages.sh` again.

`packages.txt` can also name a **pacman group**, like `pro-audio`: `install-packages.sh` installs all its members (`pacman -Sg pro-audio` lists them). A line starting with `!`, like `!audacity`, leaves that package out even when a group includes it. `verify.sh` checks the members the same way.

**Already installed by CachyOS** (and used by these configs): `niri`, `noctalia` (from `cachyos-niri-noctalia`), `xwayland-satellite`, `xdg-desktop-portal-gnome`, `xdg-desktop-portal-gtk`, `wl-clipboard`, `gnome-keyring`, `sddm`, `networkmanager`, `bluez`, `bluez-utils`, `pipewire-pulse`, `wireplumber`, `pavucontrol`, `power-profiles-daemon`, `xdg-user-dirs`, `noto-fonts`, `noto-fonts-emoji`, `cantarell-fonts`, `zsh`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`, `git`, `base-devel`, `python`, `ripgrep`, `unzip`, `unrar`, `alacritty` and `firefox`.

**Installed from this repo:**

| Group | Packages | Used by |
|---|---|---|
| AUR helper | `paru` (in the CachyOS repo) | `packages-aur.txt`, `paru -Syu` |
| Python tools | `python-pipx`; pipx: `trustsight` | `packages-pipx.txt`. TrustSight risk-scores AUR updates before you install them ([repo](https://github.com/emiliano-go/trustsight)) |
| Keyring | `libsecret`, `seahorse` | Saved passwords for Thunderbird, browsers, git; `seahorse` to manage them |
| Scripts | `jq` | `Mod+Shift+Q` force-kill |
| Fonts | `ttf-jetbrains-mono-nerd`, `ttf-iosevka-nerd`, `ttf-nerd-fonts-symbols-mono` (Doom icons); AUR: `ttf-symbola` (Emacs's fallback for symbols) | Noctalia, GTK. CatV, Feather and Grape Nuts aren't packaged, so they're in `home/.local/share/fonts/` |
| Qt theming | `kvantum`, `kvantum-qt5`, `qt5ct`, `qt6ct`, `qt5-wayland`, `qt6-wayland` | Same Rose Pine look and icons for Qt apps (Double Commander, KeePassXC) |
| Theming | `nwg-look`, `sassc`, `gnome-themes-extra`; AUR: `sunity-cursors-git`, `gtk-engine-murrine` | GTK tools and theme build dependencies; cursor theme `Sunity-cursors` |
| Shell | `starship`, `eza`, `bat`, `zoxide`, `pyenv`, `yt-dlp` | `.zshrc` aliases and prompt |
| Archives | `7zip`, `cabextract`, `cpio` | The `extract` function |
| Neovim | `neovim` (0.12+, needed by nvim-treesitter's main branch), `tree-sitter-cli`, `fd`, `nodejs`, `npm`, `python-pip`, `luarocks` | lazy.nvim, treesitter parsers, Telescope, telescope-fzf-native, Mason servers |
| Doom Emacs | `emacs-wayland`, `aspell`, `aspell-en`, `aspell-es`, `languagetool`, `shellcheck` | Doom, `spell`, `grammar`, `sh` modules |
| Development | `docker`, `docker-buildx`, `docker-compose`, `geany`, `vscodium` (CachyOS repo), `mysql-workbench`, `mariadb-libs`, `rustup`, `uv`; AUR: `postman-bin`, `pyenv-virtualenv` | Containers, editor, MySQL/MariaDB client, Rust and Python toolchains, API client |
| Network | `wireguard-tools`, `qbittorrent`; AUR: `wireguird` | WireGuard VPN (and its GUI), torrents |
| Audio production | groups `pro-audio`, `lv2-plugins`, `vst-plugins` (about 290 packages, ~6 GB); `zam-plugins-*` in every format; `x42-plugins`, `lsp-plugins`, `cardinal`, `distrho-ports`, `dragonfly-reverb`, `wolf-shaper`, `sfizz`, `geonkick`, `drumgizmo`, `helm`, `stochas`, `yoshimi`, `soundfont-fluid`; `ardour` with `pipewire-jack`, `xorg-xwayland` and `openbox` (for `ardour-x`); AUR: `vcvrack-bin`, `airwindows-lv2`, `neural-amp-modeler-lv2`, `sooperlooper`, `paulxstretch`. Vitalium, Vital's open-source build, comes with `distrho-ports`. `audacity` is left out (`!audacity`) for `audacity3-git` | DAWs (Ardour, LMMS, Reaper…), synths (Surge XT, Dexed, ZynAddSubFX…), effects (Calf, LSP, x42, ZAM, Guitarix…), patchbay (`qpwgraph`), plugin host (`carla`), Windows plugins (`yabridge`) |
| Media and writing | `discord`, `calibre`; AUR: `audacity3-git`, `tuxguitar`, `trelby` | Audio editing and recording, chat, e-books, guitar tabs, screenwriting |
| Games | `steam`, `0ad`, `cataclysm-dda-tiles`; AUR: `airshipper` (Veloren launcher) | Open them from the launcher (`Mod+D`); Steam also has `Mod+S` |
| Apps | `thunderbird`, `libreoffice-fresh`, `gimp`, `inkscape`, `keepassxc`, `obsidian`, `doublecmd-qt5`, `thunar` (with `gvfs` for trash and USB drives, `tumbler` for thumbnails), `loupe` (image viewer), `vlc` with `vlc-plugins-all` (video player and its codecs), `thunar-archive-plugin` with `file-roller` and `zip` (extract and create archives from Thunar's right-click menu); AUR: `goodvibes`, `claude-desktop` | `Mod+` app shortcuts and the launcher |

Not packaged, so `setup-desktop.sh` (themes) and `setup-editors.sh` (Doom) download them, or see the [manual install](#23-manual-install):
- **GTK theme `Rosepine-Dark`** and **icon theme `Rose-Pine-Moon`**, from [Fausto-Korpsvart/Rose-Pine-GTK-Theme](https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme).
- **Qt theme `rose-pine-foam`**, from [rose-pine/kvantum](https://github.com/rose-pine/kvantum).
- **Doom Emacs**, from [doomemacs/doomemacs](https://github.com/doomemacs/doomemacs).

## Installation

The guide has four parts. If CachyOS is already installed with the niri desktop, skip to [Part 2](#part-2--install-the-dotfiles).

1. [Install CachyOS](#part-1--install-cachyos-encrypted-with-niri), with the whole system encrypted and the niri desktop.
2. [Install the dotfiles](#part-2--install-the-dotfiles), with the scripts or step by step.
3. [Check the install and first login](#part-3--check-the-install-and-first-login): `verify.sh`, monitors and a checklist.
4. [Keeping it up to date](#part-4--keeping-it-up-to-date).

You can also [test everything in a virtual machine first](#testing-in-a-virtual-machine-first).

### Part 1 — Install CachyOS (encrypted, with niri)

#### 1.1 What you need
- A USB stick of 4 GB or more. It will be erased.
- An internet connection, ideally a cable. Wi-Fi works too. The installer downloads the packages.
- A backup of anything on the target disk. **The install erases the whole disk.**
- To keep Windows on the same disk (dual boot), stop here: that needs manual partitioning, which this guide doesn't cover.

#### 1.2 Make the USB stick
1. Download the desktop ISO from [cachyos.org/download](https://cachyos.org/download/).
2. Write it to the USB stick:
   - **On Windows:** use [Rufus](https://rufus.ie). Select the stick and the ISO, click **Start**, and choose **Write in DD Image mode** when asked.
   - **On Linux:** find the stick with `lsblk` (for example `/dev/sdb`), then run:
     ```sh
     sudo dd if=cachyos-desktop-linux-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
     ```
     Replace `/dev/sdX` with the stick, not a partition like `/dev/sdb1`. Double-check it: `dd` overwrites whatever you point it at.

#### 1.3 Firmware (UEFI) settings
The computer must boot the USB stick in **UEFI** mode. In Legacy/CSM mode the installer asks where to put the bootloader ("MBR of the drive" or a partition), and with an encrypted disk both GRUB and Limine fail to install there, or install but don't boot without the USB stick.

**ThinkPad T480:** press **Enter** at the red ThinkPad logo, then **F1**:
1. **Startup → UEFI/Legacy Boot:** `UEFI Only`. CSM Support then disappears, or set it to `No`.
2. **Security → Secure Boot → Secure Boot:** `Disabled`. If the Secure Boot keys were cleared, choose **Restore Factory Keys** first, then check it's still `Disabled`. Cleared keys don't stop Linux from booting while Secure Boot is off; restoring them keeps the option to turn it on later.
3. **Startup → Boot Order Lock:** `Disabled`, so the installer can add its boot entry.
4. Press **F10** to save. To boot the stick, press **Enter** at the logo, then **F12**, and pick the USB stick.

**Other computers:** the setup key is usually F2, Del or F10, and the boot menu is F12, F11 or Esc. Turn Secure Boot off, set the boot mode to UEFI only, and pick the entry that starts with `UEFI:` in the boot menu.

Once the live desktop is up, open a terminal and check:
```sh
ls /sys/firmware/efi
```
If it lists files, you're in UEFI mode. If it says "No such file or directory", go back to the firmware settings.

#### 1.4 Run the installer
Connect to the network (Wi-Fi is in the panel), then choose **Launch installer** in the CachyOS Hello window. Leave every option not listed here at its default.

1. **Location:** your timezone (for example `Europe/Madrid`) and language.
2. **Keyboard:** `Spanish`. This also sets the layout for the disk-passphrase prompt at boot.
3. **Bootloader:** `Limine` (the default) or `systemd-boot`. There's no location question in UEFI mode; if one appears, you're in Legacy mode (see 1.3).
4. **Partitions:**
   1. Pick the disk; check its size so you pick the right one. Choose **Erase disk**. ⚠️ **This erases the whole disk.**
   2. Leave the file system (`btrfs`) and swap at their defaults.
   3. Tick **Encrypt system** and type the disk passphrase. You'll type it at every boot. Use letters, numbers and spaces only: characters like `ñ`, `ç`, `-`, `/`, `@` or `"` sit in different places on Spanish and English keyboards. A long phrase of words is strong and easy to type.

   The installer keeps the small EFI partition unencrypted (the firmware has to read it) and encrypts the rest.
5. **Desktop:** `Niri`. It installs niri, the SDDM login screen and the Noctalia shell, which this setup uses.
6. **Packages:** leave the defaults. **Firefox** is ticked, which is the browser `Mod+W` opens. Add **Printing-Support** if you have a printer.
7. **Users:** your name, username and password. This password also unlocks the keyring at login and the lock screen.
8. **Summary:** check the disk, encryption and user, then **Install**. When it finishes, restart and remove the USB stick.

What CachyOS sets up, so the dotfiles don't have to: the GPU driver (`chwd` detects it, NVIDIA included), NetworkManager, Bluetooth, PipeWire audio, the firewall, zram swap and the SDDM login screen. It also makes **fish** your login shell; `setup-desktop.sh` switches it to zsh.

#### 1.5 First boot
1. Type the **disk passphrase** and press Enter. Nothing shows while you type; that's normal.
2. On the SDDM login screen, check that the session (bottom left) is **niri**, then log in.
3. Open a terminal with `Mod+Return` (Alacritty, from CachyOS's default niri config). For **Wi-Fi**, run `nmtui`, choose "Activate a connection" and pick your network.

#### 1.6 Protect the encryption
**If you forget the disk passphrase, the data can't be recovered.** Do these now (`verify.sh` reminds you if you don't):
1. Find the encrypted partition. It's the one marked `crypto_LUKS`, for example `/dev/sda2` on a SATA SSD or `/dev/nvme0n1p2` on an NVMe one:
   ```sh
   lsblk -f
   ```
2. Add a second, backup passphrase. Keep it somewhere safe outside this computer, for example in KeePassXC on another device:
   ```sh
   sudo cryptsetup luksAddKey /dev/sda2
   ```
   It asks for the current passphrase first, then the new one twice. Either passphrase unlocks the disk at boot.
3. Back up the encryption header. If that part of the disk gets damaged, this copy can save the data:
   ```sh
   sudo cryptsetup luksHeaderBackup /dev/sda2 --header-backup-file luks-header.img
   ```
   Copy `luks-header.img` off the computer (to another drive or a USB stick), then delete it here.

Use your partition's name from `lsblk -f` in both commands.

#### 1.7 Update the firmware (ThinkPad T480, optional)
Older T480 firmware has known Thunderbolt and charging bugs. Lenovo publishes its updates through LVFS:
```sh
sudo pacman -S fwupd
fwupdmgr refresh && fwupdmgr update
```

### Part 2 — Install the dotfiles

#### 2.1 Before you start
- **On a system you've already been using:** back up your home folder to another drive. `setup-dotfiles.sh` also moves every file it replaces into `~/.dotfiles-backup/<date>/`, including CachyOS's default niri and Noctalia configs.
- **Space:** keep about 10 GB free on `/`. Doom Emacs, LibreOffice and the language servers are large.
- **Time:** the slowest step is Doom Emacs, which downloads and compiles its packages; expect 10–20 minutes for the whole run.
- Log in as your normal user, not root.

#### 2.2 Install with the scripts (recommended)
`install-packages.sh` installs the packages, `setup-dotfiles.sh` links the files into your home folder, `setup-desktop.sh` sets up the themes and the system bits, `setup-editors.sh` installs Doom Emacs and the Neovim plugins, and `verify.sh` checks the result. Run them from Alacritty (`Mod+Return` in CachyOS's default niri config) or from a text console (`Ctrl+Alt+F2`). [The scripts in detail](#the-scripts-in-detail) has the full list of what each one does.

**1. Clone the repo:**
```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
```

**2. Install the packages:**
```sh
~/dotfiles/install-packages.sh
```
It asks for your sudo password once, then pacman and paru ask you to confirm. Accept the defaults, including replace prompts such as `7zip` replacing `p7zip`. It:
1. updates the system and installs the packages in `packages.txt`, `paru` and `pipx` included. Names that aren't in the repos are skipped with a warning;
2. installs the AUR packages in `packages-aur.txt`. A failed one is retried on its own and then skipped with a warning;
3. installs the Python tools in `packages-pipx.txt` with pipx, each in its own environment.

**3. Look at the files first (optional):** everything the next step puts in your home folder is in `~/dotfiles/home/`, laid out the same way. Hidden files start with a dot, so use `ls -la ~/dotfiles/home`. The only things not in the repo are the themes and Doom Emacs, which steps 5 and 6 download.

**4. Link the dotfiles:**
```sh
~/dotfiles/setup-dotfiles.sh
```
It only links and copies; it downloads nothing and doesn't need sudo. It:
1. symlinks every config from `~/dotfiles/home/` into `~`. Anything already there, such as CachyOS's niri and Noctalia configs and `.zshrc`, is moved to `~/.dotfiles-backup/<date>/` first;
2. copies the bundled fonts and refreshes the font cache.

**5. Set up the desktop:**
```sh
~/dotfiles/setup-desktop.sh
```
`sudo` and `chsh` ask for your password. It:
1. downloads and installs the GTK, Qt, icon and cursor themes, then applies them with `gsettings`;
2. creates `~/Pictures/Screenshots`, `~/Projects` and `~/org`;
3. makes Loupe open pictures, VLC videos and File Roller archives, so double-clicking one in Thunar or Double Commander opens it there;
4. enables power profiles and the GNOME keyring socket (CachyOS already enabled NetworkManager, Bluetooth and PipeWire, and SDDM unlocks the keyring with your login password);
5. makes zsh your login shell instead of CachyOS's default, fish;
6. checks the niri and Noctalia configs with `niri validate` and `noctalia config validate`.

**6. Install the editors:**
```sh
~/dotfiles/setup-editors.sh
```
It installs Doom Emacs, then the Neovim plugins, treesitter parsers and language servers, and builds Telescope's fzf extension. This is the slow step: Doom downloads and compiles its packages. It needs step 4 first, because it uses the linked `~/.config/doom` and `~/.config/nvim`. If you don't use one of the editors, you can skip this step.

Read the output of every script. Anything in a yellow `!!` line failed; the message says what to run to retry it. A failed step doesn't stop the later ones. All the scripts are safe to run again: finished steps are skipped or redone harmlessly.

**7. Check the result:**
```sh
~/dotfiles/verify.sh
```
It prints a ✓ or ✗ for each check and changes nothing. See [3.1](#31-run-verifysh) for what each line means.

**8. Log in to the new setup:** reboot, then log in from the SDDM login screen with the **niri** session:
```sh
sudo reboot
```

#### 2.3 Manual install
The same steps as the scripts, one at a time.

**1. Clone the repo:**
```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**2. Install the packages** (`paru` comes from the CachyOS repo with the rest):
```sh
sudo pacman -Syu --needed - < <(grep -v -e '^#' -e '^$' -e '^!' packages.txt)
paru -S --needed - < <(grep -v '^#' packages-aur.txt | grep -v '^$')
```
pacman asks which members of each group to install. Press Enter for all, except in `pro-audio`, where you leave out `audacity` because it conflicts with `audacity3-git`. `install-packages.sh` does that for you.

If pacman stops with `target not found: <name>`, that package has left the repos (often for the AUR). Remove it from `packages.txt` and run the command again; `install-packages.sh` skips such names automatically.

Then install the Python tools in `packages-pipx.txt` with pipx (`~/.local/bin` is already on `PATH` through `.zshenv`):
```sh
grep -v '^#' packages-pipx.txt | grep -v '^$' | xargs -n1 pipx install
```

This installs TrustSight. From then on, run `trustsight` before `paru -Syu` to review pending AUR updates for risky changes.

**3. Link the dotfiles.** Each file or folder in `~/dotfiles/home/` gets a symlink at the same path under `~`, after you move whatever is already there out of the way. `.config/gtk-2.0`, `gtk-3.0`, `gtk-4.0`, `Kvantum` and `xdg-desktop-portal` are linked file by file, because themes and apps add their own files there. For example:
```sh
mv ~/.config/niri ~/.config/niri.bak
ln -s ~/dotfiles/home/.config/niri ~/.config/niri
```
Copy the fonts, create the folders the configs expect, enable the two services CachyOS doesn't, and switch to zsh:
```sh
mkdir -p ~/.local/share/fonts && cp ~/dotfiles/home/.local/share/fonts/* ~/.local/share/fonts/ && fc-cache -f
xdg-user-dirs-update && mkdir -p ~/Pictures/Screenshots ~/Projects ~/org
sudo systemctl enable --now power-profiles-daemon
systemctl --user enable gnome-keyring-daemon.socket
chsh -s /usr/bin/zsh
```

**4. Install the GTK and icon themes.** Both come from [Fausto-Korpsvart/Rose-Pine-GTK-Theme](https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme). It isn't in the AUR; `rose-pine-gtk-theme-full` there is a different theme.
```sh
git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git /tmp/rose-pine-gtk
cd /tmp/rose-pine-gtk/themes
./install.sh -c dark -l      # builds ~/.themes/Rosepine-Dark; -l also sets it for GTK 4 / libadwaita apps
mkdir -p ~/.local/share/icons
cp -r /tmp/rose-pine-gtk/icons/Rose-Pine-Moon ~/.local/share/icons/
gtk-update-icon-cache -f ~/.local/share/icons/Rose-Pine-Moon
cd ~/dotfiles
```
The cursor theme `Sunity-cursors` comes from the AUR package `sunity-cursors-git` (installed in step 2). To install it by hand instead:
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

**5. Install Doom Emacs:**
```sh
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install --env
~/.config/emacs/bin/doom sync
~/.config/emacs/bin/doom doctor
```
`--env` generates Doom's envvar file, so Emacs sees the `PATH` from `.zshenv`. Your Doom config is already linked at `~/.config/doom`.

**6. Wallpaper:** the repo includes one, Raphael's *The School of Athens* (public domain), linked to `~/.local/share/backgrounds/wallpaper.jpg`. Noctalia shows it (`[wallpaper]` in `~/.config/noctalia/config.toml`). To use another image, replace that file, or put images in `~/.local/share/backgrounds` and pick one in Noctalia's wallpaper panel. `fill_mode = "crop"` crops the image to fill the screen; `"fit"` shows all of it with borders.

**7. Set up Neovim:** run `nvim`. lazy.nvim installs the plugins, treesitter builds its parsers, and Mason installs the language servers (this takes a minute). Make sure Telescope's fzf extension got compiled, then check everything:
```sh
make -C ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
```
```vim
:checkhealth
:Mason
```

**8. Set up Python (optional):** CachyOS already has a current Python. For other versions, pyenv compiles them from source, which takes several minutes:
```sh
pyenv install 3.13
pyenv global 3.13
```

**9. Check and start:** run `~/dotfiles/verify.sh`, then reboot and log in from SDDM with the **niri** session. Continue with [Part 3](#part-3--check-the-install-and-first-login).

### Part 3 — Check the install and first login

Log in from SDDM with the **niri** session: niri starts with the wallpaper and Noctalia's bar. `Ctrl+Alt+F2` and up give you a plain text console, which is handy if something goes wrong.

#### 3.1 Run verify.sh
```sh
~/dotfiles/verify.sh
```
It checks everything the install scripts do, plus the boot setup, and prints one line per check:
- `✓` passed;
- `✗` failed (most ✗ lines say what to run);
- `-` skipped, because the check can't run here (for example without sudo).

It ends with a count such as `30 passed, 0 failed, 0 skipped` and exits with an error if anything failed. It changes nothing. It asks for your sudo password once, only to read the boot partition and the encryption header; `./verify.sh --no-sudo` skips those two checks. Run it inside the niri session: a few checks, like the applied GTK theme, read your desktop settings.

What each section checks, and what to do when a line shows ✗:

| Section | Checks | If it shows ✗ |
|---|---|---|
| Packages | Everything in `packages.txt`, `packages-aur.txt` and `packages-pipx.txt` is installed | The line lists what's missing; run `install-packages.sh` again |
| Dotfiles linked | Every path from `home/` is linked into `~`, no links into the repo are broken, the bundled fonts are copied | Run `setup-dotfiles.sh` again. A broken link usually means a file was renamed or removed in the repo |
| Configs | `niri validate` and `noctalia config validate` | The error from the tool is printed under the ✗ line, with the file and line number |
| Login shell and services | zsh is your login shell; `sddm`, `NetworkManager`, `bluetooth`, `power-profiles-daemon` are enabled, plus `pipewire.socket`, `wireplumber` and `gnome-keyring-daemon.socket` for your user | For the shell: `chsh -s /usr/bin/zsh`, then log out and in. For a service: `sudo systemctl enable --now <name>` (add `--user` and drop `sudo` for user services) |
| Themes, fonts and default apps | GTK, icon, Qt and cursor themes are installed; `gsettings` applies `Rosepine-Dark`; PNG and JPEG open in Loupe, MP4 and MKV in VLC, ZIP in File Roller; JetBrains Mono and Iosevka Nerd Fonts are present | Run `setup-desktop.sh` again for the themes and default apps, or `setup-dotfiles.sh` for the bundled fonts; for the Nerd Fonts, `pacman -Q ttf-jetbrains-mono-nerd ttf-iosevka-nerd` shows whether the packages are there |
| Editors and tools | `trustsight` runs; Doom Emacs and its packages, the Neovim plugins, Telescope's fzf extension and the Mason language servers are installed | Run `setup-editors.sh` again, or the commands in [Troubleshooting](#troubleshooting) |
| Boot and encryption | Booted in UEFI mode; which firmware entry this boot came from; a LUKS-encrypted partition; the bootloader's config in `/boot`; at least two passphrases on the encrypted partition | See [3.2](#32-the-boot-setup) and [1.6](#16-protect-the-encryption) |

#### 3.2 The boot setup
`verify.sh` shows the firmware entry this boot came from, for example `Boot0001: Limine`. To see all of them:
```sh
efibootmgr
```
In a working install:
- `BootCurrent` is the entry the laptop booted from, and it's the one called **Limine** (or **Linux Boot Manager** for systemd-boot), pointing at `\EFI\limine\limine_x64.efi` on your EFI partition;
- that entry is first in `BootOrder`, so the laptop boots it without the USB stick.

Other entries are normal:
- **ThinkPad's built-in entries** (Setup, Boot Menu, Diagnostics, USB, NVMe, PCI LAN…) belong to the firmware.
- A **Windows Boot Manager** entry is left over if the disk had Windows before; the installer erased Windows, but the firmware still lists it. If `lsblk` shows no other disk with Windows on it, nothing can boot from it. It's harmless, and you can remove it with `sudo efibootmgr -b 0000 -B`, using the number `efibootmgr` shows for it.

The real test: reboot **with the USB stick removed**. You should get the passphrase prompt, then the SDDM login screen.

#### 3.3 Monitors
Open a terminal (`Mod+Return`) and list the screens:
```sh
niri msg outputs
```
If a resolution, refresh rate or scale is wrong, add a block to `~/.config/niri/config.kdl` using the name shown (for example `eDP-1` or `HDMI-A-1`):
```kdl
output "eDP-1" {
    mode "1920x1080@60"
    scale 1.0
}
```
niri applies it as soon as you save.

#### 3.4 Login screen (optional)
SDDM, the login screen, runs before you log in, so its files live outside your home folder and the main scripts leave it alone. `setup-login-screen.sh` installs a small Tokyo Night theme from `system/sddm/tokyo-night/` with the background and profile picture from `system/sddm/`:
```sh
~/dotfiles/setup-login-screen.sh
```
It asks for sudo and writes three things:
- `/usr/share/sddm/themes/tokyo-night-dotfiles/`: the theme and the background;
- `/usr/share/sddm/faces/<you>.face.icon`: your profile picture. SDDM can't read your home folder, which CachyOS keeps private, so `~/.face.icon` wouldn't work;
- `/etc/sddm.conf.d/10-dotfiles-theme.conf`: selects the theme, leaving `/etc/sddm.conf` alone.

Preview it without logging out:
```sh
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/tokyo-night-dotfiles
```
The real login screen changes the next time SDDM starts (log out or reboot).

**Other images:** pass your own, in any format Qt reads (JPG, PNG…). A square picture works best for the profile picture:
```sh
~/dotfiles/setup-login-screen.sh --background ~/Pictures/login.jpg --avatar ~/Pictures/me.png
```
Or replace `system/sddm/tokyo-night/background.jpg` and `system/sddm/avatar.jpg` and run the script again.

**Tweaks:** `system/sddm/tokyo-night/theme.conf` sets the font and where the login card sits (`cardPosition`: 0.5 is centered, 0.68 keeps it over the night sky in the default background). The layout and colors are in `Main.qml`. Run the script again after editing.

**Undo:** `sudo rm /etc/sddm.conf.d/10-dotfiles-theme.conf`, and SDDM goes back to its previous theme.

#### 3.5 Check by hand what a script can't
- [ ] `Mod+Return` opens Alacritty with the starship prompt, and `Mod+D` opens Noctalia's launcher.
- [ ] The bar shows the launcher, battery, CPU, RAM, disk, workspaces, keyboard layout, network, Bluetooth, volume, power profile and clock, in Tokyo Night colors.
- [ ] `Mod+Ctrl+Space` switches between Spanish and English, and the bar shows the layout.
- [ ] The volume, mic-mute, brightness and media keys work and show a popup.
- [ ] `notify-send hi` shows a notification.
- [ ] `Mod+Escape` locks the screen, and your password unlocks it.
- [ ] `Ctrl+Alt+P` saves a screenshot to `~/Pictures/Screenshots`.
- [ ] `Mod+V` opens the clipboard history, and `Mod+A` the control center.
- [ ] `Mod+W` opens Firefox, its file dialogs open, and nothing asks for a keyring password.
- [ ] GTK apps (Thunderbird) and Qt apps (`Mod+P` KeePassXC, `Mod+N` Double Commander) use the Rose Pine theme.
- [ ] In the terminal, `z <dir>` jumps to a directory, `ls` shows eza output, and Tab completes.
- [ ] `nvim` opens. In it:
  - `:checkhealth` shows no errors (warnings about optional tools are fine).
  - `Space ff` opens Telescope.
  - `:LspInfo` lists a server on a `.lua`, `.py` or `.ts` file.
- [ ] `Mod+E` opens Emacs.
- [ ] After a reboot without the USB stick, the passphrase prompt and SDDM appear.

### Part 4 — Keeping it up to date
- **System and AUR packages:** check pending AUR updates with TrustSight first, then update everything:
  ```sh
  trustsight
  ```
  ```sh
  paru -Syu
  ```
- **pipx tools (TrustSight):**
  ```sh
  pipx upgrade-all
  ```
- **Dotfiles:** pull the latest version and run `setup-dotfiles.sh` again, which links any new files. Then check with `verify.sh`:
  ```sh
  cd ~/dotfiles && git pull && ./setup-dotfiles.sh && ./verify.sh
  ```
  Run `setup-desktop.sh` again to update the themes, and `setup-editors.sh` after changes to the Doom or Neovim setup. All of them are safe to repeat.
  New packages in any of the three lists need `./install-packages.sh`, which is also safe to re-run. Packages removed from a list stay installed until you remove them with `sudo pacman -Rns <name>` (or `pipx uninstall <name>`).
- **Doom Emacs:** after a pull that changed `~/.config/doom/init.el` or `packages.el`, run `doom sync`. To update Doom and its packages:
  ```sh
  doom upgrade
  ```
- **Neovim plugins:** `:Lazy sync`, then `:TSUpdate` and `:MasonUpdate`.
- **Firmware:** `fwupdmgr refresh && fwupdmgr update` now and then (T480).

## The scripts in detail

All of them run as your normal user (they refuse to run as root) and are safe to run again. Run them in this order: `install-packages.sh`, `setup-dotfiles.sh`, then `setup-desktop.sh` and `setup-editors.sh` (those two in either order).

### install-packages.sh
1. Asks for sudo once and keeps it alive while AUR packages build.
2. `sudo pacman -Syu`, then installs `packages.txt` with `--needed`. Names not in the repos are listed with a warning and skipped, instead of making pacman refuse the whole list.
3. `paru -S --needed` for `packages-aur.txt`. If that fails, it retries each package on its own and warns about the ones that still fail.
4. `pipx install` for each tool in `packages-pipx.txt` that isn't installed yet.

It never removes packages.

### setup-dotfiles.sh
Links and copies, nothing else: no downloads, no sudo, no services.
1. Links every path from `home/` into `~`. Existing files are moved to `~/.dotfiles-backup/<date>/` first, and paths already linked are left alone. `.config/gtk-2.0`, `gtk-3.0`, `gtk-4.0`, `Kvantum` and `xdg-desktop-portal` are linked file by file, because themes and apps add their own files there.
2. Copies the bundled fonts, keeping fonts already there, and refreshes the font cache.

### setup-desktop.sh
1. Stops before changing anything if `git` or `sassc` is missing (run `install-packages.sh` first).
2. Downloads and installs the Rose Pine GTK theme and icons, the Sunity cursors (only if the AUR package isn't installed), and the Rose Pine Kvantum theme. Each failure is a warning; run the script again later.
3. Creates `~/Pictures/Screenshots`, `~/Projects` and `~/org`, and applies the theme with `gsettings`.
4. Makes `org.gnome.Loupe.desktop` the default for every `image/` type Loupe lists, `vlc.desktop` for every `video/` type VLC lists, and `org.gnome.FileRoller.desktop` for the archive types File Roller lists (not `.exe` and `.jar`, so those still run), with `xdg-mime default`. They're saved in `~/.config/mimeapps.list`; other defaults there stay as they are.
5. Enables `power-profiles-daemon` (with sudo) and the GNOME keyring socket, and switches your login shell to zsh if `/usr/bin/zsh` is in `/etc/shells`.
6. Runs `niri validate` and `noctalia config validate`.

### setup-editors.sh
1. Stops before changing anything if `git`, `emacs`, `nvim` or `make` is missing, or if `~/.config/doom` or `~/.config/nvim` isn't there yet (run `setup-dotfiles.sh` first).
2. Installs Doom Emacs, or runs `doom sync` if it's already installed. An existing `~/.config/emacs` that isn't Doom is left alone. Then runs `doom doctor`.
3. Installs the Neovim plugins with lazy.nvim, builds Telescope's fzf extension, installs the treesitter parsers from `ts_parsers.lua`, and the language servers through Mason.

### setup-login-screen.sh
Optional; see [3.4](#34-login-screen-optional). Installs the theme from `system/sddm/tokyo-night/`, the background (`--background FILE` to use another) and the profile picture (`--avatar FILE`), then selects the theme with a drop-in in `/etc/sddm.conf.d/`. It warns if `/etc/sddm.conf` sets its own theme, since that file wins over drop-ins.

### verify.sh
See [3.1](#31-run-verifysh). Options: `--no-sudo` skips the checks that need sudo; `--help` shows the usage.

### What the scripts change outside your home folder
- **Packages:** installed or upgraded, never removed.
- **Services:** `power-profiles-daemon` is enabled (`setup-desktop.sh`).
- **Login shell:** set to zsh with `chsh` (`setup-desktop.sh`).
- **Login screen (optional):** `setup-login-screen.sh` adds the SDDM theme and your picture under `/usr/share/sddm/` and one file in `/etc/sddm.conf.d/`, which is the only thing any script writes in `/etc`.

Nothing touches the bootloader, the boot image or the PAM login settings, so the scripts can't stop the computer from booting or block the passphrase prompt. If the login theme ever fails to load, SDDM falls back to its built-in theme; deleting the `/etc/sddm.conf.d` file undoes it.

## Testing in a virtual machine first
To try everything without touching your computer, use VirtualBox (free):
1. Create a VM: type Linux, version Arch Linux (64-bit), 4 GB of RAM or more, 2–4 CPUs, **Enable EFI** ticked, and an **80 GB** disk. **Enable EFI** matters: without it the installer runs in Legacy mode and the bootloader fails, as in 1.3.
2. **Settings → Display:** Graphics Controller **VMSVGA**, **Enable 3D Acceleration** ticked, Video Memory at the maximum. niri needs 3D acceleration in a VM.
3. Follow Part 1 using the CachyOS ISO as the VM's optical drive. Skip 1.2, 1.3 and 1.7. CachyOS's hardware detection normally installs the VirtualBox guest tools; if `systemctl status vboxservice` says the unit doesn't exist, run `sudo pacman -S virtualbox-guest-utils` and `sudo systemctl enable --now vboxservice`.
4. After the first boot, take a snapshot (**Machine → Tools → Snapshots → Take**) so you can roll back.
5. Follow Part 2 and Part 3.

VirtualBox quirks:
- Its **Host key** is Right Ctrl: use Left Ctrl for shortcuts, and `Right Ctrl+F2` to switch to tty2.
- Turn on **File → Preferences → Input → Auto Capture Keyboard** and click inside the VM, so the Super key reaches niri.
- Windows keeps `Win+L` for itself.

## Going back to your old setup
- Every file `setup-dotfiles.sh` replaced is in `~/.dotfiles-backup/<date>/`. Copy the ones you want back over the links.
- Your packages aren't removed. To get CachyOS's default niri and Noctalia setup back, move `~/.config/niri` and `~/.config/noctalia` back from the backup folder, or copy them from `/etc/skel/.config/`.
- To go back to fish: `chsh -s /usr/bin/fish`.

## Troubleshooting

### Installing and booting
- **The bootloader fails to install, or the system only boots with the USB stick in:** the installer ran in Legacy/CSM mode. Set the firmware to UEFI only (see 1.3), check with `ls /sys/firmware/efi`, and install again.
- **The disk passphrase isn't accepted at boot:** try typing it as if on an English (US) keyboard. If that works, the boot screen isn't using the Spanish layout; check that `/etc/vconsole.conf` says `KEYMAP=es`, then rebuild the boot image with `sudo limine-mkinitcpio` (Limine) or `sudo mkinitcpio -P` (systemd-boot). You can always unlock with the backup passphrase from 1.6.
- **`verify.sh` says there's only 1 passphrase:** add the backup passphrase from 1.6: `sudo cryptsetup luksAddKey /dev/sda2` (your partition's name is in the ✗ line).
- **`efibootmgr` lists a Windows Boot Manager you don't have:** it's left over from before the install; see 3.2.

### Logging in and the desktop
- **niri doesn't start, or the screen stays black:** press `Ctrl+Alt+F2`, log in, then run `niri validate` and `journalctl --user -b -u niri --no-pager | tail -40`.
- **SDDM logs you straight back out:** press `Ctrl+Alt+F2`, log in, and run `niri validate`. Check that SDDM's session menu says **niri**.
- **niri ignores your config and uses its defaults:** a duplicate keybinding or a typo stops niri loading `config.kdl`. Run `niri validate` to see the line.
- **No bar after logging in:** run `noctalia config validate` to find errors in `~/.config/noctalia/config.toml`, then start it by hand with `noctalia` to see its log. If a setting from the file seems ignored, it was probably changed in Noctalia's Settings window; check `~/.local/state/noctalia/settings.toml`.
- **The lock screen crashed and the screen stays locked (red or blank):** niri keeps the session locked on purpose. Press `Ctrl+Alt+F3`, log in, and run `loginctl terminate-user $USER`. That logs you out everywhere (unsaved work in open apps is lost); go back to the login screen with `Ctrl+Alt+F1` or `F2` and log in again.
- **Apps keep asking for a keyring password:** the login unlock isn't working. Check that `grep pam_gnome_keyring /etc/pam.d/sddm` shows the `auth` and `session` lines. If the keyring was created with a different password, delete `~/.local/share/keyrings/login.keyring` and log in again.
- **`Mod+º` does nothing:** run `wev`, press the º key and check the keysym it prints. If it isn't `masculine`, use that name in the two workspace-10 binds.
- **No network after installing:** run `nmtui`. If it says NetworkManager isn't running: `sudo systemctl enable --now NetworkManager`.
- **No sound:** run `systemctl --user status wireplumber`.
- **Other apps go silent while Ardour is open:** Ardour is using its ALSA backend, or `jack2`, and either one takes the sound card for itself. Install `pipewire-jack` (it's in `packages.txt` and replaces `jack2`), restart the audio services, then pick **JACK** in Ardour's Audio/MIDI Setup (Window → Audio/MIDI Setup). Ardour then goes through PipeWire like every other app:
  ```sh
  sudo pacman -S pipewire-jack
  systemctl --user restart pipewire pipewire-pulse wireplumber
  ```

### Ardour in its own X server
Ardour is an X11 app, and niri runs X11 apps through [xwayland-satellite](https://github.com/Supreeeme/xwayland-satellite). With it, Ardour's dropdown menus (track type, instrument, record mode…) open where Ardour doesn't expect them: you have to hold the button down, and the item picked is several rows away from the pointer. So `Mod+Shift+D` runs `~/.local/bin/ardour-x` instead, which starts Ardour in its own X server: an Xwayland window that niri opens maximized (a window rule in `config.kdl`), with Openbox inside. The X screen inside takes the window's size, so Ardour gets exactly the space between niri's bar and the screen edges. There the menus work.

- **Windows:** Ardour's main window fills the X server window. Plugin windows, the detached mixer and dialogs open inside it with a title bar: drag it to move a window (or Alt+drag anywhere on the window), drag an edge or Alt+right-drag to resize, double-click it to maximize. `Alt+Tab` switches between Ardour's windows. Openbox's settings are in `~/.config/ardour-x/rc.xml`.
- **Leaving it:** quit Ardour (`Ctrl+Q`) and the X server closes too. While Ardour is open, niri's keys still work, so you can switch workspaces as usual.
- **Limits:** you can't drag files from Thunar into Ardour, because they're in different display servers; use *Session → Import* instead. Copying and pasting text between Ardour and other apps may not work either. Audio is unaffected: Ardour still goes through PipeWire.
- **Ardour from the launcher (`Mod+D`)** starts it the normal way, with the broken menus. Use `Mod+Shift+D`, or run `ardour-x` in a terminal; it takes the same options as Ardour, for example a session folder.
- **To try without it** (for example after an xwayland-satellite update that might fix the menus), run `ardour9` in a terminal. If the menus work, change the `Mod+Shift+D` line in `config.kdl` back to start Ardour directly.

### Themes and fonts
- **Thunar has no "Extract Here" in the right-click menu:** Thunar loads plugins when it starts, so quit every Thunar window (or run `thunar -q`) and open it again. If it's still missing, check `pacman -Q thunar-archive-plugin file-roller`. In File Roller, a format that won't open usually needs its tool from the optional list in `pacman -Qi file-roller`.
- **GTK theme isn't applied:** check that `ls ~/.themes` lists `Rosepine-Dark`, then run the `gsettings` commands from step 4 of the manual install again, or pick the theme in `nwg-look`.
- **Qt apps look unthemed:** check `echo $QT_QPA_PLATFORMTHEME` shows `qt5ct:qt6ct` inside niri, and that `ls ~/.config/Kvantum` lists `rose-pine-foam`. Open `qt6ct` (or `qt5ct` for Double Commander) and check that Style is `kvantum`.
- **Cursor is the default one:** check that `ls ~/.icons /usr/share/icons | grep Sunity` finds the theme, then log out and back in.
- **Boxes instead of icons in the prompt:** the terminal's font has no Nerd Font icons. `fc-match monospace` should print `JetBrainsMono Nerd Font` (from `~/.config/fontconfig/fonts.conf`); terminals set to `monospace`, like CachyOS's Alacritty config, then show them. Apps with their own font setting need it set there. For VSCodium's built-in terminal, add this to its settings (`Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)"):
  ```json
  "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font"
  ```
  The prompt's icons are Nerd Fonts 3 codes; icons from Nerd Fonts 2 configs (codes `U+F500`–`U+FD46`) show as boxes with Nerd Fonts 3.
- **A font is reported missing:** `pacman -Q ttf-jetbrains-mono-nerd ttf-iosevka-nerd` shows whether the packages are installed, and `fc-list : family | grep -i "nerd font"` whether fontconfig sees them. Run `fc-cache -f` if it doesn't.

### Editors
- **Telescope says fzf isn't built:** run `make -C ~/.local/share/nvim/lazy/telescope-fzf-native.nvim`, then restart nvim.
- **Neovim says nvim-treesitter needs a newer version:** the `main` branch needs Neovim 0.12+. Check with `nvim --version`.
- **Treesitter errors in Neovim:** check that `tree-sitter --version` works, then run `:TSUpdate`.
- **Doom Emacs complains about missing packages after a pull:** run `doom sync`, then restart Emacs. `doom doctor` lists anything else it needs.
- **`doom doctor` says `Cannot open load file … straight`, or `doom sync` fails with `unknown revision` or `ambiguous argument 'HEAD'`:** some of Doom's package downloads are broken. Follow [Debugging Doom Emacs packages](#debugging-doom-emacs-packages).
- **`doom doctor` warns that Symbola is missing:** install the AUR package with `paru -S ttf-symbola` (it's in `packages-aur.txt`), then restart Emacs.

### Debugging Doom Emacs packages
Doom downloads each package as a git repository into `~/.config/emacs/.local/straight/repos/` and builds it into `~/.config/emacs/.local/straight/build-*/`. If `doom install` or `doom sync` is interrupted (a network drop, closing the terminal, a reboot), it can leave a repository folder whose download never finished. Doom then thinks the package is there and fails when it tries to use it.

**Symptoms:**
- `doom doctor` reports `Cannot open load file` … `straight`.
- `doom sync` or `doom upgrade` stops with `The package manager threw an error`, and the log shows `git rev-parse HEAD` failing in a package's folder:
  ```
  $ cd ~/.config/emacs/.local/straight/repos/auto-minor-mode/
  $ git rev-parse HEAD
  fatal: ambiguous argument 'HEAD': unknown revision or path not in the working tree.
  ```
- `doom sync` says `No packages need attention` but Emacs still can't load a package.

These folders are only downloaded copies. Deleting them loses nothing of yours; your config is in `~/.config/doom`, which none of this touches.

**1. List the broken downloads.** This changes nothing; it prints each package folder without a finished download:
```sh
cd ~/.config/emacs/.local/straight/repos
for d in */; do git -C "$d" rev-parse -q --verify HEAD >/dev/null 2>&1 || echo "${d%/}"; done
```

**2. Delete them**, together with their half-built copies:
```sh
cd ~/.config/emacs/.local/straight/repos
for d in */; do
  d="${d%/}"
  if ! git -C "$d" rev-parse -q --verify HEAD >/dev/null 2>&1; then
    rm -rf "$d" ../build*/"$d"
    echo "removed $d"
  fi
done
```

**3. Download them again and check:**
```sh
doom sync
doom doctor
```
Use `doom sync` once Doom is installed. `doom install` is only for the first setup; running it again just repeats the same sync.

**If that doesn't fix it,** for example when step 1 lists dozens of packages or `doom sync` keeps failing on another one, delete all downloaded packages and fetch everything fresh. It takes longer, since every package is downloaded and compiled again, but it leaves nothing half-done:
```sh
rm -rf ~/.config/emacs/.local/straight
doom sync
```

**Where to look for more:**
- `doom sync` prints the last lines of straight's error log, which name the package and the git command that failed.
- The full logs are in `~/.config/emacs/.local/state/logs/`; the newest file is the last run.
- Run `doom sync` again once the network is stable: a download that failed because of the network usually works the second time.
