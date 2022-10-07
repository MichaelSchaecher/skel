# ~/.bashrc

# By default the .bashrc file is loaded after ~/.bash_profile, ~/.bash_login or ~/.profile, because
# of this ~/.bashrc file needs to be pretty large. This can be problematic if plugins are used and
# causes Bash Terminal to be slow.

# Sometime, there is a need to copy files to the only connected server on the network.
function cp2pi () { scp ${1} pihole:${2} ; }

# Extract common archives with commonly used archiving tools. This is a modified function that is all
# over the web, but better. By not using an if condistion checking if file exist before employing case
# input option there is less chance errors.
function extract () {

        local outDir="$(echo "${1}" | awk -F'.' '{print $1}')"	# Set out directory from source.

	case "${1}" in
		*.tar.bz2|*.tbz2	)       tar xvjf "${1}" -C "${outDir}" ;;
		*.tar.gz|*.tgz		)       tar xvzf "${1}" -C "${outDir}" ;;
		*.tar.xz|*.tar		)       tar xvf "${1}" -C "${outDir}"  ;;
		*.bz2			)	bunzip2 -vd "${1}"             ;;
		*.rar			)       rar a "${1}" "${outDir}"       ;;
		*.gz			)	gunzip "${1}"                  ;;
		*.zip			)	unzip "${1}"                   ;;
		*.7z			)	7z x "${1}"                    ;;
		*			)
			# Echo common error regradeless if file exists.
			test -f "${1}" && {
				echo "${1} archive type or file not supported!" ; return ; }
                ;;
	esac
}

# This is called with the alias more command and is design to add some color to the text syntex only if
# supported by this function.

# Why some think that color output to source code syntex is only for newbies, I say that there is a reason
# that only code has bugs not features.
function colorLess () {

	local cppSource="*[ch]|[ch]pp|[ch]xx|[ch]++|cc|hh|CPP|C|H|*cp"
	local scrSource="profile|bash_*|sh|ksh|bash|ebuild|eclass|bashrc|exheres-0|exlib|zsh|zshrc"
	local pySource="py|pyw|sc|tac|sage"
	local iniSource="in|config|conf|cnf|fstab"
	local mkSource="mk|mak|Makefile|makefile"

	# Determend with language syntex is being color coded.
	case "$(echo ${1} | awk -F'.' 'NF>1{print $NF}')" in
		"${cppSource}"		) local addColor="cpp"  ;;
		"${scrSource}"		) local addColor="bash" ;;
		"${pySource}"		) local addColor="py"   ;;
		"${iniSource}"		) local addColor="ini"  ;;
		"${mkSource}"		) local addColor="make" ;;
		md			) local addColor="md"   ;;
		toml			) local addColor="toml" ;;
		dir_color		) local addColor="ruby"	;;
		*)
			# For files that do not have a file extension then try some other way to get the
			# file type. Warning this may fail with some files.
			if awk 'NR==1 {print}' ${1} | grep -q 'bash' ; then
				local addColor="bash"
			elif awk 'NR==1 {print}' ${1} | grep -q 'python' ; then
				local addColor="py"
			fi
		;;
	esac

	# Set the syntex color or not.
	test -n "${addColor}" && pygmentize -f 256 -l "${addColor}" "$1" 2> /dev/null | less || less ${1}

}

# As a result of the prompt being Starship the command history is not process the same way. Without the
# history being from with in this function being run pier to the command its self would cause the bash's
# history file would be populated incorrectly or not at all.
function histControl () {
	# The `starship_precmd` is the default PROMPT_COMMAND for `starship.`
	export PROMPT_COMMAND="starship_precmd; history -w"

	# Manage the history for the environment. Don't put duplicate lines or lines starting with space
	# in the history.
	# Then erase previous matching command. See bash(1) for more options.
	export HISTCONTROL='ignoredups:ignorespace:erasedups'

	# Ignore the following to keep bash_history from being over populated.
	export HISTIGNORE='ls:cd:pwd:history:clear:back:home:exit:source'

	# A Larger history file size would is better.
	export HISTFILESIZE="100000" ; export  HISTSIZE="1000000"

	# Add date and time for commands, with color.
	export HISTTIMEFORMAT=$(echo -e "\e[${PURPLE}m%d/%m/%y %T \e[0m")

	tac "$HISTFILE" | awk '!x[$0]++' > ~/.bash_history.old && {
		tac ~/.bash_history.old > "$HISTFILE" ; rm ~/.bash_history.old ; }
}

# Enable some useful feature that makes `bash` more like `zsh` then people think.
shopt -s checkwinsize ; shopt -s autocd	 ; shopt -s cdspell ; shopt -s extglob ;

# Manage bash history.
shopt -s histappend   ; shopt -s cmdhist ; shopt -s lithist

# Set ASCII 256bit color.
BLUE="38;5;63"    ; CYAN="38;5;109" ; GREEN="38;5;78"  ; ORANGE="38;5;208"
PURPLE="38;5;127" ; RED="38;5;202"  ; LIGHT="38;5;225" ; H_LIGHT="48;5;225"

# Colored GCC warnings and errors
export GCC_COLORS="error=$RED:warning=$ORANGE:note=$BLUE:caret=$PURPLE:locus=$CYAN:quote=$GREEN"

# Some may laugh about using nano, but I barely use a cli text editor, so there.
export EDITOR=nano

# Have less display colours for manpage.
export LESS_TERMCAP_mb=$(echo -e "\e[${PURPLE};3m")		# begin bold.
export LESS_TERMCAP_md=$(echo -e "\e[${PURPLE}m")		# begin blink.
export LESS_TERMCAP_so=$(echo -e "\e[${H_LIGHT};${PURPLE}m")	# begin reverse video.
export LESS_TERMCAP_us=$(echo -e "\e[${LIGHT};4m")		# begin underline.
export LESS_TERMCAP_me=$(echo -e "\e[0m")			# reset bold/blink.
export LESS_TERMCAP_se=$(echo -e "\e[0m")			# reset reverse video.
export LESS_TERMCAP_ue=$(echo -e "\e[0m")			# reset underline.

# for konsole and gnome-terminal.
export GROFF_NO_SGR=1

# If `shopt -s histappend` is Then allow the history to be search if using similar command.
bind '"\033[A": history-search-backward'
bind '"\033[B": history-search-forward'

alias gcc='gcc -fdiagnostics-color=auto'			# Add color to gcc.

alias inst='yay -S --noconfirm'					# Install package.
alias uinst='yay -Rsc --noconfirm'				# Remove/uninstall application.
alias srch='yay -Ss'						# Search for application.
alias update='yay -Syu --noconfirm'				# Upgrade installed applications.
alias query='yay -Qe'						# Query explicitly-installed packages.

alias add='git add .'						# Add all changes to local git repo.
alias new='git init'						# Initialize new local git repo.
alias clone='git clone'						# Clone a git repository.
alias branch='git checkout'					# Switch between git repo branches.
alias tag='git tag -a'						# Create git tag.
alias delete='git branch -D'					# Delete git branch.
alias checkout='git checkout -b'				# Create new git repo branch.
alias merge='git merge'						# Merge git repo.
alias commit='git commit -m'					# Commit changes with message.
alias push='git push origin $(git describe --abbrev=0)'		# Push current tag to remote.
alias github='git push origin $(git symbolic-ref --short HEAD)' # Push current branch to remote.

alias create='gh release create'				# Create new Github release.
alias delete='gh release delete'				# Delete Github release.
alias delasset='gh release delete-asset'			# Delete Github release asset.
alias upload='gh release upload --clobber'			# Upload release asset.
alias repo='gh repo create'					# Create new Github repo.

alias ls='ls -a --color=auto'					# Add color to list output.
alias grep='grep --color=auto'					# Grep needs some color too.
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'				# This old but still used.

alias mkdir='mkdir -p'						# Assume the parent directory.

alias back='../'						# Go back one directory.
alias home='~'							# Go to user home directory.
alias prompt='~/Projects/skel'					# Bash prompt.
alias kernel='~/Projects/linux-kernel'				# Kernel source directory.
alias website='Projects/MichaelSchaecher.github.io'		# GitHub webpage.
alias manhole='~/Projects/manhole'				# Local git repo for pihole-manager.

alias rm='rm -f'						# Force removal.
alias mv='mv -f'						# Force move.

alias ln='ln -f'						# Always force creating a soft/hard link.

alias xz='tar cvf'						# Create tar.xz archive.
alias gz='tar cvjf'						# Create tar.gz archive
alias bzip2='bzip2 -zk'						# Create bzip archive.
alias rar='rar a'						# Create rar archive.
alias gzip='gzip -9'						# Create gzip archive.
alias zip='zip -r'						# Create zip archive.
alias 7z='7z a'							# Create archive using 7z.

alias more='colorLess'						# Call function to apply less syntex color.

alias pihole='ssh pihole'					# SSH into pihole-server.
alias router='ssh router'					# SSH into router.

alias sshkey='ssh-genkey'					# Generate new ssh key.

eval "$(gh completion -s bash)"					# Add Github CLI completion.

eval "$(dircolors -b ~/.dir_color)"				# Set new color scheme for `ls` command.

# The default bash prompt is replaced by Starship: this allows for greater prompt configuration thanks to
# `~/.config/starship.toml`. By having the prompt being handled outside of `bash` the command histroy is
# not populated correctly. A workaround is to rebuild the ~/.bash_history after every command is completed.

starship_precmd_user_func="histControl"				# Manage the bash history.
eval "$(starship init bash)"					# Start Starship Prompt.
