# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Don't check mail when opening terminal.
unset MAILCHECK

# Configure oh-my-zsh
ZSH_THEME="aphrodite/aphrodite"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
plugins=(
	zsh-syntax-highlighting
)

if [ -d "/Users" ]
then
	ZSH_DISABLE_COMPFIX=true
fi

# Completion for kitty
autoload -Uz compinit
compinit
kitty + complete setup zsh | source /dev/stdin

# Load customizations
source $ZSH/oh-my-zsh.sh
source ~/.shellrc
