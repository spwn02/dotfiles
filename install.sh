#!/usr/bin/env bash

set -euo pipefail

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="${CONFIG_DIR}/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() { printf '\n==> %s\n' "$*"; }

link_file() {
  local source="$1" target="$2"
  mkdir -p "$(dirname -- "$target")"
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$(readlink "$target" 2>/dev/null || true)" = "$source" ]; then
      return
    fi
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/$(basename -- "$target")"
  fi
  ln -s "$source" "$target"
}

install_packages() {
  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        printf '%s\n' 'Homebrew is required. Install it from https://brew.sh, then rerun this script.' >&2
        exit 1
      fi
      brew install git neovim tmux btop bat mise zoxide fzf ripgrep fd eza starship lazygit jq
      brew install --cask ghostty 2>/dev/null || true
      ;;
    Linux)
      if command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed git neovim tmux btop bat mise zoxide fzf ripgrep fd eza starship lazygit jq
      elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y git neovim tmux btop bat fzf ripgrep fd-find jq
      elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y git neovim tmux btop bat fzf ripgrep fd-find jq
      else
        printf '%s\n' 'No supported Linux package manager found; skipping packages.' >&2
      fi
      ;;
    *)
      printf '%s\n' 'Unsupported operating system; skipping packages.' >&2
      ;;
  esac
}

log "Installing packages"
if [ "${DOTFILES_SKIP_PACKAGES:-0}" = 1 ]; then
  printf '%s\n' 'Skipping package installation (DOTFILES_SKIP_PACKAGES=1).'
else
  install_packages
fi

log "Installing shell and helper scripts"
mkdir -p "$HOME/.local/bin"
link_file "$REPO_DIR/bin/nyxara-tmux" "$HOME/.local/bin/nyxara-tmux"
link_file "$REPO_DIR/bin/tmux-git-status" "$HOME/.local/bin/tmux-git-status"
link_file "$REPO_DIR/home/zshrc" "$HOME/.zshrc"

log "Installing portable configuration"
for name in alacritty bat btop ghostty kitty mise nvim tmux; do
  [ -d "$REPO_DIR/$name" ] && link_file "$REPO_DIR/$name" "$CONFIG_DIR/$name"
done
link_file "$REPO_DIR/git/config" "$CONFIG_DIR/git/config"
mkdir -p "$CONFIG_DIR/zshrc.d"
link_file "$REPO_DIR/zshrc.d/shortcuts.zsh" "$CONFIG_DIR/zshrc.d/shortcuts.zsh"

if [ -d "$BACKUP_DIR" ] && [ -z "$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
  rmdir "$BACKUP_DIR"
fi

log "Done"
printf '%s\n' "Restart your shell. Backups, if needed, are in: $BACKUP_DIR"
