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
alias za="zoxide add"
alias zq="zoxide query"
alias zqi="zoxide query -i"
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

# Brew
# ----
if [ -d /home/linuxbrew/.linuxbew ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Haskell
# ------------
[ -f "/Users/david/.ghcup/env" ] && source "/Users/david/.ghcup/env"

# Aliases
# ------------
function take() {
  mkdir -p $1
  cd $1
}

alias s="source ~/.bashrc"
alias cat="bat --tabs 2"
alias colorize="ccze -A"
alias df="dysk"
alias grep="ag --noheading --nobreak --ignore node_modules --ignore vendor --ignore e2e-tests --ignore build --ignore dist --ignore build-module --ignore .lando"
alias htop="btop"
alias mdcat="bat -l markdown --tabs 2 --theme='Catppuccin Mocha'"
alias rm="trash"
alias serve="python3 -m http.server"
alias td="grep -r todo.david"
alias tl="trash-list"
alias top="btop"
alias tree="lsd --group-dirs=first --tree"
alias trim="awk '{\$1=\$1;print}'"
alias vi="nvim"
alias vim="nvim"

alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gd="git -c diff.external=difft diff"
alias gg="git pull --rebase"
alias gm="git pull"
alias gundo="git rebase --abort"
alias gp="git push"
alias gs="git status"
alias gl="git blame"
alias lg="lazygit"
alias lz="lazygit"

alias aws="AWS_ACCESS_KEY_ID=$(pass show aws/access_id) AWS_SECRET_ACCESS_KEY=$(pass show aws/access_token) aws"

alias ping="prettyping --nolegend"
alias pip="pip3"

if [ -d "/Users" ]; then
  export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
  alias ls="ls -G"
  alias eog="open -a Firefox"
else
  alias ls="lsd --group-dirs=first"
  alias eog="xviewer"
fi

if [ "$TERM" = 'xterm-kitty' ]; then
  alias eog="kitty +kitten icat"
  alias icat="kitty +kitten icat"
fi

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
