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

echo "Adding color schemes..."
mkdir -p ~/.config/qterminal.org/color-schemes
ln -s $SRC_DIR/qterminal.org/color-schemes/* ~/.config/qterminal.org/color-schemes/
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


echo "DONE"
echo "Enjoy your new life, David!"

