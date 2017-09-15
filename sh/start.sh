#/bin/bash

#             __     _   _
#             \ \   | |_(_)_ __ ___ ___
#              > >  | / / | '_ \___(_-<
#             /_/   |_\_\_| .__/   /__/
#                         |_|

#       * file name : start.sh
#       * auther    : kip-s
#       * url       : https://kip-s.net
#       * ver       : 3.21

set -u
trap exit ERR

WORKDIR=$(dirname $(dirname $(readlink -f $0)))
DOTHOME="${HOME}/.dot"

## FLAG ########################################################

FLAG=("sh" "vim" "zsh" "ssh")

################################################################

msg()
{
  if [ $1 == "input" ]; then
    read -p "press [enter] to ${@:2}." KEY
  else
    local HEADERTYPE1="|-- [$1] "
    case $1 in
      error)
        local COLOR=31 #RED
        local HEADER="\n%% ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
        local FOOTER="\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
        ;;
      success)
        local COLOR=32 # GREEN
        local HEADER=${HEADERTYPE1}
        local FOOTER=""
        ;;
      failed)
        local COLOR=31 #YELLOW
        local HEADER=${HEADERTYPE1}
        local FOOTER=""
        ;;
      h1)
        local COLOR=34 #BLUE
        local HEADER="\n## WELCOME ####################################################\n"
        local FOOTER=""
        ;;
      h2)
        local COLOR=35 #PURPLE
        local HEADER="|-- [msg] "
        local FOOTER=""
        ;;
      log)
        local COLOR=1
        local HEADER=${HEADERYPE1}
        local FOOTER=""
    esac
    local HEADER="\033[${COLOR}m${HEADER}"
    local FOOTER="${FOOTER}\033[00m\n"
    printf "${HEADER}${@:2}${FOOTER}"
  fi
}

setconf ()
{
  case $1 in
    sh)
      local DIRNAME="sh"
      local MAKEDIR="bin"
      local OPTION=("dir")
      ;;
    vim)
      local DIRNAME="vim"
      local MAKEDIR=".${DIRNAME}"
      local FILENAME=("vimrc" "${MAKEDIR}/rc")
      local LINKNAME=(".vimrc" "${MAKEDIR}/rc")
      local OPTION=("dir" "link")
      ;;
    zsh)
      local DIRNAME="zsh"
      local MAKEDIR=".cache/${DIRNAME}"
      local FILENAME=("zshenv" ${DIRNAME})
      local LINKNAME=(".zshenv" ".${DIRNAME}")
      local OPTION=("dir" "link")
      ;;
    ssh)
      local DIRNAME="ssh"
      local MAKEDIR="${DIRNAME}/.pub"
      local OPTION=("dir")
      ;;
    tmux)
      local DIRNAME="tmux"
      local FILENAME=(".tmux.conf")
      local LINKNAME=(".tmux.conf")
      local OPTION=("link")
      ;;
  esac

  for c in ${OPTION[@]}
  do
    case $c in
      dir)
        local DIRPATH="${WORKDIR}/${MAKEDIR}"
        if [ -d ${DIRPATH} ]; then
          mkdir -p ${DIRPATH}
          msg success "mkdir ${DIRPATH}"
        else
          msg failed "${DIRPATH} is already exist. [directory]"
        fi
      ;;
      link)
        if [ ${#FILENAME[@]} == ${#LINKNAME[@]} ]; then
        for n in ${FILENAME[@]}
        do
          local FILEPATH+=("${WORKDIR}/${DIRNAME}/${n}")
        done
        for n in ${LINKNAME[@]}
        do
          local LINKPATH+=("${HOME}/${n}")
        done
        fi
        for (( i = 0; i < ${#FILEPATH[@]}; ++i ))
        do
          if [ ! -e ${LINKPATH[$i]} ]; then
            ln -s ${FILEPATH[$i]} ${LINKPATH[$i]}
            msg success "link ${FILEPATH[$i]} -> ${LINKPATH[$i]}"
          else
            msg failed "${LINKPATH[$i]} is already exist. [symblic link]"
          fi
        done
        unset FILEPATH LINKPATH
      ;;
    esac
  done
}

gitinstall()
{
  local GITVER="2.14.1"
  local GITFILE="v${GITVER}.tar.gz"
  msg h2 "install git-${GITVER}"
  if type wget >/dev/null 2>&1; then
    msg log "downloading git-${GITFILE}"
    https://github.com/git/git/archive/${GITFILE} /tmp/${GITFILE}
    msg log "download completed!-${GITFILE}"
    tar -zxf /tmp/${GITFILE} /tmp/${GITVER}
    cd /tmp/${GITVER}
    if type make >/dev/null 2>&1; then
      make configure
      ./configure --prefix=usr
      make all doc info
      sudo make install
    else
      msg error "your computer 'make' is not installed."
    fi
    rm -r ${GITFILE} ${GITVER}
    msg log "removed '${GITFILE}' and '${GITVER}'."
    cd ${WORKDIR}
  else
    msg error "seriously! your computer 'wget' is NOT installed!"
  fi
}

zpluginstall()
{
  msg h2 "install zplug"
  if type git >/dev/null 2>&1; then
    if [ ! -d ${HOME}/.zplug ]; then
      export ZPLUG_HOME=$HOME/.zplug
      msg log "installing zplug..."
      cchk mkdir ".zplug"
      git clone https://github.com/zplug/zplug ${ZPLUG_HOME}
      msg h2 "done"
    else
      msg h2 "skip"
    fi
  fi
}

tmuxinit()
{
  msg h2 "init submodule"
  if [ ! -e ${HOME}/.tmux.conf ]; then
    msg log "installing tmux-config..."
    if type git >/dev/null 2>&1; then
      git clone https://github.com/kip-s/${DIR_TMUX} ${WORKDIR}/${DIR_TMUX}
      cd ${WORKDIR}/${DIR_TMUX} && git submodule init && git submodule update
      cd ${WORKDIR}/${DIR_TMUX}/vendor/tmux-mem-cpu-load && cmake . && make && sudo make install
      cd ${WORKDIR}
      msg h2 "done"
    else
      msg error "your computer 'git' is not installed."
      msg failed "installation for 'zplug' was not executed"
    fi
  else
    msg h2 "skip"
  fi

  msg h2 "install tpm"
  if [ ! -e ${HOME}/.tmux ]; then
    msg log "installing tpm..."
    if type git >/dev/null 2>&1; then
      git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
      cd ${WORKDIR}
      msg h2 "done"
    else
      msg error "your computer 'git' is not installed."
      msg failed "installation for 'tpm' was not executed"
    fi
  else
    msg h2 "skip"
  fi
}

## MAIN ########################################################

msg h1 "scriptname: $0\n"

case ${OSTYPE} in
  linux*)
    ;;
  *)
    msg error "your environment is ${OSTYPE}. This script can run only on linux."
    msg input "exit"
    return 2>&- || exit
    ;;
esac

if [ ! -e ${WORKDIR} ]; then
  cp -r ${WORKDIR} ${DOTHOME}
  ${WORKDIR} = ${DOTHOME}
fi

if ! type git >/dev/null 2>&1; then
  gitinstall
fi

for f in ${FLAG[@]}
do
  msg h2 "start ${f}"
  if [ ${f} == "zsh" ]; then
    zpluginstall
  fi
  if [ ${f} == "tmux" ]; then
    tmuxinit
  fi
  setconf ${f}
  msg h2 "end ${f}\n"
done

################################################################
