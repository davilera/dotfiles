#!/usr/bin/bash

cd "$(dirname $0)"
SRC_DIR=$(pwd)

echo "Updating pacman packages…"
sudo pacman -Syu

echo "Installing basic stuff…"
sudo pacman -S --noconfirm curl git vim kitty thefuck

echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Installing dev packages…"
sudo pacman -S --noconfirm stow zoxide tree meld jq ruby subversion composer curl python3 python-pip go cargo luarocks prettyping lsd

echo "Installing utilities…"
sudo pacman -S --noconfirm filezilla btop imagemagick poedit hunspell-es_any aspell-ca aspell-es the_silver_searcher difftastic
yay -S --noconfirm hunspell-ca

echo "Installing nvm, npm, node, bun…"
sudo pacman -S --noconfirm nvm npm bun-bin
source /usr/share/nvm/init-nvm.sh
nvm install 20 2>/dev/null
nvm use 20 2>/dev/null
npm install -g yarn >/dev/null 2>&1

echo "Installing elm…"
npm install -g elm elm-test elm-format elm-oracle >/dev/null 2>&1

echo "Installing neovim LSP servers…"
# TODO. Review this.
# npm install -g neovim >/dev/null 2>&1
# npm install -g eslint_d >/dev/null 2>&1
npm install -g prettier@npm:wp-prettier@latest 2>&1
# TODO. Review this.
# npm install -g typescript typescript-language-server >/dev/null 2>&1
npm install -g @elm-tooling/elm-language-server >/dev/null 2>&1
npm install -g emmet-ls >/dev/null 2>&1
npm install -g intelephense >/dev/null 2>&1
npm install -g vscode-langservers-extracted >/dev/null 2>&1

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

echo "Installing Lando…"
/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"
eval "$(/home/david/.lando/bin/lando shellenv)"

echo ""
echo "====================="
echo "UTILITIES FROM GITHUB"
echo "====================="

echo "Creating development directories…"
mkdir -p ~/Programs/dev/plugins 2>/dev/null
mkdir -p ~/Programs/dev/themes 2>/dev/null
mkdir -p ~/Programs/dev/sites 2>/dev/null
mkdir -p ~/Programs/dev/wordpress.org 2>/dev/null

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
stow desktop
stow lazyvim
cd - 2>/dev/null

echo ""
echo "DONE"
echo "Enjoy your new life, David!"
