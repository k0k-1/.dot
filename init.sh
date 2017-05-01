#/bin/sh

set -u
trap exit ERR

CDIR=$(dirname $(readlink -f $0)) # ???/.dot
INITSH="i.d.sh"

if [ -e $CDIR/.bin/$INITSH ]; then
    bash $CDIR/.bin/$INITSH
else
    printf "[error] $INITSH doesn't exist.\n"
    return 2>&- || exit
fi
