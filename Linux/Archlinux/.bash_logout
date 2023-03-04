# ~/.bash_logout

# Say something motivational when exiting terminal.
test "$SHLVL" -gt "1" || { /usr/sbin/motivate & sleep 5 ; }
