export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'

# --- History
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
# SHARE_HISTORY makes up-arrow see commands from concurrent panes (herdr).
# Drop it if cross-pane interleaving gets annoying.
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS EXTENDED_HISTORY

# --- Completion
# herdr's completion function lives here; regenerate after herdr updates with:
#   herdr completion zsh > ~/.zsh/completions/_herdr
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
# Case-insensitive, then substring matching as you keep typing
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# --- PATH
export PATH=$PATH:$HOME/.local/bin:$(brew --prefix rustup)/bin

# --- Docker config
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# --- Tool init
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"

# --- FZF setup: ctrl-r history search, ctrl-t file finder, alt-c cd
if command -v fzf >/dev/null 2>&1; then source <(fzf --zsh); fi

alias vim=nvim
alias aws-login='aws sso login --profile sso-base'

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# NetHack on herdr: herdr's direct pane pty feeds nethack a phantom quit at
# startup (instant, silent, exit 0 — the title screen flashes by on the
# alt-screen). A nested pty is immune, so wrap it only inside herdr.
# Inert outside herdr; revisit if a herdr update fixes the input path.
nethack() {
  if [[ "$HERDR_ENV" == "1" ]]; then
    script -q /dev/null "$(whence -p nethack)" "$@"
  else
    command nethack "$@"
  fi
}

# --- ZSH plugins (syntax-highlighting must be sourced last)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^A' beginning-of-line
