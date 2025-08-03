# shellcheck disable=SC2148
# ~/.bashrc : executed by bash(1) for login shells.

# Normally this file is executed and sourced by the ~/.bashrc file. However, I think that is dumb. So instead
# the `~/.profile` is loaded as the only file.

# Set of functions to be used.

# Use function for creating git tags
function tag () {

    # Check if the tag already exists and if it does then delete it.
    test -z "$(git tag -l "${1}")" || { echo "Tag already exists!" ; return ; }
    # Create the tag using the first argument as the name and the second argument as the message.
    git tag -a "${1}" -m "${2}"

}

# Copy to local/remote server over ssh.
function sp () { scp -r "${1}" "${3}":"${2}" ; }

# Copy from local/remote server over ssh.
function spf () { scp -r "${3}":"${2}" "${1}" ; }

# Setting the more alias to use pygmentize for syntax highlighting.
function more () {

    # Check if pygmentize is installed and use it for syntax highlighting if it is. If not use the default
    # less command.
    test -x "$(command -v pygmentize)" && pygmentize -f terminal256 -g "$1" | less -R || less "$1"
}

function xtract () {

    # shellcheck disable=SC2027
    local outDir ; outDir="(echo ${1} | awk '{print ${1}')"           # Set output directory based on file name.

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
            test -f "${1}" && { echo "${1} archive type or file not supported!" ; return ; }
        ;;
    esac

}

# Make sure the shell is interactive by checking if the variable `PS1` is set. This needs to be done ever
# though the `bash prompt` is not used. If everything checkouts enable bash completion if not enabled
test ! -n "${PS1}" && return || source "/usr/share/bash-completion/bash_completion"

# Enable some useful feature that makes `bash` more like `zsh` then people think.
shopt -s checkwinsize autocd cdspell extglob histappend cmdhist lithist

# If `shopt -s histappend` is Then allow the history to be search if using similar command.
bind '"\e[A": history-search-backward' ; bind '"\e[B": history-search-forward'

# Check if hugo is installed, it installed add it to the path.
test ! -x "$(command -v hugo)" || source <(hugo completion bash)

# Source starship completions.
test ! -x "$(command -v starship)" || source <(starship completions bash)

# Source the right config file for starship based if the file ~/.web is present and that not connected
# over ssh. This is for if you login via web browser only. This is done because most web browsers default
# fonts are not nerd fonts, so the icons don't show up correctly.

# Add .local/bin to the path.
test -d ~/.local/bin && PATH="${PATH}:$HOME/.local/bin" || true

# System colors using the 256 color palette.
b='38;5;0'   ; r='38;5;1'   ; g='38;5;2'    ; y='38;5;3'    ; p='38;5;5'    ; c='38;5;6'

# Colored GCC warnings and errors
GCC_COLORS="error=$r:warning=$b:note=$p:caret=$y:locus=$c:quote=$g" ; export GCC_COLORS

EDITOR=nano                                  ; export EDITOR            # Set the default editor to nano.

STARSHIP_LOG="errors"                        ; export STARSHIP_LOG      # Don't show errors for Starship.

# Have less display colors for manpage.
LESS_TERMCAP_mb=$'\e[95m'                   ; export LESS_TERMCAP_mb   # blinking (rare) → fuchsia
LESS_TERMCAP_md=$'\e[1;95m'                 ; export LESS_TERMCAP_md   # begin
LESS_TERMCAP_me=$'\e[0m'                    ; export LESS_TERMCAP_me   # begin bold
LESS_TERMCAP_se=$'\e[0m'                    ; export LESS_TERMCAP_se
LESS_TERMCAP_so=$'\e[1;45;97m'              ; export LESS_TERMCAP_so   # begin reverse video → magenta background, white foreground
LESS_TERMCAP_ue=$'\e[0m'                    ; export LESS_TERMCAP_ue   # end underline
LESS_TERMCAP_us=$'\e[35m'                   ; export LESS_TERMCAP_us   # reset reverse video

GROFF_NO_SGR="1"                             ; export GROFF_NO_SGR      # for konsole and gnome-terminal.

### APT ALIASES ###
alias update='sudo apt update && sudo apt dist-upgrade --yes'           # Upgrade installed applications.
alias query='sudo apt list'                                             # Query explicitly-installed packages.
alias inst='sudo apt install --yes'                                     # Install package.
alias uinst='sudo apt purge --yes --autoremove'                         # Remove/uninstall application.
alias srch='apt search'                                                 # Search for package.
alias clean='sudo apt clean && sudo apt autoclean'                      # Clean up apt cache.

alias server='hugo server --noHTTPCache --buildDrafts  --disableFastRender'
alias site='hugo new site --format yaml'                                # Create new Hugo site.
alias content='hugo new content'                                        # Create new Hugo content.
alias syntax='hugo gen chromastyles --style'                            # Generate Hugo syntax highlighting style.

### GIT AND GITHUB ALIASES ###
alias initial='git init'                                                # Show git status.
alias add='git add --all'                                               # Add all changes to local git repo.
alias branch='git checkout'                                             # Switch between git repo branches.
alias delete='git branch -D'                                            # Delete git branch.
alias checkout='git checkout -b'                                        # Create new git repo branch.
alias merge='git merge'                                                 # Merge git repo.
alias patches='git checkout --patch'                                    # Patch git repo.
alias gitmod='git submodule add'                                        # Add git submodule.
alias gitmodup='git submodule update --recursive --remote'              # Update git submodule.
alias commit='git commit -m'                                            # Commit changes with message.
alias push='git push origin'                                            # Push current tag to remote.

alias github='gh repo create'                                           # Create new Github repo.
alias clone='gh repo clone'                                             # Clone a git repository.
alias gitsrch='gh search repos -L 50 --sort updated'                    # Search Github repos.
alias release='gh release create'                                       # Create new Github release.
alias remove='gh release delete-asset --yes'                            # Delete Github release asset.
alias upload='gh release upload --clobber'                              # Upload release asset.

### EXA ALIASES ###
alias ls='exa --git --color=always'                                     # Use exa instead of ls.
alias ll='exa -l --git --color=always'                                  # Use exa with ll alias instead of ls.
alias la='exa -la --git --color=always'                                 # Use exa with la alias instead of ls.
alias lt='exa -T --git --color=always'                                  # Use exa with lt alias instead of ls.

### GERP ALIASES ###
alias grep='grep --color=auto'                                          # Grep needs some color too.
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'                                        # This is old but still used.

### UTILITIES ALIASES ###
alias mkdir='mkdir -vp'                                                 # Assume the parent directory.
alias cp='cp -av'                                                       # Copy files and directories recursively.
alias rm='rm -v'                                                        # Remove files and verbose.
alias mv='mv -v'                                                        # Move files and verbose.

alias ln='ln -v'                                                        # Always force creating of links and verbose.

alias free='free -h'                                                    # Show free memory in human readable format.
alias df='df -h'                                                        # Show disk usage in human readable format.

### ARCHIVE ALIASES ###
alias xz='tar cvf'                                                      # Create tar.xz archive.
alias gz='tar cvjf'                                                     # Create tar.gz archive
alias bzip2='bzip2 -zk'                                                 # Create bzip archive.
alias rar='rar a'                                                       # Create rar archive.
alias gzip='gzip -9'                                                    # Create gzip archive.
alias zip='zip -r'                                                      # Create zip archive.
alias 7z='7z a'                                                         # Create archive using 7z.

### SSH ALIASES ###
alias key='ssh-keygen -P "" -f'                                         # Generate no passphrase ssh key.
alias csk='ssh-copy-id -i'                                              # Copy ssh key to remote server.

test -x "$(command -v pihole)" ||
alias pihole='ssh pihole'                                               # Access local Pihole over ssh in not logged in to server.

alias gcc='gcc -fdiagnostics-color=auto'                                # Add color to gcc.

alias nano='nano -c'                                                    # Set nano to show cursor position.

### DIRECTORY ALIASES ###
alias bk='../'                                                          # Go back one directory.
alias home='~'                                                          # Go to user home directory.

alias site='~/Projects/website'                                         # Go to website project.
alias theme='~/Projects/simple-dark'                                    # Go to theme project.
alias skel='~/Projects/skel'                                            # Go to skel project.
alias pro='~/Projects/MichaelSchaecher'                                 # Go to Github profile.

alias helpful='cat ~/.helpful'                                          # Show helpful commands.

alias reload='source ~/.profile'                                        # Reload ~/.profile file.

alias hist='history'                                                    # Show bash history.

alias ping='ping -c 10'                                                 # Ping 10 times.

eval "$(ssh-agent -s)" || true

# Initialize Starship and run histControl function.
eval "$(starship init bash)"
