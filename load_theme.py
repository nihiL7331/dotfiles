import json
import sys
import os
import shutil
import subprocess

if len(sys.argv) != 2:
    print("Usage: python3 load_theme.py <theme.json>")
    exit(1)

DOTFILES = os.path.dirname(os.path.abspath(__file__))

with open(os.path.join(DOTFILES, sys.argv[1])) as f:
    theme = json.load(f)

def rgb2argb_pfd(col_str):
    return f"0xff{col_str.replace('#', ' ')}"

# ghostty setup
if shutil.which("ghostty"):
    ghostty_data = []

    for key, hex_val in theme['base'].items():
        ghostty_data.append(f"{key} = {hex_val}")

    for index, hex_val in enumerate(theme["palette"]):
        ghostty_data.append(f"palette = {index}={hex_val}")

    ghostty_out = "\n".join(ghostty_data)

    ghostty_path = os.path.join(DOTFILES, 'ghostty', '.config', 'ghostty', 'themes', 'current')
    os.makedirs(os.path.dirname(ghostty_path), exist_ok=True)
    with open(ghostty_path, 'w') as f:
        f.write(ghostty_out)

# sketchybar setup
if shutil.which("sketchybar"):
    subprocess.run(['sketchybar', '--reload'])
