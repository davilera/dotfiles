# shellcheck source=/dev/null

# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Basic settings
# --------------
unset MAILCHECK
export BUN_INSTALL="$HOME/.bun"
export PATH="./node_modules/.bin:$BUN_INSTALL/bin:./vendor/bin:$HOME/.config/composer/vendor/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.lando/bin:$PATH:/usr/bin/vendor_perl"
export GPG_TTY=$(tty)
export PHP_INI_SCAN_DIR="$PHP_INI_SCAN_DIR:$HOME/.config/php/conf.d" # layer yours last

# Faster navigation
# -----------------
eval "$(zoxide init --cmd j bash)"
alias cd="j"
alias ji="zoxide query -i"
alias za="zoxide add"
alias zq="zoxide query"
alias zr="zoxide remove"

# Kitty
# -----
alias kitty="LIBGL_ALWAYS_SOFTWARE=true GALLIUM_DRIVER=llvmpipe kitty"

# NVM
# ---
export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# nvm use 20 is too slow. Use this instead (with --no-use):
PATH="${NVM_DIR}/versions/node/v20.19.4/bin:${PATH}"

# Haskell
# ------------
[ -f "/Users/david/.ghcup/env" ] && source "/Users/david/.ghcup/env"

# Aliases
# ------------
function aws() {
  AWS_ACCESS_KEY_ID=$(pass show aws/access_id) AWS_SECRET_ACCESS_KEY=$(pass show aws/access_token) command aws "$@"
}

function cat() {
  if [[ "$#" -eq 1 ]] && [ "$TERM" = 'xterm-kitty' ] && [[ "$(file "$1" | command grep -ci "image data")" -eq 1 ]]; then
    local aux
    aux="$(mktemp)"
    magick "$1" -resize "480x320>" -gravity center "$aux"
    kitten icat --align=left "$aux"
    identify "$1"
    rm "$aux"
  elif [[ "$#" -eq 1 ]]; then
    if [ "$1" == "readme.txt" ] || [[ "$1" == *.md ]] || [[ "$1" == *.markdown ]]; then
      local aux
      aux="$(mktemp --suffix=.md)"
      cp "$1" "$aux"
      glow -s tokyo-night --pager "$aux"
      rm "$aux"
    else
      bat --tabs 2 "$1"
    fi
  else
    bat --tabs 2 "$@"
  fi
}

function take() {
  mkdir -p "$1"
  cd "$1" || exit 0
}

function trim() {
  awk "{\$1=\$1;print}" "$@"
}

alias s="source ~/.bashrc"
alias ag="ag --noheading --nobreak --ignore node_modules --ignore vendor --ignore e2e-tests --ignore build --ignore dist --ignore build-module --ignore .lando"
alias df="dysk"
alias hl="ag --passthru"
alias htop="btop"
alias kz="killall -9 zoom"
alias ping="prettyping --nolegend"
alias pip="pip3"
alias rm="trash"
alias serve="python3 -m http.server"
alias sl="ls"
alias td="ag todo.david"
alias tl="trash-list"
alias top="btop"
alias tree="lsd --group-dirs=first --tree"
alias vi="nvim"
alias vim="nvim"

# Git aliases
[ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git
alias ga="git add"
__git_complete ga _git_add
alias gb="git blame"
alias gc="git commit"
__git_complete gc _git_commit
alias gco="git checkout"
__git_complete gco _git_checkout
alias gd="git -c diff.external=difft diff"
alias gg="git pull --rebase"
__git_complete gg _git_pull
alias gm="git pull"
__git_complete gm _git_pull
alias gundo="git rebase --abort"
alias gp="git push"
__git_complete gp _git_push
alias gs="git status"
__git_complete gs _git_status
alias gl="git log"
__git_complete gl _git_log
alias lg="lazygit"
alias lz="lazygit"

# System aliases
alias pacs='pacman -Ss'       # Search for package or packages in the repositories
alias pacu='sudo pacman -Syu' # Update the system and upgrade all system packages.
alias paci='sudo pacman -S'   # Install a specific package from repos added to the system
alias pacr='sudo pacman -Rns' # Remove package, its configuration and all unwanted dependencies
alias pach='pacman -Si'       # Help information about a given package located in the repositories

alias yays='yay -Ss'   # Search for package or packages in the repositories
alias yayu='yay -Syua' # Synchronize with repositories and upgrade packages, including AUR packages.
alias yayi='yay -S'    # Install a specific package from repos added to the system
alias yayil='yay -U'   # Install specific package that has been downloaded to the local system
alias yayr='yay -Rns'  # Remove package or packages , its configuration and all unwanted dependencies
alias yayh='yay -Si'   # Display information about a given package located in the repositories
alias yayhl='yay -Qi'  # Display information about a given package in the local database
alias yayro='yay -Qtd' # Remove orphans using yay
