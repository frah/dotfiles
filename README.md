# dotfiles
freiheit dotfiles

## Install
1. Download
    ```
    $ git clone http://github.com/freiheittokkyu/dotfiles.git
    ```

2. Setup [Vundle]
    ```
    $ git submodule init
    $ git submodule update
    ```

3. Make link
    - Unix/Mac OS
        ```
        $ bash setup_dotfiles.sh
        ```

    - Windows
        Run `setup_vimrc.bat`.

4. Install bundle
    Launch `vim`,  run `:BundleInstall`.

    *Windows users* see [Vundle for Windows], commentout `set shellshash`.

5. Setup [vimproc]
    ```
    $ cd .vim/bundle/vimproc
    ```
    - Unix
        ```
        $ make -f make_gcc.mak
        ```
    - FreeBSD
        1. Replace `PF_INET` with `AF_INET` in `autoload/proc.c`.
        2. Compile
            ```
            $ make -f make_gcc.mak
            ```
    - Mac OS
        ```
        $ make -f make_mac.mak
        ```
    - Windows (VisualStudio)
        ```
        $ make -f make_msvc.mak
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
