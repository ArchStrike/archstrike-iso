#!/bin/bash

set -e -u

# This builds  the iso for i686 and x86_64 and syncs it to the repo server, it will then email the team once the build is completed. As we need to update the website.


key=""
arch=$(uname -m)
datefmt=$(date +%Y.%m.%d)
iso="ArchStrike-openbox-${datefmt}-${arch}.iso"

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
          -w http://repo.archstrike.org/archassault/iso/${iso} \
          -w http://mirrorservice.org/sites/repo.archstrike.org/archassault/iso/${iso} \
          -w http://archstrike.mirror.uber.com.au/iso/http://archassault.mirror.uber.com.au/iso/${iso} \
          -w http://mirrors.dotsrc.org/archstrike/iso/${iso} \
          -w http://mirror3.layerjet.com/archstrike/iso/${iso} \
          -w http://ftp.heanet.ie/pub/archstrike/iso/${iso} \
          -w http://archstrike.mirror.garr.it/mirrors/archassault/iso/${iso} \
          -w http://mirror.i3d.net/pub/archstrike/iso/${iso} \
          -w http://mirror.mephi.ru/archstrike/iso/${iso} \
          -w http://mirror.yandex.ru/mirrors/archstrike/iso/${iso} \
          -w http://mirror.zetup.net/archstrike/iso/${iso} \
          -w http://mirror.bytemark.co.uk/archstrike/iso/${iso} \
          -w http://mirror.catn.com/pub/archstrike/iso/${iso} \
          -w http://psg.mtu.edu/pub/archstrike/iso/${iso} \
          -w http://mirror.jmu.edu/pub/archstrike/iso/${iso} \
          -w http://mirror.team-cymru.org/archstrike/iso/${iso} \
          -w http://mirror.umd.edu/archstrike/iso/${iso} \
          -w http://mirrors.arsc.edu/archstrike/iso/${iso} \
          -w http://noodle.portalus.net/ArchStrike/iso/${iso} \
          -w http://mirrors.syringanetworks.net/archstrike/iso/${iso} out/${iso}
}

for arch in i686 x86_64; do 
    build_iso
    clean_up
    #checksums
    #create_sigs
done
