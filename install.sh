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
sudo apt-get -qq install curl zsh git i3

echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Installing dev packages…"
sudo apt-get -qq install stow fasd tree meld jq vim ruby subversion composer php-xml awscli curl g++ build-essential kitty openjdk-17-jdk openjdk-17-jre python python3-pip julia golang cargo luarocks markdown
sudo update-alternatives --set editor /usr/bin/vim.basic

echo "Installing utilities…"
sudo apt-get -qq install filezilla btop imagemagick libimage-exiftool-perl poedit myspell-es aspell-es silversearcher-ag ripgrep fd-find

echo "Installing nvm, node.js, and npm…"
rm -rf ~/.nvm >/dev/null 2>&1
mkdir ~/.nvm
version=`wget -qO- "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .tag_name`
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/$version/install.sh" | bash >/dev/null 2>&1
\. ~/.nvm/nvm.sh
nvm install 16 2>/dev/null
nvm use 16 2>/dev/null
nvm install node 2>/dev/null

echo "Installing elm…"
npm install -g elm elm-test elm-format elm-oracle >/dev/null 2>&1

echo "Installing neovim LSP servers…"
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
	wget -q https://get.docker.com/ -O /tmp/id.sh
	bash /tmp/id.sh
	version=`wget -qO- "https://api.github.com/repos/lando/lando/releases/latest" | jq -r .tag_name`
	wget -q "https://github.com/lando/lando/releases/download/$version/lando-x64-$version.deb" -O /tmp/lando.deb
	sudo dpkg -i /tmp/lando.deb
	sudo usermod -aG docker david

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

echo "Installing FiraCode…"
mkdir -p ~/.local/share/fonts/ 2>&1 >/dev/null
cd ~/.local/share/fonts/
wget --quiet "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
unzip -qqo FiraCode.zip
mv FiraCodeNerdFontMono-Regular.ttf tmp.ttf >/dev/null 2>&1
rm -f FiraCode* LICENSE readme.md >/dev/null 2>&1
mv tmp.ttf "FiraCode Nerd Font Mono.ttf" >/dev/null 2>&1
rm -f FiraCode.zip >/dev/null 2>&1
cd -

echo "Installing diff-so-fancy…"
cd ~/.local/bin/ 2>/dev/null
rm -f diff-so-fancy 2>/dev/null
wget --quiet "https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy"
chmod a+x diff-so-fancy
cd - 2>/dev/null

echo "Installing prettyping…"
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

echo "Installing lazygit…"
echo "TODO"

echo "Installing LunarVim…"
wget --quiet https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim
version=`wget -qO- "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .target_commitish`
LV_BRANCH=$version bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/$version/utils/installer/install.sh)
rm -f ~/.local/share/lunarvim.old  ~/.cache/lvim.old

echo "Installing i3 dependencies…"
sudo apt-get -qq install python3-i3ipc
wget --quiet https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py -O ~/.local/bin/autotiling
chmod a+x ~/.local/bin/autotiling

echo ""
echo "============="
echo "INIT DOTFILES"
echo "============="

echo "Installing stow and getting dotfiles…"
mkdir -p ~/.local/bin 2>/dev/null
cd $SRC_DIR 2>/dev/null
rm -rf ~/.git ~/.bash* ~/.vim 2>/dev/null
stow git
stow i3
stow kitty
stow lvim
stow programs
stow shell
stow tmux
stow vim
cd - 2>/dev/null

echo ""
echo "DONE"
echo "Enjoy your new life, David!"
