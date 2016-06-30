#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

## Where the default Home folders have not already been created, generate them

if [ -x /usr/bin/xdg-user-dirs-update ]; then
   /usr/bin/xdg-user-dirs-update
fi

## Ensure that obmenu-generator (a pipe menu) is set to the user.

#sed 's/_user_/'$(whoami)'/' ~/.config/obmenu-generator/schema.pl -i
sed 's/_user_/'$(whoami)'/' ~/.config/obmenu-generator/config.pl -i

desktop=$1

run_dwm(){
  xcompmgr -c -f -D 5 &
  xscreensaver --no-splash &
  exec dwm
}

run_spectrmw(){
  xcompmgr -c -f -D 5 &
  xscreensaver --no-splash &
  exec spectrmw
}



run_openbox(){
  exec openbox-session
}


if [[ $desktop == dwm ]]; then
      run_dwm
elif [[ $desktop == spectrwm ]]; then
      run_spectrwm
else
      run_openbox
fi
