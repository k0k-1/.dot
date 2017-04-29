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
    sleep 0.1
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

msg $BLUE "\n* > start init.sh!!\n-----------------------------"
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

if [ ! -e $HOME/.vim ]; then
    mkdir -p .vim
    msg $GREEN "make ${HOME}/.vim"
else
    msg $RED "\n${HOME}/.vim is already exist."
fi

if [ ! -e $HOME/.zplug ]; then
    mkdir -p .zplug
    mkdir -p .cache/zsh
    msg $GREEN "make ${HOME}/.zplug"
    msg $GREEN "make ${HOME}/.cache/zsh"

    #if [type git > /dev/null 2&1]; then
    #    msg $MAGENTA "\n* >> clone plugin manager"
    #    msg $GREEN "installing zplug..."
    #
    #    ZPLUG_HOME=$HOME/.zplug
    #    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    #
    #    msg $MAGENTA "\n* >> done!"
    #fi
else
    msg $RED "\n${HOME}/.zplug is already exist."
fi

if [ ! -e $HOME/.ssh ]; then
    mkdir -p .ssh/.pub
    msg $GREEN "make ${HOME}/.ssh"
    msg $GREEN "make ${HOME}/.ssh/.pub"
else
    msg $RED "\n${HOME}/.ssh is already exist."
fi

msg $MAGENTA "\n* >> done!"

# ]]
# * << -------------------------------------------------/

# * >>  create symbolic link ---------------------------/
# [[

msg $MAGENTA "\n* >> create symbolic link"

# vim
if [ ${F_VIM} == 1 ]; then
    if [ ! -e $HOME/$VIM_C ]; then
        ln -s $HDOT$VIM_C $HOME/$VIM_C
    else
        msg $RED "\n${HOME}/${VIM_C} is already exist."
    fi
    if [ ! -e $HOME/$VIM_P ]; then
        ln -s $HDOT$VIM_P $HOME/$VIM_P
    else
        msg $RED "\n${HOME}/${VIM_P} is already exist."
    fi
fi

# git
if [ ${F_GIT} == 1 ]; then
    if [ ! -e $HOME/$GIT_C ]; then
        ln -s $HDOT$GIT_C $HOME/$GIT_C
    else
        msg $RED "\n${HOME}/${GIT_C} is already exist."
    fi
fi

# zsh
if [ ${F_ZSH} == 1 ]; then
    if [ ! -e $HOME/$ZSH_E ]; then
        ln -s $HDOT$ZSH_E $HOME/$ZSH_E
    else
        msg $RED "\n${HOME}/${ZSH_E} is already exist."
    fi
    if [ ! -e $HOME/$ZSH_C ]; then
        ln -s $HDOT$ZSH_C $HOME/$ZSH_C
    else
        msg $RED "\n${HOME}/${ZSH_C} is already exist."
    fi
fi

msg $MAGENTA "\n* >> done!"

# ]]
# * << -------------------------------------------------/

msg $BLUE "\n-----------------------------\n* > all done!!\n"
