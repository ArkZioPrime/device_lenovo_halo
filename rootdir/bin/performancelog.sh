#!/vendor/bin/sh

umask 022

APLOG_DIR=/data/vendor/newlog/aplog
PERFORMANCE_DIR=${APLOG_DIR}"/performance"
#=================================================================
#Script of capturing CPU, procrank, memory and top information with time interval.
mkdir -p $PERFORMANCE_DIR
cd $PERFORMANCE_DIR
rm ./*.txt
echo "Start..."
while true;
do
echo "performance"
MYDATE=`date +%y-%m-%d_%H:%M:%S`
echo $MYDATE
#Print current CPU frequency
#Modify below lines based on CPU core number.
echo ""
echo "${MYDATE}" >> cpuinfo_cur_freq.txt &
echo "cpu0 cur freq:`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu1 cur freq:`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu2 cur freq:`cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu3 cur freq:`cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu4 cur freq:`cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu5 cur freq:`cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu6 cur freq:`cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "cpu7 cur freq:`cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_cur_freq`" >> cpuinfo_cur_freq.txt &&
echo "${MYDATE}" >> proc_meminfo.txt &
cat /proc/meminfo >> proc_meminfo.txt &
echo "${MYDATE}" >> top.txt &
top -b -m 10 -n 1 >> top.txt &
sleep 60 #60 seconds, you can modify the time interval.
done
#
#=================================================================
