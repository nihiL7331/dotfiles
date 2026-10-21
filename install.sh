#!/bin/sh
set -e

BASE_SRC="$(pwd)"
REPOS_DST="$HOME/repos"
CFG_DST="$HOME/.config"

link() {
    src="$1"
    dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "backing up: ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -sfn "$src" "$dst"
    echo "link: $dst -> $src"
}

# links to dst if dsts parent dir exists
link_if_exists() {
    src="$1"
    dst="$2"

    if [ ! -d "$(dirname "$dst")" ]; then
        echo "skipped: ${dst}"
        return 0
    fi

    link "$src" "$dst"
}

#    source                                         destination
# ---------------------------------------------------------------------------------zsh
link "$BASE_SRC/home/zshrc"                         "$HOME/.zshrc"
link "$BASE_SRC/home/zprofile"                      "$HOME/.zprofile"
# ---------------------------------------------------------------------------------git
link "$BASE_SRC/home/gitconfig"                     "$HOME/.gitconfig"
# ---------------------------------------------------------------------------------dwl(b)
link_if_exists "$BASE_SRC/dwl/startdwl.sh"          "$REPOS_DST/dwl/startdwl.sh"
link_if_exists "$BASE_SRC/dwl/config.h"             "$REPOS_DST/dwl/config.h"
link_if_exists "$BASE_SRC/dwl/dwl.c"                "$REPOS_DST/dwl/dwl.c"
link_if_exists "$BASE_SRC/dwlb/dwlb-status.sh"      "$REPOS_DST/dwlb/dwlb-status"
link_if_exists "$BASE_SRC/dwlb/config.h"            "$REPOS_DST/dwlb/config.h"
# ---------------------------------------------------------------------------------anyrun
link_if_exists "$BASE_SRC/anyrun/config.ron"        "$CFG_DST/anyrun/config.ron"
link_if_exists "$BASE_SRC/anyrun/style.css"         "$CFG_DST/anyrun/style.css"
# ---------------------------------------------------------------------------------kanshi
link_if_exists "$BASE_SRC/kanshi/config"            "$CFG_DST/kanshi/config"
# ---------------------------------------------------------------------------------nvim
link_if_exists "$BASE_SRC/nvim/init.lua"            "$CFG_DST/nvim/init.lua"
link_if_exists "$BASE_SRC/nvim/lazy-lock.json"      "$CFG_DST/nvim/lazy-lock.json"
# ---------------------------------------------------------------------------------pipewire
link_if_exists "$BASE_SRC/pipewire/pipewire.conf.d" "$CFG_DST/pipewire/pipewire.conf.d"
# ---------------------------------------------------------------------------------qutebrowser
link_if_exists "$BASE_SRC/qutebrowser/config.py"    "$CFG_DST/qutebrowser/config.py"
# ---------------------------------------------------------------------------------starship
link_if_exists "$BASE_SRC/starship/starship.toml"   "$CFG_DST/starship.toml"
