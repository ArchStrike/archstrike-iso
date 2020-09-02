#!/bin/bash

set -e -u

# This builds  the iso for i686 and x86_64 and syncs it to the repo server, it will then email the team once the build is completed. As we need to update the website.


key=""
arch=$(uname -m)
datefmt=$(date +%Y.%m.%d)
iso="ArchStrike-minimal-${datefmt}-${arch}.iso"

build_iso() {
   ./build.sh -v -A ${arch} 2>&1 |tee -a ${arch}_build.log
}


clean_up() {
  rm -rfv work/* > /dev/null
}


checksums(){
md5sum out/${iso} > md5sum-${arch}.txt
md5sum -c md5sum-${arch}.txt
sha1sum out/${iso} > sha1sum-${arch}.txt
sha1sum -c sha1sum-${arch}.txt
}


create_sigs(){
 gpg --default-key ${key}  --output ${iso}.sig -b out/${iso}
 gpg --verify ${iso}.sig out/${iso}
}



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

for arch in i686 x86_64; do 
    build_iso
    clean_up
    #checksums
    #create_sigs
done
