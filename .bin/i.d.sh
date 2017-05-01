#/bin/bash

#                 __       _   _
#                 \ \     | |_(_)_ __ ___ ___
#                  > >    | / / | '_ \___(_-<
#                 /_/     |_\_\_| .__/   /__/

#       * file name : i.d.sh
#       * auther    : kip-s
#       * url       : http://kip-s.net
#       * ver       : 1.00

#       * contents  : [1] init
#                           > var
#                               > check
#                               > color
#                               > filename
#                           > function

#                     [2] start
#                           > make dir
#                           > install external file
#                               > zplug
#                               > tmux.conf
#                           > make symbolic link





# * >   [1] init
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

set -u
trap exit ERR

# * >>  var --------------------------------------------/
# [[

CDIR=$(dirname $(dirname $(readlink -f $0))) # ???/.dot
DOTH=$HOME/.dot/
echo $CDIR

# * >>  check -------------------------/
# [[[

F_VIM=1
F_GIT=1
F_ZSH=1
F_SSH=0
F_BIN=0
F_TMUX=0
F_EMACS=0

# ]]]
# * << --------------------------------/

# * >>  coler -------------------------/
# [[[

RED=31
GREEN=32
YELLOW=33
BLUE=34
MAGENTA=35
CYAN=36
WHITE=37

# ]]]
# * << --------------------------------/

# * >>  filename ----------------------/
# [[[

if [ ${F_VIM} == 1 ]; then
    VIM_C=".vimrc"
    VIM_P=".vim/rc"
fi

if [ ${F_GIT} == 1 ]; then
    GIT_C=".gitconfig"
fi

if [ ${F_ZSH} == 1 ]; then
    ZSH_E=".zshenv"
    ZSH_C=".zsh"
fi

if [ ${F_TMUX} == 1 ]; then
    ZSH_D=".tmux-config"
    ZSH_C=".tmux.conf"
fi


# ]]]
# * << --------------------------------/

# ]]
# * << -------------------------------------------------/



# * >>  function ---------------------------------------/
# [[

msg() {
    printf "\033[$1m${@:2}\033[00m\n"
    sleep 0.1
}

key() {
    read -p "press [enter] to continue." KEY
}

switch() {
    if [ $1 == 1 ]; then
        msg $GREEN "| - [log] $2=on"
    else
        msg $GREEN "| - [log] $2=off"
    fi
}

cchk(){
    if [ ! -e $HOME/$2 ]; then
        case $1 in
            "mkdir")
                mkdir -p $2
                msg $GREEN "| - [log] $2 ${HOME}/$2" ;;
            "ln")
                ln -s $DOTH$2 $HOME/$2
                msg $GREEN "| - [log] make symbolic link ${HOME}/$2" ;;
            "cp")
                cp -r $2 $HOME/$3
                msg $GREEN "| - [log] copy $2 -> ${HOME}/$3" ;;
        esac
    else
        msg $RED "| - [msg] ${HOME}/$2 is already exist."
    fi
}

# ]]
# * << -------------------------------------------------/

case $OSTYPE in
    msys*)
        msg $RED "| - [error]"
        msg $RED "| - your environment is ${OSTYPE}."
        msg $RED "| - this script only run for linux."
        return 2>&- || exit ;;
    linux*) ;;
esac





# * >   [2] start
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

msg $BLUE "\n* > start init.sh!!\n-----------------------------"
key

switch $F_VIM "vim"
switch $F_GIT "git"
switch $F_ZSH "zsh"
switch $F_SSH "ssh"
switch $F_TMUX "tmux"
switch $F_EMACS "emacs"

if [ ! -e $CDIR ]; then
    cchk "cp" $CDIR ".dot"
fi

cd $HOME/
msg $GREEN "| - [log] cd ${HOME}"



# * >>  make dir ---------------------------------------/
# [[

msg $MAGENTA "\n* >> make directory"

if [ ${F_VIM} == 1 ]; then
    cchk "mkdir" ".vim"
fi

if [ ${F_ZSH} == 1 ]; then
    cchk "mkdir" ".zplug"
    cchk "mkdir" ".cache/zsh"
fi

if [ ${F_SSH} == 1 ]; then
    cchk "mkdir" ".ssh"
    cchk "mkdir" ".ssh/.pub"
fi

msg $MAGENTA "* >> done!"

# ]]
# * << -------------------------------------------------/



# * >>  install external file --------------------------/
# [[

# * >>  zplug -------------------------/
# [[[

if [ ${F_ZSH} == 1 ]; then
    if [ -e $HOME/.zplug ]; then
        export ZPLUG_HOME=$HOME/.zplug
        if type git >/dev/null 2>&1; then
            if [ ! -d $HOME/.zplug ]; then
                msg $MAGENTA "\n* >> clone plugin manager"
                msg $GREEN "| - [log] installing zplug..."
                git clone https://github.com/zplug/zplug $ZPLUG_HOME
                msg $MAGENTA "* >> done!"
            fi
        fi

    fi
fi

# ]]]
# * << --------------------------------/

# * >>  tmux.conf ---------------------/
# [[[

if [ ${F_TMUX} == 1 ]; then
    if [ -e $HOME/.tmux.conf ]; then
        msg $MAGENTA "\n* >> install submodule"
        msg $GREEN "| - [log] installing tmux-config..."
        cd $CDIR/$TMUX_D && git submodule init && git submodule update
        bash install.sh
        cd $CDIR
        msg $MAGENTA "* >> done!"
    fi
fi

# ]]]
# * << --------------------------------/



# * >>  create symbolic link ---------------------------/
# [[

msg $MAGENTA "\n* >> create symbolic link"

# vim
if [ ${F_VIM} == 1 ]; then
    cchk "ln" $VIM_C
    cchk "ln" $VIM_P
fi

# git
if [ ${F_GIT} == 1 ]; then
    cchk "ln" $GIT_C
fi

# zsh
if [ ${F_ZSH} == 1 ]; then
    cchk "ln" $ZSH_E
    cchk "ln" $ZSH_C
fi

# tmux
if [ ${F_TMUX} == 1 ]; then
    cchk "ln" $TMUX_C
fi

# tmux
if [ ${F_BIN} == 1 ]; then
    cchk "ln" ".bin"
fi

msg $MAGENTA "* >> done!"

# ]]
# * << -------------------------------------------------/

msg $BLUE "\n-----------------------------\n* > all done!!\n"
