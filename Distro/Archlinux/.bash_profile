# ~/.bash_profile

# Make sure the shell is interactive by checking if the variable `PS1` is set. This needs to be done ever
# though the `bash prompt` is not used. If everything checkouts enable bash completion if not enabled.
test -n "${PS1}" && source "/usr/share/bash-completion/bash_completion" || return

# Source the ~/.bashrc file if one exits.
test ! -f ~/.bashrc || source ~/.bashrc
