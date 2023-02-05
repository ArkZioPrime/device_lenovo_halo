#!/vendor/bin/sh

APLOG_DIR=/data/vendor/newlog/aplog

# Add by wangwq14@zuk.com
# Set log files max numnber
# If userdebug and eng version, set max log file larger to record more logs.
# If user version, you can set this prop by log APK with a hide activity.
if [ $(getprop ro.debuggable) = 1 ]; then
    if [ -z "$(getprop persist.log.tag.aplog.aplogsetting)" ]; then
        setprop persist.log.tag.aplogfiles  1000
    fi
fi

# setup log service
if [ $(getprop persist.log.tag.aplog.aplogsetting) = "true" ]; then
    if [ $(getprop persist.log.tag.aplog.batterylog) = "true" ]; then
        setprop ctl.start batterylog
    else
        setprop ctl.stop batterylog
    fi
    if [ $(getprop persist.log.tag.aplog.kernellog) = "true" ]; then
        setprop ctl.start kernellog
    else
        setprop ctl.stop kernellog
    fi

    if [ $(getprop persist.log.tag.aplogfiles) -gt 0 ]; then
        if [ $(getprop persist.log.tag.aplog.mainlog) = "true" ]; then
            setprop ctl.start closechatty
            wait
            setprop ctl.start mainlog_big
            setprop ctl.start mainlog_mini
        else
            setprop ctl.stop mainlog_big
            setprop ctl.stop mainlog_mini
        fi

        if [ $(getprop persist.log.tag.aplog.radiolog) = "true" ]; then
            setprop ctl.start radiolog_big
        else
            setprop ctl.stop radiolog_big
        fi

        if [ $(getprop persist.log.tag.aplog.eventslog) = "true" ]; then
            setprop ctl.start eventslog_big
        else
            setprop ctl.stop eventslog_big
        fi
    else
        if [ $(getprop persist.log.tag.aplog.mainlog) = "true" ]; then
            setprop ctl.start mainlog
            setprop ctl.start mainlog_mini
        else
            setprop ctl.stop mainlog
            setprop ctl.stop mainlog_mini
        fi

        if [ $(getprop persist.log.tag.aplog.radiolog) = "true" ]; then
            setprop ctl.start radiolog
        else
            setprop ctl.stop radiolog
        fi

        if [ $(getprop persist.log.tag.aplog.eventslog) = "true" ]; then
            setprop ctl.start eventslog
        else
            setprop ctl.stop eventslog
        fi
    fi

elif [ $(getprop ro.debuggable) = 1 ]; then
    setprop ctl.start batterylog
    setprop ctl.start closechatty
    wait
    setprop ctl.start mainlog_big
    setprop ctl.start mainlog_mini
    setprop ctl.start radiolog_big
    setprop ctl.start eventslog_big
    setprop ctl.start kernellog
    setprop ctl.start performancelog

    if [ $(getprop ro.product.brand) = Android ]; then
       setprop persist.log.tag.dloadmode.config 0
    elif [ -z "$(getprop persist.log.tag.firstbootfinish)" ]; then
       setprop persist.log.tag.dloadmode.config 1
       setprop persist.log.tag.firstbootfinish 1
    fi
    setprop persist.bluetooth.btsnoopenable true
elif [ $(getprop persist.log.tag.aplog.df) = "true" ]; then
    if [ -z "$(getprop persist.log.tag.firstbootfinish)" ]; then
        setprop ctl.start batterylog
        setprop ctl.start closechatty
        wait
        setprop ctl.start mainlog
        setprop ctl.start mainlog_mini
        setprop ctl.start radiolog
        setprop ctl.start eventslog
        setprop ctl.start kernellog
        setprop ctl.start performancelog

        setprop persist.log.tag.dloadmode.config 1
        setprop persist.log.tag.firstbootfinish 1
    fi
# start log services once,
# for after factoryreset, qfile burn, or upgrade from Android M.
elif [ -z "$(getprop persist.log.tag.firstbootfinish)" ]; then
    setprop ctl.start mainlog
    setprop ctl.start mainlog_mini
    setprop ctl.start kernellog
    setprop persist.log.tag.aplog.mainlog true
    setprop persist.log.tag.aplog.kernellog true
    wait

    # start a service to auto save and stop the log services
    setprop ctl.start assalog
    setprop persist.log.tag.dloadmode.config 0
fi

