# Load tmux first.
[[ "$TMUX" == "" ]] && TERM=screen-256color-bce tmux && exit

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# [[ "$TMUX" == "" ]] && TERM=screen-256color-bce tmux && exit

# Don't check mail when opening terminal.
unset MAILCHECK

# Configure oh-my-zsh
ZSH_THEME="aphrodite/aphrodite"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
plugins=(
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source ~/.shellrc
