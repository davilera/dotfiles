# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Don't check mail when opening terminal.
unset MAILCHECK

# Configure oh-my-zsh
ZSH_THEME="aphrodite/aphrodite"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
plugins=(
	thefuck
	yarn
	zsh-syntax-highlighting
)

if [ -d "/Users" ]
then
	ZSH_DISABLE_COMPFIX=true
fi

# Set custom window title
DISABLE_AUTO_TITLE="true"
function basepwd() {
	if [ "${PWD}" = "${HOME}" ];
	then
		echo "~"
	else
		echo `basename ${PWD}`
	fi
}

function preexec() {
	name=`basepwd`
	cmd=`echo "$1" | awk '{ print $1 }'`
	echo -ne "\033]0;${cmd} (${name})\007"
}

function precmd() {
	name=`basepwd`
	echo -ne "\033]0;${name}\007"
}

# Completion for kitty
autoload -Uz compinit
compinit
[ -x kitty ] && kitty + complete setup zsh | source /dev/stdin

# Load customizations
source $ZSH/oh-my-zsh.sh
source ~/.shellrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/home/david/.bun/_bun" ] && source "/home/david/.bun/_bun"

# Make sure node_modules/.bin is the first option
export PATH="./node_modules/.bin:$PATH"
