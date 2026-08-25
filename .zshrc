export LANG=en_US.UTF-8
export EDITOR='vim'

# --- PATH
export PATH=$PATH:/Users/ryanstruhl/.local/bin

# --- Docker config
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# --- ZSH plugin loading
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Tool init
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"

# --- FZF setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias vim=nvim
alias aws-login='aws sso login --profile sso-base'

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# pnpm
export PNPM_HOME="/Users/ryanstruhl/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
