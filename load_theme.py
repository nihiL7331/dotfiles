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


# sketchybar setup
if shutil.which("sketchybar"):
    subprocess.run(['sketchybar', '--reload'])
