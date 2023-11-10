# ~/.bash_profile

# Make sure the shell is interactive by checking if the variable `PS1` is set. This needs to be done ever
# though the `bash prompt` is not used. If everything checkouts enable bash completion if not enabled
test -n "${PS1}" && source "/usr/share/bash-completion/bash_completion" || return

# Check if hugo is installed, it installed add it to the path.
test -x "$(command -v hugo)" && source <(hugo completion bash) || return

test ! -f ~/.bashrc || source ~/.bashrc                         # Source the ~/.bashrc file if one exits.
