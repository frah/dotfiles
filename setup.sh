#!/bin/bash

cd $(dirname $0)

# Make dotfile links
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [[ $dotfile != '.git'* ]]; then
        if [ -e "$HOME/$dotfile" ]; then
            if [ -L "$HOME/$dotfile" ]; then
                rm -f $HOME/$dotfile
            else
                mv $HOME/$dotfile $HOME/${dotfile}_bk`date +%Y%m%d`
            fi
        fi
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

