#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/Programs/bin/dotfiles              # dotfiles directory

##########

# Create symlinks
for file in `find . -type f | grep -v "install.sh\|README.md\|LICENSE\|.git"`; do
	echo $file
	# echo "Moving any existing dotfiles from ~ to $olddir"
	# mv ~/.$file ~/dotfiles_old/
	# echo "Creating symlink to $file in home directory."
	# ln -s $dir/$file ~/.$file
done
