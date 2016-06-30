# Add vim as default editor
export EDITOR=vim
export BROWSER=firefox
# Gtk themes
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx


alias ls='ls --color=auto'
