if [ -n "${-//[^i]}" ]; then                # interactive shell
  if [ -f $HOME/.bash_profile ]; then       # make sure .bash_profile exists
    source $HOME/.bash_profile
  fi
fi
