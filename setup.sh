#!/bin/bash

cd $(dirname $0)

# Make dotfile links
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [[ $dotfile != '.git'* ]]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

