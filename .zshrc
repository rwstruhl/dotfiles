export LANG=en_US.UTF-8
export EDITOR='vim'

# --- PATH
export PATH=$PATH:/Users/ryanstruhl/.local/bin

# --- ZSH plugin loading
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Tool init
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"

# --- FZF setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


