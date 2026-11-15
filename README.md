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
| Wallpaper | swaybg; Raphael's *The School of Athens* (public domain) | `.local/share/backgrounds/wallpaper.jpg`, path set in the niri config |
| Terminal | foot (its default config, no config file) | none |
| Shell | zsh + starship | `.zshenv` (environment, PATH), `.zprofile` (login), `.zshrc` (interactive), `.config/starship.toml` |
| Editors | Neovim (lazy.nvim), Doom Emacs | `.config/nvim/`, `.config/doom/` |
| GTK theme | GTK 2/3/4 settings | `.config/gtk-3.0/`, `.config/gtk-4.0/`, `.gtkrc-2.0`, `.icons/` |
| Qt theme | Kvantum + qt5ct/qt6ct | `.config/Kvantum/`, `.config/qt5ct/`, `.config/qt6ct/` |
| Portals | xdg-desktop-portal (file pickers through GTK, screencasting through GNOME) | `.config/xdg-desktop-portal/niri-portals.conf` |
| Autostart | XDG autostart entries, run by `niri-session` | `.config/autostart/` (hides the duplicate `nm-applet`) |
| Fonts | JetBrains Mono / Iosevka Nerd Font (packages); CatV, Feather, Grape Nuts (bundled) | `.local/share/fonts/` |

## Features

- **niri**
  - Spanish (`es`) and English (`us`) keyboard layouts: Spanish is the default, `Mod+Ctrl+Space` switches, and waybar shows the current one.
  - Touchpad tap-to-click, natural scrolling, and disable-while-typing.
  - Focus follows the mouse.
  - 8px gaps and a 2px Tokyo Night focus ring.
  - Rounded corners and a translucent terminal (foot).
  - Preset column widths (1/3, 1/2, 2/3).
- **Autostart:** waybar, mako, swaybg, swayidle, the Emacs daemon, the network tray applet and the clipboard history watcher, from the niri config. `niri-session` also runs the standard XDG autostart entries, which is how the Bluetooth applet starts.
- **File pickers:** "Open file" dialogs from portal-using apps (Flatpaks, Firefox-based browsers) use the GTK file chooser, because GNOME's portal would need Nautilus.
- **Idle:** locks after 10 minutes, turns monitors off after 15, and locks before sleep.
- **Screenshots:** built into niri, saved to `~/Pictures/Screenshots`.
- **Waybar:**
  - Left: battery, CPU, memory, disk.
  - Center: niri workspaces.
  - Right: keyboard layout (`es` / `us`), network (click opens `nmtui`), volume (click opens pavucontrol), power profile (click cycles power-saver / balanced / performance), clock with a calendar tooltip, tray.
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
| `Mod+Return` | foot (terminal) |
| `Mod+D` | fuzzel launcher |
| `Mod+E` | Emacs (client) |
| `Mod+W` | Firefox |
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
| `Mod+Ctrl+Space` | Switch keyboard layout: Spanish ↔ English |
| `Mod+C` | Center column |

### Workspaces and system
| Key | Action |
|---|---|
| `Mod+1…9`, `Mod+º` (`` Mod+` `` on English) | Go to workspace 1–9, 10 |
| `Mod+Shift+1…9`, `Mod+Shift+º` (`` Mod+Shift+` `` on English) | Move column to workspace 1–9, 10 |
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

### foot
foot runs with its default keys; `man foot.ini` (section `key-bindings`) lists them all. The main ones:

| Key | Action |
|---|---|
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl++` / `Ctrl+-` / `Ctrl+0` | Font bigger / smaller / reset |
| `Shift+PageUp` / `Shift+PageDown` | Scroll back / forward |
| `Ctrl+Shift+R` | Search the scrollback |
| `Ctrl+Shift+N` | New terminal in the same folder |

## Customizing keybindings

### niri (window manager)
Bindings live in the `binds { }` block of `~/.config/niri/config.kdl`. niri reloads the file as soon as you save it, so there's nothing to restart. Run `niri validate` if a change doesn't take effect; a broken file keeps the last working config and shows an error.

Each line is `<keys> { <action>; }`:
```kdl
binds {
    // Launch an app
    Mod+B { spawn "firefox"; }

    // Arguments are separate strings
    Mod+Ctrl+Return { spawn "foot" "btop"; }

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

### foot
foot has no config file here, so it uses its defaults. To change keys (or fonts and colors), create `~/.config/foot/foot.ini`, starting from the commented example at `/etc/xdg/foot/foot.ini`:
```sh
mkdir -p ~/.config/foot && cp /etc/xdg/foot/foot.ini ~/.config/foot/
```
Keys go in the `[key-bindings]` section, for example `clipboard-copy=Control+Shift+c`. `man foot.ini` lists every action. Open a new foot window to apply changes.

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
| Fonts | `ttf-jetbrains-mono-nerd`, `ttf-iosevka-nerd`, `ttf-nerd-fonts-symbols-mono` (Doom icons), `cantarell-fonts`, `noto-fonts`, `noto-fonts-emoji` | waybar, fuzzel, mako, GTK. CatV, Feather and Grape Nuts aren't packaged, so they stay in `.local/share/fonts/` |
| Qt theming | `kvantum`, `kvantum-qt5`, `qt5ct`, `qt6ct`, `qt5-wayland`, `qt6-wayland` | Same Rose Pine look and icons for Qt apps (Double Commander, KeePassXC) |
| Theming | `nwg-look`, `sassc`, `gnome-themes-extra`; AUR: `sunity-cursors-git`, `gtk-engine-murrine` | GTK tools and theme build dependencies; cursor theme `Sunity-cursors` |
| Terminal | `foot` | `Mod+Return`. Renders on the CPU, so it doesn't depend on the GPU driver |
| Shell | `zsh`, `starship`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `eza`, `bat`, `zoxide`, `fzf`, `pyenv`, `yt-dlp` | `.zshrc` aliases and plugins |
| Archives | `unzip`, `unrar`, `7zip`, `cabextract`, `cpio` | The `extract` function |
| Neovim | `neovim` (0.12+, needed by nvim-treesitter's main branch), `git`, `base-devel`, `tree-sitter-cli`, `ripgrep`, `fd`, `nodejs`, `npm`, `python`, `python-pip`, `luarocks` | lazy.nvim, treesitter parsers, Telescope, telescope-fzf-native, Mason servers (`ts_ls`, `bashls`, `pylsp`, `lua_ls`, `rust_analyzer`) |
| LaTeX | `texlive-basic`, `texlive-latex`, `texlive-latexrecommended`, `texlive-latexextra`, `texlive-binextra` (latexmk), `zathura`, `zathura-pdf-mupdf` | VimTeX compile and PDF viewer |
| Doom Emacs | `emacs-wayland`, `aspell`, `aspell-en`, `aspell-es`, `languagetool`, `shellcheck` | Doom, `spell`, `grammar`, `sh` modules |
| AUR safety | AUR: `trustsight` | Risk-scores AUR updates before you install them ([repo](https://github.com/emiliano-go/trustsight)) |
| Apps | `firefox`, `thunderbird`, `libreoffice-fresh`, `gimp`, `inkscape`, `keepassxc`, `doublecmd-qt5`; AUR: `goodvibes` | `Mod+` app shortcuts |

Not packaged, so install these by hand:
- **GTK theme `Rosepine-Dark`** and **icon theme `Rose-Pine-Moon`** (step 5 below).
- **Doom Emacs** (step 6 below).

## Installation

The guide has four parts. If Arch is already installed, skip to [Part 2](#part-2--install-the-dotfiles).

1. [Install Arch Linux](#part-1--install-arch-linux-encrypted-with-archinstall), with the whole system encrypted, using `archinstall`.
2. [Install the dotfiles](#part-2--install-the-dotfiles), with one script or step by step.
3. [First login](#part-3--first-login): monitors and a checklist.
4. [Keeping it up to date](#part-4--keeping-it-up-to-date).

You can also [test everything in a virtual machine first](#testing-in-a-virtual-machine-first).

### Part 1 — Install Arch Linux (encrypted, with archinstall)

#### 1.1 What you need
- A USB stick of 2 GB or more. It will be erased.
- An internet connection, ideally a cable. Wi-Fi works too.
- A backup of anything on the target disk. **The install erases the whole disk.**
- To keep Windows on the same disk (dual boot), stop here: that needs manual partitioning, which this guide doesn't cover.

#### 1.2 Make the USB stick
1. Download `archlinux-x86_64.iso` from [archlinux.org/download](https://archlinux.org/download/), from a mirror near you.
2. Write it to the USB stick:
   - **On Windows:** use [Rufus](https://rufus.ie). Select the stick and the ISO, click **Start**, and choose **Write in DD Image mode** when asked.
   - **On Linux:** find the stick with `lsblk` (for example `/dev/sdb`), then run:
     ```sh
     sudo dd if=archlinux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
     ```
     Replace `/dev/sdX` with the stick, not a partition like `/dev/sdb1`. Double-check it: `dd` overwrites whatever you point it at.

#### 1.3 Firmware (BIOS/UEFI) settings
Open the firmware setup; the key is usually F2, Del or F10 at power-on. Then:
1. Turn **Secure Boot** off. The Arch ISO isn't signed for it.
2. Make sure it boots in **UEFI** mode, not "Legacy" or "CSM".
3. Save, then boot from the USB stick. The boot-menu key is usually F12, F11 or Esc.

Pick the first entry in the Arch boot menu and wait for the `root@archiso` prompt.

#### 1.4 Keyboard and network
1. Set the Spanish keyboard:
   ```sh
   loadkeys es
   ```
2. **Wired:** nothing to do. **Wi-Fi:** connect with `iwctl`:
   ```sh
   iwctl device list
   ```
   ```sh
   iwctl --passphrase "YourWifiPassword" station wlan0 connect "YourNetwork"
   ```
   Use the device name from the first command if it isn't `wlan0`.
3. Check the connection:
   ```sh
   ping -c 3 archlinux.org
   ```

#### 1.5 Run archinstall
```sh
archinstall
```
Move with the arrow keys, select with Enter, and go back with Esc. Leave every option not listed here at its default. These menu names are from `archinstall` 3.x and may differ slightly in other versions.

1. **Locales:**
   - **Keyboard layout:** `es`. This also sets the layout for the disk-passphrase prompt at boot.
   - **Locale language:** for example `es_ES.UTF-8` or `en_US.UTF-8`.
   - **Locale encoding:** `UTF-8`.
2. **Mirrors and repositories → Select regions:** your country, or ones nearby.
3. **Disk configuration:**
   1. **Partitioning → Use a best-effort default partition layout.** Select your disk; check its size so you pick the right one. ⚠️ **This erases the whole disk.**
   2. **Filesystem:** `ext4`.
   3. **Separate partition for /home:** no. One encrypted partition for everything is simpler.
   4. **Disk encryption:**
      - **Encryption type:** `LUKS`.
      - **Encryption password:** your disk passphrase. You'll type it at every boot. Use letters, numbers and spaces only: characters like `ñ`, `ç`, `-`, `/`, `@` or `"` sit in different places on Spanish and English keyboards. A long phrase of words is strong and easy to type.
      - **Partitions:** select the **root** partition (the large `ext4` one). Leave the small boot partition (`fat32`, about 1 GB) unencrypted; the firmware has to read it.
   5. **Back.** The summary should show the boot partition (`fat32`, `/boot`) and the root partition (`ext4`, `/`, encrypted).
4. **Swap:** leave it on (zram).
5. **Bootloader:** `Systemd-boot`.
6. **Unified kernel images:** off.
7. **Hostname:** a name for the computer, for example `arch`.
8. **Authentication:**
   - **Root password:** set one.
   - **User account → Add a user:** your username and password, and answer **yes** to "superuser (sudo)". This password also unlocks the keyring at login.
9. **Profile → Type → Minimal.** No desktop: the dotfiles provide niri.
10. **Applications:**
    - **Bluetooth:** on, if the computer has Bluetooth.
    - **Audio:** `Pipewire`.
11. **Kernels:** `linux`.
12. **Network configuration:** "Use NetworkManager".
13. **Additional packages:** `git`, plus the graphics driver for your GPU:
    - **AMD:** `vulkan-radeon`
    - **Intel:** `vulkan-intel`
    - **NVIDIA:** `nvidia-open`, then also do [1.7](#17-nvidia-only).
14. **Timezone:** yours, for example `Europe/Madrid`.
15. **Automatic time sync (NTP):** on.

Choose **Install**, check the summary (disk, encryption, user), and confirm. When it finishes, answer **no** to chrooting into the new system, then reboot and remove the USB stick:
```sh
reboot
```

#### 1.6 First boot
1. Type the **disk passphrase** and press Enter. Nothing shows while you type; that's normal.
2. Log in as your user on the text console.
3. **Wi-Fi:** run `nmtui`, choose "Activate a connection" and pick your network.

#### 1.7 NVIDIA only
niri needs kernel modesetting. Find the boot entry and add `nvidia-drm.modeset=1` to the end of its `options` line:
```sh
ls /boot/loader/entries/
```
```sh
sudo nano /boot/loader/entries/<the-entry>.conf
```
Then reboot. Also read [niri's NVIDIA notes](https://yalter.github.io/niri/Nvidia.html).

#### 1.8 Protect the encryption
**If you forget the disk passphrase, the data can't be recovered.** Do these now:
1. Find the encrypted partition. It's the one marked `crypto_LUKS`, for example `/dev/nvme0n1p2`:
   ```sh
   lsblk -f
   ```
2. Add a second, backup passphrase. Keep it somewhere safe outside this computer, for example in KeePassXC on another device:
   ```sh
   sudo cryptsetup luksAddKey /dev/nvme0n1p2
   ```
3. Back up the encryption header. If that part of the disk gets damaged, this copy can save the data:
   ```sh
   sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file luks-header.img
   ```
   Copy `luks-header.img` off the computer (to another drive or a USB stick), then delete it here.

### Part 2 — Install the dotfiles

#### 2.1 Before you start
- **On an existing system:** back up your home folder to another drive. The installer also moves every file it replaces into `~/.dotfiles-backup/<date>/`.
- **Network:** the installer turns connman off and uses NetworkManager. Use a cable, or be ready to reconnect Wi-Fi with `nmtui`.
- **Space:** keep about 20 GB free on `/`. TeX Live, Doom Emacs, LibreOffice and the language servers are large.
- Log in as your normal user, not root.

#### 2.2 Quick install (recommended)
```sh
git clone https://github.com/GerMP21/dotfiles.git ~/dotfiles
```
```sh
~/dotfiles/full-install.sh
```
It runs every step of the [manual install](#23-manual-install) in order. It asks for your sudo password once at the start, `chsh` asks for your password again, and pacman and paru ask you to confirm packages. Accept the defaults, including replace prompts such as `7zip` replacing `p7zip`. The whole run takes a while.

What it does:
1. Installs the packages in `packages.txt`. Names that aren't in the official repos are skipped with a warning.
2. Installs `paru` (an AUR helper) if you don't have it.
3. Installs the AUR packages in `packages-aur.txt`. A failed one is retried on its own and then skipped with a warning.
4. Runs `install.sh`, which links the configs, installs the fonts, enables the services and makes zsh your shell.
5. Installs the GTK, Qt, icon and cursor themes and applies them.
6. Installs Doom Emacs.
7. Installs the Neovim plugins, treesitter parsers and language servers, and builds Telescope's fzf extension.
8. Checks that the wallpaper is in place.
9. Checks the niri config with `niri validate`.

At the end, read the output. Anything in yellow `!!` lines failed; the message says what to run to retry it. You can run the script again safely: finished steps are skipped or redone harmlessly.

Then reboot and log in on **tty1**:
```sh
sudo reboot
```

#### 2.3 Manual install
The same steps as `full-install.sh`, one at a time.

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

If pacman stops with `target not found: <name>`, that package has left the official repos (often for the AUR). Remove it from `packages.txt` and run the command again; `full-install.sh` skips such names automatically.

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
~/.config/emacs/bin/doom sync
~/.config/emacs/bin/doom doctor
```
`--env` generates Doom's envvar file, so Emacs sees the `PATH` from `.zshenv`. Your Doom config is already linked at `~/.config/doom`.

**7. Wallpaper:** the repo includes one, Raphael's *The School of Athens* (public domain), linked to `~/.local/share/backgrounds/wallpaper.jpg`. To use another image, replace that file or change the `swaybg` line in `~/.config/niri/config.kdl`. `-m fill` crops the image to fill the screen; use `-m fit` to show all of it with borders.

**8. Set up Neovim:** run `nvim`. lazy.nvim installs the plugins, treesitter builds its parsers, and Mason installs the language servers (this takes a minute). Make sure Telescope's fzf extension got compiled, then check everything:
```sh
make -C ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
```
```vim
:checkhealth
:Mason
```

**9. Set up Python (optional):**
```sh
pyenv install 3.13
pyenv global 3.13
```

**10. Start niri:** reboot, then log in on **tty1**. `.zprofile` runs `niri-session -l`. Continue with [Part 3](#part-3--first-login).

### Part 3 — First login

Log in on **tty1**: niri starts by itself, with the wallpaper and waybar. On other ttys (`Ctrl+Alt+F2` and up) you get a plain text console, which is handy if something goes wrong.

#### 3.1 Monitors
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

#### 3.2 Check that everything works
- [ ] `Mod+Return` opens foot, and `Mod+D` opens fuzzel.
- [ ] Waybar shows the layout, battery, CPU, memory, disk, workspaces, network, volume, power profile and clock.
- [ ] `Mod+Ctrl+Space` switches between Spanish and English, and waybar shows `es` / `us`.
- [ ] The volume, mic-mute, brightness and media keys work.
- [ ] The tray shows one network icon and one Bluetooth icon.
- [ ] `notify-send hi` shows a notification.
- [ ] `Mod+Escape` locks the screen, and your password unlocks it.
- [ ] `Ctrl+Alt+P` saves a screenshot to `~/Pictures/Screenshots`, and `Mod+V` opens the clipboard history.
- [ ] `Mod+W` opens Firefox, its file dialogs open, and nothing asks for a keyring password.
- [ ] GTK apps (Thunderbird) and Qt apps (`Mod+P` KeePassXC, `Mod+N` Double Commander) use the Rose Pine theme.
- [ ] In the terminal, `z <dir>` jumps to a directory, `ls` shows eza output, and Tab completes.
- [ ] `nvim` opens. In it:
  - `:checkhealth` shows no errors.
  - `Space ff` opens Telescope.
  - `:LspInfo` lists a server on a `.lua`, `.py` or `.ts` file.
- [ ] `Mod+E` opens Emacs.

### Part 4 — Keeping it up to date
- **System and AUR packages:** check pending AUR updates with TrustSight first, then update everything:
  ```sh
  trustsight
  ```
  ```sh
  paru -Syu
  ```
- **Dotfiles:** pull the latest version and re-run the linker, which is safe to repeat:
  ```sh
  cd ~/dotfiles && git pull && ./install.sh
  ```
  New packages in `packages.txt` need `full-install.sh`, which is also safe to re-run.
- **Neovim plugins:** `:Lazy sync`, then `:TSUpdate` and `:MasonUpdate`.
- **Doom Emacs:**
  ```sh
  doom upgrade
  ```

### Testing in a virtual machine first
To try everything without touching your computer, use VirtualBox (free):
1. Create a VM: type Linux, version Arch Linux (64-bit), 4 GB of RAM or more, 2–4 CPUs, **Enable EFI** ticked, and an **80 GB** disk.
2. **Settings → Display:** Graphics Controller **VMSVGA**, **Enable 3D Acceleration** ticked, Video Memory at the maximum. niri needs 3D acceleration in a VM.
3. Follow Part 1 using the Arch ISO as the VM's optical drive. Skip 1.2 and 1.3; add `virtualbox-guest-utils` to the additional packages.
4. After the first boot, run `sudo systemctl enable --now vboxservice` and take a snapshot (**Machine → Tools → Snapshots → Take**) so you can roll back.
5. Follow Part 2.

VirtualBox quirks:
- Its **Host key** is Right Ctrl: use Left Ctrl for shortcuts, and `Right Ctrl+F2` to switch to tty2.
- Turn on **File → Preferences → Input → Auto Capture Keyboard** and click inside the VM, so the Super key reaches niri.
- Windows keeps `Win+L` for itself.

### Going back to your old setup
- Every file `install.sh` replaced is in `~/.dotfiles-backup/<date>/`. Copy the ones you want back over the links.
- Your old packages aren't removed. Restoring your old `.zprofile` brings back your old login, for example `startx`.

## Troubleshooting
- **The disk passphrase isn't accepted at boot:** try typing it as if on an English (US) keyboard. If that works, the boot screen isn't using the Spanish layout; check that `/etc/vconsole.conf` says `KEYMAP=es`, then run `sudo mkinitcpio -P`. You can always unlock with the backup passphrase from 1.8.
- **niri doesn't start, or the screen stays black:** press `Ctrl+Alt+F2`, log in, then run `niri validate` and `journalctl --user -b -u niri --no-pager | tail -40`.
- **No network after installing:** run `nmtui`. If it says NetworkManager isn't running: `sudo systemctl enable --now NetworkManager`.
- **Telescope says fzf isn't built:** run `make -C ~/.local/share/nvim/lazy/telescope-fzf-native.nvim`, then restart nvim.
- **niri doesn't start from tty1:** run `niri-session` by hand and read the errors. `niri validate` also checks the config.
- **No sound:** run `systemctl --user status wireplumber`.
- **GTK theme isn't applied:** check that `ls ~/.themes` lists `Rosepine-Dark`, then run the `gsettings` commands from step 5 of the manual install again, or pick the theme in `nwg-look`.
- **Qt apps look unthemed:** check `echo $QT_QPA_PLATFORMTHEME` shows `qt5ct:qt6ct` inside niri, and that `ls ~/.config/Kvantum` lists `rose-pine-foam`. Open `qt6ct` (or `qt5ct` for Double Commander) and check that Style is `kvantum`.
- **niri ignores your config and uses its defaults:** a duplicate keybinding or a typo stops niri loading `config.kdl`. Run `niri validate` to see the line.
- **`Mod+º` does nothing:** run `wev`, press the º key and check the keysym it prints. If it isn't `masculine`, use that name in the two workspace-10 binds.
- **Apps keep asking for a keyring password:** the login unlock isn't working. Check that `grep pam_gnome_keyring /etc/pam.d/login` shows two lines. If the keyring was created with a different password, delete `~/.local/share/keyrings/login.keyring` and log in again.
- **Neovim says nvim-treesitter needs a newer version:** the `main` branch needs Neovim 0.12+. Check with `nvim --version`.
- **Two network or Bluetooth icons in the tray:** an app started both from the niri config and from its XDG autostart entry. Run `ls /etc/xdg/autostart ~/.config/autostart` and either remove its `spawn-at-startup` line or hide the entry with a `Hidden=true` file in `~/.config/autostart/`.
- **Cursor is the default one:** check that `ls ~/.icons /usr/share/icons | grep Sunity` finds the theme, then log out and back in.
- **Treesitter errors in Neovim:** check that `tree-sitter --version` works, then run `:TSUpdate`.
