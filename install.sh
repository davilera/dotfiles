#!/usr/bin/zsh
############################
# install.sh
############################

cd "`dirname $0`"
SRC_DIR=`pwd`
export DEBIAN_FRONTEND="noninteractive"

echo "Updating apt packages…"
sudo apt-get -qq update
sudo apt-get -qq upgrade

echo "Installing basic stuff…"
sudo apt-get -qq install curl zsh git vim kitty thefuck

echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Installing dev packages…"
sudo apt-get -qq install stow zoxide tree meld jq ruby subversion composer php-xml awscli curl g++ build-essential openjdk-17-jdk openjdk-17-jre python3 python3-pip golang cargo luarocks markdown
sudo update-alternatives --set editor /usr/bin/vim.basic

echo "Installing utilities…"
sudo apt-get -qq install filezilla btop imagemagick libimage-exiftool-perl poedit myspell-ca myspell-es aspell-es silversearcher-ag
cargo install lsd >/dev/null 2>&1

echo "Installing nvm, node.js, and npm…"
rm -rf ~/.nvm >/dev/null 2>&1
mkdir ~/.nvm
version=`wget -qO- "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .tag_name`
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/$version/install.sh" | bash >/dev/null 2>&1
\. ~/.nvm/nvm.sh
nvm install 20 2>/dev/null
nvm use 20 2>/dev/null
nvm install node 2>/dev/null
npm install -g yarn >/dev/null 2>&1

echo "Installing elm…"
npm install -g elm elm-test elm-format elm-oracle >/dev/null 2>&1

echo "Installing neovim LSP servers…"
npm install -g neovim >/dev/null 2>&1
npm install -g eslint_d >/dev/null 2>&1
npm install -g prettier@npm:wp-prettier@latest 2>&1
npm install -g typescript typescript-language-server >/dev/null 2>&1
npm install -g @elm-tooling/elm-language-server >/dev/null 2>&1
npm install -g emmet-ls >/dev/null 2>&1
npm install -g intelephense >/dev/null 2>&1
npm install -g vscode-langservers-extracted >/dev/null 2>&1

cd $SRC_DIR 2>/dev/null
stow --no-folding composer >/dev/null 2>&1
composer global install >/dev/null 2>&1
cd - 2>/dev/null

echo ""
echo -n "Do you want to install Docker and Lando? (y/N) "
read answer
if [ "$answer" = "y" ];
then
	echo "Installing Docker…"
	/bin/bash -c "$(curl -fsSL https://get.docker.com)"
	echo "Installing Lando…"
	/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"

	echo "Configuring docker…"
	sudo groupadd docker >/dev/null 2>&1
	sudo usermod -aG docker $USER
fi

echo ""
echo -n "Do you want to install Inkscape and Gimp? (y/N) "
read answer
if [ "$answer" = "y" ];
then
	sudo apt-get -qq install inkscape gimp

	echo "Configuring inkscape…"
	mkdir -p ~/.config/inkscape/extensions >/dev/null 2>&1
	cd ~/.config/inkscape/extensions >/dev/null 2>&1
	wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.py" >/dev/null 2>&1
	wget "https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.inx" >/dev/null 2>&1
	cd - >/dev/null 2>&1

fi

echo ""
echo "Updating apt packages…"
sudo apt-get -qq update

echo "Upgrading system…"
sudo apt-get -qq upgrade

echo "Cleaning unnecessary packages…"
sudo apt-get -qq autoremove >/dev/null 2>&1
sudo apt-get -qq autoclean >/dev/null 2>&1

echo "Customizing environment…"
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo ""
echo "====================="
echo "UTILITIES FROM GITHUB"
echo "====================="

echo "Creating development directories…"
mkdir -p ~/Programs/dev/plugins 2>/dev/null
mkdir -p ~/Programs/dev/themes 2>/dev/null
mkdir -p ~/Programs/dev/wordpress.org 2>/dev/null

echo "Installing oh-my-zsh…"
rm -rf ~/.oh-my-zsh 2>&1 >/dev/null
git clone --quiet "https://github.com/robbyrussell/oh-my-zsh" ~/.oh-my-zsh
rm -f ~/.zshrc ~/.zshrc.pre-oh-my-zsh

echo "Adding zsh plugins…"
git clone --quiet "https://github.com/zsh-users/zsh-syntax-highlighting" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "Adding zsh themes…"
git clone --quiet "https://github.com/bhilburn/powerlevel9k" ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone --quiet "https://github.com/win0err/aphrodite-terminal-theme" ~/.oh-my-zsh/custom/themes/aphrodite

echo "Installing greenclip…"
mkdir -p ~/.local/bin
cd ~/.local/bin/ 2>/dev/null
killall -9 greenclip >/dev/null 2>&1
rm -f greenclip 2>/dev/null
wget --quiet "https://github.com/erebe/greenclip/releases/latest/download/greenclip"
chmod a+x greenclip
cd - 2>/dev/null

echo "Installing diff-so-fancy…"
mkdir -p ~/.local/bin
cd ~/.local/bin/ 2>/dev/null
rm -f diff-so-fancy 2>/dev/null
wget --quiet "https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy"
chmod a+x diff-so-fancy
cd - 2>/dev/null

echo "Installing prettyping…"
mkdir -p ~/.local/bin
cd ~/.local/bin/ 2>/dev/null
rm -f prettyping 2>/dev/null
wget --quiet "https://github.com/denilsonsa/prettyping/archive/refs/tags/v1.0.1.zip"
unzip -qqo v1.0.1.zip 
mv prettyping-1.0.1/prettyping . 2>/dev/null
rm -rf prettyping-1.0.1 v1.0.1.zip
cd - 2>/dev/null

echo "Installing bat…"
cd /tmp
version=`wget -qO- "https://api.github.com/repos/sharkdp/bat/releases/latest" | jq -r .tag_name | sed -e "s/v//"`
wget --quiet "https://github.com/sharkdp/bat/releases/download/v$version/bat-musl_${version}_amd64.deb"
sudo dpkg -i "bat-musl_${version}_amd64.deb"

mkdir -p "$(bat --config-dir)/themes" >/dev/null 2>&1
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme >/dev/null 2>&1
bat cache --build >/dev/null 2>&1

echo "Installing lazygit…"
LAZYGIT_VERSION=`wget -qO- "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r .tag_name | sed -e "s/v//"`
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" >/dev/null 2>&1
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -f lazygit lazygit.tar.gz

echo "Installing LunarVim…"
sudo apt-get -qq install xclip ripgrep fd-find
mkdir -p ~/.local/bin
wget --quiet https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim
version=`wget -qO- "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .target_commitish`
LV_BRANCH=$version bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/$version/utils/installer/install.sh)
rm -rf ~/.local/share/lunarvim.old  ~/.cache/lvim.old

echo "Installing i3 dependencies…"
echo "deb [arch=amd64] http://debian.sur5r.net/i3/ jammy universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list >/dev/null
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb /tmp/keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install /tmp/keyring.deb
rm /tmp/keyring.deb
sudo apt-get -qq update
sudo apt-get -qq install i3 python3-i3ipc feh qalc polybar rofi dunst picom
mkdir -p ~/.local/bin
wget --quiet https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py -O ~/.local/bin/autotiling
chmod a+x ~/.local/bin/autotiling

mkdir -p ~/.local/bin
wget --quiet https://github.com/jluttine/rofi-power-menu/raw/master/rofi-power-menu -O ~/.local/bin/rofi-power-menu

echo ""
echo "============="
echo "INIT DOTFILES"
echo "============="

echo "Installing stow and getting dotfiles…"
mkdir -p ~/.local/bin
mkdir -p ~/.local/bin 2>/dev/null
cd $SRC_DIR 2>/dev/null
rm -rf ~/.git ~/.bash* ~/.vim 2>/dev/null
stow --no-folding desktop
stow --no-folding git
stow --no-folding programs
stow --no-folding shell
stow lvim
stow vim
cd - 2>/dev/null

echo ""
echo "============"
echo "MANUAL TASKS"
echo "============"

echo "1. Install proprietary nvidia drivers"
echo "2. Link “$SRC_DIR/others/firefox/chrome” to your Firefox profile"
echo "3. Set Catppuccin Macchiato Pink theme in Firefox"
echo "4. Enable “toolkit.legacyUserProfileCustomizations.stylesheets” in “about:config”"
echo "5. Import Sidebery settings"
echo "6. Set Mouse Pointer to Bibata Original Classic"
echo "7. Set Applications theme to Catppuccin Pink Dark"
echo "8. Set Icons to Mint-Y-Pink"
echo "9. Set Desktop to Catppuccin Pink Dark"
echo "10. Install Zoom"

echo ""
echo "DONE"
echo "Enjoy your new life, David!"
