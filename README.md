# dotfiles

A repository consisting of a automated pipeline for setting up my dotfiles.

## Requirements

- `git` (for downloading `nvim` repositories),
- `stow` (for symlinking),
- `python3` (for the theme controller).

## Usage

1. Clone the repository

```bash
git clone https://github.com/nihiL7331/dotfiles.git
cd ~/dotfiles
```

2. Symlink the config files

```bash
stow nvim ghostty sketchybar
```

3. Run the theme controller to deploy a theme

```bash
python3 load_theme.py <theme> [apps]
# theme available options: 
# - melange
# - catppuccin-mocha
# - catppuccin-macchiato
# - kanagawa-dragon
# - kanagawa-wave
# - rose-pine
# - rose-pine-moon
# apps available options (,-separated, default: all):
# - nvim
# - ghostty
# - sketchybar
```

## How it works (load_theme.py)

- `nvim`
    - Checks if an official Git repository is provided.
    - If it is, then it clones it into `nvim`.
    - If not, then it generates a native Lua colorscheme fallback based off of `defaults`.
- `ghostty`
    - Checks if an URL to a raw theme configuration is provided.
    - If it is, then it downloads it.
    - If not, then it generates a 16-color ANSI fallback.
- `sketchybar`
    - Generates a `colors.sh` file with exported ARGB variables.
    - Reloads the bar.

## Roadmap

- [x] Use `argparse` for parsing arguments.
- [x] Add `--apps` flag to `load_theme.py`
- [ ] Add `waybar` support.
- [ ] Add `tmux` configuration.
- [ ] Add servers to `nvim` config.
- [ ] Make using `stow` easier (nest to make `stow *` possible?).
- [ ] Add more themes for testing.
- [ ] Add bootstrap script.
