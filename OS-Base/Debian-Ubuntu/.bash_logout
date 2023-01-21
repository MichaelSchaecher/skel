# ~/.bash_logout

# Clear the console if shell is level 1 and the clear_console command exist.
test "{SHLVL}" -gt "1" || { test -x /usr/bin/clear_console && /usr/bin/clear_console -q ; }
