#fd=0                                        # stdin
#if [[ -t "$fd" || -p /dev/stdin ]]; then    # check for interactive terminal
case $- in
*i*)                                        # interactive shell
  if [ -f $HOME/.bash_profile ]; then       # make sure .bash_profile exists
    source $HOME/.bash_profile
  fi
esac
