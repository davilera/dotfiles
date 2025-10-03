#!/usr/bin/bash
# shellcheck disable=SC2038

cd "$(dirname "$0")"
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

############
title "INIT"
############

subtitle "Updating pacman packages…"
sudo pacman -Syu

subtitle "Installing basic stuff…"
sudo pacman -S --noconfirm curl git vim kitty thefuck hplip trash-cli wget

##############
title "SYSTEM"
##############

subtitle "Installing dev packages…"
sudo pacman -S --noconfirm stow zoxide tree meld jq ruby subversion composer curl python3 python-pip go cargo luarocks prettyping lsd

subtitle "Installing utilities…"
sudo pacman -S --noconfirm filezilla btop imagemagick poedit hunspell-es_any aspell-ca aspell-es the_silver_searcher difftastic aws-cli-v2 perl-image-exiftool
yay -S --noconfirm hunspell-ca

sudo pacman -S --noconfirm python-markdown
cat <<EOF | sudo tee /usr/local/bin/markdown >/dev/null
#!/bin/sh
python -m markdown $@
EOF
sudo chmod a+x /usr/local/bin/markdown

subtitle "Installing openssh…"
sudo pacman -S --noconfirm openssh
sudo sed -i "s/^# *Port 22/Port 22/" /etc/ssh/sshd_config
sudo systemctl enable sshd
sudo systemctl restart sshd

subtitle "Installing nvm, npm, node, bun…"
sudo pacman -S --noconfirm nvm npm bun-bin
source /usr/share/nvm/init-nvm.sh
nvm install 20
nvm use 20

subtitle "Installing global npm deps…"
gum spin --padding="0 2" --title="Installing yarn…" -- npm install -g yarn
gum spin --padding="0 2" --title="Installing elm…" -- npm install -g elm elm-test elm-format elm-oracle @elm-tooling/elm-language-server
gum spin --padding="0 2" --title="Installing emmet…" -- npm install -g emmet-ls
gum spin --padding="0 2" --title="Installing eslint…" -- npm install -g @wordpress/eslint-plugin @typescript-eslint/eslint-plugin @typescript-eslint/parser
gum spin --padding="0 2" --title="Installing intelephense…" -- npm install -g intelephense
gum spin --padding="0 2" --title="Installing prettier…" -- npm install -g prettier@npm:wp-prettier@latest @wordpress/prettier-config
gum spin --padding="0 2" --title="Installing script helpers…" -- npm install -g glob lodash path >/dev/null 2>&1
gum spin --padding="0 2" --title="Installing stylelint…" -- npm install -g stylelint @wordpress/stylelint-config >/dev/null 2>&1
gum spin --padding="0 2" --title="Installing vscode langservers…" -- npm install -g vscode-langservers-extracted

subtitle "Installing composer deps…"
cd "$SRC_DIR" 2>/dev/null
stow --no-folding composer >/dev/null 2>&1
composer global install >/dev/null 2>&1
cd - 2>/dev/null

subtitle "Installing apps…"
sudo pacman -S --noconfirm inkscape gimp
yay -S --noconfirm zoom

subtitle "Configuring inkscape…"
mkdir -p ~/.config/inkscape/extensions >/dev/null 2>&1
cd ~/.config/inkscape/extensions >/dev/null 2>&1
wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.py" >/dev/null 2>&1
wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.inx" >/dev/null 2>&1
cd - >/dev/null 2>&1

subtitle "Installing Firefox…"
sudo pacman -Syy
sudo pacman -S --noconfirm firefox firefoxpwa

subtitle "Installing firefoxpwa’s runtime…"
firefoxpwa runtime install

subtitle "Installing WhatsApp webapp…"
if [ "$(firefoxpwa profile list | grep -c whatsapp.web)" -eq 0 ]; then
  profile="$(firefoxpwa profile create | grep "Profile created" | sed -e "s/.*Profile created: //")"
  firefoxpwa site install https://web.whatsapp.com/data/manifest.json --profile "$profile"
fi

subtitle "Installing Lando…"
/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"
eval "$(/home/david/.lando/bin/lando shellenv)"

#############################
title "UTILITIES FROM GITHUB"
#############################

# TODO. View how to integrate with Omarchy.
# echo "Installing greenclip…"
# sudo pacman -S --noconfirm rofi-greenclip

# TODO. Review how to use colorscheme from Omarchy theme.
subtitle "Configuring bat…"
mkdir -p "$(bat --config-dir)/themes" >/dev/null 2>&1
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme >/dev/null 2>&1
bat cache --build >/dev/null 2>&1

#####################
title "INIT DOTFILES"
#####################

subtitle "Stowing dotfiles…"
mkdir -p ~/.local/bin 2>/dev/null
cd "$SRC_DIR" 2>/dev/null

if gum confirm "Do you want to stow git config?"; then
  rm -rf ~/.git 2>/dev/null
  stow --no-folding git
fi

rm -rf ~/.bash* 2>/dev/null
stow --no-folding shell

find desktop/.config -mindepth 1 -maxdepth 1 | xargs -n1 basename | while read -r file; do
  rm -rf "$HOME/.config/$file" 2>/dev/null
done
stow desktop

rm -rf ~/.config/nvim 2>/dev/null
stow nvim

stow --no-folding programs
systemctl --user enable empty-trash.timer
systemctl --user start empty-trash.timer

stow tooling-config

cd - 2>/dev/null

#############################S"
title "LOAD ADDITIONAL CONFIGS"
#############################S"

if [ "$(~/.local/share/omarchy/bin/omarchy-theme-current)" != "Catppuccin" ]; then
  yes n | ~/.local/share/omarchy/bin/omarchy-theme-set catppuccin
fi
yes n | ~/.local/share/omarchy/bin/omarchy-install-terminal kitty
dconf load /org/gnome/meld/ <"${SRC_DIR}/dconf/meld.ini"
xdg-settings set default-web-browser firefox.desktop

echo -e "\e[32mDone! Enjoy your new life, David.\e[0m"
gum confirm "Relaunch Hyprland to use new settings?" && uwsm stop
