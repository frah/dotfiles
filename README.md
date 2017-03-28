# dotfiles
frah dotfiles

## Install
### Unix/Mac OS

1. Download

    ```
    $ git clone http://github.com/frah/dotfiles.git
    ```

2. Setup

    ```
    $ ./setup.sh
    ```

### Windows

1. Download

    ```
    > git clone http://github.com/frah/dotfiles.git
    ```

2. Make link

    Run `setup_vimrc.bat`.

3. Setup [vimproc]

    ```
    > cd .vim/bundle/vimproc
    > make -f make_msvc.mak
    ```

## Update
1. Update git repository

    ```
    $ git fetch origin
    $ git merge --ff origin/master
    ```

2. Update bundles

    Launch `vim`

