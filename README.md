# Cross-platform dotfiles

Curated configuration for macOS and Linux. The repository deliberately excludes the rest of `~/.config`, including browser profiles, application state, caches, logs, and credentials.

## Install

Clone this repository somewhere outside `~/.config`, then run:

```sh
git clone <repository-url> "$HOME/dotfiles"
cd "$HOME/dotfiles"
./install.sh
```

On macOS, install Homebrew first. The installer uses Homebrew for the portable CLI tools and Ghostty. On Linux it supports pacman, apt, and dnf; Hyprland/Omarchy configuration remains intentionally separate and is not installed by this script.

The installer creates backups before replacing existing files and installs configurations through symlinks, so future updates are just `git pull`.

## Personal paths

The tmux launcher defaults to `$HOME/dev/cpp/Nyx`. Override it without editing the repository:

```sh
NYXARA_PROJECT_DIR="$HOME/path/to/project" ./install.sh
```

Other useful overrides are `XDG_CONFIG_HOME` and `NYXARA_TMUX_SESSION`.
