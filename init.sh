#/bin/bash

# * >   [1] init
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

set -u

# color
RED=31
GREEN=32
YELLOW=33
BLUE=34
MAGENTA=35
CYAN=36
WHITE=37

# * >>  function ---------------------------------------/
# [[

msg() {
    printf "\033[$1m${@:2}\033[00m\n"
}

key() {
    read -p "press [enter] to continue." KEY
}

# ]]
# * << -------------------------------------------------/

case $OSTYPE in
    msys*)
        msg $RED "your environment is ${OSTYPE}."
        msg $RED "this script only run for linux."
        return 2>&- || exit
        ;;
    linux*)
        ;;
esac

msg $BLUE "\n* > start init.sh\n-----------------------------"
key

# * >>  check ------------------------------------------/
# [[

F_VIM=1
F_GIT=1
F_ZSH=1
#F_TMUX=
#F_EMACS=

# ]]
# * << -------------------------------------------------/

msg $GREEN "\nvim=${F_VIM}"
msg $GREEN "git=${F_GIT}"
msg $GREEN "zsh=${F_ZSH}"

# * >>  var --------------------------------------------/
# [[

CDIR=$(dirname $(readlink -f $0)) # ???/.dot

if [ ! -d $CDIR ]; then
    cp -r $CDIR $HOME/.dot
    msg $GREEN "copy ${CDIR} -> ${HOME}/.dot"
fi

HDOT=$HOME/.dot/

# filename
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

# ]]
# * << -------------------------------------------------/



# * >   [1] start
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

cd $HOME/
msg $GREEN "cd ${HOME}"

# * >>  make dir ---------------------------------------/
# [[

msg $MAGENTA "\n* >> make directory"

if [ ! -d $HOME/.vim ]; then
    mkdir -p .vim
    msg $GREEN "make ${HOME}/.vim"
fi

if [ ! -d $HOME/.zplug ]; then
    mkdir -p .zplug
    mkdir -p .cache/zsh
    msg $GREEN "make ${HOME}/.zplug"
    msg $GREEN "make ${HOME}/.cache/zsh"
fi

if [ ! -d $HOME/.ssh ]; then
    mkdir -p .ssh/.pub
    msg $GREEN "make ${HOME}/.ssh"
    msg $GREEN "make ${HOME}/.ssh/.pub"
fi

msg $MAGENTA "\n* >> done!"

# ]]
# * << -------------------------------------------------/

# * >>  clone ------------------------------------------/
# [[

if [type git > /dev/null 2&1]; then
    ZPLUG_HOME=$HOME/.zplug
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

# ]]
# * << -------------------------------------------------/

# * >>  create symbolic link ---------------------------/
# [[

msg $MAGENTA "\n* >> create symbolic link"

# vim
if [ ${F_VIM} == 1 ]; then
    ln -s $HDOT$VIM_C $VIM_C
    ln -s $HDOT$VIM_P $VIM_P
fi

# git
if [ ${F_GIT} == 1 ]; then
    ln -s $HDOT$GIT_C $GIT_C
fi

# zsh
if [ ${F_ZSH} == 1 ]; then
    ln -s $HDOT$ZSH_E $ZSH_E
    ln -s $HDOT$ZSH_C $ZSH_C
fi

msg $MAGENTA "\n* >> done!"

# ]]
# * << -------------------------------------------------/

msg $BLUE "\n-----------------------------\n* > all done!\n"
