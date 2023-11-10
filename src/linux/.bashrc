# ~/.bashrc

# By default the .bashrc file is loaded after ~/.bash_profile, ~/.bash_login or ~/.profile, because
# of this ~/.bashrc file needs to be pretty large. This can be problematic if plugins are used and
# causes Bash Terminal to be slow.

# Extract common archives with commonly used archiving tools. This is a modified function that is all
# over the web, but better. By not using an if condition checking if file exist before employing case
# input option there is less chance errors.
function extract () {

	local outDir

    outDir="$(echo "${1}" | awk -F'.' '{print $1}')"			# Set out directory from source.

	case "${1}" in
		*.tar.bz2|*.tbz2	)	tar xvjf "${1}" -C "${outDir}"	;;
		*.tar.gz|*.tgz		)	tar xvzf "${1}" -C "${outDir}"	;;
		*.tar.xz|*.tar		)	tar xvf "${1}" -C "${outDir}"	;;
		*.bz2				)	bunzip2 -vd "${1}"				;;
		*.rar				)	rar a "${1}" "${outDir}"		;;
		*.gz				)	gunzip "${1}"					;;
		*.zip				)	unzip "${1}"					;;
		*.7z				)	7z x "${1}"						;;
		*					)
			# Echo common error regardless if file exists.
			test -f "${1}" && {
				echo "${1} archive type or file not supported!" ; return ; }
                ;;
	esac
}

# Setting the more alias to use pygmentize for syntax highlighting.
function more () { pygmentize -f terminal256 -g "$1" | less -R; }

# As a result of the prompt being Starship the command history is not process the same way. Without the
# history being from with in this function being run pier to the command its self would cause the bash's
# history file would be populated incorrectly or not at all.
function histControl () {

	# The `starship_precmd` is the default PROMPT_COMMAND for `starship.`
	PROMPT_COMMAND="starship_precmd; history -w"

	# Manage the history for the environment. Don't put duplicate lines or lines starting with space
	# in the history.
	# Then erase previous matching command. See bash(1) for more options.
	HISTCONTROL='ignoredups:ignorespace:erasedups'

	# Ignore the following to keep bash_history from being over populated.
	HISTIGNORE='ls:cd:pwd:history:clear:back:home:exit:source'

	# A Larger history file size would is better.
	HISTFILESIZE="100000" ; export  HISTSIZE="1000000"

	# Add date and time for commands, with color.
	HISTTIMEFORMAT=$(echo -e "\e[${PURPLE}m%d/%m/%y %T \e[0m")

	export PROMPT_COMMAND HISTCONTROL HISTIGNORE HISTFILESIZE HISTSIZE HISTTIMEFORMAT

	# Rewrite the history file, removing all duplicates preserving the most recent version of the
	# command. This is done by reversing the order of the history file, removing duplicates, then
	# reversing the order again to put the history file back in the correct order.
	if test -f "${HISTFILE}" ; then
		tac "${HISTFILE}" | awk '!x[$0]++' > ~/.bash_history.old
		tac ~/.bash_history.old > "${HISTFILE}"
		test -f ~/.bash_history.old && rm ~/.bash_history.old || return
	fi

}

# Enable some useful feature that makes `bash` more like `zsh` then people think.
shopt -s checkwinsize ; shopt -s autocd	 ; shopt -s cdspell ; shopt -s extglob ;

# Manage bash history.
shopt -s histappend   ; shopt -s cmdhist ; shopt -s lithist

# Set ASCII 256bit color.
BLUE="38;5;63"    ; CYAN="38;5;109" ; GREEN="38;5;78"  ; ORANGE="38;5;208"
PURPLE="38;5;127" ; RED="38;5;202"  ; LIGHT="38;5;225" ; H_LIGHT="48;5;225"

# Colored GCC warnings and errors
GCC_COLORS="error=$RED:warning=$ORANGE:note=$BLUE:caret=$PURPLE:locus=$CYAN:quote=$GREEN" ; export GCC_COLORS

# Some may laugh about using nano, but I barely use a cli text editor, so there.
EDITOR=nano ; export EDITOR

# Have less display colors for manpage.
LESS_TERMCAP_mb=$(echo -e "\e[${PURPLE};3m")					# begin bold.
LESS_TERMCAP_md=$(echo -e "\e[${PURPLE}m")						# begin blink.
LESS_TERMCAP_so=$(echo -e "\e[${H_LIGHT};${PURPLE}m")			# begin reverse video.
LESS_TERMCAP_us=$(echo -e "\e[${LIGHT};4m")						# begin underline.
LESS_TERMCAP_me=$(echo -e "\e[0m")								# reset bold/blink.
LESS_TERMCAP_se=$(echo -e "\e[0m")								# reset reverse video.
LESS_TERMCAP_ue=$(echo -e "\e[0m")								# reset underline.

GROFF_NO_SGR="1"												# for konsole and gnome-terminal.

export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_so LESS_TERMCAP_us \
	LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_ue GROFF_NO_SGR

STARSHIP_LOG="error" ; export STARSHIP_LOG						# Don't show Starship warnings or errors.

# If `shopt -s histappend` is Then allow the history to be search if using similar command.
bind '"\033[A": history-search-backward'
bind '"\033[B": history-search-forward'

alias gcc='gcc -fdiagnostics-color=auto'						# Add color to gcc.

alias inst='sudo apt install --yes'                             # Install package.
alias uinst='sudo apt install --yes --autoremove'               # Remove/uninstall application.
alias srch='apt search'                                         # Search for application.
alias update='sudo apt update && sudo apt upgrade --yes'        # Upgrade installed applications.
alias query='sudo apt list'                                     # Query explicitly-installed packages.

alias add='git add .'											# Add all changes to local git repo.
alias new='git init'											# Initialize new local git repo.
alias branch='git checkout'										# Switch between git repo branches.
alias tag='git tag -a'											# Create git tag.
alias delete='git branch -D'									# Delete git branch.
alias checkout='git checkout -b'								# Create new git repo branch.
alias merge='git merge'											# Merge git repo.
alias commit='git commit -m'									# Commit changes with message.
alias push='git push origin $(git describe --abbrev=0)'			# Push current tag to remote.
alias github='git push origin $(git symbolic-ref --short HEAD)' # Push current branch to remote.

alias clone='gh repo clone'										# Clone a git repository.
alias create='gh release create'								# Create new Github release.
alias delete='gh release delete --yes'							# Delete Github release.
alias delasset='gh release delete-asset --yes'					# Delete Github release asset.
alias upload='gh release upload --clobber'						# Upload release asset.
alias repo='gh repo create'										# Create new Github repo.

alias ls='ls -a --color=auto'									# Add color to list output.
alias grep='grep --color=auto'									# Grep needs some color too.
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'								# This is old but still used.

alias mkdir='mkdir -p'											# Assume the parent directory.

alias back='../'												# Go back one directory.
alias home='~'													# Go to user home directory.

# Aliases for source projects.
alias kernel='Projects/linux-kernel'							# Kernel source.
alias webpage='Project/MichaelSchaecher.github.io'				# Github webpage Source.

alias rm='rm -f'												# Force removal.
alias mv='mv -f'												# Force move.

alias ln='ln -f'												# Always force creating a soft/hard link.

alias xz='tar cvf'												# Create tar.xz archive.
alias gz='tar cvjf'												# Create tar.gz archive
alias bzip2='bzip2 -zk'											# Create bzip archive.
alias rar='rar a'												# Create rar archive.
alias gzip='gzip -9'											# Create gzip archive.
alias zip='zip -r'												# Create zip archive.
alias 7z='7z a'													# Create archive using 7z.

alias status='pihole status'									# Show pihole status
alias report='cat /var/log/manhole.log | less'					# Print log about Pihole Management.

alias pihole='ssh dns_pihole_app'								# Access dns.pihole.app over ssh.
alias omv='ssh omv'												# Access local NAS over ssh.

# Aliases to generate ssh keys with no passphrase and set file name.
alias key='ssh-keygen -P "" -f'									# Generate ssh key without passphrase and set file name.
alias nas='ssh truenas'											# Access local TrueNAS over ssh.
alias router='ssh router'										# Access local router over ssh.
alias pi='ssh docker-pi'										# Access local Raspberry Pi over ssh.

eval "$(dircolors -b ~/.dir_colors)"							# Set new color scheme for `ls` command.

# The default bash prompt is replaced by Starship: this allows for greater prompt configuration thanks to
# `~/.config/starship.toml`. By having the prompt being handled outside of `bash` the command histroy is
# not populated correctly. A workaround is to rebuild the ~/.bash_history after every command is completed.

# Shellcheck disable=SC2034
starship_precmd_user_func="histControl"							# Manage the bash history.
eval "$(starship init bash)"									# Start Starship Prompt.
