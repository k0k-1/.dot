#               ,______________________,
#               |****;/''   /*********/
#               |**7'      /*********/
#               |;(       /*********/
#                       /'********/'
#                      /*********/
#                    /'********/'
#                   /*********/       _.
#                 /'********/'       )*|
#                /*********/       ,7**|
#               /*********/______/*****|
#               """"""""""""""""""""""""
#               __              _
#               \ \      ___ __| |_
#                > >    |_ /(_-< ' \
#               /_/     /__|___/_||_|     ___
#                                        |___|

#       * file name : .zshrc
#       * auther    : kip-s
#       * url       : http://kip-s.net
#       * ver       : 3.00

#       * contents  : [1] general
#                           > complement
#                           > history
#                           > path
#                           > plugin
#                           > alias

#                     [2] look
#                           > theme
#                           > ls color
#                           > prompt
#                               > prompt reset

#                     [3] os
#                           > linux
#                           > mac os
#                           > windows





# * >   [1] general
# -------------------------------------------                            /
# ----------------------------------------------------------------------/
# [

export EDITOR=vim
export LANG=en_US
export ENCODE=UTF-8
export LC_CTYPE=$LANG.$ENCODE
export LC_ALL=$LANG.$ENCODE
export KCODE=u

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

setopt auto_pushd
setopt auto_cd
setopt no_beep
setopt no_list_beep
alias history='history -E'
alias v='vim .'



# * >>  complement -------------------------------------/
# [[

autoload -U compinit; compinit
setopt auto_list 
setopt auto_menu 
setopt list_packed 
setopt list_types
bindkey "^[[Z" reverse-menu-complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt correct
setopt extended_glob
unsetopt caseglob
autoload predict-on
fpath=($ZDOTDIR/rc/completion $fpath)


# ]]
# * << -------------------------------------------------/



# * >>  history ----------------------------------------/
# [[

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt bang_hist
setopt extended_history
setopt hist_ignore_dups
setopt share_history
setopt hist_reduce_blanks
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
function history-all { history -E 1 }

# ]]
# * << -------------------------------------------------/



# * >>  path -------------------------------------------/
# [[

if (( $+commands[go] )); then
    if [ -d $HOME/.go ]; then
        export GOPATH=$HOME/.go
        export PATH=$GOPATH/bin:$PATH
        export GO15VENDOREXPERIMENT=1
    fi
fi

# ]]
# * << -------------------------------------------------/



# * >>  plugin -----------------------------------------/
# [[

if (( $+commands[git] )); then
    if [ -f $ZDOTDIR/.zplug ]; then
        source $ZDOTDIR/.zplug
    fi
fi

if [ -f $GOPATH/bin/peco ]; then
    function peco-select-history() {
        local tac
        local tacv=${commands[tac]:-"tail -r"}
        BUFFER=$(\history -n 1 | \
        eval $tac | \
#        local tac
#        if which tac > /dev/null; then
#            tac="tac"
#        else
#            tac="tail -r"
#        fi
#        BUFFER=$(\history -n 1 | \
#        eval $tac | \
        peco --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle clear-screen
    }
    zle -N peco-select-history
    bindkey '^r' peco-select-history 
fi

# ]]
# * << -------------------------------------------------/



# * >>  alias -------------------------------------------/
# [[

function runcpp () { g++ $1 && shift && ./a.out $@ }
alias -s {c,cpp}=runcpp

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
    *.rar) unrar $1;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz,rar}=extract

if (( $+commands[git] )); then
    function git() {
        if [ -f $HOME/.gitconfi ]; then
            mv $HOME/.gitconfi $HOME/.gitconfig
        fi
            builtin git $@
        if [ -f $HOME/.gitconfig ]; then
            mv $HOME/.gitconfig $HOME/.gitconfig
        fi
    }
fi

autoload -Uz zmv
alias zmv='noglob zmv -W'
alias fuck='eval $(thefuck $(fc -ln -1))'
alias diff='diff -u'

# * >>> color --------------------------/

# * >>>> cat
if (( $+commands[pymentize] )); then
    alias cat='pygmentize -O style=monokai -f console256 -g'
fi

# * >>>> diff
if (( $+commands[colordiff] )); then
    alias diff='colordiff -u'
fi

# * >>>> less
export MANPAGER='less -R'
function man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# * >>>> grep
alias grep='grep --color'

# * >>>> grc
if (( $+commands[grc] )); then
    alias mount='grc mount'
    alias ifconfig='grc ifconfig'
    alias dig='grc dig'
    alias ldap='grc ldap'
    alias netstat='grc netstat'
    alias ping='grc ping'
    alias ps='grc ps'
    alias traceroute='grc traceroute'
    alias gcc='grc gcc'
    alias g++='grc g++'
fi

# * <<< --------------------------------/


# ]]
# * << -------------------------------------------------/

# ]





# * >   [2] look
# -------------------------------------------                           /
# ---------------------------------------------------------------------/
# [

autoload -Uz vcs_info
setopt transient_rprompt
setopt prompt_subst



# * >>  theme ------------------------------------------/
# [[

autoload -U colors; colors
export TERM=xterm-256color

# ]]
# * << -------------------------------------------------/



# * >>  ls color ---------------------------------------/
# [[

export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='no=00;38;5;244:rs=0:di=00;38;5;33:ln=00;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:cd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:ca=30;41:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:ex=00;38;5;64:'
if ! [[ $OSTYPE = msys* ]]; then
    if [ -f $ZDOTDIR/.dircolors ]; then
        if (( $+commands[dircolors] )); then
            eval $(dircolors $ZDOTDIR/.dircolors)
        elif (( $+commands[gdircolors] )); then
            eval $(gdircolors $ZDOTDIR/.dircolors)
        fi
    fi
fi
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

alias ls='ls -F --color=auto --group-directories-first'

function cd() {
    builtin cd $@ && ls;
}

# ]]
# * << -------------------------------------------------/



# * >>  prompt -----------------------------------------/
# [[

PROMPT="[%~]%(!,#,$) "
RPROMPT="[%n|%m|%w|%*]"
SPROMPT="%r is correct [n,y,a,e]: "

if [[ $TERM = xterm* ]];then
    z_d_gray=237
    z_white=15
    z_blue=31
    z_red=161

    z_bg=$z_d_gray
    z_fg=$z_white
    z_c=%F{$z_fg}%K{$z_bg}
    z_body="$z_c %~ $z_c%F{$z_white}%(?.%K{$z_blue}.%K{$z_red}) * %f%k "

    case ${UID} in
        0) #root
            z_uc=$z_red;;
        *)
            z_uc=$z_blue;;
    esac

    PROMPT=$z_body
    RPROMPT="%F{$z_fg}%K{$z_uc} %n $z_c %m $z_c|$z_c %w $z_c|$z_c %* %f%k"

    if (( $+commands[python] )); then
        if [ -f $ZDOTDIR/rc/prompt.py ]; then
            function u_prompt() {
                if [ -f $ZDOTDIR/rc/prompt.py ]; then
                    export PROMPT="$(~/.zsh/rc/prompt.py $?)"
                else
                    PROMPT=$z_body
                fi
            }
            precmd() { u_prompt }
        fi
    fi
fi



# * >>> prompt reset (time sync) -------/

zmodload zsh/datetime
reset_tmout() { TMOUT=$[1-EPOCHSECONDS%1] }
precmd_functions=($precmd_functions reset_tmout)
redraw_tmout() { zle reset-prompt; reset_tmout }
TRAPALRM() { redraw_tmout }

# * <<< --------------------------------/

# ]]
# * << -------------------------------------------------/

# ]





# * >   [3] os
# -------------------------------------------                           /
# ---------------------------------------------------------------------/
# [

case $OSTYPE in #uname http://en.wikipedia.org/wiki/Uname
    # linux
    linux*)
        if [ -f $HOME/.tmux.conf ]; then 
            [[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]] && tmux
        fi
        ;;
    # mac os
    darwin*)
        alias ls='ls -G -F -L'
        function cd() {
            builtin cd $@ && ls;
        }
        ;;
    #windows
    CYGWIN*)
        ;;
    msys*)
        alias shutdown='shutdown -s -f'
        if (( $+commands[winpty] )); then
            alias cl='winpty cl'
            alias diskpart='winpty diskpart'
            alias sdelete='winpty sdelete'
            alias mysql='winpty mysql'
        fi
        ;;
esac

# ]





# * >   [4] local setting
# -------------------------------------------                           /
# ---------------------------------------------------------------------/
# [

if [ -d $HOME/.cache/zsh ]; then
    if [ -f $HOME/.cache/zsh/.zsh_local ]; then
        source $HOME/.cache/zsh/.zsh_local
    fi
fi

# ]
