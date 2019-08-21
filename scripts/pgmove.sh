#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variables come from what's being called from deploymove.sh under functions
## BWLIMIT 9 and Lower Prevents Google 750GB Google Upload Ban
################################################################################
if pidof -o %PPID -x "$0"; then
   exit 1
fi

useragent="$(cat /pg/var/uagent)"
cleaner="$(cat /pg/var/cloneclean)"

touch /pg/logs/pgtransfer.log
touch /pg/logs/.transfer_list
touch /pg/logs/.temp_list

#chown -R 1000:1000 "{{hdpath}}/transfer"
#chmod -R 775 "{{hdpath}}/transfer"

find /pg/transfer/ -type f > /pg/logs/.temp_list

while read p; do
  sed -i "/^$p\b/Id" /pg/logs/.temp_list
done </pg/logs/.transfer_list

head -n +1 /pg/logs/.temp_list >> /pg/logs/.transfer_list
uploadfile=$(head -n +1 /pg/logs/.temp_list)

chown 1000:1000 "$uploadfile"
chmod 775 "$uploadfile"

#{{type}}

rclone move "$uploadfile" "gd:/" \
--config /pg/rclone/blitz.conf \
--log-file=/pg/logs/pgtransfer.log \
--log-level INFO --stats 5s --stats-file-name-length 0 \
--bwlimit {{bandwidth.stdout}}M \
--tpslimit 6 \
--checkers=16 \
--drive-chunk-size={{dcs}} \
--user-agent="$useragent" \
--exclude="**_HIDDEN~" --exclude="**partial~"  \
--exclude=".fuse_hidden**" --exclude="**.grab/**"

find "{{hdpath}}/transfer/" -mindepth 2 -type d -mmin +2 -empty -exec rm -rf {} \;

# Removes garbage | torrent folder excluded
find "{{hdpath}}/downloads" -mindepth 2 -type d -cmin +$cleaner  $(printf "! -name %s " $(cat /pg/var/exclude)) -empty -exec rm -rf {} \;
find "{{hdpath}}/downloads" -mindepth 2 -type f -cmin +$cleaner  $(printf "! -name %s " $(cat /pg/var/exclude)) -size +1M -exec rm -rf {} \;
