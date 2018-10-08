[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PS1="\[\e[33m\]\s\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[36m\]\W\[\e[m\]\[\e[32m\]\`git_branch\`\[\e[m\]\\$ "

# Find/replace function.
function fr () {
	rg -l "$1" | xargs perl -p -i -e "s#$1#$2#g"
}

# Determines the current branch of a git repository.
function git_branch () {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		echo "[${BRANCH}]"
	else
		echo ""
	fi
}
