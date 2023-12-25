# ~/.bashrc : executed by bash(1) for login shells.

# Normally this file is executed and sourced by the ~/.bashrc file. However, I think that is dumb. So instead
# the `~/.profile` is loaded as the only file.

# Set of functions to be used.

# Extract an archive file.

# Setting the more alias to use pygmentize for syntax highlighting.
function more () {

    # Check if pygmentize is installed and use it for syntax highlighting if it is. If not use the default
    # less command.
    test -x "$(command -v pygmentize)" && pygmentize -f terminal256 -g "$1" | less -R || less "$1"

    return
}

function xtract () {

    # Set the default output directory based on the file name without the extension.
    local outDir ; outDir="(echo "${1}" | awk '{print ${1}')"

    # Use case menu.
    case "${1}" in
        *.tar.bz2|*.tbz2    )    tar xvjf "${1}" -C "${outDir}"  ;;
        *.tar.gz|*.tgz      )    tar xvzf "${1}" -C "${outDir}"  ;;
        *.tar.xz|*.tar      )    tar xvf "${1}" -C "${outDir}"   ;;
        *.bz2               )    bunzip2 -vd "${1}"              ;;
        *.rar               )    rar a "${1}" "${outDir}"        ;;
        *.gz                )    gunzip "${1}"                   ;;
        *.zip               )    unzip "${1}"                    ;;
        *.7z                )    7z x "${1}"                     ;;
        *                   )
            # Echo common error regardless if file exists.
            test -f "${1}" && {
                echo "${1} archive type or file not supported!" ; return ; }
                ;;
    esac

}

# This bash profile uses Starship as the prompt, as a result the bash history needs the handled differently.
function histControl () {

    # Use the default `starship_precmd` with history -w to write the history to the history file.
    PROMPT_COMMAND="starship_precmd; history -w"

    # Ignore duplicate commands and commands that start with a space.
    HISTCONTROL="ignoreboth"

    # Ignore the following commonly used commands.
    HISTIGNORE="&:ls:[bf]g:exit:clear:history:pwd:cd:source"

    # A Larger history file size would is better.
    HISTFILESIZE="100000" ; export  HISTSIZE="1000000"

    # Add date and time for commands, with color.
    HISTTIMEFORMAT=$(echo -e "\e[${PURPLE}m%d/%m/%y %T \e[0m")

    export PROMPT_COMMAND HISTCONTROL HISTIGNORE HISTFILESIZE HISTSIZE HISTTIMEFORMAT

    # Rewrite the history file, removing all duplicates preserving the most recent version of the
    # command. This is done by reversing the order of the history file, removing duplicates, then
    # reversing the order again to put the history file back in the correct order.
    tac "${HISTFILE}" | awk '!x[$0]++' > ~/.bash_history.old
    tac ~/.bash_history.old > "${HISTFILE}"

    # Remove the temporary history file.
    test ! -f ~/.bash_history.old || rm ~/.bash_history.old > /dev/null 2>&1

}

# Make sure the shell is interactive by checking if the variable `PS1` is set. This needs to be done ever
# though the `bash prompt` is not used. If everything checkouts enable bash completion if not enabled
test ! -n "${PS1}" || source "/usr/share/bash-completion/bash_completion"

# Check if hugo is installed, it installed add it to the path.
test ! -x "$(command -v hugo)" || source <(hugo completion bash)

# Enable some useful feature that makes `bash` more like `zsh` then people think.
shopt -s checkwinsize ; shopt -s autocd     ; shopt -s cdspell ; shopt -s extglob ;

shopt -s histappend   ; shopt -s cmdhist ; shopt -s lithist     # Manage bash history.

# If `shopt -s histappend` is Then allow the history to be search if using similar command.
bind '"\033[A": history-search-backward' ; bind '"\033[B": history-search-forward'

source "/usr/share/bash-completion/bash_completion"             # Enable bash completion.

# Check if hugo is installed, it installed add it to the path.
test ! -x "$(command -v hugo)" || source <(hugo completion bash)

eval "$(dircolors -b ~/.dir_colors)"                            # Set new color scheme for `ls` command.

# Shellcheck disable=SC2034
starship_precmd_user_func="histControl"                         # Manage the bash history.

# Set ASCII 256bit color.
BLUE="38;5;63"    ; CYAN="38;5;109" ; GREEN="38;5;78"  ; ORANGE="38;5;208"
PURPLE="38;5;127" ; RED="38;5;202"  ; LIGHT="38;5;225" ; H_LIGHT="48;5;225"

# Colored GCC warnings and errors
GCC_COLORS="error=$RED:warning=$ORANGE:note=$BLUE:caret=$PURPLE:locus=$CYAN:quote=$GREEN" ; export GCC_COLORS

# Some may laugh about using nano, but I barely use a cli text editor, so there.
EDITOR=nano ; export EDITOR

# Have less display colors for manpage.
LESS_TERMCAP_mb=$(echo -e "\e[${PURPLE};3m")                    # begin bold.
LESS_TERMCAP_md=$(echo -e "\e[${PURPLE}m")                      # begin blink.
LESS_TERMCAP_so=$(echo -e "\e[${H_LIGHT};${PURPLE}m")           # begin reverse video.
LESS_TERMCAP_us=$(echo -e "\e[${LIGHT};4m")                     # begin underline.
LESS_TERMCAP_me=$(echo -e "\e[0m")                              # reset bold/blink.
LESS_TERMCAP_se=$(echo -e "\e[0m")                              # reset reverse video.
LESS_TERMCAP_ue=$(echo -e "\e[0m")                              # reset underline.

export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_so \
    LESS_TERMCAP_us LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_ue

GROFF_NO_SGR="1" ; export GROFF_NO_SGR                          # for konsole and gnome-terminal.

STARSHIP_LOG="error" ; export STARSHIP_LOG                      # Don't show Starship warnings or errors.

alias gcc='gcc -fdiagnostics-color=auto'                        # Add color to gcc.

alias inst='sudo apt install --yes'                             # Install package.
alias uinst='sudo apt purge --yes --autoremove'                 # Remove/uninstall application.
alias srch='apt search'                                         # Search for application.
alias update='sudo apt update && sudo apt upgrade --yes'        # Upgrade installed applications.
alias query='sudo apt list'                                     # Query explicitly-installed packages.

alias add='git add .'                                           # Add all changes to local git repo.
alias new='git init'                                            # Initialize new local git repo.
alias branch='git checkout'                                     # Switch between git repo branches.
alias tag='git tag -a'                                          # Create git tag.
alias delete='git branch -D'                                    # Delete git branch.
alias checkout='git checkout -b'                                # Create new git repo branch.
alias merge='git merge'                                         # Merge git repo.
alias pat='git checkout --patch'                                # Patch git repo.
alias sub='git submodule add'                                   # Add git submodule.
alias upsub='git submodule update --recursive --remote'         # Update git submodule.
alias commit='git commit -m'                                    # Commit changes with message.
alias push='git push origin $(git describe --abbrev=0)'         # Push current tag to remote.
alias github='git push origin $(git symbolic-ref --short HEAD)' # Push current branch to remote.

alias clone='gh repo clone'                                     # Clone a git repository.
alias create='gh release create'                                # Create new Github release.
alias delete='gh release delete --yes'                          # Delete Github release.
alias delasset='gh release delete-asset --yes'                  # Delete Github release asset.
alias upload='gh release upload --clobber'                      # Upload release asset.
alias repo='gh repo create'                                     # Create new Github repo.

alias ls='ls -a --color=auto'                                   # Add color to list output.
alias grep='grep --color=auto'                                  # Grep needs some color too.
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'                                # This is old but still used.

alias mkdir='mkdir -p'                                          # Assume the parent directory.

alias rm='rm -v'                                                # Force removal and verbose.
alias mv='mv -vf'                                               # Force move and verbose.

alias ln='ln -vf'                                               # Always force creating of links and verbose.

alias df='df -h'                                                # Show disk usage in human readable format.

alias cp='cp -a'                                                # Copy files and directories recursively.

alias xz='tar cvf'                                              # Create tar.xz archive.
alias gz='tar cvjf'                                             # Create tar.gz archive
alias bzip2='bzip2 -zk'                                         # Create bzip archive.
alias rar='rar a'                                               # Create rar archive.
alias gzip='gzip -9'                                            # Create gzip archive.
alias zip='zip -r'                                              # Create zip archive.
alias 7z='7z a'                                                 # Create archive using 7z.

# alias status='pihole status'                                    # Show pihole status
# alias report='cat /var/log/manhole.log | less'                  # Print log about Pihole Management.

alias key='ssh-keygen -P "" -f'                                 # Generate ssh key without passphrase and set file name.
alias copy='ssh-copy-id -i'                                     # Copy ssh key to remote server.

alias back='../'                                                # Go back one directory.
alias home='~'                                                  # Go to user home directory.

alias nas='ssh truenas'                                         # Access local TrueNAS over ssh.
alias router='ssh router'                                       # Access local router over ssh.
alias pihole='ssh pihole'                                       # Access local Pihole over ssh.
alias prox='ssh proxmox'                                        # Access local Proxmox over ssh.

alias pi='ssh docker-pi'                                        # Access local Raspberry Pi over ssh.

alias nano='nano -c'                                            # Set nano to show cursor position.

alias free='free -h'                                            # Show free memory in human readable format.

# Aliases for source projects.
alias website='code ~/Projects/website'                         # Go to website project.
alias theme='code ~/Projects/simple-dark'                       # Go to theme project.
alias skel='code ~/Projects/skel'                               # Go to skel project.
alias profile='code ~/Projects/MichaelSchaecher'                # Go to Github profile.

# Start Hugo server with no cache and build drafts.
alias server='hugo server --noHTTPCache --buildDrafts  --disableFastRender'

alias site='hugo new site --format yaml'                        # Create new Hugo site.
alias content='hugo new content'                                # Create new Hugo content.

alias reload='source ~/.profile'                                # Reload ~/.profile file.

eval "$(starship init bash)"                                    # Start Starship Prompt.
