#!/bin/sh --
set -e

echo ""
echo "START POST-MERGE HOOK"
echo ""

HOOK_DIR=`dirname $0`      #git_hooks directory
PROC_DIR="$HOOK_DIR/../.." #vimproc directory

cd $PROC_DIR

case `uname -s` in
    Darwin)
        MAKE_FILE='make_mac.mak'
        PROC_FILE='proc.so'
        ;;
    Linux)
        MAKE_FILE='make_gcc.mak'
        PROC_FILE='proc.so'
        ;;
    FreeBSD)
        MAKE_FILE='make_gcc.mak'
        PROC_FILE='proc.so'
        sed -e 's/PF_INET/AF_INET/g' autoload/proc.c > autoload/proc.c
        ;;
    CYGWIN*)
        MAKE_FILE='make_cygwin.mak'
        PROC_FILE='proc_cygwin.dll'
        ;;
    *)
        echo "This type of OS is not supported"
        exit 1
        ;;
esac

if [ -f autoload/$PROC_FILE ]; then
    echo "deleting previous $PROC_FILE ..."
    rm autoload/$PROC_FILE
    echo "done"
    echo ""
fi

echo "compiling $PROC_FILE ..."
make -f $MAKE_FILE
echo "done"
echo ""

echo "vimproc: build success!"
echo ""

echo "END POST-MERGE HOOK"

