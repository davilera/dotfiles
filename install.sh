#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/Programs/dotfiles
############################

SRC_DIR=~/Programs/dotfiles
export DEBIAN_FRONTEND="noninteractive"


echo "=================="
echo "BASIC CONFIG FILES"
echo "=================="

echo "Configuring Bash it..."
if [ ! -d ~/.bash_it ];
then
	git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it 2>&1 >/dev/null
else
	cd ~/.bash_it 2>&1 >/dev/null
	git up 2>&1 >/dev/null
fi
~/.bash_it/install.sh --no-modify-config --silent >/dev/null 2>&1

cd $SRC_DIR
for file in `ls -p | grep -v / | grep -v "install.sh\|README.md\|LICENSE"`;
do
	echo "Adding ~/.$file..."
	rm ~/.$file 2>/dev/null >&2
	ln -s $SRC_DIR/$file ~/.$file
done


echo ""
echo "========="
echo "QTERMINAL"
echo "========="

mkdir -p ~/.config/qterminal.org/color-schemes
cd $SRC_DIR
for file in `ls -d config/qterminal.org/color-schemes/*`;
do
	echo "Adding colorscheme `basename $file`..."
	rm -rf ~/.$file 2>/dev/null >&2
	ln -s $SRC_DIR/$file ~/.$file
done

echo "Adding qterminal ini file..."
rm -f ~/.config/qterminal.org/qterminal.ini
ln -s $SRC_DIR/config/qterminal.org/qterminal.ini ~/.config/qterminal.org/qterminal.ini

echo "Installing FiraCode..."
mkdir -p ~/.local/share/fonts/
cd ~/.local/share/fonts/
wget --quiet https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Light.ttf
wget --quiet https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf
wget --quiet https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Medium.ttf
wget --quiet https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Bold.ttf

echo ""
echo "========"
echo "CINNAMON"
echo "========"

# APPLETS
mkdir -p ~/.local/share/cinnamon/applets
cd $SRC_DIR
for file in `ls -d local/share/cinnamon/applets/*`;
do
	echo "Adding applet `basename $file`..."
	rm -rf ~/.$file 2>/dev/null >&2
	ln -s $SRC_DIR/$file ~/.$file
done

# EXTENSIONS
mkdir -p ~/.local/share/cinnamon/extensions
cd $SRC_DIR
for file in `ls -d local/share/cinnamon/extensions/*`;
do
	echo "Adding extension `basename $file`..."
	rm -rf ~/.$file 2>/dev/null >&2
	ln -s $SRC_DIR/$file ~/.$file
done


echo ""
echo "=============="
echo "CUSTOM SCRIPTS"
echo "=============="

echo "Creating development directories..."
mkdir -p ~/Programs/bin 2>/dev/null
mkdir -p ~/Programs/dev/plugins 2>/dev/null
mkdir -p ~/Programs/dev/themes 2>/dev/null
mkdir -p ~/Programs/dev/wordpress.org 2>/dev/null

mkdir -p ~/Programs/dev
echo "Adding local-by-nelio..."
rm -rf ~/Programs/dev/local-by-nelio
ln -s $SRC_DIR/Programs/dev/local-by-nelio ~/Programs/dev/

mkdir -p ~/Programs
echo "Adding scripts..."
rm -rf ~/Programs/bin
ln -s $SRC_DIR/Programs/bin ~/Programs/


echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Let's perform some system changes..."
sudo ls >/dev/null 2>&1

echo ""

echo "Installing dev packages..."
sudo apt-get -qq install fasd tree meld docker.io docker-compose vim ruby subversion composer php7.2-xml poedit myspell-es aspell-es
sudo update-alternatives --set editor /usr/bin/vim.basic

echo "Installing utilities..."
sudo apt-get -qq install inkscape gimp filezilla qterminal tmux

echo "Updating apt packages..."
sudo apt-get -qq update

echo "Upgrading system..."
sudo apt-get -qq upgrade

echo "Cleaning unnecessary packages..."
sudo apt-get -qq autoremove >/dev/null 2>&1
sudo apt-get -qq autoclean >/dev/null 2>&1


echo ""
echo "==="
echo "VIM"
echo "==="

echo ""
echo -n "Do you want to install vim packages? (y/N) "
read answer
if [ "$answer" == "y" ];
then

	# YouCompleteMe...
	echo "Building YouCompleteMe..."

	echo "  - Installing packages..."
	sudo apt-get -qq install build-essential cmake python2.7-dev python3-dev >/dev/null 2>&1
	mkdir -p ~/.vim/bundle >/dev/null 2>&1
	cd ~/.vim/bundle >/dev/null 2>&1
	if [ -d YouCompleteMe ];
	then
		rm -rf YouCompleteMe
	fi

	echo "  - Cloning github project..."
	git clone https://github.com/Valloric/YouCompleteMe >/dev/null 2>&1
	cd YouCompleteMe
	git pull >/dev/null 2>&1

	echo "  - Cloning submodules..."
	git submodule update --init --recursive >/dev/null 2>&1

	echo "  - Compiling and installing..."
	./install.sh >/dev/null 2>&1

	echo "  - Cleaning..."
	sudo apt-get -qq remove build-essential cmake python2.7-dev python3-dev >/dev/null 2>&1

	# Other packages
	echo "Installing VIM packages..."
	vim +PluginInstall +qall >/dev/null 2>&1

fi

echo ""
echo "DONE"
echo "Enjoy your new life, David!"

