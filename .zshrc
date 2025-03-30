eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias vim="nvim"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias l='ls -al'

export PATH="$HOME/.moon/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NODE_OPTIONS=--max-old-space-size=16384
export CANVAS_SKETCH_OUTPUT="sketch_export"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(cat {} || tree -C {}) 2> /dev/null | head -$LINES'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden --bind ?:toggle-preview"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -$LINES'"

export SHORT_HOST="${HOST/.*/}"

if [ $(ps ax | grep "[s]sh-agent" | wc -l) -eq 0 ] ; then
    eval $(ssh-agent -s) > /dev/null
    if [ "$(ssh-add -l)" = "The agent has no identities." ] ; then
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 > /dev/null 2>&1
    fi
fi

# sst
export PATH=/Users/ryanstruhl/.sst/bin:$PATH
