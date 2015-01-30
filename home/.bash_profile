BASH_MAJMINVERSION=${BASH_VERSION%.*}
BASH_MAJVERSION=${BASH_VERSION%%.*}
BASH_MINVERSION=${BASH_MAJMINVERSION#${BASH_MAJVERSION}.}

FULLHOST=${HOSTNAME%%.*}

# source local configuration
if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi

#Start ssh in a screen session
sssh () {
    if ! ssh-add -l; then
        ssh-add
    fi
    screen -rd "$1" || screen -S "$1" "command ssh" "$1"
}

#Get a Kerberos ticket before logging into lxp
lxp () {
    if which klist &>/dev/null; then
        if klist -s; then
            command ssh lxp "$@"
        else
            kinit && command ssh lxp "$@"
        fi
    else
        command ssh lxp "$@"
    fi
}

#Check an ssh key is unlocked before sshing
ssh () {
    for token in "$@"; do
        if [ "$token" == "lxp" -o "$token" == "lxplus" -o "$token" == "lxplus.cern.ch" ]; then
            lxp "${@/$token}"
            return
        fi
    done
    if [ "${HOSTNAME#*.}" == "cern.ch" ]; then
        ssh-add -l &> /dev/null || ssh-add -t 24h && command ssh "$@"
    else
        ssh-add -l &> /dev/null || ssh-add && command ssh "$@"
    fi
}

# A few aliases to improve the console and save time
export SKOORB=skoorb.net
export SERVER=server.skoorb.net
export DESKTOP=desktop.skoorb.net
export PI=pi.skoorb.net
export PI2=pi2.skoorb.net
export LAP=laptop.skoorb.net
export LXP=lxplus.cern.ch
export LA0=linappserv0.pp.rhul.ac.uk
export LA1=linappserv1.pp.rhul.ac.uk
export LA2=linappserv2.pp.rhul.ac.uk
export LA5=linappserv5.pp.rhul.ac.uk
export AFSHOME=/afs/cern.ch/user/b/brooks
export SVNOFF=svn+ssh://svn.cern.ch/reps/atlasoff
export SVNUSR=svn+ssh://svn.cern.ch/reps/atlasusr
export SVNGRP=svn+ssh://svn.cern.ch/reps/atlasgrp
export SVNINST=svn+ssh://svn.cern.ch/reps/atlasinst
alias s="screen -dR"
alias j="jobs"
alias g="git"
alias ls="ls --color=auto"
alias sl="ls -r"
alias dir="ls *.*[^~]"
alias pdf="evince"
alias skoorb='ssh $SKOORB'
alias server='ssh $SERVER'
alias desktop='ssh $DESKTOP'
alias pi='ssh $PI'
alias pi2='ssh $PI2'
alias lap='ssh $LAP'
alias la0='ssh $LA0'
alias la1='ssh $LA1'
alias la2='ssh $LA2'
alias la5='ssh $LA5'
alias tree="tree -CA"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias screen='env screen' # Forward through env vars to get X11 DISPLAY working
alias tbrowse='python -i ~/bin/browser.py '
tmplog=/tmp/$USER/tmp.log
alias mailme='tee '$tmplog';cat '$tmplog' | mail -s "Job done" "morphit2k@googlemail.com";rm '$tmplog
alias Date='date --rfc-3339=date' # YYYY-mm-dd format date

scp () {
    # wrapper function to prevent scp of local-only files
    options="1246BCpqrvc:F:i:l:o:P:S:"
    while getopts $options option
    do
        case $option in
            1 | 2 | 4 | 6 | B | C | p | q | r | v)
                args+=($option)
                ;;
            c | F | i | l | o | P | S)
                args+=($option "$OPTARG")
                ;;
        esac
    done
    if [[ $1 != *:* && $2 != *:* ]]
    then
        echo "Are you sure you want to scp local to local?"
        echo "use 'command scp ARGS' if you're sure"
        return 1
    fi
    command scp "${args[@]}" "$1" "$2"
}

# Env vars for a few things
export EDITOR=vim
export PAGER=less
alias view="vim -R"

alias vim='vim -w ~/.vim/log'

# Set the LS_COLORS variable
if [ "${HOSTNAME}" != "linappserv0.pp.rhul.ac.uk" ]; then
    eval $(dircolors ${HOME}/.config/colors)
else
    eval $(dircolors <(grep -v "RESET\|MULTIHARDLINK\|CAPABILITY" .config/colors))
fi

# define some colors which will be used in the prompt
NO_COLOUR=$'\033[0m'
RED=$'\033[0;31m'
LIGHT_RED=$'\033[1;31m'
GREEN=$'\033[0;32m'
LIGHT_GREEN=$'\033[1;32m'
YELLOW=$'\033[0;33m'
LIGHT_YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
LIGHT_BLUE=$'\033[1;34m'
MAGENTA=$'\033[0;35m'
LIGHT_MAGENTA=$'\033[1;35m'
CYAN=$'\033[0;36m'
LIGHT_CYAN=$'\033[1;36m'
WHITE=$'\033[0;37m'
LIGHT_WHITE=$'\033[1;37m'

START_TITLE=$"\033]0;"
END_TITLE=$"\007"

function print_titlebar {
  # Echo title command sequence to the terminal
  if [ -n "$1" ]; then
    printf "${START_TITLE}%s${END_TITLE}" "$1"
  fi
}

# Don't junk up simple linux terminals
if [[ "$TERM" =~ "linux" ]];then #-o "$STY" == "" ]; then
  export PROMPT_COMMAND=""
else
  # List the screen id if this is a screen session
  if [ -n "$STY" ]; then
    TERM_TEXT="${STY#*.}"
    TERM_TEXT="[${TERM_TEXT%.$HOSTNAME}]"
  fi
  titlebar="${TERM_TEXT}@${FULLHOST#*-}:\$(PWD)"
  export PROMPT_COMMAND="print_titlebar ${titlebar}"
  export TERM=xterm-256color
fi

# Set up the prompt to display user@first_part_of_server_name
# and the pwd relative to our home directory and Testarea
function PWD {
  es=$?
  local ps1="${PWD/$TestArea/$}"
  if [ $BASH_MAJVERSION -ge 4 ] && [ $BASH_MINVERSION -ge 3 ]; then
    ps1="${ps1/$HOME/\~}"   #Bash 4.3 now expands in substitutions
  else
    ps1="${ps1/$HOME/~}"    #But prior versions didn't
  fi
  ps1="${ps1/$AFSHOME/@}"
  echo $ps1
  return $es
}

function prompt_exit() {
  #Set colour red or green based on exit code of last command
  es=$?
  if [ $es -eq 0 ]; then
    status_color="$LIGHT_GREEN"
  else
    status_color="$LIGHT_RED"
  fi
  echo $status_color
  return $es
}
PS1="\[\$(prompt_exit)\]\t\[$YELLOW\]$TERM_TEXT\[$GREEN\]@${FULLHOST#*-}\[$LIGHT_BLUE\](\j)\[$NO_COLOUR\]\$(PWD)\$(__git_ps1 '<%s')>\[$NO_COLOUR\] "

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# save infinite history
HISTSIZE=
HISTFILESIZE=

# Use Vi shortcuts
set -o vi

# Expand variables in paths in bash v4
if [ $BASH_MAJVERSION == 4 ] && [ $BASH_MINVERSION -ge 2 ]; then
    shopt -s direxpand
fi

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
    # Override dynamic completion loading to resolve aliases
    _completion_loader()
    {
        # Resolve alias
        name=${BASH_ALIASES[$1]:-$1}
        local compfile=/usr/share/bash-completion/completions
        compfile+="/${name##*/}"
        echo " -completing $1 as $name with $compfile"

        # Avoid trying to source dirs; https://bugzilla.redhat.com/903540
        # Set alias completion to real completion
        [[ -f "$compfile" ]] && . "$compfile" &>/dev/null &&
        complete -F "_$name" "$1" && return 124

        # Need to define *something*, otherwise there will be no completion at all.
        complete -F _minimal "$1" && return 124
    }
fi

if go version &> /dev/null; then
    export GOROOT=$(go env GOROOT)
fi

# Set up virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev

# Set up environment variables for Python and ROOT (Allowing pyROOT)
export PYTHONDIR=/usr/bin/python
export PYTHONSTARTUP=/home/$USER/.pythonrc

export LD_LIBRARY_PATH=$ROOTSYS/lib:$PYTHONDIR/lib:$MINUIT2DIR/lib:$PYTHIA8/lib
export PYTHONPATH=$ROOTSYS/lib:$PYTHONDIR/lib
export PATH=$HOME/.local/bin:$ROOTSYS/bin:$PATH
alias root="root -l"

# Set up ATLAS computing environment
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias atlsetup='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

# Store ssh settings in a hostname specific script
SSH_ENV="$HOME/.ssh/${HOSTNAME%%.*}.environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     # Import identities immediately
#     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
    start_agent;
fi

#Move environment between sessions, i.e. into an old screen
ENV_FILE=${HOME}/.env
push_env() {
    if [ -f $ENV_FILE ]; then
        # echo "Removing $ENV_FILE"
        rm $ENV_FILE
    fi
    # mkfifo $ENV_FILE

    for var in ${@}; do
        # eval echo ${var}=\$${var}
        eval echo ${var}=\$${var} >> $ENV_FILE
    done
}
pull_env() {
    if [ ! -e $ENV_FILE ]; then
        echo "$ENV_FILE not found!"
        return 1
    fi
    while read i; do
        # echo -n "receiving: \"$i\""
        # echo $i
        eval $i
    done < $ENV_FILE
}
#If this is a new shell, not a screen; save out the X DISPLAY variable
if [ -z "$STY" ]; then
    push_env DISPLAY
fi

# End up in /home/$USER
#cd ~
