#!/usr/bin/env bash

set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$HOME/.local/share/fonts"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$ZSH_PLUGINS"

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

if ! fc-list | grep -qi "BlexMono"; then
  mkdir -p "$FONT_DIR"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/blex.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IBMPlexMono.zip \
    && unzip -q "$tmp/blex.zip" -d "$FONT_DIR" \
    && fc-cache -f "$FONT_DIR" \
    || echo "Warning: BlexMono install failed" >&2
  rm -rf "$tmp"
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

for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
  dest="$ZSH_PLUGINS/$(basename "$repo")"
  if [ ! -d "$dest" ]; then
    git clone --depth 1 "https://github.com/$repo" "$dest" \
      || echo "Warning: failed to clone $repo" >&2
  fi
done

# zsh
ln -sfn "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# neovim
ln -sfn "$DOTFILES/nvim" "$XDG_CONFIG_HOME/nvim"

# ghostty
ln -sfn "$DOTFILES/ghostty" "$XDG_CONFIG_HOME/ghostty"

# tmux
ln -sfn "$DOTFILES/tmux" "$XDG_CONFIG_HOME/tmux"

# starship
ln -sfn "$DOTFILES/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"

# sketchybar
if [[ "$(uname)" == "Darwin" ]]; then
  ln -sfn "$DOTFILES/sketchybar" "$XDG_CONFIG_HOME/sketchybar"
fi
