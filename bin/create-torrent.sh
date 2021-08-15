#!/bin/bash
create_torrent(){
mktorrent -a udp://tracker.coppersurfer.tk:6969/announce \
          -a udp://tracker.ccc.de:80/announce \
          -a udp://tracker.publicbt.com:80 \
          -a udp://tracker.istole.it:80 \
          -a http://tracker.openbittorrent.com:80/announce \
          -a http://tracker.ipv6tracker.org:80/announce \
          -c "The ArchStrike Project is an Arch Linux based Distro for penetration testers, security professionals and all-around linux enthusiasts." \
          -n "${iso}" -v \
          -w https://mirror.archstrike.org/iso/${iso} \
}
create_torrent
