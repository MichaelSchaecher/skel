# FILEPATH: ~/.config/fish/config.fish

# This fish config file is located at the specified FILEPATH. It is used to configure fish shell settings.
# The line "set fish_greeting" is used to suppress fish's intro message.

### EXPORT ###
set fish_greeting                                                   # Supresses fish's intro message
set TERM "xterm-256color"                                           # Sets the terminal type to xterm-256color

# For a command that is available the default color of blue needs to be changed to green.
set -U fish_color_autosuggestion 3a9b9e                             # Set color for autosuggestion.
set -U fish_color_command E0FFFF                                    # Set color for command.

set -U fish_key_bindings fish_default_key_bindings                  # Set key bindings to emacs.

set -U EDITOR "code"                                                # Set default editor

set -U PAGER "less"                                                 # Set default pager.

set BASH_COMPLETION_COMPAT_DIR /usr/share/bash-completion/completions

# General output colors. These are used for the output colors for the less command used
# for manpages and the output colors for the GCC diagnostics (errors, warnings, notes, etc.).

# Color       Value       fg(38)/bg(48)   style
# Magenta     127         38              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# Cyan        109         38              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# Green       78          38              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# Orange      208         38              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# Red         202         38              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# Light       225         38              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# H_Light     127         48              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)
# H_Dark      127         48              3 (italic) 4 (underline) 5 (blink) 7 (reverse) 8 (invisible)

# Have less display colors for manpage.
set -gx LESS_TERMCAP_mb \e"[38;5;127;3m"                            # begin bold.
set -gx LESS_TERMCAP_md \e"[38;5;127m"                              # begin blink.
set -gx LESS_TERMCAP_so \e"[$48;5;127;$38;5;225m"                   # begin reverse video.
set -gx LESS_TERMCAP_us \e"[38;5;225;4m"                            # begin underline.
set -gx LESS_TERMCAP_me \e"[0m"                                     # reset bold/blink.
set -gx LESS_TERMCAP_se \e"[0m"                                     # reset reverse video.
set -gx LESS_TERMCAP_ue \e"[0m"                                     # reset underline.

set -gx GROFF_NO_SGR 1                                              # Set groff to not output SGR escape sequences.

# Define the colors for GCC diagnostics (errors, warnings, notes, etc.).
set -gx GCC_COLORS "error=38;5;202:warning=38;5;208:note=38;5;63:caret=38;5;127:locus=38;5;109:quote=38;5;78"

hugo completion fish > ~/.config/fish/completions/hugo.fish         # Source hugo completion.

### FUNCTIONS ###

# Copy file to remote/local server using scp.
function sp
    scp -r $argv[1] $argv[3]:$argv[2]                               # Copy file to remote server.
end

# Set color sytax for less if pygmentize is installed.
function more

    if type -q pygmentize &>/dev/null
        pygmentize -f terminal256 -g $argv | less -R                # Set color syntax for less.
    else
        less $argv                                                  # Use default less if pygmentize is not installed.
    end

end

# Function to create new hugo theme.
function theme
    hugo new theme $argv[1] --themesDir .                           # Create new hugo theme.
end

# Extract compressed files.
function extract

    # Create a variable containing the file name without the extension.
    set outDir (basename $argv[1] (string match -r '\.*$' $argv[1]))

    # Set switch statement to extract file based on extension.
    switch $argv[1]
        case "*.tar.bz2" "*.tbz2"
            tar xjf $argv[1] -C $outDir                             # Extract tar.bz2 file.
        case "*.tar.gz" "*.tgz"
            tar xzf $argv[1] -C $outDir                             # Extract tar.gz file.
        case "*.tar.xz" "*.tar"
            tar xvf $argv[1] -C $outDir                             # Extract tar.xz file.
        case "*.bz2" "*.bz"
            bunzip2 -vd $argv[1]                                    # Extract bz2 file.
        case "*.rar"
            rar a $argv[1] $outDir                                  # Extract rar file.
        case "*.gz"
            gunzip $argv[1]                                         # Extract gz file.
        case "*.zip"
            unzip $argv[1]                                          # Extract zip file.
        case "*.7z"
            7z x $argv[1]                                           # Extract 7z file.
        case "*"
            echo "extract: '$argv[1]' - unknown archive method"     # Display error message.
            return 1
    end

end

# Functions needed for !! and !$
function __history_previous_command

    # Switch statement to determine if the command is empty or not.
    switch (commandline -t)
    case "!"
        commandline -t $history[1]; commandline -f repaint          # Replace the command with the previous command.
    case ""
        commandline -i !                                            # Insert the previous command at the cursor.
    end

end

# Functions needed to display the previous command arguments.
function __history_previous_command_arguments

    # Switch statement to determine if the command is empty or not.
    switch (commandline -t)
    case "!"
        commandline -t ""
        commandline -f history-token-search-backward                # Search backward for the previous command.
    case ""
        commandline -i '$'                                          # Insert the previous command arguments at the cursor.
    end

end

### KEY BINDINGS ###

# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
    bind -Minsert ! __history_previous_command                      # Bind '!' to __history_previous_command.
    bind -Minsert '$' __history_previous_command_arguments          # Bind '$' to __history_previous_command_arguments.
else
    bind ! __history_previous_command                               # Bind '!' to __history_previous_command.
    bind '$' __history_previous_command_arguments                   # Bind '$' to __history_previous_command_arguments.
end

### ALIASES ###

alias gcc='gcc -fdiagnostics-color=auto'                            # Add color to gcc.

alias update='sudo apt update && sudo apt upgrade --yes'            # Upgrade installed applications.
alias query='sudo apt list'                                         # Query explicitly-installed packages.
alias inst='sudo apt install --yes'                                 # Install package.
alias uinst='sudo apt purge --yes --autoremove'                     # Remove/uninstall application.
alias srch='apt search'                                             # Search for package.
alias clean='sudo apt clean && sudo apt autoclean'                  # Clean up apt cache.

# Git aliases for common commands used altough some of these are not used often because of Github CLI.

alias initial='git init'                                            # Show git status.
alias add='git add --all'                                           # Add all changes to local git repo.
alias branch='git checkout'                                         # Switch between git repo branches.
alias tag='git tag -a'                                              # Create git tag.
alias delete='git branch -D'                                        # Delete git branch.
alias checkout='git checkout -b'                                    # Create new git repo branch.
alias merge='git merge'                                             # Merge git repo.
alias patching='git checkout --patch'                               # Patch git repo.
alias sub='git submodule add'                                       # Add git submodule.
alias update-sub='git submodule update --recursive --remote'        # Update git submodule.
alias commit='git commit -m'                                        # Commit changes with message.
alias push='git push origin'                                        # Push current tag to remote.

alias github='gh repo create'                                       # Create new Github repo.
alias clone='gh repo clone'                                         # Clone a git repository.
alias release='gh release create'                                   # Create new Github release.
alias del-release='gh release delete --yes'                         # Delete Github release.
alias del-asset='gh release delete-asset --yes'                     # Delete Github release asset.
alias up-release='gh release upload --clobber'                      # Upload release asset.

# Start Hugo server with drafts and fast render disabled.
alias server='hugo server --noHTTPCache --buildDrafts  --disableFastRender'

alias site='hugo new site --format yaml'                            # Create new Hugo site.
alias cont='hugo new content'                                       # Create new Hugo content.

alias nas='ssh truenas'                                             # Access local TrueNAS over ssh.
alias router='ssh router'                                           # Access local router over ssh.

if ! command -v pihole &> /dev/null
    alias pihole='ssh pihole'                                       # Access local Pi-hole over ssh.
end

alias prox='ssh proxmox'                                            # Access local Proxmox over ssh.
alias tunnel='ssh cloudflared'                                      # Access local Raspberry Pi over ssh.
alias vault='ssh vaultwarden'                                       # Access local Vaultwarden over ssh.
alias emby='ssh emby'                                               # Access local Emby Media Server over ssh.

alias nano='nano -c'                                                # Set nano to show cursor position.

alias free='free -h'                                                # Show free memory in human readable format.

# Changing "ls" to "exa"
alias ls='exa --color=always --group-directories-first'             # my preferred listing
alias la='exa -a --color=always --group-directories-first'          # all files and dirs
alias ll='exa -l --color=always --group-directories-first'          # long format
alias lt='exa -aT --color=always --group-directories-first'         # tree listing

alias grep='grep --color=auto'                                      # Grep needs some color too.
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'                                    # This is old but still used.

alias mkdir='mkdir -vp'                                             # Assume the parent directory.

alias rm='rm -v'                                                    # Force removal and verbose.
alias mv='mv -v'                                                    # Force move and verbose.

alias ln='ln -v'                                                    # Always force creating of links and verbose.exit

alias df='df -h'                                                    # Show disk usage in human readable format.

alias cp='cp -av'                                                   # Copy files and directories recursively.

alias reload='source ~/.config/fish/config.fish'                    # Reload fish config file.

starship init fish | source                                         # Initialize starship prompt.
