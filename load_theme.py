import json
import os
import shutil
import subprocess
import urllib.request
import urllib.error
import argparse

parser = argparse.ArgumentParser(prog="load_theme")
parser.add_argument("theme", type=str, help="Name of the theme to load (e.g. melange)")
parser.add_argument("-a", "--apps", type=str, help="Comma-separated apps to target")
args = parser.parse_args()

if args.apps:
    target_apps = [app.strip().lower() for app in args.apps.split(",")]
else:
    target_apps = None

DOTFILES = os.path.dirname(os.path.abspath(__file__))

with open(os.path.join(DOTFILES, f"{args.theme}.json")) as f:
    theme = json.load(f)

theme_name = theme["name"]

# ghostty setup
if (not target_apps or "ghostty" in target_apps) and shutil.which("ghostty"):
    ghostty_path = os.path.join(
        DOTFILES, "ghostty", ".config", "ghostty", "themes", "current"
    )
    os.makedirs(os.path.dirname(ghostty_path), exist_ok=True)

    ghostty_target = theme.get("ghostty")

    if ghostty_target and ghostty_target.startswith("http"):
        try:
            urllib.request.urlretrieve(ghostty_target, ghostty_path)
        except urllib.error.URLError as e:
            print(f"Download failed for Ghostty theme: {e}")
            ghostty_target = None

    if not ghostty_target or not ghostty_target.startswith("http"):
        defaults = theme.get("defaults", {})

        ghostty_data = [
            f"palette = 0={defaults['a']['bg']}",
            f"palette = 1={defaults['c']['red']}",
            f"palette = 2={defaults['c']['green']}",
            f"palette = 3={defaults['c']['yellow']}",
            f"palette = 4={defaults['c']['blue']}",
            f"palette = 5={defaults['c']['magenta']}",
            f"palette = 6={defaults['c']['cyan']}",
            f"palette = 7={defaults['a']['ui']}",
            f"palette = 8={defaults['a']['float']}",
            f"palette = 9={defaults['b']['red']}",
            f"palette = 10={defaults['b']['green']}",
            f"palette = 11={defaults['b']['yellow']}",
            f"palette = 12={defaults['b']['blue']}",
            f"palette = 13={defaults['b']['magenta']}",
            f"palette = 14={defaults['b']['cyan']}",
            f"palette = 15={defaults['a']['fg']}",
            f"background = {defaults['a']['bg']}",
            f"foreground = {defaults['a']['fg']}",
            f"cursor-color = {defaults['a']['com']}",
            f"selection-background = {defaults['a']['sel']}",
        ]

        with open(ghostty_path, "w") as f:
            f.write("\n".join(ghostty_data))

# nvim setup
if (not target_apps or "nvim" in target_apps) and shutil.which("nvim"):
    state_path = os.path.join(
        DOTFILES, "nvim", ".config", "nvim", "lua", "core", "current_theme.lua"
    )
    os.makedirs(os.path.dirname(state_path), exist_ok=True)

    nvim_target = theme.get("nvim")

    if nvim_target and "/" in nvim_target:
        pack_dir = os.path.expanduser("~/.local/share/nvim/site/pack/themes/start")
        repo_name = nvim_target.split("/")[-1]
        clone_path = os.path.join(pack_dir, repo_name)

        if not os.path.exists(clone_path):
            os.makedirs(pack_dir, exist_ok=True)
            subprocess.run(
                [
                    "git",
                    "clone",
                    "--depth",
                    "1",
                    f"https://github.com/{nvim_target}",
                    clone_path,
                ],
                check=True,
            )

        with open(state_path, "w") as f:
            f.write(f"return '{theme_name}'")

    else:
        colors_dir = os.path.join(DOTFILES, "nvim", ".config", "nvim", "colors")
        os.makedirs(colors_dir, exist_ok=True)
        fallback_path = os.path.join(colors_dir, f"{theme_name}.lua")

        defaults = theme["defaults"]

        nvim_data = [
            "vim.cmd('highlight clear')",
            "if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end",
            "vim.o.termguicolors = true",
            f"vim.g.colors_name = '{theme_name}'",
            "local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end",
        ]

        ui_mappings = {
            "Normal": f"{{ fg = '{defaults['a']['fg']}', bg = '{defaults['a']['bg']}' }}",
            "LineNr": f"{{ fg = '{defaults['a']['ui']}' }}",
            "CursorLineNr": f"{{ fg = '{defaults['a']['com']}', bold = true }}",
            "Visual": f"{{ bg = '{defaults['a']['sel']}' }}",
            "FloatBorder": f"{{ fg = '{defaults['a']['ui']}', bg = '{defaults['a']['float']}' }}",
            "NormalFloat": f"{{ bg = '{defaults['a']['float']}' }}",
            "Comment": f"{{ fg = '{defaults['a']['com']}', italic = true }}",
        }
        for group, opts in ui_mappings.items():
            nvim_data.append(f"hl('{group}', {opts})")

        syntax_mappings = {
            "String": f"{{ fg = '{defaults['b']['green']}' }}",
            "Function": f"{{ fg = '{defaults['b']['blue']}' }}",
            "Keyword": f"{{ fg = '{defaults['b']['magenta']}' }}",
            "Type": f"{{ fg = '{defaults['b']['yellow']}' }}",
            "Number": f"{{ fg = '{defaults['b']['magenta']}' }}",
            "Constant": f"{{ fg = '{defaults['b']['cyan']}' }}",
            "Variable": f"{{ fg = '{defaults['a']['fg']}' }}",
            "@variable": f"{{ fg = '{defaults['a']['fg']}' }}",
            "@variable.parameter": f"{{ fg = '{defaults['c']['blue']}' }}",
            "@property": f"{{ fg = '{defaults['c']['cyan']}' }}",
            "ErrorMsg": f"{{ fg = '{defaults['b']['red']}', bg = '{defaults['d']['red']}' }}",
        }
        for group, opts in syntax_mappings.items():
            nvim_data.append(f"hl('{group}', {opts})")

        with open(fallback_path, "w") as f:
            f.write("\n".join(nvim_data))

        with open(state_path, "w") as f:
            f.write(f"return '{theme_name}'")


# sketchybar setup
if (not target_apps or "sketchybar" in target_apps) and shutil.which("sketchybar"):
    sketchybar_path = os.path.join(
        DOTFILES, "sketchybar", ".config", "sketchybar", "colors.sh"
    )
    os.makedirs(os.path.dirname(sketchybar_path), exist_ok=True)

    sketchybar_target = theme.get("sketchybar")

    def to_argb(hex_color):
        return f"0xff{hex_color.replace('#', '')}"

    if sketchybar_target and sketchybar_target.startswith("http"):
        try:
            urllib.request.urlretrieve(sketchybar_target, sketchybar_path)
        except urllib.error.URLError as e:
            print(f"Failed to download sketchybar theme: {e}")
            sketchybar_target = None

    if not sketchybar_target or not sketchybar_target.startswith("http"):
        defaults = theme.get("defaults", {})
        a = defaults.get("a", {})
        b = defaults.get("b", {})

        sketchybar_data = [
            "#!/usr/bin/env bash",
            f"export BG={to_argb(a.get('bg', '#000000'))}",
            f"export FG={to_argb(a.get('fg', '#FFFFFF'))}",
            f"export UI={to_argb(a.get('ui', '#888888'))}",
            f"export SEL={to_argb(a.get('sel', '#444444'))}",
            f"export RED={to_argb(b.get('red', '#FF0000'))}",
            f"export GREEN={to_argb(b.get('green', '#00FF00'))}",
            f"export YELLOW={to_argb(b.get('yellow', '#FFFF00'))}",
            f"export BLUE={to_argb(b.get('blue', '#0000FF'))}",
            f"export MAGENTA={to_argb(b.get('magenta', '#FF00FF'))}",
            f"export CYAN={to_argb(b.get('cyan', '#00FFFF'))}",
        ]

        with open(sketchybar_path, "w") as f:
            f.write("\n".join(sketchybar_data))

    subprocess.run(["sketchybar", "--reload"], check=True)

# tmux setup
if (not target_apps or "tmux" in target_apps) and shutil.which("tmux"):
    tmux_path = os.path.join(DOTFILES, "tmux", ".config", "tmux", "theme.conf")
    os.makedirs(os.path.dirname(tmux_path), exist_ok=True)

    defaults = theme.get("defaults", {})
    a = defaults.get("a", {})
    b = defaults.get("b", {})

    bg = a.get("bg", "#000000")
    fg = a.get("fg", "#FFFFFF")
    com = a.get("com", "#888888")
    ui = a.get("ui", "#444444")
    accent = b.get("blue", "#0000FF")

    tmux_data = [
        f"set -g status-style 'fg={fg} bg={bg}'",
        f"setw -g window-status-current-style 'fg={bg} bg={accent} nobold'",
        "setw -g window-status-current-format ' #I #W '",
        f"setw -g window-status-style 'fg={com} bg={bg}'",
        f"setw -g window-status-format ' #I #[fg={fg}]#W '",
        f"set -g pane-border-style 'fg={ui}'",
        f"set -g pane-active-border-style 'fg={accent}'",
    ]

    with open(tmux_path, "w") as f:
        f.write("\n".join(tmux_data))

    subprocess.run(
        ["tmux", "has-session"],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    subprocess.run(
        ["tmux", "source-file", os.path.expanduser("~/.config/tmux/tmux.conf")],
        check=True,
    )
