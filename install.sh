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
sudo apt-get -qq install curl zsh

echo ""
echo "=================="
echo "BASIC CONFIG FILES"
echo "=================="

echo "Installing stow and getting dotfiles…"
sudo apt-get -qq install stow
cd $SRC_DIR 2>/dev/null
rm -rf ~/.git ~/.bash* ~/.vim 2>/dev/null
stow git
stow programs
stow shell
stow tmux
stow vim
stow lvim
cd - 2>/dev/null

find kitty -type f | while read file;
do
	file=`echo $file | sed -e "s/kitty\///"`
	mkdir -p ~/`dirname $file` 2>/dev/null
	rm ~/$file 2>/dev/null
	ln -s $SRC_DIR/kitty/$file ~/$file
done

echo "Installing git dependencies…"
cd $SRC_DIR 2>/dev/null
git submodule update --init --recursive 2>/dev/null
cd - 2>/dev/null

echo "Creating development directories…"
mkdir -p ~/Programs/dev/plugins 2>/dev/null
mkdir -p ~/Programs/dev/themes 2>/dev/null
mkdir -p ~/Programs/dev/wordpress.org 2>/dev/null

echo "Installing Oh My Zsh…"
rm -rf ~/.oh-my-zsh 2>&1 >/dev/null
git clone --quiet https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
rm -f ~/.zshrc.pre-oh-my-zsh

echo "Adding zsh plugins…"
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "Adding zsh themes…"
git clone --quiet https://github.com/bhilburn/powerlevel9k ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone --quiet https://github.com/win0err/aphrodite-terminal-theme ~/.oh-my-zsh/custom/themes/aphrodite

cd $SRC_DIR
for file in `ls -p | grep -v / | grep -v "install.sh\|README.md\|LICENSE"`;
do
	echo "Adding ~/.$file…"
	rm ~/.$file 2>/dev/null >&2
	ln -s $SRC_DIR/$file ~/.$file
done

echo "Installing FiraCode…"
mkdir -p ~/.local/share/fonts/
cd ~/.local/share/fonts/
wget --quiet https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip >/dev/null 2>&1
mv FiraCodeNerdFontMono-Regular.ttf tmp.ttf >/dev/nul 2>&1
rm FiraCode* >/dev/null 2>&1
mv tmp.ttf "FiraCode Nerd Font Mono.ttf" >/dev/nul 2>&1
rm -f FiraCode.zip >/dev/null 2>&1

echo "Installing LunarVim…"
echo "Nope!
# TODO
# curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage --output nvim.appimage
# chmod u+x nvim.appimage
# mkdir -p ~/.local/bin
# mv nvim.appimage ~/.local/bin/nvim

echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Let’s perform some system changes…"
sudo ls >/dev/null 2>&1

echo ""

echo "Installing dev packages…"
sudo apt-get -qq install fasd tree meld jq vim ruby subversion composer php-xml poedit myspell-es aspell-es awscli curl g++ build-essential kitty openjdk-17-jdk openjdk-17-jre python python3-pip julia golang cargo luarocks markdown silversearcher-ag
sudo update-alternatives --set editor /usr/bin/vim.basic
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb -P /tmp 2>/dev/null
sudo dpkg -i /tmp/ripgrep_13.0.0_amd64.deb

echo "Configuring git…"
git config --global core.editor "~/.local/bin/lvim"

echo "Installing nvm, node.js, and npm…"
rm -rf ~/.nvm >/dev/null 2>&1
mkdir ~/.nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash >/dev/null 2>&1
bash -c "nvm install node"

echo "Installing elm…"
npm install -g elm elm-test elm-format elm-oracle >/dev/null 2>&1

echo "Installing Neovim TLS servers…"
npm install -g typescript typescript-language-server >/dev/null 2>&1
npm install -g @elm-tooling/elm-language-server >/dev/null 2>&1
npm install -g emmet-ls >/dev/null 2>&1
npm install -g intelephense >/dev/null 2>&1
npm install -g vscode-langservers-extracted >/dev/null 2>&1
composer global require php-stubs/wordpress-globals php-stubs/wordpress-stubs php-stubs/woocommerce-stubs php-stubs/wp-cli-stubs

echo ""
echo -n "Do you want to install Docker and Lando? (y/N) "
read answer
if [ "$answer" = "y" ];
then
	wget -q https://get.docker.com/ -O /tmp/id.sh
	bash /tmp/id.sh
	wget -q https://github.com/lando/lando/releases/download/v3.0.0-rc.17/lando-v3.0.0-rc.17.deb -O /tmp/lando.deb
	sudo dpkg -i /tmp/lando.deb
	sudo usermod -aG docker david

	echo "Configuring docker..."
	sudo groupadd docker >/dev/null 2>&1
	sudo usermod -aG docker $USER
fi

echo "Installing utilities..."
sudo apt-get -qq install filezilla htop imagemagick libimage-exiftool-perl

echo ""
echo -n "Do you want to install Inkscape and Gimp? (y/N) "
read answer
if [ "$answer" = "y" ];
then
	sudo apt-get -qq install inkscape gimp

	echo "Configuring inkscape..."
	mkdir -p ~/.config/inkscape/extensions >/dev/null 2>&1
	cd ~/.config/inkscape/extensions >/dev/null 2>&1
	wget https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.py >/dev/null 2>&1
	wget https://raw.githubusercontent.com/Klowner/inkscape-applytransforms/master/applytransform.inx >/dev/null 2>&1
	cd - >/dev/null 2>&1

fi

echo "Updating apt packages..."
sudo apt-get -qq update

echo "Upgrading system..."
sudo apt-get -qq upgrade

echo "Cleaning unnecessary packages..."
sudo apt-get -qq autoremove >/dev/null 2>&1
sudo apt-get -qq autoclean >/dev/null 2>&1

echo ""
echo "================"
echo "SOME EXTRA STUFF"
echo "================"

echo "Installing bat..."
cd /tmp
wget --quiet https://github.com/sharkdp/bat/releases/download/v0.11.0/bat-musl_0.11.0_amd64.deb
sudo dpkg -i bat-musl_0.11.0_amd64.deb


echo ""
echo "DONE"
echo "Enjoy your new life, David!"
