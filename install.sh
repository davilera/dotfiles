#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/Programs/dotfiles
############################

SRC_DIR=~/Programs/dotfiles


echo "=================="
echo "BASIC CONFIG FILES"
echo "=================="

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
for file in `ls -d local/share/cinnamon/applets/*`;
do
	echo "Adding applet `basename $file`..."
	rm -rf ~/.$file 2>/dev/null >&2
	ln -s $SRC_DIR/$file ~/.$file
done

# EXTENSIONS
mkdir -p ~/.local/share/cinnamon/extensions
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

mkdir -p ~/Programs
echo "Loading scripts..."
rm -rf ~/Programs/bin
ln -s $SRC_DIR/Programs/bin ~/Programs/
echo ""

echo "DONE"
echo "Enjoy your new life, David!"

