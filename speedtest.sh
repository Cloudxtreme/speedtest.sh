#!/bin/bash

usage() {
echo
echo "Usage: $0 [-c 1-10] [-s 1-3]"
echo
echo "-c = connections"
echo "-s = download source"
echo
echo "Speedtest sources"
echo "1 = speed.hetzner.de"
echo "2 = speedtest.belwue.net"
echo "3 = speedtest.tele2.net"
echo
exit 1;
}

while getopts ":s:c:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            ((c > 10 || c == 0)) && usage
            ;;
        s)
            s=${OPTARG}
            ((s > 3 )) && usage
            ((s == 1 )) && SRC="http://speed.hetzner.de/1GB.bin"
            ((s == 2 )) && SRC="http://speedtest.belwue.net/1G"
            ((s == 3 )) && SRC="http://speedtest.tele2.net/1GB.zip"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${c}" ] || [ -z "${s}" ]; then
    usage
fi
echo
echo "Starting download of $SRC with $c connection(s)"
echo
aria2c -d /dev -o null  --allow-overwrite=true -x $c $SRC --file-allocation=none --continue=false
echo
