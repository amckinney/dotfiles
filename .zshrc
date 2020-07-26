# Exports
export ZSH="~/.oh-my-zsh"
export ZSH_THEME="avit"
export EDITOR='vim'

# Source
source $ZSH/oh-my-zsh.sh

# Aliases
alias zshconfig="mate ~/.zshrc"

# Find/replace function.
function fr () {
	rg -l "$1" | xargs perl -p -i -e "s#$1#$2#g"
}

# Misc
plugins=(git)

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
