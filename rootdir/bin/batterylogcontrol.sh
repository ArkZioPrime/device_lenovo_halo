#!/vendor/bin/sh

# Add by wangwq14, start to record battery log.

umask 022

VER=16

if [ -d /data/vendor/newlog/aplog ]; then
	APLOG_DIR=/data/vendor/newlog/aplog
else
	APLOG_DIR=/data/local/newlog/aplog
fi

BATT_LOGFILE_GROUP_MAX_SIZE=20971520

product=""
platform=""
get_product() {
    a=`getprop|grep ro.product.name`
    b=`echo ${a##*\[}`
    product=`echo ${b%]*}`
}

get_platform() {
    a=`getprop|grep ro.board.platform`
    b=`echo ${a##*\[}`
    platform=`echo ${b%]*}`
}
get_product
get_platform

if [[ "$product" == "doom" ]]; then
    FILE_NUM=$(getprop persist.log.tag.aplogfiles)
    if [ $FILE_NUM -gt 0 ]; then
        FILE_NUM=20
    else
        FILE_NUM=5
    fi

    /vendor/bin/batterylogger -n ${FILE_NUM} -s ${BATT_LOGFILE_GROUP_MAX_SIZE} -p ${APLOG_DIR}
    exit
fi

BATT_LOGSHELL="/vendor/bin/batterylog.sh"
BATT_LOGFILE=${APLOG_DIR}"/batterylog"
BATT_LOGFILE_QC=${APLOG_DIR}"/batterylog.qc"

# mv files.x-1 to files.x
mv_files()
{
    if [ -z "$1" ]; then
      echo "No file name!"
      return
    fi

    if [ -z "$2" ]; then
      fileNum=$(getprop persist.log.tag.aplogfiles)
      if [ $fileNum -gt 0 ]; then
        LAST_FILE=$fileNum
      else
        LAST_FILE=5
      fi
    else
      LAST_FILE=$2
    fi

    i=$LAST_FILE
    while [ $i -gt 0 ]; do
      prev=$(($i-1))
      if [ -e "$1.$prev" ]; then
        mv $1.$prev $1.$i
      fi
      i=$(($i-1))
    done

    if [ -e $1 ]; then
      mv $1 $1.1
    fi
}

file_count=0
count=1
prop_len=0
dumper_en=1

mv_files $BATT_LOGFILE
if [ $dumper_en -eq 1 ]; then
    mv_files $BATT_LOGFILE_QC
fi

out_data=""
out_name=""
batt1_path=""
batt1_name=""
batt2_path=""
batt2_name=""
cooling_path=""
cooling_name=""
tz_path=""
tz_name=""

array=(
        "online"				"/sys/devices/system/cpu/online"
        "prfp_cur"				"/sys/kernel/debug/clk/measure_only_apcs_goldplus_post_acd_clk/clk_measure"
        "prf_cur"				"/d/clk/measure_only_apcs_gold_post_acd_clk/clk_measure"
        "pwr_cur"				"/d/clk/measure_only_apcs_silver_post_acd_clk/clk_measure"
        "prfp_hw_max"			"/sys/devices/system/cpu/cpu7/dcvsh_freq_limit"
        "prf_hw_max"			"/sys/devices/system/cpu/cpu4/dcvsh_freq_limit"
        "pwr_hw_max"			"/sys/devices/system/cpu/cpu0/dcvsh_freq_limit"
        "brightness"			"/sys/class/backlight/panel0-backlight/brightness"
        "mpctl"					"/sys/devices/system/cpu/cpu0/rq-stats/mpctl"
        "mpctl2"				"/sys/devices/system/cpu/cpu0/rq-stats/mpctl2"
        "capacity"				"/sys/class/power_supply/battery/capacity"
        "voltage_now"			"/sys/class/power_supply/battery/voltage_now"
        "current_now"			"/sys/class/power_supply/battery/current_now"
        "voltage1"				"/sys/class/lenovo-battery/voltage1"
        "voltage2"				"/sys/class/lenovo-battery/voltage2"
        "temp"					"/sys/class/power_supply/battery/temp"
        "temp1"					"/sys/class/lenovo-battery/temp1"
        "temp2"					"/sys/class/lenovo-battery/temp2"
        "status"				"/sys/class/power_supply/battery/status"
        "health"				"/sys/class/power_supply/battery/health"
        "charge_counter"		"/sys/class/power_supply/battery/charge_counter"
        "charge_full"			"/sys/class/power_supply/battery/charge_full"
        "charge_full_design"	"/sys/class/power_supply/battery/charge_full_design"
        "cycle_count"			"/sys/class/power_supply/battery/cycle_count"
        "usb_online"			"/sys/class/power_supply/usb/online"
        "vbus"					"/sys/class/power_supply/usb/voltage_now"
        "fan_level"				"/sys/class/hwmon/hwmon0/fan_level"
        "fan0_duty"				"/sys/class/hwmon/hwmon0/fan0_duty"
        "fan1_duty"				"/sys/class/hwmon/hwmon0/fan1_duty"
        "thermal_fan"			"/sys/class/hwmon/hwmon0/thermal_fan"
)

array_halo=(
        "online"				"/sys/devices/system/cpu/online"
        "brightness"			"/sys/class/backlight/panel0-backlight/brightness"
        "mpctl"					"/sys/devices/system/cpu/cpu0/rq-stats/mpctl"
        "mpctl2"				"/sys/devices/system/cpu/cpu0/rq-stats/mpctl2"
        "capacity"				"/sys/class/power_supply/battery/capacity"
	"fg_soc_h"			"/sys/class/lenovo-battery/batt_fg_soc_h"
	"fg_soc_l"			"/sys/class/lenovo-battery/batt_fg_soc_l"
        "voltage_now"			"/sys/class/power_supply/battery/voltage_now"
        "current_now"			"/sys/class/power_supply/battery/current_now"
	"fg_temp"			"/sys/class/lenovo-battery/batt_fg_die_temp"
        "cycle_count"			"/sys/class/power_supply/battery/cycle_count"
        "soh"					"/sys/class/qcom-battery/soh"
        "batt_temp"					"/sys/class/power_supply/battery/temp"
	"temp_raw"					"/sys/class/lenovo-battery/temp_raw"
        "status"				"/sys/class/power_supply/battery/status"
        "qcom_voltage"					"/sys/class/lenovo-battery/batt_qcom_voltage_now"
        "qcom_ocv"					"/sys/class/power_supply/battery/voltage_ocv"
        "health"				"/sys/class/power_supply/battery/health"
        "usb_online"			"/sys/class/power_supply/usb/online"
        "charger_type"					"/sys/class/qcom-battery/usb_real_type"
        "vbus"					"/sys/class/power_supply/usb/voltage_now"
	"input_suspend"			"/sys/class/qcom-battery/usb_input_suspend_en"
	"charge_en"			"/sys/class/qcom-battery/batt_charge_en"
	"acc_en"			"/sys/class/qcom-battery/batt_charge_accelerate_en"
	"bypass_en"			"/sys/class/qcom-battery/batt_charge_bypass_en"
	"health_en"			"/sys/class/qcom-battery/batt_charge_health_en"
	"typec_orien"			"/sys/class/qcom-battery/usb_typec_orientation"
	"charge_limit"			"/sys/class/power_supply/battery/charge_control_limit"
	"charge_limit_max"		"/sys/class/power_supply/battery/charge_control_limit_max"
        "prfp_cur"				"/sys/kernel/debug/clk/measure_only_apcs_goldplus_post_acd_clk/clk_measure"
        "prf_cur"				"/d/clk/measure_only_apcs_gold_post_acd_clk/clk_measure"
        "pwr_cur"				"/d/clk/measure_only_apcs_silver_post_acd_clk/clk_measure"
        "prfp_hw_max"			"/sys/devices/system/cpu/cpu7/dcvsh_freq_limit"
        "prf_hw_max"			"/sys/devices/system/cpu/cpu4/dcvsh_freq_limit"
        "pwr_hw_max"			"/sys/devices/system/cpu/cpu0/dcvsh_freq_limit"
)

array_default=(
        "capacity"			"/sys/class/power_supply/battery/capacity"
        "voltage_now"			"/sys/class/power_supply/battery/voltage_now"
        "current_now"			"/sys/class/power_supply/battery/current_now"
        "cycle_count"			"/sys/class/power_supply/battery/cycle_count"
        "temp"				"/sys/class/power_supply/battery/temp"
        "status"			"/sys/class/power_supply/battery/status"
        "health"			"/sys/class/power_supply/battery/health"
        "usb_online"			"/sys/class/power_supply/usb/online"
)

if [[ "$product" == "diablo" ]] || [[ "$product" == "diablo_fac" ]]; then
	pause_time=5
	freq_path=
	dev_path=
	tz_path=
	pro_name=
	pro_data=
	len=${#array[@]}

    sleep 3
    while [ 1 ]
    do
        utime=($(cat /proc/uptime))
        ktime=${utime[0]}

        if [[ "$pro_name" == "" ]] || [ ! -f ${BATT_LOGFILE} ]; then
            # add header
            pro_name="time,uptime,version,log_cnt,rec_cnt,platform,product,"

			while [ $i -lt $len ]
			do
			echo ${array[i+1]}
				if [ -r ${array[i+1]} ]; then
					freq_path+="${array[i+1]}"" "
					pro_name+="${array[i]}",
				fi
				((i=i+2))
			done

            # add cooling device
            p=/sys/class/thermal
            cd $p
            for i in cooling_device*
            do
                dev_path+=${p}/${i}/cur_state" "
                pro_name+=dev-`cat ${p}/${i}/type`,
            done
            cd -

            # add thermal zone
            p=/sys/class/thermal
            cd $p
            for i in thermal_zone*
            do
                tz_type=`cat ${p}/${i}/type`
				if [[ "$tz_type" == "skin-msm-therm" ]] || \
                            [[ "$tz_type" == "camera-therm" ]] || \
                            [[ "$tz_type" == "hot-pock-therm" ]] || \
                            [[ "$tz_type" == "rear-cam-therm" ]] || \
                            [[ "$tz_type" == "fan0-therm" ]] || \
                            [[ "$tz_type" == "sub-conn-therm" ]] || \
                            [[ "$tz_type" == "fan1-therm" ]] || \
                            [[ "$tz_type" == "pa-therm" ]] || \
                            [[ "$tz_type" == "pa-therm2" ]] || \
                            [[ "$tz_type" == "wifi-therm" ]] || \
                            [[ "$tz_type" == "smb-therm" ]] || \
                            [[ "$tz_type" == "tof-therm" ]] || \
                            [[ "$tz_type" == "conn-therm" ]] || \
                            [[ "$tz_type" == "wlc-therm" ]] || \
                            [[ "$tz_type" == "xo-therm" ]] || \
                            [[ "$tz_type" == "front_temp" ]] || \
                            [[ "$tz_type" == "back_temp" ]] || \
                            [[ "$tz_type" == "user_front_temp" ]] || \
                            [[ "$tz_type" == "user_back_temp" ]] || \
                            [[ "$tz_type" == "batt-therm3" ]] || \
                            [[ "$tz_type" == "cpu-1-1" ]]; then
					tz_path+=${p}/${i}/temp" "
					pro_name+=tz-${tz_type},
				else
                    continue;
                fi

            done
            cd -

            # write prop name to file
            echo ${pro_name} >${BATT_LOGFILE}
        fi

        # add header
        pro_data="`echo $(date "+%Y-%m-%d %H:%M:%S.%3N")`,${ktime},${VER},${file_count},${count},${platform},${product},"
        pro_data+=`cat ${freq_path} | tr '\n' ','`
        pro_data+=`cat ${dev_path} | tr '\n' ','`
        pro_data+=`cat ${tz_path} | tr '\n' ','`

        echo ${pro_data} >>${BATT_LOGFILE}

        if [ $(((count - 1) % 5)) -eq 0 ]; then
            dumper_flag=1
        else
            dumper_flag=0
        fi

        BATT_LOGFILE_size=`stat -c "%s" $BATT_LOGFILE`
        BATT_LOGFILE_GROUP_size=$(($BATT_LOGFILE_size))

        let count=$count+1
        sleep $pause_time

        if [ $BATT_LOGFILE_GROUP_size -gt $BATT_LOGFILE_GROUP_MAX_SIZE ]; then
            mv_files $BATT_LOGFILE
            if [ $dumper_en -eq 1 ]; then
                mv_files $BATT_LOGFILE_QC
            fi
            let file_count=$file_count+1
        fi
    done
elif [[ "$product" == "halo" ]] || [[ "$product" == "halo_fac" ]]; then
	pause_time=5
	freq_path=
	dev_path=
	tz_path=
	pro_name=
	pro_data=
	len=${#array[@]}

    sleep 3
    while [ 1 ]
    do
        utime=($(cat /proc/uptime))
        ktime=${utime[0]}

        if [[ "$pro_name" == "" ]] || [ ! -f ${BATT_LOGFILE} ]; then
            # add header
            pro_name="time,uptime,version,log_cnt,rec_cnt,platform,product,"

			while [ $i -lt $len ]
			do
			echo ${array_halo[i+1]}
				if [ -r ${array_halo[i+1]} ]; then
					freq_path+="${array_halo[i+1]}"" "
					pro_name+="${array_halo[i]}",
				fi
				((i=i+2))
			done

            # add cooling device
            p=/sys/class/thermal
            cd $p
            for i in cooling_device*
            do
                dev_path+=${p}/${i}/cur_state" "
                pro_name+=dev-`cat ${p}/${i}/type`,
            done
            cd -

            # add thermal zone
            p=/sys/class/thermal
            cd $p
            for i in thermal_zone*
            do
                tz_type=`cat ${p}/${i}/type`
				if [[ "$tz_type" == "user_front_temp" ]] || \
                            [[ "$tz_type" == "front_temp" ]] || \
                            [[ "$tz_type" == "user_back_temp" ]] || \
                            [[ "$tz_type" == "back_temp" ]] || \
                            [[ "$tz_type" == "skin-msm-therm" ]] || \
                            [[ "$tz_type" == "camera-therm" ]] || \
                            [[ "$tz_type" == "hot-pock-therm" ]] || \
                            [[ "$tz_type" == "rear-cam-therm" ]] || \
                            [[ "$tz_type" == "tof-therm" ]] || \
                            [[ "$tz_type" == "fan0-therm" ]] || \
                            [[ "$tz_type" == "pa-therm" ]] || \
                            [[ "$tz_type" == "pa-therm2" ]] || \
                            [[ "$tz_type" == "wifi-therm" ]] || \
                            [[ "$tz_type" == "wlc-therm" ]] || \
                            [[ "$tz_type" == "conn-therm" ]] || \
                            [[ "$tz_type" == "batt-therm3" ]] || \
                            [[ "$tz_type" == "xo-therm" ]] || \
                            [[ "$tz_type" == "cpu-1-7" ]]; then
					tz_path+=${p}/${i}/temp" "
					pro_name+=tz-${tz_type},
				else
                    continue;
                fi

            done
            cd -

            # write prop name to file
            echo ${pro_name} >${BATT_LOGFILE}
        fi

        # add header
        pro_data="`echo $(date "+%Y-%m-%d %H:%M:%S.%3N")`,${ktime},${VER},${file_count},${count},${platform},${product},"
        pro_data+=`cat ${freq_path} | tr '\n' ','`
        pro_data+=`cat ${dev_path} | tr '\n' ','`
        pro_data+=`cat ${tz_path} | tr '\n' ','`

        echo ${pro_data} >>${BATT_LOGFILE}

        if [ $(((count - 1) % 5)) -eq 0 ]; then
            dumper_flag=1
        else
            dumper_flag=0
        fi

        BATT_LOGFILE_size=`stat -c "%s" $BATT_LOGFILE`
        BATT_LOGFILE_GROUP_size=$(($BATT_LOGFILE_size))

        let count=$count+1
        sleep $pause_time

        if [ $BATT_LOGFILE_GROUP_size -gt $BATT_LOGFILE_GROUP_MAX_SIZE ]; then
            mv_files $BATT_LOGFILE
            if [ $dumper_en -eq 1 ]; then
                mv_files $BATT_LOGFILE_QC
            fi
            let file_count=$file_count+1
        fi
    done
elif [[ "$platform" == "kona" ]]; then
    pause_time=5
    while [ 1 ]
    do
        utime=($(cat /proc/uptime))
        ktime=${utime[0]}

        if [[ "$out_name" == "" ]] || [ ! -f ${BATT_LOGFILE} ]; then
            # add header
            out_name="time,uptime,version,log_cnt,rec_cnt,platform,product,"

            # add freq
            freq_name="pwr_cur,perf_cur,perfp_cur,pwr_max,perf_max,perfp_max,gpu_cur,gpu_max,mpctl,backlight,"
            freq_path="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq \
                        /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_cur_freq \
                        /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_cur_freq \
                        /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq \
                        /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq \
                        /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq \
                        /sys/devices/platform/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0/gpuclk \
                        /sys/devices/platform/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0/max_gpuclk \
			/sys/devices/system/cpu/cpu0/rq-stats/mpctl \
                        /sys/class/backlight/panel0-backlight/brightness "

            # add ps
            cd /sys/class/power_supply
            for i in *
            do
                if [[ "$i" == "dc" ]]; then
                    continue
                fi

                cd $i
                for j in *
                do
                    if [ -d $j ] || [[ "$j" == "uevent" ]] || [[ "$j" == "flash_trigger" ]]; then
                        continue
                    fi
                    # ps file path
                    ps_path+=/sys/class/power_supply/${i}/${j}" "
                    # ps name
                    if [[ "$i" == "bq27z561-master"* ]]; then
                        ps_name+="batt1"-${j},
                    elif [[ "$i" == "bq27z561-slave"* ]]; then
                        ps_name+="batt2"-${j},
                    elif [[ "$i" == "bq2589h-charger"* ]]; then
                        ps_name+="sec"-${j},
                    elif [[ "$i" == "bq2597x-master"* ]]; then
                        ps_name+="cp1"-${j},
                    elif [[ "$i" == "bq2597x-slave"* ]]; then
                        ps_name+="cp2"-${j},
                    elif [[ "$i" == "bq2597x-sec-master"* ]]; then
                        ps_name+="cp3"-${j},
                    elif [[ "$i" == "bq2597x-sec-slave"* ]]; then
                        ps_name+="cp4"-${j},
                    else
                        ps_name+=${i}-${j},
                    fi
                done
                cd -
            done
            cd -

            # add battery1 info
            p=/sys/devices/platform/soc/988000.i2c/i2c-3/3-0055
            cd $p
            for i in *
            do
                if [ -d $i ] || [[ "$i" == "uevent" ]] || \
                        [[ "$i" == "modalias" ]] || \
                        [[ "$i" == "name" ]] || \
                        [[ "$i" == "DeviceInfo" ]] || \
                        [[ "$i" == "RaTable" ]]; then
                    continue
                fi
                # batt1 file path
                batt1_path+=${p}/${i}" "
                # batt1 name
                batt1_name+=batt1-${i},
            done
            cd -

            # add battery2 info
            p=/sys/devices/platform/soc/990000.i2c/i2c-5/5-0055
            cd $p
            for i in *
            do
                if [ -d $i ] || [[ "$i" == "uevent" ]] || \
                        [[ "$i" == "modalias" ]] || \
                        [[ "$i" == "name" ]] || \
                        [[ "$i" == "DeviceInfo" ]] || \
                        [[ "$i" == "RaTable" ]]; then
                    continue
                fi
                # batt2 file path
                batt2_path+=${p}/${i}" "
                # batt2 name
                batt2_name+=batt2-${i},
            done
            cd -

            # add cooling device
            p=/sys/class/thermal
            cd $p
            for i in cooling_device*
            do
                # cooling device path
                cooling_path+=${p}/${i}/cur_state" "
                # cooling device name
                cooling_name+=dev-`cat ${p}/${i}/type`,
            done
            cd -

            # add thermal zone
            p=/sys/class/thermal
            cd $p
            for i in thermal_zone*
            do
                # tz path
                tz_type=`cat ${p}/${i}/type`

                if [[ "$tz_type" == "modem-mmw1-mod-usr" ]] || \
                        [[ "$tz_type" == "modem-mmw2-mod-usr" ]] || \
                        [[ "$tz_type" == "modem-mmw3-mod-usr" ]]; then
                    continue;
                fi

                tz_path+=${p}/${i}/temp" "
                # tz name
                tz_name+=tz-${tz_type},
            done
            cd -

            # write prop name to file
            out_name+=${freq_name}${ps_name}${batt1_name}${batt2_name}${cooling_name}${tz_name}
            echo ${out_name} >${BATT_LOGFILE}
        fi

        # add header
        out_data="`echo $(date "+%Y-%m-%d %H:%M:%S.%3N")`,${ktime},${VER},${file_count},${count},${platform},${product},"
        # add freq
        freq_data=`cat ${freq_path} | tr '\n' ','`
        # add ps
        ps_data=`cat ${ps_path} | tr '\n' ','`
        # add batt1
        batt1_data=`cat ${batt1_path} | tr '\n' ','`
        # add batt2
        batt2_data=`cat ${batt2_path} | tr '\n' ','`
        # add cooling device
        cooling_data=`cat ${cooling_path} | tr '\n' ','`
        # add tz
        tz_data=`cat ${tz_path} | tr '\n' ','`
        # write data to file
        out_data+=${freq_data}${ps_data}${batt1_data}${batt2_data}${cooling_data}${tz_data}
        echo ${out_data} >>${BATT_LOGFILE}

        if [ $(((count - 1) % 5)) -eq 0 ]; then
            dumper_flag=1
        else
            dumper_flag=0
        fi

        BATT_LOGFILE_size=`stat -c "%s" $BATT_LOGFILE`
        BATT_LOGFILE_GROUP_size=$(($BATT_LOGFILE_size))

        let count=$count+1
        sleep $pause_time

        if [ $BATT_LOGFILE_GROUP_size -gt $BATT_LOGFILE_GROUP_MAX_SIZE ]; then
            mv_files $BATT_LOGFILE
            if [ $dumper_en -eq 1 ]; then
                mv_files $BATT_LOGFILE_QC
            fi
            let file_count=$file_count+1
        fi
    done
else
	pause_time=5
	freq_path=
	dev_path=
	pro_name=
	pro_data=
	len=${#array[@]}

    sleep 3
    while [ 1 ]
    do
        utime=($(cat /proc/uptime))
        ktime=${utime[0]}

        if [[ "$pro_name" == "" ]] || [ ! -f ${BATT_LOGFILE} ]; then
            # add header
            pro_name="time,uptime,version,log_cnt,rec_cnt,platform,product,"

			while [ $i -lt $len ]
			do
			echo ${array_default[i+1]}
				if [ -r ${array_default[i+1]} ]; then
					freq_path+="${array_default[i+1]}"" "
					pro_name+="${array_default[i]}",
				fi
				((i=i+2))
			done

            # add cooling device
            p=/sys/class/thermal
            cd $p
            for i in cooling_device*
            do
                dev_path+=${p}/${i}/cur_state" "
                pro_name+=dev-`cat ${p}/${i}/type`,
            done
            cd -

            # write prop name to file
            echo ${pro_name} >${BATT_LOGFILE}
        fi

        # add header
        pro_data="`echo $(date "+%Y-%m-%d %H:%M:%S.%3N")`,${ktime},${VER},${file_count},${count},${platform},${product},"
        pro_data+=`cat ${freq_path} | tr '\n' ','`
        pro_data+=`cat ${dev_path} | tr '\n' ','`

        echo ${pro_data} >>${BATT_LOGFILE}

        if [ $(((count - 1) % 5)) -eq 0 ]; then
            dumper_flag=1
        else
            dumper_flag=0
        fi

        BATT_LOGFILE_size=`stat -c "%s" $BATT_LOGFILE`
        BATT_LOGFILE_GROUP_size=$(($BATT_LOGFILE_size))

        let count=$count+1
        sleep $pause_time

        if [ $BATT_LOGFILE_GROUP_size -gt $BATT_LOGFILE_GROUP_MAX_SIZE ]; then
            mv_files $BATT_LOGFILE
            if [ $dumper_en -eq 1 ]; then
                mv_files $BATT_LOGFILE_QC
            fi
            let file_count=$file_count+1
        fi
    done
fi
