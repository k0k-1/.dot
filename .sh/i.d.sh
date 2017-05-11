#/bin/bash

#                 __       _   _
#                 \ \     | |_(_)_ __ ___ ___
#                  > >    | / / | '_ \___(_-<
#                 /_/     |_\_\_| .__/   /__/

#       * file name : i.d.sh
#       * auther    : kip-s
#       * url       : http://kip-s.net
#       * ver       : 1.10

# * »   [1] init
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

set -u
trap exit ERR

# * »»  var --------------------------------------------/
# [[

CDIR=$(dirname $(dirname $(readlink -f $0)))
DOTH=$HOME/.dot/

# * »»  check -------------------------/
# [[[

COPYHOME=0
F_VIM=1
F_GIT=1
F_ZSH=1
F_SSH=1
F_BIN=1
F_TMUX=1
F_EMACS=0

# ]]]
# * «« --------------------------------/

# * »»  coler -------------------------/
# [[[

ERRMSG=31 # red
LOGMSG=32 # green
WRNMSG=33 # yellow
H1MSG=34  # blue
H2MSG=35  # purple

# ]]]
# * «« --------------------------------/

# * »»  filename ----------------------/
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
    TMUX_D=".tmux-config"
    TMUX_C=".tmux.conf"
fi

# ]]]
# * «« --------------------------------/

# ]]
# * «« -------------------------------------------------/



# * »»  function ---------------------------------------/
# [[

# \033 = esc
msg() {
    printf "\033[$1m${@:2}\033[00m\n"
    sleep 0.1
}

key() {
    read -p "press [enter] to $@." KEY
}

switch() {
    if [ $1 == 1 ]; then
        msg $LOGMSG "| - [log] $2=on"
    else
        msg $LOGMSG "| - [log] $2=off"
    fi
}

cchk(){
    if [ ! -e $HOME/$2 ]; then
        case $1 in
            mkdir)
                mkdir -p $2
                msg $LOGMSG "| - [log] make dir '$2' ${HOME}/$2" ;;
            "ln")
                ln -s $CDIR/$2 $HOME/$2
                msg $LOGMSG "| - [log] make symbolic link ${CDIR}/$2" ;;
            "cp")
                cp -r $2 $HOME/$3
                msg $LOGMSG "| - [log] copy $2 -> ${HOME}/$3" ;;
        esac
    else
        msg $WRNMSG "| - [msg] ${HOME}/$2 is already exist."
    fi
}

# ]]
# * «« -------------------------------------------------/

case $OSTYPE in
    msys*)
        msg $ERRMSG "| - [error]"
        msg $ERRMSG "| - your environment is ${OSTYPE}."
        msg $ERRMSG "| - this script only run for linux."
        key "exit"
        return 2>&- || exit ;;
    linux*) ;;
esac





# * »   [2] start
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

msg $H1MSG "\n* » start init.sh!!\n-----------------------------"
key "start"

switch $F_VIM "vim"
switch $F_GIT "git"
switch $F_ZSH "zsh"
switch $F_SSH "ssh"
switch $F_TMUX "tmux"
switch $F_EMACS "emacs"

if [ $COPYHOME == 1 ]; then
    if [ ! -e $CDIR ]; then
        cchk cp $CDIR ".dot"
        $CDIR = $DOTH
    fi
fi

cd $HOME/
msg $LOGMSG "| - [log] cd ${HOME}"



# * »»  make dir ---------------------------------------/
# [[

msg $H2MSG "\n* »» make directory"

if [ ${F_VIM} == 1 ]; then
    cchk mkdir ".vim"
fi

if [ ${F_ZSH} == 1 ]; then
    cchk mkdir ".zplug"
    cchk mkdir ".cache/zsh"
fi

if [ ${F_SSH} == 1 ]; then
    cchk mkdir ".ssh"
    cchk mkdir ".ssh/.pub"
fi

# sh
if [ ${F_BIN} == 1 ]; then
    cchk mkdir ".bin"
fi

msg $H2MSG "* »» done!"

# ]]
# * «« -------------------------------------------------/



# * »»  install external file --------------------------/
# [[

# * »»  git ---------------------------/
# [[[

GIT_VER="2.13.0-rc1"
GIT_FN="v${GIT_VER}.tar.gz"

if ! type git >/dev/null 2>&1; then
    if [ ${F_BIN} == 1 && ${F_GIT} == 1 ]; then
        msg $H2MSG "\n* »» install git-${GIT_VER}"
        if type wget >/dev/null 2>&1; then
            msg $LOGMSG "| - [log] downloading git-$GIT_FN"
            wget https://github.com/git/git/archive/$GIT_FN /tar/$GIT_FN
            msg $LOGMSG "| - [log] downloaded git-$GIT_FN"
            cd /tmp/
            tar -zxf $GIT_FN $GIT_VER
            cd /tmp/$GIT_VER
            if type make >/dev/null 2>&1; then
                make configure
                ./configure --prefix=usr
                make all doc info
                sudo make install
            else
                msg $ERRMSG "| - [error] your computer 'make' is not installed."
            fi
            rm -r $GIT_FN $GIT_VER
            msg $LOGMSG "| - [log] removed '${GIT_FN}' and '${GIT_VER}'."
            cd $CDIR
        else
            msg $ERRMSG "| - [error] seriously! your computer 'wget' is NOT installed!"
        fi
    fi
fi

# ]]]
# * «« --------------------------------/



# * »»  zplug -------------------------/
# [[[

if [ ${F_ZSH} == 1 ]; then
    msg $H2MSG "\n* »» install zplug"
    if type git >/dev/null 2>&1; then
        if [ ! -d $HOME/.zplug ]; then
            export ZPLUG_HOME=$HOME/.zplug
            msg $LOGMSG "| - [log] installing zplug..."
            git clone https://github.com/zplug/zplug $ZPLUG_HOME
            msg $H2MSG "* »» done"
        else
            msg $H2MSG "* »» skip"
        fi
    fi
fi

# ]]]
# * «« --------------------------------/

# * »»  tmux.conf ---------------------/
# [[[

if [ ${F_TMUX} == 1 ]; then
    msg $H2MSG "\n* »» init submodule"
    if [ ! -e $HOME/.tmux.conf ]; then
        msg $LOGMSG "| - [log] installing tmux-config..."
        cd $CDIR/$TMUX_D && git submodule init && git submodule update
        bash install.sh
        cd $CDIR
        msg $H2MSG "* »» done"
    else
        msg $H2MSG "* »» skip"
    fi
fi

if [ ${F_TMUX} == 1 ]; then
    msg $H2MSG "\n* »» install tpm"
    if type git >/dev/null 2>&1; then
    if [ ! -e $HOME/.tmux ]; then
        msg $LOGMSG "| - [log] installing tpm..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        cd $CDIR
        msg $H2MSG "* »» done"
    else
        msg $H2MSG "* »» skip"
    fi
    fi
fi

# ]]]
# * «« --------------------------------/



# * »»  create symbolic link ---------------------------/
# [[

msg $H2MSG "\n* »» create symbolic link"

# vim
if [ ${F_VIM} == 1 ]; then
    cchk ln $VIM_C
    cchk ln $VIM_P
fi

# git
if [ ${F_GIT} == 1 ]; then
    cchk ln $GIT_C
fi

# zsh
if [ ${F_ZSH} == 1 ]; then
    cchk ln $ZSH_E
    cchk ln $ZSH_C
fi

# tmux
if [ ${F_TMUX} == 1 ]; then
    cchk ln $TMUX_C
fi

# sh
if [ ${F_BIN} == 1 ]; then
    cchk ln ".sh"
fi

msg $H2MSG "* »» done!"

# ]]
# * «« -------------------------------------------------/

msg $H1MSG "\n-----------------------------\n* » all done!!\n"
