# dotfiles
freiheit dotfiles

## Install
- Unix/Mac OS
    1. Download

        ```
        $ git clone http://github.com/freiheittokkyu/dotfiles.git
        ```

    2. Setup

        ```
        $ bash setup.sh
        ```

- Windows
    1. Download

        ```
        > git clone http://github.com/freiheittokkyu/dotfiles.git
        ```

    2. Setup [Vundle]

        ```
        > git submodule init
        > git submodule update
        ```

    3. Make link

        Run `setup_vimrc.bat`.

    4. Install bundle

        Launch `vim`,  run `:BundleInstall`.

        *Windows users* see [Vundle for Windows], commentout `set shellslash`.

    5. Setup [vimproc]

        ```
        > cd .vim/bundle/vimproc
        > make -f make_msvc.mak
        ```

## Update
1. Update git repository

    ```
    $ git pull
    $ git submodule update
    ```

2. Update bundles

    Launch `vim`, run `:BundleInstall!`.

[Vundle]:http://github.com/gmarik/vundle
[Vundle for Windows]:https://github.com/gmarik/vundle/wiki/Vundle-for-Windows
[vimproc]:http://github.com/Shougo/vimproc
