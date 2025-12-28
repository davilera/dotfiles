#!/usr/bin/env bash
# shellcheck disable=SC2038

cd "$(dirname "$0")" || exit
SRC_DIR=$(pwd)

title() {
  echo ""
  gum style --trim --bold --foreground=2 "$1"
}

subtitle() {
  echo ""
  gum style --trim --foreground=6 "$1"
}

# ========================================================
# ========================================================
title "BASICS"
# ========================================================
# ========================================================

# --------------------------------------------------------
subtitle "Updating pacman packages…"
# --------------------------------------------------------

sudo pacman -Syu

# --------------------------------------------------------
subtitle "Installing packages…"
# --------------------------------------------------------

cat <<EOD | xargs sudo pacman -S --needed --noconfirm
	aspell-ca
	aspell-es
	aws-cli-v2
	bat
	btop
	bun-bin
	cargo
	composer
	curl
	curl
	difftastic
	dysk
	filezilla
	firefox
	firefoxpwa
	gimp
	glow
	go
	hplip
	hunspell-es_any
	imagemagick
	inkscape
	jq
	kitty
	lsd
	luarocks
	meld
	npm
	nvm
	openssh
	pass
	perl-image-exiftool
	poedit
	prettyping
	python-markdown
	python-pip
	python3
	ruby
	stow
	subversion
	the_silver_searcher
	trash-cli
	tree
	wget
	yq
	zoxide
EOD

cat <<EOD | xargs yay -S --needed --noconfirm
	bc
	hunspell-ca
	zoom
EOD

# --------------------------------------------------------
subtitle "Configuring packages…"
# --------------------------------------------------------

# Bat setup
mkdir -p "$(bat --config-dir)/themes" >/dev/null 2>&1
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme >/dev/null 2>&1
bat cache --build >/dev/null 2>&1

# Markdown setup
cat <<EOF | sudo tee /usr/local/bin/markdown >/dev/null
#!/bin/sh
python -m markdown $@
EOF
sudo chmod a+x /usr/local/bin/markdown

# Meld setup
dconf load /org/gnome/meld/ <"${SRC_DIR}/dconf/meld.ini"

# SSHD setup
sudo sed -i "s/^# *Port 22/Port 22/" /etc/ssh/sshd_config
sudo systemctl enable sshd
sudo systemctl restart sshd

# Adding links for vi and nvim
[[ ! -e /usr/bin/vi ]] &&
  sudo ln -s /usr/bin/nvim /usr/bin/vi
[[ ! -e /usr/bin/vim ]] &&
  sudo ln -s /usr/bin/nvim /usr/bin/vim

# Inkscape setup
mkdir -p ~/.config/inkscape/extensions >/dev/null 2>&1
cd ~/.config/inkscape/extensions >/dev/null 2>&1 || exit
[[ ! -e applytransform.py ]] &&
  wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.py" >/dev/null 2>&1
[[ ! -e applytransform.inx ]] &&
  wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.inx" >/dev/null 2>&1
cd - >/dev/null 2>&1 || exit

# Set Firefox as Default browser
xdg-settings set default-web-browser firefox.desktop

# Firefox PWA
[[ ! -e "$HOME/.local/share/firefoxpwa/runtime/firefox" ]] &&
  gum spin --padding="0 2" --title="Installing firefoxpwa runtime…" -- firefoxpwa runtime install
"$SRC_DIR/bin/.local/bin/firefox-webapp-install" ChatGPT https://chatgpt.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png >/dev/null
"$SRC_DIR/bin/.local/bin/firefox-webapp-install" WhatsApp https://web.whatsapp.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png >/dev/null

# Pacman and Yay aliases
git clone https://github.com/davilera/pac ~/.local/share/archlinux-pac-aliases 2>/dev/null

# ========================================================
# ========================================================
title "DEVELOPMENT"
# ========================================================
# ========================================================

# --------------------------------------------------------
subtitle "Installing global npm deps…"
# --------------------------------------------------------

source /usr/share/nvm/init-nvm.sh
nvm install 20.19.6

NVM_DIR="$HOME/.nvm/versions/node/v20.19.6/lib/node_modules"
npm_install() {
  for name in "$@"; do
    dirname="$(echo "$name" | sed -e "s/\([^@]\)@.*$/\1/")"
    if [[ ! -d "$NVM_DIR/$dirname" ]]; then
      label="$(printf "%s, " "$@" | sed -e "s/, $//" | sed -e "s/, \([^,]\+\)$/, and \1/")"
      gum spin --padding="0 2" --show-error --title="Installing ${label}…" -- npm install -g "$@"
      return
    fi
  done
}

npm_install yarn
npm_install @wordpress/eslint-plugin @typescript-eslint/eslint-plugin @typescript-eslint/parser
npm_install @wordpress/scripts
npm_install elm elm-test elm-format elm-oracle @elm-tooling/elm-language-server
npm_install emmet-ls
npm_install glob lodash path
npm_install intelephense
npm_install prettier@npm:wp-prettier@latest @wordpress/prettier-config
npm_install stylelint @wordpress/stylelint-config
npm_install vscode-langservers-extracted

# --------------------------------------------------------
subtitle "Installing composer deps…"
# --------------------------------------------------------

cd "$SRC_DIR" 2>/dev/null || exit
stow --no-folding composer >/dev/null 2>&1
composer global install >/dev/null 2>&1
cd - 2>/dev/null || exit

# --------------------------------------------------------
subtitle "Installing Lando…"
# --------------------------------------------------------

if [[ ! -x "$HOME/.lando/bin/lando" ]]; then
  /bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)" -- -y
  eval "$(/home/david/.lando/bin/lando shellenv)"
fi

# ========================================================
# ========================================================
title "CUSTOMIZE SETUP"
# ========================================================
# ========================================================

# --------------------------------------------------------
subtitle "Stowing dotfiles…"
# --------------------------------------------------------

cd "$SRC_DIR" 2>/dev/null || exit

stow --no-folding bin

rm -rf ~/.git 2>/dev/null
stow --no-folding git

rm -rf ~/.config/hypr 2>/dev/null
stow hypr

rm -rf ~/.config/kitty 2>/dev/null
stow kitty

stow meld

rm -rf ~/.config/nvim ~/.local/share/nvim 2>/dev/null
stow nvim

rm -rf ~/.bash* 2>/dev/null
stow --no-folding shell

rm -rf ~/.config/php 2>/dev/null
stow tooling-config

stow --no-folding trash
systemctl --user enable empty-trash.timer
systemctl --user start empty-trash.timer

rm -rf ~/.config/uwsm 2>/dev/null
stow uwsm

rm -rf ~/.config/waybar 2>/dev/null
stow waybar

cd - 2>/dev/null || exit

# --------------------------------------------------------
subtitle "Customizing Omarchy…"
# --------------------------------------------------------

if [ "$(~/.local/share/omarchy/bin/omarchy-theme-current)" != "Catppuccin" ]; then
  yes n | ~/.local/share/omarchy/bin/omarchy-theme-set catppuccin
fi
yes n | ~/.local/share/omarchy/bin/omarchy-install-terminal kitty
