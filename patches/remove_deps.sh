#
#   AIS dom
#
#   Homepage: https://ai-speaker.com
#
################################################
#  Remove deps script
#  run it by executiong in AIS dom console:
# curl https://raw.githubusercontent.com/sviete/AIS-utils/master/patches/remove_deps.sh | bash
#
################################################
set -e

echo "-----------------------------"
echo $(date '+%Y %b %d %H:%M')
echo "----REMOVE DEPS START ----"
echo "-----------------------------"

# bash
echo "1. remove deps"
rm -rf /data/data/pl.sviete.dom/files/home/AIS/deps

# install fusermount
echo "2. install fusermount"
apt -y update
apt -y upgrade
apt install libfuse -y

# allow to write <permission name="android.permission.WRITE_EXTERNAL_STORAGE" />
echo "3. allow to write on external storage"
curl -o "/data/data/pl.sviete.dom/.ais/platform.xml" -L  https://raw.githubusercontent.com/sviete/AIS-utils/master/patches/platform.xml
su -c "mount -o rw,remount,rw /system && cp /data/data/pl.sviete.dom/.ais/platform.xml /system/etc/permissions/platform.xml"

echo "-----------------------------"
echo $(date '+%Y %b %d %H:%M')
echo "----ALL OK END----"
echo "-----------------------------"
