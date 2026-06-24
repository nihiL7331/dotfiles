import json
import os
import shutil
import subprocess

DOTFILES = os.path.dirname(os.path.abspath(__file__))

with open(os.path.join(DOTFILES, 'theme.json')) as f:
    theme = json.load(f)

def rgb2argb_pfd(col_str):
    return f"0xff{col_str.replace('#', ' ')}"

# ghostty setup
if shutil.which("ghostty"):


# sketchybar setup
if shutil.which("sketchybar"):
    subprocess.run(['sketchybar', '--reload'])
