#
# ~/.bash_logout
#
if test "$SHLVL" -eq "1" ; then
	test -x /usr/bin/clear_console && /usr/bin/clear_console -q
fi