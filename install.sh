#!/usr/bin/zsh
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/Programs/dotfiles
############################

cd "`dirname $0`"
SRC_DIR=`pwd`
export DEBIAN_FRONTEND="noninteractive"

echo "=================="
echo "BASIC CONFIG FILES"
echo "=================="

echo "Installing Oh My Zsh..."
rm -rf ~/.oh-my-zsh 2>&1 >/dev/null
git clone --quiet https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
rm -f ~/.zshrc.pre-oh-my-zsh

echo "Adding zsh plugins..."
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "Adding zsh themes..."
git clone --quiet https://github.com/bhilburn/powerlevel9k ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone --quiet https://github.com/win0err/aphrodite-terminal-theme ~/.oh-my-zsh/custom/themes/aphrodite

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
cp $SRC_DIR/config/qterminal.org/qterminal.ini ~/.config/qterminal.org/qterminal.ini

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

echo "Loading setup..."
dconf write /org/cinnamon/panels-autohide "['1:false', '2:false', '3:false']"
dconf write /org/cinnamon/panels-show-delay "['1:0', '2:0', '3:0']"
dconf write /org/cinnamon/panels-hide-delay "['1:0', '2:0', '3:0']"
dconf write /org/cinnamon/enabled-extensions "['!cinnamon-maximus@fmete', 'transparent-panels@germanfr']"
dconf write /org/cinnamon/panel-edit-mode "false"
dconf write /org/cinnamon/enabled-applets "['panel2:right:1:systray@cinnamon.org:0', 'panel1:left:0:menu@cinnamon.org:1', 'panel1:left:1:grouped-window-list@cinnamon.org:3', 'panel2:right:3:keyboard@cinnamon.org:4', 'panel2:right:8:notifications@cinnamon.org:5', 'panel2:right:4:removable-drives@cinnamon.org:6', 'panel2:right:7:network@cinnamon.org:8', 'panel2:right:6:sound@cinnamon.org:9', 'panel2:right:2:power@cinnamon.org:10', 'panel2:right:9:calendar@cinnamon.org:11', 'panel2:left:0:window-buttons-with-title@fmete:18', 'panel2:right:0:trash@cinnamon.org:19']"
dconf write /org/cinnamon/next-applet-id 20
dconf write /org/cinnamon/no-adjacent-panel-barriers "true"
dconf write /org/cinnamon/panel-zone-icon-sizes "'[{\"panelId\":1,\"left\":0,\"center\":0,\"right\":24},{\"panelId\":2,\"left\":0,\"center\":0,\"right\":0}]'"
dconf write /org/cinnamon/panels-enabled "['1:0:left', '2:0:top']"
dconf write /org/cinnamon/panels-height "['1:40', '2:24', '3:40']"
dconf write /org/cinnamon/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"
dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
dconf write /org/cinnamon/desktop/interface/gtk-theme "'Mint-Y-Darker'"
dconf write /org/nemo/desktop/home-icon-visible "false"
dconf write /org/nemo/desktop/computer-icon-visible "false"
dconf write /org/cinnamon/desktop/sound/volume-sound-file "/usr/share/mint-artwork/sounds/logout.ogg"
dconf write /org/cinnamon/desktop/sound/event-sounds "false"

rm -rf ~/.cinnamon/configs/* >/dev/null 2>&1
ln -s $SRC_DIR/cinnamon/configs/* ~/.cinnamon/configs/

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

mkdir -p ~/Programs
echo "Adding scripts..."
rm -rf ~/Programs/bin
ln -s $SRC_DIR/Programs/bin ~/Programs/

rm -rf ~/Programs/bin/git
mkdir ~/Programs/bin/git
cd ~/Programs/bin/git
git clone --quiet https://github.com/denilsonsa/prettyping
git clone --quiet https://github.com/so-fancy/diff-so-fancy


echo ""
echo "======"
echo "SYSTEM"
echo "======"

echo "Let's perform some system changes..."
sudo ls >/dev/null 2>&1

echo ""

echo "Installing dev packages..."
sudo apt-get -qq install fasd tree meld jq vim ruby subversion composer php7.2-xml poedit myspell-es aspell-es npm
sudo update-alternatives --set editor /usr/bin/vim.basic

echo "Installing Docker and Lando..."
wget -q https://get.docker.com/ -O /tmp/id.sh && echo "yes"
bash /tmp/id.sh
wget -q https://github.com/lando/lando/releases/download/v3.0.0-rc.17/lando-v3.0.0-rc.17.deb -O /tmp/lando.deb
sudo dpkg -i /tmp/lando.deb
sudo usermod -aG docker david

echo "Installing utilities..."
sudo apt-get -qq install inkscape gimp filezilla qterminal tmux htop imagemagick libimage-exiftool-perl

echo "Updating apt packages..."
sudo apt-get -qq update

echo "Upgrading system..."
sudo apt-get -qq upgrade

echo "Cleaning unnecessary packages..."
sudo apt-get -qq autoremove >/dev/null 2>&1
sudo apt-get -qq autoclean >/dev/null 2>&1

echo "Configuring docker..."
sudo groupadd docker >/dev/null 2>&1
sudo usermod -aG docker $USER

echo "Installing bat..."
cd /tmp
wget --quiet https://github.com/sharkdp/bat/releases/download/v0.11.0/bat-musl_0.11.0_amd64.deb
sudo dpkg -i bat-musl_0.11.0_amd64.deb


echo ""
echo "==="
echo "VIM"
echo "==="

echo ""
echo -n "Do you want to install vim packages? (y/N) "
read answer
if [ "$answer" = "y" ];
then

	# Install Vundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle

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

