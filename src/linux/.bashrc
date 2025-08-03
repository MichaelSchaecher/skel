# shellcheck disable=SC2148
# ~/.bashrc : executed by bash(1) for login shells.

# Normally this file is executed and sourced by the ~/.bashrc file. However, I think that is dumb. So instead
# the `~/.profile` is loaded as the only file.

# Set of functions to be used.

# Use function for creating git tags
function tag () {

    test -z "$(git tag -l "${1}")" || { echo "Tag already exists!" ; return ; }
    git tag -a "${1}" -m "${2}"

}

# Copy to local/remote server over ssh.
function sp () { scp -r "${1}" "${3}":"${2}" ; }

# Copy from local/remote server over ssh.
function spf () { scp -r "${3}":"${2}" "${1}" ; }

# Setting the more alias to use pygmentize for syntax highlighting.
function more () {

    test -x "$(command -v pygmentize)" && pygmentize -f terminal256 -g "$1" | less -R || less "$1"
}

function xtract () {

    # shellcheck disable=SC2027
    local outDir ; outDir="(echo ${1} | awk '{print ${1}')"

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

# shellcheck disable=SC1091
test ! -n "${PS1}" || source "/usr/share/bash-completion/bash_completion"

# Enable some useful feature that makes `bash` more like `zsh` then people think.
shopt -s checkwinsize autocd cdspell extglob histappend cmdhist lithist

# Key bindings for history search.
bind '"\e[A": history-search-backward' ; bind '"\e[B": history-search-forward'

# shellcheck disable=SC1090
test ! -x "$(command -v hugo)" || source <(hugo completion bash)

# shellcheck disable=SC1090
test ! -x "$(command -v starship)" || source <(starship completions bash)

# Add .local/bin to the path.
test -d ~/.local/bin && PATH="${PATH}:$HOME/.local/bin"

# System colors using the 256 color palette.
b='38;5;0'   ; r='38;5;1'   ; g='38;5;2'    ; y='38;5;3'    ; p='38;5;5'    ; c='38;5;6'

# Colored GCC warnings and errors
GCC_COLORS="error=$r:warning=$b:note=$p:caret=$y:locus=$c:quote=$g" ; export GCC_COLORS

EDITOR=nano                                  ; export EDITOR

STARSHIP_LOG="errors"                        ; export STARSHIP_LOG

# Have less display colors for manpage.
LESS_TERMCAP_mb=$'\e[95m'                   ; export LESS_TERMCAP_mb   # blinking (rare) → fuchsia
LESS_TERMCAP_md=$'\e[1;95m'                 ; export LESS_TERMCAP_md   # begin
LESS_TERMCAP_me=$'\e[0m'                    ; export LESS_TERMCAP_me   # begin bold
LESS_TERMCAP_se=$'\e[0m'                    ; export LESS_TERMCAP_se

# begin reverse video → magenta background, white foreground
LESS_TERMCAP_so=$'\e[1;45;97m'              ; export LESS_TERMCAP_so

LESS_TERMCAP_ue=$'\e[0m'                    ; export LESS_TERMCAP_ue   # end underline
LESS_TERMCAP_us=$'\e[35m'                   ; export LESS_TERMCAP_us   # reset reverse video

GROFF_NO_SGR="1"                             ; export GROFF_NO_SGR      # for konsole and gnome-terminal.

### APT ALIASES ###
alias update='sudo apt update && sudo apt dist-upgrade --yes'
alias query='sudo apt list'
alias inst='sudo apt install --yes'
alias uinst='sudo apt purge --yes --autoremove'
alias srch='apt search'
alias clean='sudo apt clean && sudo apt autoclean'

### HUGO ALIASES ###
alias server='hugo server --noHTTPCache --buildDrafts  --disableFastRender'
alias site='hugo new site --format yaml'
alias content='hugo new content'
alias syntax='hugo gen chromastyles --style'

# Switch between Github Auth accounts depending on the current directory.
if [ "$(basename "$(pwd)")" = "Personal" ]; then
    gh auth switch --user "$USER"
elif [ "$(basename "$(pwd)")" = "Organization" ]; then
    gh auth switch --user "MLSTidbits"
fi

### GIT AND GITHUB ALIASES ###
alias initial='git init'
alias add='git add --all'
alias branch='git checkout'
alias delete='git branch -D'
alias checkout='git checkout -b'
alias merge='git merge'
alias patches='git checkout --patch'
alias gitmod='git submodule add'
alias gitmodup='git submodule update --recursive --remote'
alias commit='git commit -m'
alias push='git push origin'

### GitHub CLI Aliases ###
alias github='gh repo create'
alias clone='gh repo clone'
alias gitsrch='gh search repos -L 50 --sort updated'
alias release='gh release create'
alias remove='gh release delete-asset --yes'
alias upload='gh release upload --clobber'

### EXA ALIASES ###
alias ls='exa --git --color=always'
alias ll='exa -l --git --color=always'
alias la='exa -la --git --color=always'
alias lt='exa -T --git --color=always'

### GERP ALIASES ###
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

### UTILITIES ALIASES ###
alias mkdir='mkdir -vp'
alias cp='cp -av'
alias rm='rm -v'
alias mv='mv -v'

alias ln='ln -v'

alias free='free -h'
alias df='df -h'

alias gcc='gcc -fdiagnostics-color'

alias ping='ping -c 5'

### ARCHIVE ALIASES ###
alias xz='tar cvf'
alias gz='tar cvjf'
alias bzip2='bzip2 -zk'
alias rar='rar a'
alias gzip='gzip -9'
alias zip='zip -r'
alias 7z='7z a'

### SSH ALIASES ###
alias key='ssh-keygen -P "" -f'
alias csk='ssh-copy-id -i'

test -x "$(command -v pihole)" || alias pihole='ssh pihole'

alias nano='nano -c'

### DIRECTORY ALIASES ###
alias bk='../'
alias home='~'

alias reload='source ~/.profile'

eval "$(ssh-agent -s)" 2> /dev/null || true

# Initialize Starship and run histControl function.
eval "$(starship init bash)"
