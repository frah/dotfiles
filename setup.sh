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

HOOKSCRIPT_PATH='.vim/bundle/vimproc/.git/hooks/post-merge'
cp .vim/vimproc_post-merge.sh $HOOKSCRIPT_PATH
chmod +x $HOOKSCRIPT_PATH
cd .vim/bundle/vimproc
git pull

