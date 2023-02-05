#! /system/bin/sh
if [ "$1" = "" ]; then
echo "plsease add parameter"
echo "parametr ：open"
echo "open wsa8830 protection algo"
echo "parametr ：close"
echo "close wsa8830 protection algo"
echo "parametr ：cali"
echo "run wsa8830 calibration"
fi

case "$1" in
open)
echo "smartpa open algo"
setprop vendor.audio.speaker_algo true
getprop vendor.audio.speaker_algo
pkill audio
;;
close)
echo "smartpa close algo"
setprop vendor.audio.speaker_algo false
getprop vendor.audio.speaker_algo
pkill audio
;;
cali)
echo "smartpa calibration"
mkdir /mnt/vendor/persist/factory/audio
touch /mnt/vendor/persist/factory/audio/audio.cal
cp /data/vendor/audio/audio.cal /mnt/vendor/persist/factory/audio/audio.cal
;;
esac