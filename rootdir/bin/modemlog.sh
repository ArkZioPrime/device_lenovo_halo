#!/vendor/bin/sh

#ZUKMT-572
#This script added by Lenovo Protocol team
#used for 3333 modem offline log
#the entire file is required when porting feature ZUKMT-572

umask 022

Log(){
    log -p d -t modemlog $1
}
#add by lenovo for USER_MANUALLY_SELECT_MODEM_CFG      BEGIN
CFGNAME=$(getprop persist.log.tag.lenovo.mconfig)
Log "[diag] user manually selected cfg name=$CFGNAME"
CFGFILE=/vendor/etc/$CFGNAME

#add for set modem offline log number by secret code 4636
if [ -z "$(getprop persist.log.tag.modem.mnum)" ]; then
    setprop persist.log.tag.modem.mnum  10
    Log "[diag]get property persist.log.tag.modem.mnum fail so set it to be default value 10"
fi
CFGNUM=$(getprop persist.log.tag.modem.mnum)
Log "[diag]final config log num=$CFGNUM "

TABLET=$(getprop vendor.config.zui.devicetype)
Log "[diag] tablet type=$TABLET"

# User can config modem log by file "/sdcard/log_cfg/cs.cfg"
# System default config file is "/vendor/etc/cs.cfg".

if [ -f $CFGFILE ]; then
    Log "[diag] user manually selected logcfg path=$CFGFILE"
#add by lenovo for USER_MANUALLY_SELECT_MODEM_CFG      END
elif [ -e /data/vendor/newlog/cs.cfg ]; then
#    setprop "persist.sys.lenovo.log.qxdmcfg" "/sdcard/log_cfg/cs.cfg"
    CFGFILE=/data/vendor/newlog/cs.cfg
    Log "[diag] setprop persist.sys.lenovo.log.qxdmcfg to /data/vendor/newlog/cs.cfg"
else
#    setprop "persist.sys.lenovo.log.qxdmcfg" "/vendor/etc/cs.cfg"
    CFGFILE=/vendor/etc/cs.cfg
    Log "[diag] setprop persist.sys.lenovo.log.qxdmcfg to /vendor/etc/cs.cfg"
fi
LOGFILE=/data/vendor/diag_mdlog
#setprop "persist.sys.lenovo.log.path" "/sdcard/log/mdlog"
Log "[diag] setprop persist.sys.lenovo.log.path to /data/vendor/diag_mdlog"

#CFGFILE=$(getprop persist.sys.lenovo.log.qxdmcfg)
#LOGFILE=$(getprop persist.sys.lenovo.log.path)

Log "start diag_mdlog"
chmod 777 /data/vendor/diag_mdlog
Log "[diag] CFGFILE=$CFGFILE"
Log "[diag] LOGFILE=$LOGFILE"

#kill the diag_mdlog process at first
/vendor/bin/diag_mdlog -k

Log "current platform is $(getprop ro.board.platform)"
PLATFORMNAME=$(getprop ro.board.platform)

PLATFORM_NAME_LIST=("lahaina" "taro")
for PLATFORM_NAME in "${PLATFORM_NAME_LIST[@]}"
do
    if [ $(getprop ro.board.platform) = $PLATFORM_NAME ]; then
        Log "chmod 777"
        setprop persist.log.tag.qdss.config 0

        Log "reduce qdss log"
        #reduce qdss log
        echo 1 > /sys/bus/coresight/reset_source_sink
        echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
        echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/enable_sink
        echo 1 > /sys/bus/coresight/devices/coresight-stm/enable_source

        Log "disable ftrace"
        #disable ftrace
        echo 0 > /sys/kernel/tracing/instances/usb/tracing_on
        echo 0 > /sys/kernel/debug/tracing/tracing_on
        echo 0 > /sys/kernel/debug/tracing/events/enable
        echo 0 > /sys/kernel/tracing/tracing_on
        echo 0 > /sys/kernel/tracing/instances/wifi/tracing_on
        echo 0 > /sys/kernel/tracing/instances/ufs/tracing_on
        echo 0 > /sys/kernel/tracing/instances/bootreceiver/tracing_on
        echo 0 > /sys/kernel/tracing/instances/kgsl-fence/tracing_on

        break
    fi

done

# -s set the single log size in MB
if [ $CFGNAME = CHGPD.cfg ]; then
    Log "CHGPD log enabled"
    /vendor/bin/diag_mdlog -u -s 64 -n $CFGNUM -f $CFGFILE  -o $LOGFILE/chgpd
elif [ $PLATFORMNAME = kona ]; then
    Log "kona use non qdss"
    /vendor/bin/diag_mdlog -u -s 512 -n $CFGNUM -f $CFGFILE -m $CFGFILE -o $LOGFILE
elif [ $(getprop vendor.config.zui.devicetype) = PAD ]; then
    /vendor/bin/diag_mdlog -s 512 -n 10 -f $CFGFILE -m $CFGFILE -o /data/vendor/diag_mdlog
    Log "for wifi tablet"
#TABZUIS-546 disable qdss for m10 plus   BEGIN
elif [ $(getprop vendor.config.zui.devicetype) = PAD_WITH_SIM ]; then
    /vendor/bin/diag_mdlog -s 512 -n 10 -f $CFGFILE -m $CFGFILE -o /data/vendor/diag_mdlog
    Log "for LTE tablet"
#TABZUIS-546 disable qdss for m10 plus   END
else
    Log "default make qdss log enabled"
    /vendor/bin/diag_mdlog -q 2 -u -s 512 -n $CFGNUM -f $CFGFILE -m $CFGFILE -i -o $LOGFILE
fi

# scripty will hold in the last line, should never come here.
Log "[diag] start diag_mdlog done, exit scripty"

