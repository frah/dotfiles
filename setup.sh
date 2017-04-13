#!/bin/bash

cd $(dirname $0)

curl -# -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

# Make dotfile links
for dotfile in .?*
do
    if [ $dotfile != '..' ]; then
        case "$dotfile" in
            ".git" ) continue;;
            ".travis.yml" ) continue;;
            ".vintrc.yaml" ) continue;;
        esac
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

