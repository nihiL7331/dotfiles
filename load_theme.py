import json
import sys
import os
import shutil
import subprocess
import urllib.request
import urllib.error

if len(sys.argv) != 2:
    print("Usage: python3 load_theme.py <theme.json>")
    exit(1)

DOTFILES = os.path.dirname(os.path.abspath(__file__))

with open(os.path.join(DOTFILES, sys.argv[1])) as f:
    theme = json.load(f)

theme_name = theme["name"]

# ghostty setup
if shutil.which("ghostty"):
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
if shutil.which("nvim"):
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
if shutil.which("sketchybar"):
    subprocess.run(['sketchybar', '--reload'])
