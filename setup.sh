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

# Setup vim
git submodule init
git submodule update
echo -e "Installing bundles...\nAfter BundleInstall is complete, exit vim. (:qa!)" | vim +BundleInstall -

cd ~/.vim/bundle/vimproc
case "$(uname -s)" in
Darwin)
    make -f make_mac.mak
    ;;
FreeBSD)
    make -f make_unix.mak
    ;;
esac

cd ~/.vim/bundle/jcommenter.vim
nkf -w -Lu --overwrite plugin/jcommenter.vim

