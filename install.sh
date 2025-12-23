#!/usr/bin/env bash
# shellcheck disable=SC2038

cd "$(dirname "$0")" || exit
SRC_DIR=$(pwd)

title() {
  echo ""
  gum style --trim --border=thick --padding="1 10" "$1"
  echo ""
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

cat <<EOD | xargs sudo pacman -S --noconfirm
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
sudo pacman -S --noconfirm

cat <<EOD | xargs yay -S --noconfirm
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
sudo ln -s /usr/bin/nvim /usr/bin/vi
sudo ln -s /usr/bin/nvim /usr/bin/vim

# Inkscape setup
mkdir -p ~/.config/inkscape/extensions >/dev/null 2>&1
cd ~/.config/inkscape/extensions >/dev/null 2>&1 || exit
wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.py" >/dev/null 2>&1
wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.inx" >/dev/null 2>&1
cd - >/dev/null 2>&1 || exit

# Set Firefox as Default browser
xdg-settings set default-web-browser firefox.desktop

# Firefox PWA
gum spin --padding="0 2" --title="Installing firefoxpwa runtime…" -- firefoxpwa runtime install
"$SRC_DIR/bin/.local/bin/firefox-webapp-install" ChatGPT https://chatgpt.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png
"$SRC_DIR/bin/.local/bin/firefox-webapp-install" WhatsApp https://web.whatsapp.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png

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
nvm install 20
nvm use 20

gum spin --padding="0 2" --show-error --title="Installing yarn…" -- npm install -g yarn
gum spin --padding="0 2" --show-error --title="Installing elm…" -- npm install -g elm elm-test elm-format elm-oracle @elm-tooling/elm-language-server
gum spin --padding="0 2" --show-error --title="Installing emmet…" -- npm install -g emmet-ls
gum spin --padding="0 2" --show-error --title="Installing eslint…" -- npm install -g @wordpress/eslint-plugin @typescript-eslint/eslint-plugin @typescript-eslint/parser
gum spin --padding="0 2" --show-error --title="Installing intelephense…" -- npm install -g intelephense
gum spin --padding="0 2" --show-error --title="Installing prettier…" -- npm install -g prettier@npm:wp-prettier@latest @wordpress/prettier-config
gum spin --padding="0 2" --show-error --title="Installing script helpers…" -- npm install -g glob lodash path
gum spin --padding="0 2" --show-error --title="Installing stylelint…" -- npm install -g stylelint @wordpress/stylelint-config
gum spin --padding="0 2" --show-error --title="Installing vscode langservers…" -- npm install -g vscode-langservers-extracted
gum spin --padding="0 2" --show-error --title="Installing WordPress scripts…" -- npm install -g @wordpress/scripts

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

/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)" -- -y
eval "$(/home/david/.lando/bin/lando shellenv)"

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
