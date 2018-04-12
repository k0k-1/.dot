#!/bin/bash

#				* ver				: 3.63

set -u
trap exit ERR

WORKDIR=$(dirname $(readlink -f $0))
DOTHOME="${HOME}/.dot"

## FLAG ########################################################

FLAG=("submodule" "vim" "zsh" "ssh" "tmux")

################################################################

# usage: msg {input|error|success|failed|h1|h2|log} "message body"
msg()
{
	local DEBUG=0

	if [ $1 = "input" ]; then
		read -p "press [enter] to ${@:2}." KEY
	else
		local HEADERTYPE1="|-- [$1] "
		case $1 in
			error)
				local COLOR=200 #RED
				local HEADER="\n!! ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
				local FOOTER="\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
				;;
			success)
				local COLOR=47 # GREEN
				local HEADER=${HEADERTYPE1}
				local FOOTER=""
				;;
			failed)
				local COLOR=197 #RED
				local HEADER=${HEADERTYPE1}
				local FOOTER=""
				;;
			h1)
				local COLOR=110 #BLUE
				local HEADER="\n###############################################################\n"
				local FOOTER="\n###############################################################\n"
				;;
			h2)
				local COLOR=216 #ORANGE
				local HEADER="|-- [msg] "
				local FOOTER=""
				;;
			log)
				local COLOR=15 #WHITE
				local HEADER=${HEADERTYPE1}
				local FOOTER=""
				;;
			dbg)
				if [ ${DEBUG} = 1 ];then
					local COLOR=83 #GREEN
					local HEADER=${HEADERTYPE1}
					local FOOTER=""
				else
					return
				fi
				;;
		esac

		local HEADER="\x1b[38;05;${COLOR}m${HEADER}"
		local FOOTER="${FOOTER}\033[00m\n"
		printf "${HEADER}${@:2}${FOOTER}"
	fi
}

setconf ()
{
	case $1 in
		vim)
			local DIRNAME="vim"
			local MAKEDIR=".${DIRNAME}"
			local FILENAME=("vimrc" "rc")
			local LINKNAME=(".vimrc" "${MAKEDIR}/rc")
			local OPTION=("dir" "link")
			;;
		zsh)
			local DIRNAME="zsh"
			local MAKEDIR=".cache/${DIRNAME}"
			local FILENAME=("zshenv" ".")
			local LINKNAME=(".zshenv" ".${DIRNAME}")
			local OPTION=("dir" "link")
			;;
		ssh)
			local DIRNAME="ssh"
			local MAKEDIR=".${DIRNAME}/pub"
			local OPTION=("dir")
			;;
		tmux)
			local DIRNAME="tmux"
			local FILENAME=(".tmux.conf")
			local LINKNAME=(".tmux.conf")
			local OPTION=("link")
			;;
		submodule)
			msg h2 "init submodule"
			cd ${WORKDIR} && git submodule init && git submodule update
			cd ${WORKDIR}/tmux && git submodule init && git submodule update
			return
			;;
	esac

	local FILEPATH=()
	local LINKPATH=()

	for c in ${OPTION[@]}
	do
		case $c in
			dir)
				local DIRPATH="${HOME}/${MAKEDIR}"
				msg dbg "DIRPATH = ${DIRPATH}"
				if [ ! -d ${DIRPATH} ]; then
					mkdir -p ${DIRPATH}
					msg success "mkdir ${DIRPATH}"
				else
					msg failed "${DIRPATH} is already exist. [directory]"
				fi
			;;
			link)
				if [ ${#FILENAME[@]} = ${#LINKNAME[@]} ]; then
					msg dbg "FILENAME = ${#FILENAME[@]}"
					msg dbg "LINKNAME = ${#LINKNAME[@]}"
					for n in ${FILENAME[@]}
					do
						FILEPATH+=("${WORKDIR}/${DIRNAME}/${n}")
					msg dbg "FILEPATH = ${n}"
					done
					msg dbg "FILEPATH = ${#FILEPATH[@]}"
					for n in ${LINKNAME[@]}
					do
						LINKPATH+=("${HOME}/${n}")
					msg dbg "LINKPATH = ${n}"
					done
					msg dbg "LINKPATH = ${#LINKPATH[@]}"
				fi
				for ((i=0;${i}<=${#FILEPATH[@]}-1;i++))
				do
					if [ ${1} = "tmux" ]; then
						msg h2 "compile tmux plugin"
						if [ ! -e ${HOME}/${FILENAME} ]; then
							msg log "installing tmux-config..."
							if ! type cmake >/dev/null 2>&1; then
								msg error "Your computer 'cmake' is NOT installed.\nPlease execute something similar to the following command\nsudo apt install cmake build-essential"
								msg input "skip."
								continue
							else
								cd ${WORKDIR}/${DIRNAME}/vendor/tmux-mem-cpu-load && cmake . && make && sudo make install
								cd ${WORKDIR}
								msg h2 "done."
							fi
						else
							msg h2 "skip."
						fi
					fi

					msg dbg "i = ${i}"
					msg dbg "FILEPATH[${i}] = ${FILEPATH[${i}]}"
					msg dbg "LINKPATH[${i}] = ${LINKPATH[${i}]}"
					if [ ! -e ${LINKPATH[$i]} ]; then
						ln -s ${FILEPATH[$i]} ${LINKPATH[$i]}
						msg success "link ${FILEPATH[$i]} -> ${LINKPATH[$i]}"
					else
						msg failed "${LINKPATH[$i]} is already exist. [symbolic link]"
					fi

				done
				unset FILEPATH LINKPATH
			;;
		esac
	done

}


## MAIN ########################################################

msg h1 "scriptname: $0"

case ${OSTYPE} in
	linux*)
		;;
	*)
		msg error "Your environment is ${OSTYPE}. This script can run only on linux."
		msg input "exit."
		return 2>&- || exit
		;;
esac

if ! type git >/dev/null 2>&1; then
	msg error "Your computer 'git' is NOT installed."
	msg input "exit."
	return 2>&- || exit
fi

if [ ! -e ${HOME}/.gitconfig ]; then
	msg error "Your computer '.gitconfig' is NOT found."
	msg input "exit."
	return 2>&- || exit
fi

if [ ! -e ${WORKDIR} ]; then
	cp -r ${WORKDIR} ${DOTHOME}
	${WORKDIR} = ${DOTHOME}
fi

for f in ${FLAG[@]}
do
	msg h2 "start ${f}"
	setconf ${f}
	msg h2 "end ${f}\n"
done

msg h1 "all done."
################################################################
