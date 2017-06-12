#/bin/sh

set -u
trap exit ERR

CDIR=$(dirname $(readlink -f $0))
ERRMSG=31 # red

INITSH="start.sh"

msg() {
    printf "\033[$1m${@:2}\033[00m\n"
}

if [ -e $CDIR/sh/$INITSH ]; then
    bash $CDIR/sh/$INITSH
else
    msg $ERRMSG "[error] '${INITSH}' doesn't exist."
    return 2>&- || exit
fi
