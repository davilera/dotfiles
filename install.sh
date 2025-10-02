#!/usr/bin/bash

cd "$(dirname "$0")"
SRC_DIR=$(pwd)

echo "Updating pacman packages…"
sudo pacman -Syu

echo "Installing basic stuff…"
sudo pacman -S --noconfirm curl git vim kitty thefuck hplip

echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Installing dev packages…"
sudo pacman -S --noconfirm stow zoxide tree meld jq ruby subversion composer curl python3 python-pip go cargo luarocks prettyping lsd

echo "Installing utilities…"
sudo pacman -S --noconfirm filezilla btop imagemagick poedit hunspell-es_any aspell-ca aspell-es the_silver_searcher difftastic aws-cli-v2 perl-image-exiftool
yay -S --noconfirm hunspell-ca

sudo pacman -S --noconfirm python-markdown
cat <<EOF | sudo tee /usr/local/bin/markdown >/dev/null
#!/bin/sh
python -m markdown $@
EOF
sudo chmod a+x /usr/local/bin/markdown

echo "Installing openssh…"
sudo pacman -S --noconfirm openssh
sudo sed -i "s/^# *Port 22/Port 22/" /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "Installing nvm, npm, node, bun…"
sudo pacman -S --noconfirm nvm npm bun-bin
source /usr/share/nvm/init-nvm.sh
nvm install 20 2>/dev/null
nvm use 20 2>/dev/null
npm install -g yarn >/dev/null 2>&1

echo "Installing elm…"
npm install -g elm elm-test elm-format elm-oracle >/dev/null 2>&1

echo "Installing nvim helpers…"
# TODO. Review this.
echo " » prettier"
npm install -g prettier@npm:wp-prettier@latest 2>&1
echo " » elm tooling"
npm install -g @elm-tooling/elm-language-server >/dev/null 2>&1
echo " » emmet"
npm install -g emmet-ls >/dev/null 2>&1
echo " » intelephense"
npm install -g intelephense >/dev/null 2>&1
echo " » vscode landservers"
npm install -g vscode-langservers-extracted >/dev/null 2>&1
echo " » eslint"
npm install -g @wordpress/eslint-plugin @typescript-eslint/eslint-plugin @typescript-eslint/parser >/dev/null 2>&1

echo "Installing script helpers…"
npm install -g glob lodash path >/dev/null 2>&1

echo "Installing composer deps…"
cd "$SRC_DIR" 2>/dev/null
stow --no-folding composer >/dev/null 2>&1
composer global install >/dev/null 2>&1
cd - 2>/dev/null

echo "Installing apps…"
sudo pacman -S --noconfirm inkscape gimp
yay -S --noconfirm zoom

echo "Configuring inkscape…"
mkdir -p ~/.config/inkscape/extensions >/dev/null 2>&1
cd ~/.config/inkscape/extensions >/dev/null 2>&1
wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.py" >/dev/null 2>&1
wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.inx" >/dev/null 2>&1
cd - >/dev/null 2>&1

echo "Installing Firefox…"
sudo pacman -Syy
sudo pacman -S --noconfirm firefox firefoxpwa

echo "Installing firefoxpwa’s runtime…"
firefoxpwa runtime install

echo "Installing WhatsApp webapp…"
if [ "$(firefoxpwa profile list | grep -c whatsapp.web)" -eq 0 ]; then
  profile="$(firefoxpwa profile create | grep "Profile created" | sed -e "s/.*Profile created: //")"
  firefoxpwa site install https://web.whatsapp.com/data/manifest.json --profile "$profile"
fi

echo "Installing Lando…"
/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"
eval "$(/home/david/.lando/bin/lando shellenv)"

echo ""
echo "====================="
echo "UTILITIES FROM GITHUB"
echo "====================="

# TODO. View how to integrate with Omarchy.
# echo "Installing greenclip…"
# sudo pacman -S --noconfirm rofi-greenclip

# TODO. Review how to use colorscheme from Omarchy theme.
echo "Configuring bat…"
mkdir -p "$(bat --config-dir)/themes" >/dev/null 2>&1
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme >/dev/null 2>&1
bat cache --build >/dev/null 2>&1

echo ""
echo "============="
echo "INIT DOTFILES"
echo "============="

echo "Stowing dotfiles…"
mkdir -p ~/.local/bin 2>/dev/null
cd "$SRC_DIR" 2>/dev/null
rm -rf ~/.git ~/.bash* ~/.vim 2>/dev/null
stow --no-folding git
stow --no-folding programs
stow --no-folding shell
rm -rf ~/.config/hypr 2>/dev/null
rm -rf ~/.config/kitty 2>/dev/null
rm -rf ~/.config/qalculate 2>/dev/null
stow desktop
rm -rf ~/.config/nvim 2>/dev/null
stow nvim
cd - 2>/dev/null

echo ""
echo "======================="
echo "LOAD ADDITIONAL CONFIGS"
echo "======================="

if [ "$(~/.local/share/omarchy/bin/omarchy-theme-current)" != "Catppuccin" ]; then
  yes n | ~/.local/share/omarchy/bin/omarchy-theme-set catppuccin
fi
yes n | ~/.local/share/omarchy/bin/omarchy-install-terminal kitty
dconf load /org/gnome/meld/ <"${SRC_DIR}/dconf/meld.ini"
xdg-settings set default-web-browser firefox.desktop

echo ""
echo "DONE"
echo "Enjoy your new life, David!"

gum confirm "Relaunch Hyprland to use new settings?" && uwsm stop
