#/bin/bash

#                 __       _   _
#                 \ \     | |_(_)_ __ ___ ___
#                  > >    | / / | '_ \___(_-<
#                 /_/     |_\_\_| .__/   /__/

#       * file name : start.sh
#       * auther    : kip-s
#       * url       : https://kip-s.net
#       * ver       : 2.01

# * »   [1] init
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

set -u
trap exit ERR

# * »»  var --------------------------------------------/
# [[

WORK_DIR=$(dirname $(dirname $(readlink -f $0)))
DOTHOME=$HOME/.dot/

# * »»  flugs -------------------------/
# [[[

COPYHOME=0
FLAG_VIM=1
FLAG_GIT=1
FLAG_ZSH=1
FLAG_SSH=1
FLAG_BIN=1
FLAG_TMUX=1
FLAG_EMACS=0
FLAG_SH=1

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

if [ ${FLAG_VIM} == 1 ]; then
  CONFIG_VIM="vimrc"
  LINK_CONFIG_VIM=".vimrc"
  DIR_VIM="vim/rc"
  LINK_DIR_VIM=".vim/rc"
fi

if [ ${FLAG_GIT} == 1 ]; then
  CONFIG_GIT=".gitconfig"
  LINK_CONFIG_GIT=$CONFIG_GIT
fi

if [ ${FLAG_ZSH} == 1 ]; then
  CONFIG_ZSH="zshenv"
  LINK_CONFIG_ZSH=".zshenv"
  DIR_ZSH="zsh"
  LINK_DIR_ZSH=".zsh"
fi

if [ ${FLAG_TMUX} == 1 ]; then
  DIR_TMUX="tmux-config"
  LINK_DIR_TMUX=$DIR_TMUX
  CONFIG_TMUX=".tmux.conf"
  LINK_CONFIG_TMUX=$CONFIG_TMUX
fi

if [ ${FLAG_SH} == 1 ]; then
  DIR_SH="sh"
  LINK_DIR_SH=".sh"
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
                ln -s $WORK_DIR/$3 $HOME/$2
                msg $LOGMSG "| - [log] make symbolic link ${HOME}/$2" ;;
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

switch $FLAG_VIM "vim"
switch $FLAG_GIT "git"
switch $FLAG_ZSH "zsh"
switch $FLAG_SSH "ssh"
switch $FLAG_TMUX "tmux"
switch $FLAG_EMACS "emacs"

if [ $COPYHOME == 1 ]; then
    if [ ! -e $WORK_DIR ]; then
        cchk cp $WORK_DIR ".dot"
        $WORK_DIR = $DOTHOME
    fi
fi

cd $HOME/
msg $LOGMSG "| - [log] cd ${HOME}"



# * »»  make dir ---------------------------------------/
# [[

msg $H2MSG "\n* »» make directory"

if [ ${FLAG_VIM} == 1 ]; then
    cchk mkdir ".vim"
fi

if [ ${FLAG_ZSH} == 1 ]; then
    cchk mkdir ".cache/zsh"
fi

if [ ${FLAG_SSH} == 1 ]; then
    cchk mkdir ".ssh"
    cchk mkdir ".ssh/.pub"
fi

# sh
if [ ${FLAG_BIN} == 1 ]; then
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
    if [ ${FLAG_BIN} == 1 && ${FLAG_GIT} == 1 ]; then
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
            cd $WORK_DIR
        else
            msg $ERRMSG "| - [error] seriously! your computer 'wget' is NOT installed!"
        fi
    fi
fi

# ]]]
# * «« --------------------------------/



# * »»  zplug -------------------------/
# [[[

if [ ${FLAG_ZSH} == 1 ]; then
    msg $H2MSG "\n* »» install zplug"
    if type git >/dev/null 2>&1; then
        if [ ! -d $HOME/.zplug ]; then
            export ZPLUG_HOME=$HOME/.zplug
            msg $LOGMSG "| - [log] installing zplug..."
            cchk mkdir ".zplug"
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

if [ ${FLAG_TMUX} == 1 ]; then
    msg $H2MSG "\n* »» init submodule"
    if [ ! -e $HOME/.tmux.conf ]; then
        msg $LOGMSG "| - [log] installing tmux-config..."
        cd $WORK_DIR/$DIR_TMUX && git submodule init && git submodule update
        cd $WORK_DIR/$DIR_TMUX/vendor/tmux-mem-cpu-load && cmake . && make && sudo make install
        cd $WORK_DIR
        msg $H2MSG "* »» done"
    else
        msg $H2MSG "* »» skip"
    fi
fi

if [ ${FLAG_TMUX} == 1 ]; then
    msg $H2MSG "\n* »» install tpm"
    if type git >/dev/null 2>&1; then
    if [ ! -e $HOME/.tmux ]; then
        msg $LOGMSG "| - [log] installing tpm..."
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
        cd $WORK_DIR
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
if [ ${FLAG_VIM} == 1 ]; then
    cchk ln $LINK_CONFIG_VIM $CONFIG_VIM
    cchk ln $LINK_DIR_VIM $DIR_VIM
fi

# git
if [ ${FLAG_GIT} == 1 ]; then
    cchk ln $LINK_CONFIG_GIT $CONFIG_GIT
fi

# zsh
if [ ${FLAG_ZSH} == 1 ]; then
    cchk ln $LINK_CONFIG_ZSH $CONFIG_ZSH
    cchk ln $LINK_DIR_ZSH $DIR_ZSH
fi

# tmux
if [ ${FLAG_TMUX} == 1 ]; then
    cchk ln $LINK_CONFIG_TMUX $CONFIG_TMUX
    tmux source-file $HOME/.tmux.conf
fi

# sh
if [ ${FLAG_BIN} == 1 ]; then
    cchk ln $LINK_DIR_SH $DIR_SH
fi

msg $H2MSG "* »» done!"

# ]]
# * «« -------------------------------------------------/

msg $H1MSG "\n-----------------------------\n* » all done!!\n"
