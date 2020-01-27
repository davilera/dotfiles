#!/usr/bin/env bash

[[ "$TMUX" == "" ]] && TERM=screen-256color-bce tmux && exit

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=false

# -----------------------------------------------------------------------------------
# Add custom stuff
# -----------------------------------------------------------------------------------

PATH="./node_modules/.bin:./vendor/bin:~/Programs/bin:$PATH"

function bb {
	ddccontrol dev:/dev/i2c-7 -r 0x10 -w $1 >/dev/null 2>/dev/null
}

# fasd aliases
# ------------
eval "$(fasd --init auto)"
alias j="fasd_cd -d"

# NVM
# ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# aliases
# ------------
alias ccat="pygmentize -f terminal256 -O style=native -g"
alias colorize="ccze -A"
alias grep="grep --color --exclude-dir=vendor --exclude-dir=node_modules --exclude-dir=e2e-tests --exclude-dir=build --exclude-dir=dist --exclude-dir=build-module --exclude=*.min --exclude=*.min.* --exclude=*.md --exclude=*.map --exclude-dir=.git"
alias ls="ls --color --group-directories-first"
alias tree="tree -C"
alias eog="xviewer"
