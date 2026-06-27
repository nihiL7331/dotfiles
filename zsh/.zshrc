# env

export XDG_CONFIG_HOME="$HOME/.config"
export LANG=en_US.UTF-8

if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi
export SUDO_EDITOR='nvim'

# path

export PATH="$HOME/.local/bin:$PATH"    # pipx / user tools
export PATH="$HOME/.cargo/bin:$PATH"    # rust
export PATH="$PATH:$HOME/.dotnet/tools" # C#
export PATH="$PATH:/usr/local/go/bin"   # go

if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
  export PATH="$PATH:/opt/homebrew/bin"
  export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
  export DOTNET_ROOT_ARM64="/opt/homebrew/opt/dotnet/libexec"
fi

# history

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt share_history      # share across sessions
setopt hist_ignore_dups   # dont record immediate duplicates
setopt hist_ignore_space  # skip commands starting with a space
setopt hist_verify        # show expansion before running
setopt extended_history   # timestamp entries
setopt inc_append_history # write as you go

# completion

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive

# plugins

ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
eval "$(starship init zsh)"

# tool initialization

export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm >/dev/null; node "$@"; }
npm()  { nvm >/dev/null; npm "$@"; }
npx()  { nvm >/dev/null; npx "$@"; }

eval "$(rbenv init - zsh)"

[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" &>/dev/null

# tmux

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t ghostty 2>/dev/null || tmux new-session -s ghostty
fi

if [[ -n "$TMUX" ]]; then
  autoload -Uz add-zsh-hook
  tmux-rename-window() {
    tmux rename-window "$(basename "$PWD")";
  }
  add-zsh-hook precmd tmux-rename-window
fi

# syntax highlighting (keep last)

source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
