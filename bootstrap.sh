#!/usr/bin/env bash

set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$XDG_CONFIG_HOME"

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

if command -v apt-get &> /dev/null; then
  $SUDO apt-get update -y
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y neovim tmux git python3
elif command -v pacman &> /dev/null; then
  $SUDO pacman -Syu --noconfirm --needed neovim tmux git python
elif command -v brew &> /dev/null; then
  brew install neovim tmux git python sketchybar
else
  echo "No recognized package manager. Quitting." >&2
  exit 1
fi

# neovim
ln -sfn "$DOTFILES/nvim" "$XDG_CONFIG_HOME/nvim"

# ghostty
ln -sfn "$DOTFILES/ghostty" "$XDG_CONFIG_HOME/ghostty"

# tmux
ln -sfn "$DOTFILES/tmux" "$XDG_CONFIG_HOME/tmux"

# sketchybar
if [[ "$(uname)" == "Darwin" ]]; then
  ln -sfn "$DOTFILES/sketchybar" "$XDG_CONFIG_HOME/sketchybar"
fi
