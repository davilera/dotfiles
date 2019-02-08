 !/bin/bash
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

mkdir -p ~/Programs/dev
echo "Adding local-by-nelio..."
rm -rf ~/Programs/dev/local-by-nelio
ln -s $SRC_DIR/Programs/dev/local-by-nelio ~/Programs/dev/
echo ""

mkdir -p ~/Programs
echo "Adding scripts..."
rm -rf ~/Programs/bin
ln -s $SRC_DIR/Programs/bin ~/Programs/
echo ""


echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Let's perform some system changes..."
sudo ls >/dev/null 2>&1

echo ""
echo "Installing dev packages..."
sudo apt-get -qq install fasd tree meld docker.io docker-compose vim ruby subversion composer php7.2-xml
sudo update-alternatives --set editor /usr/bin/vim.basic

echo "Installing utilities..."
sudo apt-get -qq install inkscape gimp filezilla

echo "Updating apt packages..."
sudo apt-get -qq update
echo "Upgrading system..."
sudo apt-get -qq upgrade
echo "Cleaning unnecessary packages..."
sudo apt-get -qq autoremove
sudo apt-get -qq autoclean


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
	sudo apt-get -qq install build-essential cmake python2.7-dev python3-dev
	cd ~/.vim/bundle
	if [ -d YouCompleteMe ];
	then
		rm -rf YouCompleteMe 2>&1 >/dev/null
	fi
	git clone https://github.com/Valloric/YouCompleteMe
	cd YouCompleteMe
	git pull
	git submodule update --init --recursive
	./install.sh
	sudo apt-get -qq remove build-essential cmake python2.7-dev python3-dev

	# Other packages
	vim +PluginInstall +qall

fi

echo ""
echo "DONE"
echo "Enjoy your new life, David!"

