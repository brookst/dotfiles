# source local configuration
if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
#Start ssh in a screen session
sssh () {
    screen -S $1 ssh $1
}
# A few aliases to improve the console and save time
SKOORB=skoorb.net
SERVER=tims-server.skoorb.net
DESKTOP=tims-desktop.skoorb.net
PI=pi.skoorb.net
PI2=pi2.skoorb.net
LAP=laptop.skoorb.net
LXP=lxplus.cern.ch
LA0=linappserv0.pp.rhul.ac.uk
LA1=linappserv1.pp.rhul.ac.uk
LA5=linappserv5.pp.rhul.ac.uk
AFSHOME=/afs/cern.ch/user/b/brooks
SVNOFF=svn+ssh://svn.cern.ch/reps/atlasoff
SVNUSR=svn+ssh://svn.cern.ch/reps/atlasusr
SVNGRP=svn+ssh://svn.cern.ch/reps/atlasgrp
alias ls="ls --color=auto"
alias sl="ls -r"
alias dir="ls *.*[^~]"
alias pdf="evince"
alias ssh="ssh-add -l || ssh-add && ssh"
alias skoorb="ssh $SKOORB"
alias server="ssh $SERVER"
alias desktop="ssh $DESKTOP"
alias pi="ssh $PI"
alias pi2="ssh $PI2"
alias lap="ssh $LAP"
alias lxp=sssh lxp
alias la0=sssh la0
alias la1="ssh $LA1"
alias la5="ssh $LA5"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias screen='env screen' # Forward through env vars to get X11 DISPLAY working
alias tbrowse='python -i ~/bin/browser.py '
tmplog=/tmp/$USER/tmp.log
alias mailme='tee '$tmplog';cat '$tmplog' | mail -s "Job done" "brooks@cern.ch";rm '$tmplog

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
EDITOR=vim

# define some colors which will be used in the prompt
NO_COLOUR=$'\033[0m'
LIGHT_GRAY=$'\033[0;37m'
WHITE=$'\033[1;37m'
RED=$'\033[0;31m'
LIGHT_RED=$'\033[1;31m'
GREEN=$'\033[0;32m'
LIGHT_GREEN=$'\033[1;32m'
BLUE=$'\033[0;34m'
LIGHT_BLUE=$'\033[1;34m'
YELLOW=$'\033[1;33m'
LIGHT_CYAN=$'\033[1;36m'

START_TITLE=$"\033]2;"
END_TITLE=$"\007"

# Don't junk up simple linux terminals
if [[ "$TERM" =~ "linux" ]];then #-o "$STY" == "" ]; then
  export TITLEBAR=""
# List the screen id if this is a screen session
elif [ -n "$STY" ]; then
  export TERM_TEXT="[${STY#*.}]"
  export TITLEBAR="$START_TITLE[${STY#*.}]$USER@${HOSTNAME%%.*}$END_TITLE"
  export TERM=screen-256color
# Just insert TITLEBAR in xterms etc.
else
  export TITLEBAR="$START_TITLE$USER@${HOSTNAME%%.*}$END_TITLE"
  export TERM=xterm-256color
fi
# Echo title command sequence to the terminal
echo -ne $TITLEBAR


# Set up the prompt to display user@first_part_of_server_name
# and the pwd relative to our home directory and Testarea
function PWD {
  es=$?
  PWD1="${PWD/$TestArea/$}"
  PWD2="${PWD1/$HOME/~}"
  PWD3="${PWD2/$AFSHOME/@}"
  echo $PWD3
  return $es
}

function prompt_exit() {
  es=$?
  if [ $es -eq 0 ]; then
    status_color="$LIGHT_GREEN"
  else
    status_color="$LIGHT_RED"
  fi
  echo $status_color
  return $es
}
PS1="\[$YELLOW\]$TERM_TEXT\[$GREEN\]\u@\h\[$NO_COLOUR\]\$(PWD)\[\$(prompt_exit)\]\$(__git_ps1 '<%s')>\[$NO_COLOUR\] "

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# save lots of history
HISTSIZE=5000

# Expand variables in paths
shopt -s direxpand

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
fi

export GOROOT=$(go env GOROOT)

# Set up virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev

# Set up environment variables for Python and ROOT (Allowing pyROOT)
export PYTHONDIR=/usr/bin/python
export PYTHONSTARTUP=/home/$USER/.pythonrc

export LD_LIBRARY_PATH=$ROOTSYS/lib:$PYTHONDIR/lib:$MINUIT2DIR/lib:$PYTHIA8/lib
export PYTHONPATH=$ROOTSYS/lib:$PYTHONDIR/lib
export PATH=~/bin:$ROOTSYS/bin:$PATH
alias root="root -l"

# Set up ATLAS computing environment
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias atlsetup='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
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

# End up in /home/$USER
#cd ~
