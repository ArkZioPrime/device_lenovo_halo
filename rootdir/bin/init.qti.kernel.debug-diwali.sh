#=============================================================================
# Copyright (c) 2020-2022 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2014-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

enable_tracing_events()
{
    # sound
    echo 1 > /sys/kernel/tracing/events/asoc/snd_soc_reg_read/enable
    echo 1 > /sys/kernel/tracing/events/asoc/snd_soc_reg_write/enable
    # mdp
    echo 1 > /sys/kernel/tracing/events/mdss/mdp_video_underrun_done/enable
    # video
    echo 1 > /sys/kernel/tracing/events/msm_vidc/enable
    # power
    echo 1 > /sys/kernel/tracing/events/msm_low_power/enable
    # fastrpc
    echo 1 > /sys/kernel/tracing/events/fastrpc/enable

    echo 1 > /sys/kernel/tracing/tracing_on
}

# function to enable ftrace events
enable_ftrace_event_tracing()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    enable_tracing_events
}

enable_memory_debug()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/buffer_size
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo coresight-stm > /sys/class/stm_source/ftrace/stm_source_link
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
}
enable_lpm_with_dcvs_tracing()
{
    # "Configure CPUSS LPM Debug events"
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/reset
    echo 0x0 0x3 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x0 0x3 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0x4 0x4 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x4 0x4 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0x5 0x5 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x5 0x5 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0x6 0x8 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x6 0x8 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0xc 0xf 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0xc 0xf 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0xc 0xf 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0x1d 0x1d 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x1d 0x1d 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0x2b 0x3f 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x2b 0x3f 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0x80 0x9a 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
    echo 0x80 0x9a 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
    echo 0 0x11111111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 1 0x66660001  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 2 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 3 0x00100000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 5 0x11111000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 6 0x11111111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 7 0x11111111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 16 0x11111111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 17 0x11111111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 18 0x11111111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 19 0x00000111  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
    echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_ts
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_type
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_trig_ts


    # "Configure CPUCP Trace and Debug Bus ACTPM "
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/reset
    ### CMB_MSR : [10]: debug_en, [7:6] : 0x0-0x3 : clkdom0-clkdom3 debug_bus
    ###         : [5]: trace_en, [4]: 0b0:continuous mode 0b1 : legacy mode
    ###         : [3:0] : legacy mode : 0x0 : combined_traces 0x1-0x4 : clkdom0-clkdom3
    ### Select CLKDOM0 (L3) debug bus and all CLKDOM trace bus
    echo 0 0x420 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_msr
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-actpm/mcmb_lanes_select
    echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tpda-actpm/cmbchan_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_ts_all
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_ts
    echo 0 0x20000000 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_mask
    echo 0 0x20000000 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_val

    # "Start Trace collection "
    echo 2 > /sys/bus/coresight/devices/coresight-tpdm-apss/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/enable_source
    echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-actpm/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/enable_source

}


enable_stm_hw_events()
{
   #TODO: Add HW events
}

gemnoc_dump()
{
    #; gem_noc_fault_sbm
    echo 0x191b0040 > $DCC_PATH/config
    echo 0x191b0048 > $DCC_PATH/config
    #; gem_noc_qns_cnoc_poc_err
    echo 0x19180010 > $DCC_PATH/config
    echo 0x19180020 6 > $DCC_PATH/config
    #; gem_noc_qns_pcie_poc_err
    echo 0x19181010 > $DCC_PATH/config
    echo 0x19181020 6 > $DCC_PATH/config
    #; gem_noc_qns_llcc0_poc_err
    echo 0x19100010 > $DCC_PATH/config
    echo 0x19100020 6 > $DCC_PATH/config
    #; gem_noc_qns_llcc1_poc_err
    echo 0x19140010 > $DCC_PATH/config
    echo 0x19140020 6 > $DCC_PATH/config
    #; gem_noc_qns_llcc2_poc_err
    #; gem_noc_qns_llcc3_poc_err

    #; gem_noc_qns_cnoc_poc_dbg
    echo 0x19180410 > $DCC_PATH/config
    echo 0x10  > $DCC_PATH/loop
    echo 0x19180438 > $DCC_PATH/config
    echo 0x19180430 2 > $DCC_PATH/config
    echo 0x19180430 2 > $DCC_PATH/config
    echo 0x19180430 2 > $DCC_PATH/config
    echo 0x19180430 2 > $DCC_PATH/config
    echo 0x1  > $DCC_PATH/loop
    echo 0x19180408 2 > $DCC_PATH/config
    #; gem_noc_qns_pcie_poc_dbg
    echo 0x19181410 > $DCC_PATH/config
    echo 0x10  > $DCC_PATH/loop
    echo 0x19181438 > $DCC_PATH/config
    echo 0x19181430 2 > $DCC_PATH/config
    echo 0x19181430 2 > $DCC_PATH/config
    echo 0x19181430 2 > $DCC_PATH/config
    echo 0x19181430 2 > $DCC_PATH/config
    echo 0x1  > $DCC_PATH/loop
    echo 0x19181408 2 > $DCC_PATH/config
    #; gem_noc_qns_llcc0_poc_dbg
    echo 0x19100410 > $DCC_PATH/config
    echo 0x40  > $DCC_PATH/loop
    echo 0x19100438 > $DCC_PATH/config
    echo 0x19100430 2 > $DCC_PATH/config
    echo 0x19100430 2 > $DCC_PATH/config
    echo 0x19100430 2 > $DCC_PATH/config
    echo 0x19100430 2 > $DCC_PATH/config
    echo 0x1  > $DCC_PATH/loop
    echo 0x19100408 2 > $DCC_PATH/config
    #; gem_noc_qns_llcc1_poc_dbg
    echo 0x19140410 > $DCC_PATH/config
    echo 0x40  > $DCC_PATH/loop
    echo 0x19140438 > $DCC_PATH/config
    echo 0x19140430 2 > $DCC_PATH/config
    echo 0x19140430 2 > $DCC_PATH/config
    echo 0x19140430 2 > $DCC_PATH/config
    echo 0x19140430 2 > $DCC_PATH/config
    echo 0x1  > $DCC_PATH/loop
    echo 0x19140408 2 > $DCC_PATH/config

    #; NonCoherent_sys_chain
    echo 0x19191018 > $DCC_PATH/config
    echo 0x19191008 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    echo 0x19191010 2 > $DCC_PATH/config
    #; NonCoherent_odd_chain
    echo 0x1914d018 > $DCC_PATH/config
    echo 0x1914d008 > $DCC_PATH/config
    echo 0x1914d010 2 > $DCC_PATH/config
    echo 0x1914d010 2 > $DCC_PATH/config
    echo 0x1914d010 2 > $DCC_PATH/config
    echo 0x1914d010 2 > $DCC_PATH/config
    echo 0x1914d010 2 > $DCC_PATH/config
    #; NonCoherent_even_chain
    echo 0x1910d018 > $DCC_PATH/config
    echo 0x1910d008 > $DCC_PATH/config
    echo 0x1910d010 2 > $DCC_PATH/config
    echo 0x1910d010 2 > $DCC_PATH/config
    echo 0x1910d010 2 > $DCC_PATH/config
    echo 0x1910d010 2 > $DCC_PATH/config
    echo 0x1910d010 2 > $DCC_PATH/config
    #; Coherent_sys_chain
    echo 0x19190018 > $DCC_PATH/config
    echo 0x19190008 > $DCC_PATH/config
    echo 0x19190010 2 > $DCC_PATH/config
    echo 0x19190010 2 > $DCC_PATH/config
    echo 0x19190010 2 > $DCC_PATH/config
    #; Coherent_odd_chain
    echo 0x1914c018 > $DCC_PATH/config
    echo 0x1914c008 > $DCC_PATH/config
    echo 0x1914c010 2 > $DCC_PATH/config
    echo 0x1914c010 2 > $DCC_PATH/config
    echo 0x1914c010 2 > $DCC_PATH/config
    echo 0x1914c010 2 > $DCC_PATH/config
    #; Coherent_even_chain
    echo 0x1910c018 > $DCC_PATH/config
    echo 0x1910c008 > $DCC_PATH/config
    echo 0x1910c010 2 > $DCC_PATH/config
    echo 0x1910c010 2 > $DCC_PATH/config
    echo 0x1910c010 2 > $DCC_PATH/config
    echo 0x1910c010 2 > $DCC_PATH/config

    echo 0x19121010 > $DCC_PATH/config
    echo 0x19123010 > $DCC_PATH/config
    echo 0x191a1010 > $DCC_PATH/config
    echo 0x191a4010 > $DCC_PATH/config
    echo 0x191a5010 > $DCC_PATH/config
    echo 0x191a0010 > $DCC_PATH/config
    echo 0x19160010 > $DCC_PATH/config
    echo 0x19120010 > $DCC_PATH/config
    echo 0x191a6010 > $DCC_PATH/config
    echo 0x19122010 > $DCC_PATH/config
    echo 0x191a2010 > $DCC_PATH/config
    echo 0x191a3010 > $DCC_PATH/config
    echo 0x19161010 > $DCC_PATH/config
    echo 0x19162010 > $DCC_PATH/config
    echo 0x19163010 > $DCC_PATH/config
}

dc_noc_dump() {
    #; dc_noc_dch_erl
    echo 0x190e0010 > $DCC_PATH/config
    echo 0x190e0020 8 > $DCC_PATH/config
    echo 0x190e0248 > $DCC_PATH/config
    #; dc_noc_ch_hm02_erl
    #; dc_noc_ch_hm13_erl

    #; dch/DebugChain
    echo 0x190e5018 > $DCC_PATH/config
    echo 0x190e5008 > $DCC_PATH/config
    echo 0x6  > $DCC_PATH/loop
    echo 0x190e5010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

lpass_ag_noc_dump() {
    #; lpass_ag_noc_lpass_ag_noc_Errorlogger_erl
    echo 0x3c40010 > $DCC_PATH/config
    echo 0x3c40020 8 > $DCC_PATH/config
    echo 0x3c4b048 > $DCC_PATH/config

    #; agnoc_core_DebugChain
    echo 0x3c41018 > $DCC_PATH/config
    echo 0x3c41008 > $DCC_PATH/config
    echo 0x5  > $DCC_PATH/loop
    echo 0x3c41010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

mmss_noc_dump() {
    echo 0x175B010 > $DCC_PATH/config
    echo 0x175B090 > $DCC_PATH/config
    echo 0x175B110 > $DCC_PATH/config
    echo 0x174B090 > $DCC_PATH/config
    echo 0x174B010 > $DCC_PATH/config
    echo 0x174C010 > $DCC_PATH/config
    echo 0x175D010 > $DCC_PATH/config
    echo 0x174C090 > $DCC_PATH/config
    echo 0x175C010 > $DCC_PATH/config
    echo 0x175C090 > $DCC_PATH/config
}

system_noc_dump() {
    #; system_noc_erl
    echo 0x1680010 > $DCC_PATH/config
    echo 0x1680020 8 > $DCC_PATH/config
    echo 0x1680248 > $DCC_PATH/config

    #; DebugChain
    echo 0x1681018 > $DCC_PATH/config
    echo 0x1681008 > $DCC_PATH/config
    echo 0x7  > $DCC_PATH/loop
    echo 0x1681010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    echo 0x1691010 > $DCC_PATH/config
    echo 0x1697010 > $DCC_PATH/config
    echo 0x1698010 > $DCC_PATH/config
    echo 0x1694010 > $DCC_PATH/config
    echo 0x1696010 > $DCC_PATH/config
    echo 0x1699010 > $DCC_PATH/config

    echo 0x840202C > $DCC_PATH/config
    echo 0x8402030 > $DCC_PATH/config
    echo 0x8402034 > $DCC_PATH/config
    echo 0x8402038 > $DCC_PATH/config
    echo 0x8402048 > $DCC_PATH/config
    echo 0x840204C > $DCC_PATH/config
}

aggre_noc_dump() {
    #; aggre_noc_a1noc_ErrorLogger_erl
    echo 0x16e0010 > $DCC_PATH/config
    echo 0x16e0020 8 > $DCC_PATH/config
    echo 0x16e0248 > $DCC_PATH/config
    #; aggre_noc_a2noc_ErrorLogger_erl
    echo 0x1700010 > $DCC_PATH/config
    echo 0x1700020 8 > $DCC_PATH/config
    echo 0x1700248 > $DCC_PATH/config
    #; aggre_noc_pcie_anoc_ErrorLogger_erl
    echo 0x16c0010 > $DCC_PATH/config
    echo 0x16c0020 8 > $DCC_PATH/config
    echo 0x16c0248 > $DCC_PATH/config

    #; aggre_noc/DebugChain_south
    echo 0x16e1018 > $DCC_PATH/config
    echo 0x16e1008 > $DCC_PATH/config
    echo 0x4  > $DCC_PATH/loop
    echo 0x16e1010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    #; aggre_noc/DebugChain_pcie
    echo 0x16c1018 > $DCC_PATH/config
    echo 0x16c1008 > $DCC_PATH/config
    echo 0x4  > $DCC_PATH/loop
    echo 0x16c1010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    #; aggre_noc/DebugChain_center
    echo 0x1701018 > $DCC_PATH/config
    echo 0x1701008 > $DCC_PATH/config
    echo 0x5  > $DCC_PATH/loop
    echo 0x1701010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    echo 0x16e9010 > $DCC_PATH/config
    echo 0x16ea010 > $DCC_PATH/config
    echo 0x16eb010 > $DCC_PATH/config
    echo 0x1710010 > $DCC_PATH/config
    echo 0x1714010 > $DCC_PATH/config
    echo 0x1711010 > $DCC_PATH/config
    echo 0x170e010 > $DCC_PATH/config
    echo 0x170f010 > $DCC_PATH/config
    echo 0x1712010 > $DCC_PATH/config
    echo 0x1713010 > $DCC_PATH/config
    echo 0x1715010 > $DCC_PATH/config

    echo 0x1A089C > $DCC_PATH/config
    echo 0x120008 > $DCC_PATH/config

    echo 0x1A0004 > $DCC_PATH/config
    echo 0x1A0008 > $DCC_PATH/config
    echo 0x120024 > $DCC_PATH/config
    echo 0x120028 > $DCC_PATH/config
    echo 0x1A0010 > $DCC_PATH/config
    echo 0x1A0018 > $DCC_PATH/config
}

config_noc_dump() {
    #; config_noc_erl
    echo 0x1500010 > $DCC_PATH/config
    echo 0x1500020 8 > $DCC_PATH/config
    echo 0x1500248 2 > $DCC_PATH/config
    echo 0x1500258 > $DCC_PATH/config
    echo 0x1500448 > $DCC_PATH/config

    #; config_noc/south_DebugChain
    echo 0x1512018 > $DCC_PATH/config
    echo 0x1512008 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x1512010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    #; config_noc/north_DebugChain
    echo 0x1513018 > $DCC_PATH/config
    echo 0x1513008 > $DCC_PATH/config
    echo 0x4  > $DCC_PATH/loop
    echo 0x1513010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    #; config_noc/center_DebugChain
    echo 0x1510018 > $DCC_PATH/config
    echo 0x1510008 > $DCC_PATH/config
    echo 0xb  > $DCC_PATH/loop
    echo 0x1510010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x1847ac > $DCC_PATH/config
}


config_dcc_ddr()
{
    #DDR -DCC starts here.
    #Start Link list #6
    #DDRSS
    echo 0x19080024 > $DCC_PATH/config
    echo 0x1908002c > $DCC_PATH/config
    echo 0x19080034 > $DCC_PATH/config
    echo 0x1908003c > $DCC_PATH/config
    echo 0x19080044 > $DCC_PATH/config
    echo 0x1908004c > $DCC_PATH/config
    echo 0x19080058 2 > $DCC_PATH/config
    echo 0x190800c8 > $DCC_PATH/config
    echo 0x190800d4 > $DCC_PATH/config
    echo 0x190800e0 > $DCC_PATH/config
    echo 0x19080144 > $DCC_PATH/config
    echo 0x1908014c > $DCC_PATH/config
    echo 0x19080174 > $DCC_PATH/config
    echo 0x1908017c > $DCC_PATH/config
    echo 0x19080184 > $DCC_PATH/config
    echo 0x1908018c > $DCC_PATH/config
    echo 0x19080194 > $DCC_PATH/config
    echo 0x1908019c > $DCC_PATH/config
    echo 0x190801a4 > $DCC_PATH/config
    echo 0x190801ac 3 > $DCC_PATH/config

    #DPCC
    echo 0x190a9168 2 > $DCC_PATH/config
    echo 0x190a9178 2 > $DCC_PATH/config
    echo 0x190a9188 2 > $DCC_PATH/config
    echo 0x190a80e4 2 > $DCC_PATH/config
    echo 0x190a80f8 5 > $DCC_PATH/config
    echo 0x190a8150 2 > $DCC_PATH/config
    echo 0x190a8164 2 > $DCC_PATH/config
    echo 0x190a8174 4 > $DCC_PATH/config
    echo 0x190a819c > $DCC_PATH/config
    echo 0x190a81cc > $DCC_PATH/config
    echo 0x190a8498 > $DCC_PATH/config
    echo 0x190a8804 > $DCC_PATH/config
    echo 0x190a880c > $DCC_PATH/config
    echo 0x190a8834 > $DCC_PATH/config
    echo 0x190a8840 2 > $DCC_PATH/config
    echo 0x190a8850 2 > $DCC_PATH/config
    echo 0x190a8860 3 > $DCC_PATH/config
    echo 0x190a8878 > $DCC_PATH/config
    echo 0x190a888c > $DCC_PATH/config
    echo 0x190a8900 > $DCC_PATH/config
    echo 0x190a9134 2 > $DCC_PATH/config
    echo 0x190a9198 2 > $DCC_PATH/config
    echo 0x190a91c4 2 > $DCC_PATH/config
    echo 0x190aa034 3 > $DCC_PATH/config
    echo 0x190aa044 > $DCC_PATH/config
    echo 0x190aa04c > $DCC_PATH/config
    echo 0x190a8884 > $DCC_PATH/config
    echo 0x190a9140 > $DCC_PATH/config

    #DPCC_PLL
    echo 0x190a0008 2 > $DCC_PATH/config
    echo 0x190a1008 2 > $DCC_PATH/config

    # LLCC
    echo 0x19220344 9 > $DCC_PATH/config
    echo 0x19220370 7 > $DCC_PATH/config
    echo 0x19220480 > $DCC_PATH/config
    echo 0x19222400 26 > $DCC_PATH/config
    echo 0x19222470 5 > $DCC_PATH/config
    echo 0x1922320c > $DCC_PATH/config
    echo 0x19223214 2 > $DCC_PATH/config
    echo 0x19223220 4 > $DCC_PATH/config
    echo 0x19223308 > $DCC_PATH/config
    echo 0x19223318 > $DCC_PATH/config
    echo 0x19223318 > $DCC_PATH/config
    echo 0x1922358c > $DCC_PATH/config
    echo 0x19234010 > $DCC_PATH/config
    echo 0x1923801c 8 > $DCC_PATH/config
    echo 0x19238050 > $DCC_PATH/config
    echo 0x19238100 > $DCC_PATH/config
    echo 0x19238100 7 > $DCC_PATH/config
    echo 0x1923c004 > $DCC_PATH/config
    echo 0x1923c014 > $DCC_PATH/config
    echo 0x1923c020 > $DCC_PATH/config
    echo 0x1923c030 > $DCC_PATH/config
    echo 0x1923c05c 3 > $DCC_PATH/config
    echo 0x1923c074 > $DCC_PATH/config
    echo 0x1923c088 > $DCC_PATH/config
    echo 0x1923c0a0 > $DCC_PATH/config
    echo 0x1923c0b0 > $DCC_PATH/config
    echo 0x1923c0c0 > $DCC_PATH/config
    echo 0x1923c0d0 > $DCC_PATH/config
    echo 0x1923c0e0 > $DCC_PATH/config
    echo 0x1923c0f0 > $DCC_PATH/config
    echo 0x1923c100 > $DCC_PATH/config
    echo 0x1923d064 > $DCC_PATH/config
    echo 0x19240008 6 > $DCC_PATH/config
    echo 0x19240028 > $DCC_PATH/config
    echo 0x1924203c 3 > $DCC_PATH/config
    echo 0x19242044 2 > $DCC_PATH/config
    echo 0x19242048 2 > $DCC_PATH/config
    echo 0x1924204c 10 > $DCC_PATH/config
    echo 0x1924208c > $DCC_PATH/config
    echo 0x192420b0 > $DCC_PATH/config
    echo 0x192420b0 > $DCC_PATH/config
    echo 0x192420b8 3 > $DCC_PATH/config
    echo 0x192420f4 > $DCC_PATH/config
    echo 0x192420fc 3 > $DCC_PATH/config
    echo 0x19242104 5 > $DCC_PATH/config
    echo 0x19242114 > $DCC_PATH/config
    echo 0x19242324 14 > $DCC_PATH/config
    echo 0x19242410 > $DCC_PATH/config
    echo 0x192430a8 > $DCC_PATH/config
    echo 0x19248004 7 > $DCC_PATH/config
    echo 0x19248024 > $DCC_PATH/config
    echo 0x19248040 > $DCC_PATH/config
    echo 0x19248048 > $DCC_PATH/config
    echo 0x19249064 > $DCC_PATH/config
    echo 0x1924c000 > $DCC_PATH/config
    echo 0x1924c030 > $DCC_PATH/config
    echo 0x1924c030 3 > $DCC_PATH/config
    echo 0x1924c040 3 > $DCC_PATH/config
    echo 0x1924c054 2 > $DCC_PATH/config
    echo 0x1924c078 > $DCC_PATH/config
    echo 0x1924c108 > $DCC_PATH/config
    echo 0x1924c110 > $DCC_PATH/config
    echo 0x19250020 > $DCC_PATH/config
    echo 0x19250020 > $DCC_PATH/config
    echo 0x19251054 > $DCC_PATH/config
    echo 0x19252014 3 > $DCC_PATH/config
    echo 0x19252028 > $DCC_PATH/config
    echo 0x19252028 17 > $DCC_PATH/config
    echo 0x19252070 8 > $DCC_PATH/config
    echo 0x19252098 > $DCC_PATH/config
    echo 0x192520a0 > $DCC_PATH/config
    echo 0x192520b4 > $DCC_PATH/config
    echo 0x192520c0 > $DCC_PATH/config
    echo 0x192520d0 3 > $DCC_PATH/config
    echo 0x192520f4 10 > $DCC_PATH/config
    echo 0x19252120 12 > $DCC_PATH/config
    echo 0x1925802c > $DCC_PATH/config
    echo 0x1925809c 2 > $DCC_PATH/config
    echo 0x192580a8 3 > $DCC_PATH/config
    echo 0x192580b8 > $DCC_PATH/config
    echo 0x192580c0 7 > $DCC_PATH/config
    echo 0x192580e0 > $DCC_PATH/config
    echo 0x192580e8 > $DCC_PATH/config
    echo 0x192580f0 > $DCC_PATH/config
    echo 0x192580f8 > $DCC_PATH/config
    echo 0x19258100 > $DCC_PATH/config
    echo 0x19258108 > $DCC_PATH/config
    echo 0x19258110 > $DCC_PATH/config
    echo 0x19258118 > $DCC_PATH/config
    echo 0x19258120 > $DCC_PATH/config
    echo 0x19258128 > $DCC_PATH/config
    echo 0x19258210 3 > $DCC_PATH/config
    echo 0x19259010 > $DCC_PATH/config
    echo 0x19259070 > $DCC_PATH/config
    echo 0x1925b004 > $DCC_PATH/config
    echo 0x1926004c > $DCC_PATH/config
    echo 0x1926004c 2 > $DCC_PATH/config
    echo 0x19260050 2 > $DCC_PATH/config
    echo 0x19260054 2 > $DCC_PATH/config
    echo 0x19260058 2 > $DCC_PATH/config
    echo 0x1926005c 2 > $DCC_PATH/config
    echo 0x19260060 2 > $DCC_PATH/config
    echo 0x19260064 2 > $DCC_PATH/config
    echo 0x19260068 3 > $DCC_PATH/config
    echo 0x19260078 > $DCC_PATH/config
    echo 0x1926020c > $DCC_PATH/config
    echo 0x19260214 > $DCC_PATH/config
    echo 0x19261084 > $DCC_PATH/config
    echo 0x19262020 > $DCC_PATH/config
    echo 0x19263020 > $DCC_PATH/config
    echo 0x19264020 > $DCC_PATH/config
    echo 0x19265020 > $DCC_PATH/config
    echo 0x19320344 2 > $DCC_PATH/config
    echo 0x19320348 8 > $DCC_PATH/config
    echo 0x19320370 7 > $DCC_PATH/config
    echo 0x19320480 > $DCC_PATH/config
    echo 0x19320480 > $DCC_PATH/config
    echo 0x19322400 > $DCC_PATH/config
    echo 0x19322400 26 > $DCC_PATH/config
    echo 0x19322470 5 > $DCC_PATH/config
    echo 0x1932320c > $DCC_PATH/config
    echo 0x19323214 2 > $DCC_PATH/config
    echo 0x19323220 > $DCC_PATH/config
    echo 0x19323220 2 > $DCC_PATH/config
    echo 0x19323224 2 > $DCC_PATH/config
    echo 0x19323228 2 > $DCC_PATH/config
    echo 0x1932322c > $DCC_PATH/config
    echo 0x19323308 > $DCC_PATH/config
    echo 0x19323308 > $DCC_PATH/config
    echo 0x19323318 > $DCC_PATH/config
    echo 0x19323318 > $DCC_PATH/config
    echo 0x1932358c > $DCC_PATH/config
    echo 0x19334010 > $DCC_PATH/config
    echo 0x1933801c 8 > $DCC_PATH/config
    echo 0x19338050 > $DCC_PATH/config
    echo 0x19338100 > $DCC_PATH/config
    echo 0x19338100 7 > $DCC_PATH/config
    echo 0x1933c004 > $DCC_PATH/config
    echo 0x1933c014 > $DCC_PATH/config
    echo 0x1933c020 > $DCC_PATH/config
    echo 0x1933c030 > $DCC_PATH/config
    echo 0x1933c05c 3 > $DCC_PATH/config
    echo 0x1933c074 > $DCC_PATH/config
    echo 0x1933c088 > $DCC_PATH/config
    echo 0x1933c0a0 > $DCC_PATH/config
    echo 0x1933c0b0 > $DCC_PATH/config
    echo 0x1933c0c0 > $DCC_PATH/config
    echo 0x1933c0d0 > $DCC_PATH/config
    echo 0x1933c0e0 > $DCC_PATH/config
    echo 0x1933c0f0 > $DCC_PATH/config
    echo 0x1933c100 > $DCC_PATH/config
    echo 0x1933d064 > $DCC_PATH/config
    echo 0x19340008 6 > $DCC_PATH/config
    echo 0x19340028 > $DCC_PATH/config
    echo 0x1934203c 3 > $DCC_PATH/config
    echo 0x19342044 2 > $DCC_PATH/config
    echo 0x19342048 2 > $DCC_PATH/config
    echo 0x1934204c 10 > $DCC_PATH/config
    echo 0x1934208c > $DCC_PATH/config
    echo 0x193420b0 > $DCC_PATH/config
    echo 0x193420b0 > $DCC_PATH/config
    echo 0x193420b8 3 > $DCC_PATH/config
    echo 0x193420f4 > $DCC_PATH/config
    echo 0x193420fc 3 > $DCC_PATH/config
    echo 0x19342104 5 > $DCC_PATH/config
    echo 0x19342114 > $DCC_PATH/config
    echo 0x19342324 14 > $DCC_PATH/config
    echo 0x19342410 > $DCC_PATH/config
    echo 0x193430a8 > $DCC_PATH/config
    echo 0x19348004 > $DCC_PATH/config
    echo 0x19348004 2 > $DCC_PATH/config
    echo 0x19348008 2 > $DCC_PATH/config
    echo 0x1934800c 2 > $DCC_PATH/config
    echo 0x19348010 4 > $DCC_PATH/config
    echo 0x19348024 > $DCC_PATH/config
    echo 0x19348040 > $DCC_PATH/config
    echo 0x19348048 > $DCC_PATH/config
    echo 0x19349064 > $DCC_PATH/config
    echo 0x1934c000 > $DCC_PATH/config
    echo 0x1934c030 > $DCC_PATH/config
    echo 0x1934c030 3 > $DCC_PATH/config
    echo 0x1934c040 3 > $DCC_PATH/config
    echo 0x1934c054 2 > $DCC_PATH/config
    echo 0x1934c078 > $DCC_PATH/config
    echo 0x1934c108 > $DCC_PATH/config
    echo 0x1934c110 > $DCC_PATH/config
    echo 0x19350020 > $DCC_PATH/config
    echo 0x19350020 > $DCC_PATH/config
    echo 0x19351054 > $DCC_PATH/config
    echo 0x19352014 3 > $DCC_PATH/config
    echo 0x19352028 > $DCC_PATH/config
    echo 0x19352028 17 > $DCC_PATH/config
    echo 0x19352070 8 > $DCC_PATH/config
    echo 0x19352098 > $DCC_PATH/config
    echo 0x193520a0 > $DCC_PATH/config
    echo 0x193520b4 > $DCC_PATH/config
    echo 0x193520c0 > $DCC_PATH/config
    echo 0x193520d0 3 > $DCC_PATH/config
    echo 0x193520f4 10 > $DCC_PATH/config
    echo 0x19352120 12 > $DCC_PATH/config
    echo 0x1935802c > $DCC_PATH/config
    echo 0x1935802c > $DCC_PATH/config
    echo 0x1935809c > $DCC_PATH/config
    echo 0x1935809c 2 > $DCC_PATH/config
    echo 0x193580a8 3 > $DCC_PATH/config
    echo 0x193580b8 > $DCC_PATH/config
    echo 0x193580c0 7 > $DCC_PATH/config
    echo 0x193580e0 > $DCC_PATH/config
    echo 0x193580e8 > $DCC_PATH/config
    echo 0x193580f0 > $DCC_PATH/config
    echo 0x193580f8 > $DCC_PATH/config
    echo 0x193580a0 > $DCC_PATH/config
    echo 0x193580a8 3 > $DCC_PATH/config
    echo 0x193580b8 > $DCC_PATH/config
    echo 0x193580c0 7 > $DCC_PATH/config
    echo 0x193580e0 > $DCC_PATH/config
    echo 0x193580e8 > $DCC_PATH/config
    echo 0x193580f0 > $DCC_PATH/config
    echo 0x193580f8 > $DCC_PATH/config
    echo 0x19358100 > $DCC_PATH/config
    echo 0x19358100 > $DCC_PATH/config
    echo 0x19358108 > $DCC_PATH/config
    echo 0x19358108 > $DCC_PATH/config
    echo 0x19358110 > $DCC_PATH/config
    echo 0x19358110 > $DCC_PATH/config
    echo 0x19358118 > $DCC_PATH/config
    echo 0x19358118 > $DCC_PATH/config
    echo 0x19358120 > $DCC_PATH/config
    echo 0x19358120 > $DCC_PATH/config
    echo 0x19358128 > $DCC_PATH/config
    echo 0x19358128 > $DCC_PATH/config
    echo 0x19358210 > $DCC_PATH/config
    echo 0x19358210 2 > $DCC_PATH/config
    echo 0x19358214 2 > $DCC_PATH/config
    echo 0x19358218 > $DCC_PATH/config
    echo 0x19359010 > $DCC_PATH/config
    echo 0x19359010 > $DCC_PATH/config
    echo 0x19359070 > $DCC_PATH/config
    echo 0x19359070 > $DCC_PATH/config
    echo 0x1935b004 > $DCC_PATH/config
    echo 0x1935b004 > $DCC_PATH/config
    echo 0x1936004c > $DCC_PATH/config
    echo 0x1936004c > $DCC_PATH/config
    echo 0x1936004c 2 > $DCC_PATH/config
    echo 0x19360050 > $DCC_PATH/config
    echo 0x19360050 2 > $DCC_PATH/config
    echo 0x19360054 > $DCC_PATH/config
    echo 0x19360054 2 > $DCC_PATH/config
    echo 0x19360058 > $DCC_PATH/config
    echo 0x19360058 2 > $DCC_PATH/config
    echo 0x1936005c > $DCC_PATH/config
    echo 0x1936005c 2 > $DCC_PATH/config
    echo 0x19360060 > $DCC_PATH/config
    echo 0x19360060 2 > $DCC_PATH/config
    echo 0x19360064 > $DCC_PATH/config
    echo 0x19360064 2 > $DCC_PATH/config
    echo 0x19360068 > $DCC_PATH/config
    echo 0x19360068 3 > $DCC_PATH/config
    echo 0x19360078 > $DCC_PATH/config
    echo 0x1936020c > $DCC_PATH/config
    echo 0x19360214 > $DCC_PATH/config
    echo 0x19361084 > $DCC_PATH/config
    echo 0x19362020 > $DCC_PATH/config
    echo 0x19363020 > $DCC_PATH/config
    echo 0x19364020 > $DCC_PATH/config
    echo 0x19365020 > $DCC_PATH/config
    echo 0x19200004 > $DCC_PATH/config
    echo 0x19201004 > $DCC_PATH/config
    echo 0x19202004 > $DCC_PATH/config
    echo 0x19203004 > $DCC_PATH/config
    echo 0x19204004 > $DCC_PATH/config
    echo 0x19205004 > $DCC_PATH/config
    echo 0x19206004 > $DCC_PATH/config
    echo 0x19207004 > $DCC_PATH/config
    echo 0x19208004 > $DCC_PATH/config
    echo 0x19209004 > $DCC_PATH/config
    echo 0x1920a004 > $DCC_PATH/config
    echo 0x1920b004 > $DCC_PATH/config
    echo 0x1920c004 > $DCC_PATH/config
    echo 0x1920d004 > $DCC_PATH/config
    echo 0x1920e004 > $DCC_PATH/config
    echo 0x1920f004 > $DCC_PATH/config
    echo 0x19210004 > $DCC_PATH/config
    echo 0x19211004 > $DCC_PATH/config
    echo 0x19212004 > $DCC_PATH/config
    echo 0x19213004 > $DCC_PATH/config
    echo 0x19214004 > $DCC_PATH/config
    echo 0x19215004 > $DCC_PATH/config
    echo 0x19216004 > $DCC_PATH/config
    echo 0x19217004 > $DCC_PATH/config
    echo 0x19218004 > $DCC_PATH/config
    echo 0x19219004 > $DCC_PATH/config
    echo 0x1921a004 > $DCC_PATH/config
    echo 0x1921b004 > $DCC_PATH/config
    echo 0x1921c004 > $DCC_PATH/config
    echo 0x1921d004 > $DCC_PATH/config
    echo 0x1921e004 > $DCC_PATH/config
    echo 0x1921f004 > $DCC_PATH/config


    # MC5
    echo 0x192c5cac 3 > $DCC_PATH/config
    echo 0x192c0080 > $DCC_PATH/config
    echo 0x192c0310 > $DCC_PATH/config
    echo 0x192c0400 2 > $DCC_PATH/config
    echo 0x192c0410 6 > $DCC_PATH/config
    echo 0x192c0430 > $DCC_PATH/config
    echo 0x192c0440 > $DCC_PATH/config
    echo 0x192c0448 > $DCC_PATH/config
    echo 0x192c04a0 > $DCC_PATH/config
    echo 0x192c04b0 4 > $DCC_PATH/config
    echo 0x192c04d0 2 > $DCC_PATH/config
    echo 0x192c1400 > $DCC_PATH/config
    echo 0x192c1408 > $DCC_PATH/config
    echo 0x192c2400 2 > $DCC_PATH/config
    echo 0x192c2438 2 > $DCC_PATH/config
    echo 0x192c2454 > $DCC_PATH/config
    echo 0x192c3400 4 > $DCC_PATH/config
    echo 0x192c3418 3 > $DCC_PATH/config
    echo 0x192c4700 > $DCC_PATH/config
    echo 0x192c53b0 > $DCC_PATH/config
    echo 0x192c5804 > $DCC_PATH/config
    echo 0x192c590c > $DCC_PATH/config
    echo 0x192c5a14 > $DCC_PATH/config
    echo 0x192c5c0c > $DCC_PATH/config
    echo 0x192c5c18 2 > $DCC_PATH/config
    echo 0x192c5c2c 2 > $DCC_PATH/config
    echo 0x192c5c38 > $DCC_PATH/config
    echo 0x192c5c4c > $DCC_PATH/config
    echo 0x192c5ca4 > $DCC_PATH/config
    echo 0x192c5cac 3 > $DCC_PATH/config
    echo 0x192c6400 > $DCC_PATH/config
    echo 0x192c6418 2 > $DCC_PATH/config
    echo 0x192c9100 > $DCC_PATH/config
    echo 0x192c9110 > $DCC_PATH/config
    echo 0x192c9120 > $DCC_PATH/config
    echo 0x192c9180 > $DCC_PATH/config
    echo 0x192c9180 2 > $DCC_PATH/config
    echo 0x192c9184 > $DCC_PATH/config
    echo 0x192c91a0 > $DCC_PATH/config
    echo 0x192c91b0 > $DCC_PATH/config
    echo 0x192c91c0 2 > $DCC_PATH/config
    echo 0x192c91e0 > $DCC_PATH/config
    echo 0x193c5cac 3 > $DCC_PATH/config
    echo 0x193c0080 > $DCC_PATH/config
    echo 0x193c0310 > $DCC_PATH/config
    echo 0x193c0400 2 > $DCC_PATH/config
    echo 0x193c0410 6 > $DCC_PATH/config
    echo 0x193c0430 > $DCC_PATH/config
    echo 0x193c0440 > $DCC_PATH/config
    echo 0x193c0448 > $DCC_PATH/config
    echo 0x193c04a0 > $DCC_PATH/config
    echo 0x193c04b0 4 > $DCC_PATH/config
    echo 0x193c04d0 2 > $DCC_PATH/config
    echo 0x193c1400 > $DCC_PATH/config
    echo 0x193c1408 > $DCC_PATH/config
    echo 0x193c2400 2 > $DCC_PATH/config
    echo 0x193c2438 2 > $DCC_PATH/config
    echo 0x193c2454 > $DCC_PATH/config
    echo 0x193c3400 4 > $DCC_PATH/config
    echo 0x193c3418 3 > $DCC_PATH/config
    echo 0x193c4700 > $DCC_PATH/config
    echo 0x193c53b0 > $DCC_PATH/config
    echo 0x193c5804 > $DCC_PATH/config
    echo 0x193c590c > $DCC_PATH/config
    echo 0x193c5a14 > $DCC_PATH/config
    echo 0x193c5c0c > $DCC_PATH/config
    echo 0x193c5c18 2 > $DCC_PATH/config
    echo 0x193c5c2c 2 > $DCC_PATH/config
    echo 0x193c5c38 > $DCC_PATH/config
    echo 0x193c5c4c > $DCC_PATH/config
    echo 0x193c5ca4 > $DCC_PATH/config
    echo 0x193c5cac 3 > $DCC_PATH/config
    echo 0x193c6400 > $DCC_PATH/config
    echo 0x193c6418 2 > $DCC_PATH/config
    echo 0x193c9100 > $DCC_PATH/config
    echo 0x193c9110 > $DCC_PATH/config
    echo 0x193c9120 > $DCC_PATH/config
    echo 0x193c9180 > $DCC_PATH/config
    echo 0x193c9180 2 > $DCC_PATH/config
    echo 0x193c9184 > $DCC_PATH/config
    echo 0x193c91a0 > $DCC_PATH/config
    echo 0x193c91b0 > $DCC_PATH/config
    echo 0x193c91c0 2 > $DCC_PATH/config
    echo 0x193c91e0 > $DCC_PATH/config
    echo 0x192c1420 > $DCC_PATH/config
    echo 0x192c1430 > $DCC_PATH/config
    echo 0x193c1420 > $DCC_PATH/config
    echo 0x193c1430 > $DCC_PATH/config


    # MCCC
    echo 0x190ba280 > $DCC_PATH/config
    echo 0x190ba288 8 > $DCC_PATH/config
    echo 0x192e0610 4 > $DCC_PATH/config
    echo 0x192e0680 4 > $DCC_PATH/config
    echo 0x193e0610 3 > $DCC_PATH/config
    echo 0x193e0618 2 > $DCC_PATH/config
    echo 0x193e0680 2 > $DCC_PATH/config
    echo 0x193e0684 3 > $DCC_PATH/config
    echo 0x193e068c > $DCC_PATH/config

    # DDRPHY
    echo 0x19281e64 > $DCC_PATH/config
    echo 0x19281ea0 > $DCC_PATH/config
    echo 0x19281f30 2 > $DCC_PATH/config
    echo 0x19283e64 > $DCC_PATH/config
    echo 0x19283ea0 > $DCC_PATH/config
    echo 0x19283f30 2 > $DCC_PATH/config
    echo 0x1928527c > $DCC_PATH/config
    echo 0x19285290 > $DCC_PATH/config
    echo 0x192854ec > $DCC_PATH/config
    echo 0x192854f4 > $DCC_PATH/config
    echo 0x19285514 > $DCC_PATH/config
    echo 0x1928551c > $DCC_PATH/config
    echo 0x19285524 > $DCC_PATH/config
    echo 0x19285548 > $DCC_PATH/config
    echo 0x19285550 > $DCC_PATH/config
    echo 0x19285558 > $DCC_PATH/config
    echo 0x192855b8 > $DCC_PATH/config
    echo 0x192855c0 > $DCC_PATH/config
    echo 0x192855ec > $DCC_PATH/config
    echo 0x19285860 > $DCC_PATH/config
    echo 0x19285870 > $DCC_PATH/config
    echo 0x192858a0 > $DCC_PATH/config
    echo 0x192858a8 > $DCC_PATH/config
    echo 0x192858b0 > $DCC_PATH/config
    echo 0x192858b8 > $DCC_PATH/config
    echo 0x192858d8 2 > $DCC_PATH/config
    echo 0x192858f4 > $DCC_PATH/config
    echo 0x192858fc > $DCC_PATH/config
    echo 0x19285920 > $DCC_PATH/config
    echo 0x19285928 > $DCC_PATH/config
    echo 0x19285944 > $DCC_PATH/config
    echo 0x19286604 > $DCC_PATH/config
    echo 0x1928660c > $DCC_PATH/config
    echo 0x19381e64 > $DCC_PATH/config
    echo 0x19381ea0 > $DCC_PATH/config
    echo 0x19381f30 2 > $DCC_PATH/config
    echo 0x19383e64 > $DCC_PATH/config
    echo 0x19383ea0 > $DCC_PATH/config
    echo 0x19383f30 2 > $DCC_PATH/config
    echo 0x1938527c > $DCC_PATH/config
    echo 0x19385290 > $DCC_PATH/config
    echo 0x193854ec > $DCC_PATH/config
    echo 0x193854f4 > $DCC_PATH/config
    echo 0x19385514 > $DCC_PATH/config
    echo 0x1938551c > $DCC_PATH/config
    echo 0x19385524 > $DCC_PATH/config
    echo 0x19385548 > $DCC_PATH/config
    echo 0x19385550 > $DCC_PATH/config
    echo 0x19385558 > $DCC_PATH/config
    echo 0x193855b8 > $DCC_PATH/config
    echo 0x193855c0 > $DCC_PATH/config
    echo 0x193855ec > $DCC_PATH/config
    echo 0x19385860 > $DCC_PATH/config
    echo 0x19385870 > $DCC_PATH/config
    echo 0x193858a0 > $DCC_PATH/config
    echo 0x193858a8 > $DCC_PATH/config
    echo 0x193858b0 > $DCC_PATH/config
    echo 0x193858b8 > $DCC_PATH/config
    echo 0x193858d8 2 > $DCC_PATH/config
    echo 0x193858f4 > $DCC_PATH/config
    echo 0x193858fc > $DCC_PATH/config
    echo 0x19385920 > $DCC_PATH/config
    echo 0x19385928 > $DCC_PATH/config
    echo 0x19385944 > $DCC_PATH/config
    echo 0x19386604 > $DCC_PATH/config
    echo 0x1938660c > $DCC_PATH/config

    #Pimem
    echo 0x610110 5 > $DCC_PATH/config

    # SHRM2
    echo 0x19032020 > $DCC_PATH/config
    echo 0x19032024 > $DCC_PATH/config
    echo 0x1908e01c > $DCC_PATH/config
    echo 0x1908e030 > $DCC_PATH/config
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1908e008 > $DCC_PATH/config
    echo 0x19032020 > $DCC_PATH/config
    echo 0x1908e948 > $DCC_PATH/config
    echo 0x19032024 > $DCC_PATH/config

    echo 0x19030040 0x1 1 > $DCC_PATH/config_write
    echo 0x1903005c 0x22C000 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config

    echo 0x1903005c 0x22C001 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C002 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C003 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C004 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C005 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C006 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C007 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C008 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C009 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C00A 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C00B 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C00C 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C00D 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C00E 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C00F 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C010 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C011 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C012 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C013 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C014 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C015 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C016 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C017 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C018 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C019 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C01A 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C01B 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C01C 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C01D 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C01E 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C01F 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C300 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C341 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    echo 0x1903005c 0x22C7B1 1 > $DCC_PATH/config_write
    echo 0x19030010 > $DCC_PATH/config
    #End Link list #6
}

config_dcc_rpmh()
{
    echo 0xb281024 > $DCC_PATH/config
    echo 0xbde1034 > $DCC_PATH/config

    #RPMH_PDC_APSS
    echo 0xb201020 2 > $DCC_PATH/config
    echo 0xb211020 2 > $DCC_PATH/config
    echo 0xb221020 2 > $DCC_PATH/config
    echo 0xb231020 2 > $DCC_PATH/config
    echo 0xb204520 > $DCC_PATH/config
}

config_dcc_apss_rscc()
{
    #APSS_RSCC_RSC register
    echo 0x17a00010 > $DCC_PATH/config
    echo 0x17a10010 > $DCC_PATH/config
    echo 0x17a20010 > $DCC_PATH/config
    echo 0x17a30010 > $DCC_PATH/config
    echo 0x17a00030 > $DCC_PATH/config
    echo 0x17a10030 > $DCC_PATH/config
    echo 0x17a20030 > $DCC_PATH/config
    echo 0x17a30030 > $DCC_PATH/config
    echo 0x17a00038 > $DCC_PATH/config
    echo 0x17a10038 > $DCC_PATH/config
    echo 0x17a20038 > $DCC_PATH/config
    echo 0x17a30038 > $DCC_PATH/config
    echo 0x17a00040 > $DCC_PATH/config
    echo 0x17a10040 > $DCC_PATH/config
    echo 0x17a20040 > $DCC_PATH/config
    echo 0x17a30040 > $DCC_PATH/config
    echo 0x17a00048 > $DCC_PATH/config
    echo 0x17a00400 3 > $DCC_PATH/config
    echo 0x17a10400 3 > $DCC_PATH/config
    echo 0x17a20400 3 > $DCC_PATH/config
    echo 0x17a30400 3 > $DCC_PATH/config
}

config_dcc_misc()
{
    #secure WDOG register
    echo 0xc230000 6 > $DCC_PATH/config
    echo 0x17b020 > $DCC_PATH/config
    echo 0x17b030 > $DCC_PATH/config
    echo 0x17b028 > $DCC_PATH/config
    echo 0x120004 > $DCC_PATH/config
    echo 0x18b02c > $DCC_PATH/config
    echo 0x17B01C > $DCC_PATH/config
    echo 0x17B034 > $DCC_PATH/config
    echo 0x17B03C > $DCC_PATH/config
    echo 0x17B044 > $DCC_PATH/config
    echo 0x17B018 > $DCC_PATH/config
    echo 0x1C001B0 > $DCC_PATH/config

    echo 0x8402C0C > $DCC_PATH/config
    echo 0x8402C10 > $DCC_PATH/config
    echo 0x8402C14 > $DCC_PATH/config
    echo 0x8402C18 > $DCC_PATH/config
    echo 0x8402C1C > $DCC_PATH/config
    echo 0x8402C20 > $DCC_PATH/config
    echo 0x8402C2C > $DCC_PATH/config
    echo 0x8402C30 > $DCC_PATH/config
    echo 0x8402C34 > $DCC_PATH/config
    echo 0x8402C38 > $DCC_PATH/config
    echo 0x8402C48 > $DCC_PATH/config
    echo 0x8402C4C > $DCC_PATH/config

    echo 0x193008 > $DCC_PATH/config
    echo 0x19300C > $DCC_PATH/config
}

config_dcc_gict()
{
    echo 0x17120000 > $DCC_PATH/config
    echo 0x17120008 > $DCC_PATH/config
    echo 0x17120010 > $DCC_PATH/config
    echo 0x17120018 > $DCC_PATH/config
    echo 0x17120020 > $DCC_PATH/config
    echo 0x17120028 > $DCC_PATH/config
    echo 0x17120040 > $DCC_PATH/config
    echo 0x17120048 > $DCC_PATH/config
    echo 0x17120050 > $DCC_PATH/config
    echo 0x17120058 > $DCC_PATH/config
    echo 0x17120060 > $DCC_PATH/config
    echo 0x17120068 > $DCC_PATH/config
    echo 0x17120080 > $DCC_PATH/config
    echo 0x17120088 > $DCC_PATH/config
    echo 0x17120090 > $DCC_PATH/config
    echo 0x17120098 > $DCC_PATH/config
    echo 0x171200a0 > $DCC_PATH/config
    echo 0x171200a8 > $DCC_PATH/config
    echo 0x171200c0 > $DCC_PATH/config
    echo 0x171200c8 > $DCC_PATH/config
    echo 0x171200d0 > $DCC_PATH/config
    echo 0x171200d8 > $DCC_PATH/config
    echo 0x171200e0 > $DCC_PATH/config
    echo 0x171200e8 > $DCC_PATH/config
    echo 0x17120100 > $DCC_PATH/config
    echo 0x17120108 > $DCC_PATH/config
    echo 0x17120110 > $DCC_PATH/config
    echo 0x17120118 > $DCC_PATH/config
    echo 0x17120120 > $DCC_PATH/config
    echo 0x17120128 > $DCC_PATH/config
    echo 0x17120140 > $DCC_PATH/config
    echo 0x17120148 > $DCC_PATH/config
    echo 0x17120150 > $DCC_PATH/config
    echo 0x17120158 > $DCC_PATH/config
    echo 0x17120160 > $DCC_PATH/config
    echo 0x17120168 > $DCC_PATH/config
    echo 0x17120180 > $DCC_PATH/config
    echo 0x17120188 > $DCC_PATH/config
    echo 0x17120190 > $DCC_PATH/config
    echo 0x17120198 > $DCC_PATH/config
    echo 0x171201a0 > $DCC_PATH/config
    echo 0x171201a8 > $DCC_PATH/config
    echo 0x171201c0 > $DCC_PATH/config
    echo 0x171201c8 > $DCC_PATH/config
    echo 0x171201d0 > $DCC_PATH/config
    echo 0x171201d8 > $DCC_PATH/config
    echo 0x171201e0 > $DCC_PATH/config
    echo 0x171201e8 > $DCC_PATH/config
    echo 0x17120200 > $DCC_PATH/config
    echo 0x17120208 > $DCC_PATH/config
    echo 0x17120210 > $DCC_PATH/config
    echo 0x17120218 > $DCC_PATH/config
    echo 0x17120220 > $DCC_PATH/config
    echo 0x17120228 > $DCC_PATH/config
    echo 0x17120240 > $DCC_PATH/config
    echo 0x17120248 > $DCC_PATH/config
    echo 0x17120250 > $DCC_PATH/config
    echo 0x17120258 > $DCC_PATH/config
    echo 0x17120260 > $DCC_PATH/config
    echo 0x17120268 > $DCC_PATH/config
    echo 0x17120280 > $DCC_PATH/config
    echo 0x17120288 > $DCC_PATH/config
    echo 0x17120290 > $DCC_PATH/config
    echo 0x17120298 > $DCC_PATH/config
    echo 0x171202a0 > $DCC_PATH/config
    echo 0x171202a8 > $DCC_PATH/config
    echo 0x171202c0 > $DCC_PATH/config
    echo 0x171202c8 > $DCC_PATH/config
    echo 0x171202d0 > $DCC_PATH/config
    echo 0x171202d8 > $DCC_PATH/config
    echo 0x171202e0 > $DCC_PATH/config
    echo 0x171202e8 > $DCC_PATH/config
    echo 0x17120300 > $DCC_PATH/config
    echo 0x17120308 > $DCC_PATH/config
    echo 0x17120310 > $DCC_PATH/config
    echo 0x17120318 > $DCC_PATH/config
    echo 0x17120320 > $DCC_PATH/config
    echo 0x17120328 > $DCC_PATH/config
    echo 0x17120340 > $DCC_PATH/config
    echo 0x17120348 > $DCC_PATH/config
    echo 0x17120350 > $DCC_PATH/config
    echo 0x17120358 > $DCC_PATH/config
    echo 0x17120360 > $DCC_PATH/config
    echo 0x17120368 > $DCC_PATH/config
    echo 0x17120380 > $DCC_PATH/config
    echo 0x17120388 > $DCC_PATH/config
    echo 0x17120390 > $DCC_PATH/config
    echo 0x17120398 > $DCC_PATH/config
    echo 0x171203a0 > $DCC_PATH/config
    echo 0x171203a8 > $DCC_PATH/config
    echo 0x171203c0 > $DCC_PATH/config
    echo 0x171203c8 > $DCC_PATH/config
    echo 0x171203d0 > $DCC_PATH/config
    echo 0x171203d8 > $DCC_PATH/config
    echo 0x171203e0 > $DCC_PATH/config
    echo 0x171203e8 > $DCC_PATH/config
    echo 0x17120400 > $DCC_PATH/config
    echo 0x17120408 > $DCC_PATH/config
    echo 0x17120410 > $DCC_PATH/config
    echo 0x17120418 > $DCC_PATH/config
    echo 0x17120420 > $DCC_PATH/config
    echo 0x17120428 > $DCC_PATH/config
    echo 0x17120440 > $DCC_PATH/config
    echo 0x17120448 > $DCC_PATH/config
    echo 0x17120450 > $DCC_PATH/config
    echo 0x17120458 > $DCC_PATH/config
    echo 0x17120460 > $DCC_PATH/config
    echo 0x17120468 > $DCC_PATH/config
    echo 0x17120480 > $DCC_PATH/config
    echo 0x17120488 > $DCC_PATH/config
    echo 0x17120490 > $DCC_PATH/config
    echo 0x17120498 > $DCC_PATH/config
    echo 0x171204a0 > $DCC_PATH/config
    echo 0x171204a8 > $DCC_PATH/config
    echo 0x171204c0 > $DCC_PATH/config
    echo 0x171204c8 > $DCC_PATH/config
    echo 0x171204d0 > $DCC_PATH/config
    echo 0x171204d8 > $DCC_PATH/config
    echo 0x171204e0 > $DCC_PATH/config
    echo 0x171204e8 > $DCC_PATH/config
    echo 0x17120500 > $DCC_PATH/config
    echo 0x17120508 > $DCC_PATH/config
    echo 0x17120510 > $DCC_PATH/config
    echo 0x17120518 > $DCC_PATH/config
    echo 0x17120520 > $DCC_PATH/config
    echo 0x17120528 > $DCC_PATH/config
    echo 0x17120540 > $DCC_PATH/config
    echo 0x17120548 > $DCC_PATH/config
    echo 0x17120550 > $DCC_PATH/config
    echo 0x17120558 > $DCC_PATH/config
    echo 0x17120560 > $DCC_PATH/config
    echo 0x17120568 > $DCC_PATH/config
    echo 0x17120580 > $DCC_PATH/config
    echo 0x17120588 > $DCC_PATH/config
    echo 0x17120590 > $DCC_PATH/config
    echo 0x17120598 > $DCC_PATH/config
    echo 0x171205a0 > $DCC_PATH/config
    echo 0x171205a8 > $DCC_PATH/config
    echo 0x171205c0 > $DCC_PATH/config
    echo 0x171205c8 > $DCC_PATH/config
    echo 0x171205d0 > $DCC_PATH/config
    echo 0x171205d8 > $DCC_PATH/config
    echo 0x171205e0 > $DCC_PATH/config
    echo 0x171205e8 > $DCC_PATH/config
    echo 0x17120600 > $DCC_PATH/config
    echo 0x17120608 > $DCC_PATH/config
    echo 0x17120610 > $DCC_PATH/config
    echo 0x17120618 > $DCC_PATH/config
    echo 0x17120620 > $DCC_PATH/config
    echo 0x17120628 > $DCC_PATH/config
    echo 0x17120640 > $DCC_PATH/config
    echo 0x17120648 > $DCC_PATH/config
    echo 0x17120650 > $DCC_PATH/config
    echo 0x17120658 > $DCC_PATH/config
    echo 0x17120660 > $DCC_PATH/config
    echo 0x17120668 > $DCC_PATH/config
    echo 0x17120680 > $DCC_PATH/config
    echo 0x17120688 > $DCC_PATH/config
    echo 0x17120690 > $DCC_PATH/config
    echo 0x17120698 > $DCC_PATH/config
    echo 0x171206a0 > $DCC_PATH/config
    echo 0x171206a8 > $DCC_PATH/config
    echo 0x171206c0 > $DCC_PATH/config
    echo 0x171206c8 > $DCC_PATH/config
    echo 0x171206d0 > $DCC_PATH/config
    echo 0x171206d8 > $DCC_PATH/config
    echo 0x171206e0 > $DCC_PATH/config
    echo 0x171206e8 > $DCC_PATH/config
    echo 0x1712e000 > $DCC_PATH/config
}

config_dcc_core()
{
    # core hang
    echo 0x1740003c > $DCC_PATH/config

    #MIBU Debug registers

    #CHI (GNOC) Hang counters

    #SYSCO and other misc debug
    echo 0x17400438 > $DCC_PATH/config

    #PPUHWSTAT_STS

    #CPRh
    echo 0x17900908 > $DCC_PATH/config
    echo 0x17900c18 > $DCC_PATH/config
    echo 0x17901908 > $DCC_PATH/config
    echo 0x17901c18 > $DCC_PATH/config

    # pll status for all banks and all domains
    echo 0x17a80000 0x8007 > $DCC_PATH/config_write
    echo 0x17a80000 > $DCC_PATH/config
    echo 0x17a80024 0x0 > $DCC_PATH/config_write
    echo 0x17a80024 > $DCC_PATH/config
    echo 0x17a80020 0x0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x40 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x80 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0xc0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x100 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x140 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x180 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x1c0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x200 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x240 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x280 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x2c0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x300 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x340 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x380 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x3c0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80024 0x4000 > $DCC_PATH/config_write
    echo 0x17a80024 > $DCC_PATH/config
    echo 0x17a80020 0x0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80020 0x0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80020 0x0 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config
    echo 0x17a80020 0x40 > $DCC_PATH/config_write
    echo 0x17a80020 > $DCC_PATH/config
    echo 0x17a80038 > $DCC_PATH/config

    echo 0x17a82000 0x8007 > $DCC_PATH/config_write
    echo 0x17a82000 > $DCC_PATH/config
    echo 0x17a82024 0x0 > $DCC_PATH/config_write
    echo 0x17a82024 > $DCC_PATH/config
    echo 0x17a82020 0x0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x40 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x80 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0xc0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x100 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x140 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x180 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x1c0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x200 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x240 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x280 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x2c0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x300 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x340 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x380 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x3c0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82024 0x4000 > $DCC_PATH/config_write
    echo 0x17a82024 > $DCC_PATH/config
    echo 0x17a82020 0x0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82020 0x0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82020 0x0 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config
    echo 0x17a82020 0x40 > $DCC_PATH/config_write
    echo 0x17a82020 > $DCC_PATH/config
    echo 0x17a82038 > $DCC_PATH/config

    echo 0x17a84000 0x8007 > $DCC_PATH/config_write
    echo 0x17a84000 > $DCC_PATH/config
    echo 0x17a84024 0x0 > $DCC_PATH/config_write
    echo 0x17a84024 > $DCC_PATH/config
    echo 0x17a84020 0x0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x40 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x80 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0xc0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x100 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x140 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x180 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x1c0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x200 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x240 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x280 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x2c0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x300 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x340 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x380 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x3c0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84024 0x4000 > $DCC_PATH/config_write
    echo 0x17a84024 > $DCC_PATH/config
    echo 0x17a84020 0x0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84020 0x0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84020 0x0 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config
    echo 0x17a84020 0x40 > $DCC_PATH/config_write
    echo 0x17a84020 > $DCC_PATH/config
    echo 0x17a84038 > $DCC_PATH/config

    echo 0x17a86000 0x8007 > $DCC_PATH/config_write
    echo 0x17a86000 > $DCC_PATH/config
    echo 0x17a86024 0x0 > $DCC_PATH/config_write
    echo 0x17a86024 > $DCC_PATH/config
    echo 0x17a86020 0x0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x40 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x80 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0xc0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x100 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x140 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x180 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x1c0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x200 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x240 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x280 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x2c0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x300 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x340 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x380 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x3c0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86024 0x4000 > $DCC_PATH/config_write
    echo 0x17a86024 > $DCC_PATH/config
    echo 0x17a86020 0x0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86020 0x0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86020 0x0 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config
    echo 0x17a86020 0x40 > $DCC_PATH/config_write
    echo 0x17a86020 > $DCC_PATH/config
    echo 0x17a86038 > $DCC_PATH/config

    #rpmh
    echo 0xc201244 > $DCC_PATH/config
    echo 0xc202244 > $DCC_PATH/config

    #L3-ACD
    echo 0x17a94030 > $DCC_PATH/config
    echo 0x17a9408c > $DCC_PATH/config
    echo 0x17a9409c 0x78 > $DCC_PATH/config_write
    echo 0x17a9409c 0x0  > $DCC_PATH/config_write
    echo 0x17a94048 0x1  > $DCC_PATH/config_write
    echo 0x17a94090 0x0  > $DCC_PATH/config_write
    echo 0x17a94090 0x25 > $DCC_PATH/config_write
    echo 0x17a94098 > $DCC_PATH/config
    echo 0x17a94048 0x1D > $DCC_PATH/config_write
    echo 0x17a94090 0x0  > $DCC_PATH/config_write
    echo 0x17a94090 0x25 > $DCC_PATH/config_write
    echo 0x17a94098 > $DCC_PATH/config

    #SILVER-ACD
    echo 0x17a90030 > $DCC_PATH/config
    echo 0x17a9008c > $DCC_PATH/config
    echo 0x17a9009c 0x78 > $DCC_PATH/config_write
    echo 0x17a9009c 0x0  > $DCC_PATH/config_write
    echo 0x17a90048 0x1  > $DCC_PATH/config_write
    echo 0x17a90090 0x0  > $DCC_PATH/config_write
    echo 0x17a90090 0x25 > $DCC_PATH/config_write
    echo 0x17a90098 > $DCC_PATH/config
    echo 0x17a90048 0x1D > $DCC_PATH/config_write
    echo 0x17a90090 0x0  > $DCC_PATH/config_write
    echo 0x17a90090 0x25 > $DCC_PATH/config_write
    echo 0x17a90098 > $DCC_PATH/config


    #GOLD-ACD
    echo 0x17a92030 > $DCC_PATH/config
    echo 0x17a9208c > $DCC_PATH/config
    echo 0x17a9209c 0x78 > $DCC_PATH/config_write
    echo 0x17a9209c 0x0  > $DCC_PATH/config_write
    echo 0x17a92048 0x1  > $DCC_PATH/config_write
    echo 0x17a92090 0x0  > $DCC_PATH/config_write
    echo 0x17a92090 0x25 > $DCC_PATH/config_write
    echo 0x17a92098 > $DCC_PATH/config
    echo 0x17a92048 0x1D > $DCC_PATH/config_write
    echo 0x17a92090 0x0  > $DCC_PATH/config_write
    echo 0x17a92090 0x25 > $DCC_PATH/config_write
    echo 0x17a92098 > $DCC_PATH/config

    #GOLDPLUS-ACD
    echo 0x17a96030 > $DCC_PATH/config
    echo 0x17a9608c > $DCC_PATH/config
    echo 0x17a9609c 0x78 > $DCC_PATH/config_write
    echo 0x17a9609c 0x0  > $DCC_PATH/config_write
    echo 0x17a96048 0x1  > $DCC_PATH/config_write
    echo 0x17a96090 0x0  > $DCC_PATH/config_write
    echo 0x17a96090 0x25 > $DCC_PATH/config_write
    echo 0x17a96098 > $DCC_PATH/config
    echo 0x17a96048 0x1D > $DCC_PATH/config_write
    echo 0x17a96090 0x0  > $DCC_PATH/config_write
    echo 0x17a96090 0x25 > $DCC_PATH/config_write
    echo 0x17a96098 > $DCC_PATH/config

    echo 0x13822000 > $DCC_PATH/config

    #Security Control Core for Binning info
    echo 0x221c21c4 > $DCC_PATH/config

    #SoC version
    echo 0x1fc8000 > $DCC_PATH/config

    #WDOG BIT Config
    echo 0x17400038 > $DCC_PATH/config
}
config_apss_pwr_state()
{
    #TODO: need to be updated
}

config_dcc_gic()
{
    echo 0x17100104 29 > $DCC_PATH/config
    echo 0x17100204 29 > $DCC_PATH/config
    echo 0x17100384 29 > $DCC_PATH/config
}

config_adsp()
{
    echo 0xb2b1020 > $DCC_PATH/config
}

enable_dcc_pll_status()
{
   #TODO: need to be updated

}

config_dcc_tsens()
{
    echo 0xc222004 > $DCC_PATH/config
    echo 0xc263014 > $DCC_PATH/config
    echo 0xc2630e0 > $DCC_PATH/config
    echo 0xc2630ec > $DCC_PATH/config
    echo 0xc2630a0 16 > $DCC_PATH/config
    echo 0xc2630e8 > $DCC_PATH/config
    echo 0xc26313c > $DCC_PATH/config
    echo 0xc223004 > $DCC_PATH/config
    echo 0xc265014 > $DCC_PATH/config
    echo 0xc2650e0 > $DCC_PATH/config
    echo 0xc2650ec > $DCC_PATH/config
    echo 0xc2650a0 16 > $DCC_PATH/config
    echo 0xc2650e8 > $DCC_PATH/config
    echo 0xc26513c > $DCC_PATH/config
}

config_dcc_pcie()
{
    echo 0x16C1008 > $DCC_PATH/config
    echo 0x16C1010 > $DCC_PATH/config
    echo 0x16C1014 > $DCC_PATH/config
    echo 0x16C1018 > $DCC_PATH/config
    echo 0x16E1008 > $DCC_PATH/config
    echo 0x16E1010 > $DCC_PATH/config
    echo 0x16E1014 > $DCC_PATH/config
    echo 0x16E1018 > $DCC_PATH/config
    echo 0x1701008 > $DCC_PATH/config
    echo 0x1701010 > $DCC_PATH/config
    echo 0x1701014 > $DCC_PATH/config
    echo 0x1701018 > $DCC_PATH/config
    echo 0x170E010 > $DCC_PATH/config
    echo 0x170F010 > $DCC_PATH/config
    echo 0x1710010 > $DCC_PATH/config
    echo 0x1711010 > $DCC_PATH/config
    echo 0x1712010 > $DCC_PATH/config
    echo 0x1713010 > $DCC_PATH/config
    echo 0x1714010 > $DCC_PATH/config
    echo 0x1715010 > $DCC_PATH/config
    echo 0x16E9010 > $DCC_PATH/config
    echo 0x16EA010 > $DCC_PATH/config
    echo 0x16EB010 > $DCC_PATH/config
    echo 0x16C6010 > $DCC_PATH/config
    echo 0x190D8010 > $DCC_PATH/config
    echo 0x190D9010 > $DCC_PATH/config
    echo 0x190D1008 > $DCC_PATH/config
    echo 0x190D1010 > $DCC_PATH/config
    echo 0x190D1014 > $DCC_PATH/config
    echo 0x190D1018 > $DCC_PATH/config
    echo 0x1691010 > $DCC_PATH/config
    echo 0x1694010 > $DCC_PATH/config
    echo 0x1695010 > $DCC_PATH/config
    echo 0x1696010 > $DCC_PATH/config
    echo 0x1697010 > $DCC_PATH/config
    echo 0x1698010 > $DCC_PATH/config
    echo 0x1699010 > $DCC_PATH/config
    echo 0x1681008 > $DCC_PATH/config
    echo 0x1681010 > $DCC_PATH/config
    echo 0x1681014 > $DCC_PATH/config
    echo 0x1681018 > $DCC_PATH/config
    echo 0x1C001B0 > $DCC_PATH/config
    echo 0x1C00024 > $DCC_PATH/config
    echo 0x1C00028 > $DCC_PATH/config
    echo 0x1C00224 > $DCC_PATH/config
    echo 0x1C00500 > $DCC_PATH/config
    echo 0x1C004D0 > $DCC_PATH/config
    echo 0x1C004D4 > $DCC_PATH/config
    echo 0x1C003C0 > $DCC_PATH/config
    echo 0x1C00630 > $DCC_PATH/config
    echo 0x1C00230 > $DCC_PATH/config
    echo 0x1C00000 > $DCC_PATH/config
    echo 0x17B034 > $DCC_PATH/config
    echo 0x17B03C > $DCC_PATH/config
    echo 0x17B028 > $DCC_PATH/config
    echo 0x17B030 > $DCC_PATH/config
    echo 0x17B01C > $DCC_PATH/config
    echo 0x17B020 > $DCC_PATH/config
}

config_smmu()
{
    echo 0x15002204 > $DCC_PATH/config
    #SMMU_500_APPS_REG_WRAPPER_BASE=0x151CC000
    #ANOC_1

    echo 0x1a000c 2 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC = $SMMU_500_APPS_REG_WRAPPER_BASE+0x4050 = 0x151D0050"
    #let "APPS_SMMU_DEBUG_TESTBUS_ANOC_1_SEC = $SMMU_500_APPS_REG_WRAPPER_BASE+0x4058 = 0x151D0058"

    echo 0x151d0050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC
    echo 0x151d0058 > $DCC_PATH/config

    echo 0x151d0050 0x80 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC
    echo 0x151d0058 > $DCC_PATH/config

    echo 0x151d0050 0xC0 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC
    echo 0x151d0058 > $DCC_PATH/config

    echo 0x151d0050 0x87 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC
    echo 0x151d0058 > $DCC_PATH/config

    echo 0x151d0050 0xAF > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC
    echo 0x151d0058 > $DCC_PATH/config

    echo 0x151d0050 0xBC > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_1_SEC
    echo 0x151d0058 > $DCC_PATH/config

    #ANOC_2
    echo 0x1a0014 2 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_2_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x9050 = 0x151D5050"
    #let "APPS_SMMU_DEBUG_TESTBUS_ANOC_2_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x9058 = 0x151D5058"

    echo 0x151d5050 0x40 > $DCC_PATH/config_write
    echo 0x151d5058 > $DCC_PATH/config

    echo 0x151d5050 0x80 > $DCC_PATH/config_write
    echo 0x151d5058 > $DCC_PATH/config

    echo 0x151d5050 0xC0 > $DCC_PATH/config_write
    echo 0x151d5058 > $DCC_PATH/config

    echo 0x151d5050 0x87 > $DCC_PATH/config_write
    echo 0x151d5058 > $DCC_PATH/config

    echo 0x151d5050 0xAF > $DCC_PATH/config_write
    echo 0x151d5058 > $DCC_PATH/config

    echo 0x151d5050 0xBC > $DCC_PATH/config_write
    echo 0x151d5058 > $DCC_PATH/config

    #MNOC_SF_0
    echo 0x12c018 2 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_SF_0_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x25050 = 0x151F1050"
    #let "APPS_SMMU_DEBUG_TESTBUS_MNOC_SF_0_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x25058 = 0x151F1058"

    echo 0x151f1050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_SF_0_HLOS1_NS(0x151F1050)
    echo 0x151f1058 > $DCC_PATH/config

    echo 0x151f1050 0x80 > $DCC_PATH/config_write
    echo 0x151f1058 > $DCC_PATH/config
    #okay till here

    echo 0x151f1050 0xC0 > $DCC_PATH/config_write
    echo 0x151f1058 > $DCC_PATH/config

    echo 0x151f1050 0x87 > $DCC_PATH/config_write
    echo 0x151f1058 > $DCC_PATH/config

    echo 0x151f1050 0xAF > $DCC_PATH/config_write
    echo 0x151f1058 > $DCC_PATH/config

    echo 0x151f1050 0xBC > $DCC_PATH/config_write
    echo 0x151f1058 > $DCC_PATH/config



    #MNOC_SF_1
    echo 0x12c024 > $DCC_PATH/config
    echo 0x12c020 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_SF_1_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x29050 = 0x151F5050"
    #let "APPS_SMMU_DEBUG_TESTBUS_MNOC_SF_1_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x29058 = 0x151F5058"

    echo 0x151f5050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_SF_1_HLOS1_NS(0x151F5050)
    echo 0x151f5058 > $DCC_PATH/config
    #
    echo 0x151f5050 0x80 > $DCC_PATH/config_write
    echo 0x151f5058 > $DCC_PATH/config

    echo 0x151f5050 0xC0 > $DCC_PATH/config_write
    echo 0x151f5058 > $DCC_PATH/config
    #
    echo 0x151f5050 0x87 > $DCC_PATH/config_write
    echo 0x151f5058 > $DCC_PATH/config
    #
    echo 0x151f5050 0xAF > $DCC_PATH/config_write
    echo 0x151f5058 > $DCC_PATH/config
    #
    echo 0x151f5050 0xBC > $DCC_PATH/config_write
    echo 0x151f5058 > $DCC_PATH/config

    ##MNOC_HF_0
    echo 0x12c02c > $DCC_PATH/config
    echo 0x12c028 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_HF_0_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0xD050 = 0x151D9050"
    #let "APPS_SMMU_DEBUG_TESTBUS_MNOC_HF_0_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0xD058 = 0x151D9058"

    echo 0x151d9050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_HF_0_HLOS1_NS(0x151D9050)
    echo 0x151d9058 > $DCC_PATH/config

    echo 0x151d9050 0x80 > $DCC_PATH/config_write
    echo 0x151d9058 > $DCC_PATH/config

    echo 0x151d9050 0xC0 > $DCC_PATH/config_write
    echo 0x151d9058 > $DCC_PATH/config

    echo 0x151d9050 0x87 > $DCC_PATH/config_write
    echo 0x151d9058 > $DCC_PATH/config

    echo 0x151d9050 0xAF > $DCC_PATH/config_write
    echo 0x151d9058 > $DCC_PATH/config

    echo 0x151d9050 0xBC > $DCC_PATH/config_write
    echo 0x151d9058 > $DCC_PATH/config

    #MNOC_HF_1
    echo 0x12c034 > $DCC_PATH/config
    echo 0x12c030 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_HF_1_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x11050 = 0x151DD050"
    #let "APPS_SMMU_DEBUG_TESTBUS_MNOC_HF_1_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x11058 = 0x151DD058"

    echo 0x151dd050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_MNOC_HF_1_HLOS1_NS(0x151DD050)
    echo 0x151dd058 > $DCC_PATH/config

    echo 0x151dd050 0x80 > $DCC_PATH/config_write
    echo 0x151dd058 > $DCC_PATH/config

    echo 0x151dd050 0xC0 > $DCC_PATH/config_write
    echo 0x151dd058 > $DCC_PATH/config

    echo 0x151dd050 0x87 > $DCC_PATH/config_write
    echo 0x151dd058 > $DCC_PATH/config

    echo 0x151dd050 0xAF > $DCC_PATH/config_write
    echo 0x151dd058 > $DCC_PATH/config

    echo 0x151dd050 0xBC > $DCC_PATH/config_write
    echo 0x151dd058 > $DCC_PATH/config


    #COMPUTE_DSP_0
    echo 0x1a9018 > $DCC_PATH/config
    echo 0x1a9014 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_COMPUTE_DSP_0_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x19050 = 0x151E5050"
    #let "APPS_SMMU_DEBUG_TESTBUS_COMPUTE_DSP_0_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x19058 = 0x151E5058"

    echo 0x151e5050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_COMPUTE_DSP_0_HLOS1_NS(0x151E5050)
    echo 0x151e5058 > $DCC_PATH/config

    echo 0x151e5050 0x80 > $DCC_PATH/config_write
    echo 0x151e5058 > $DCC_PATH/config

    echo 0x151e5050 0xC0 > $DCC_PATH/config_write
    echo 0x151e5058 > $DCC_PATH/config

    echo 0x151e5050 0x87 > $DCC_PATH/config_write
    echo 0x151e5058 > $DCC_PATH/config

    echo 0x151e5050 0xAF > $DCC_PATH/config_write
    echo 0x151e5058 > $DCC_PATH/config

    echo 0x151e5050 0xBC > $DCC_PATH/config_write
    echo 0x151e5058 > $DCC_PATH/config

    ##COMPUTE_DSP_1
    echo 0x1a9020 > $DCC_PATH/config
    echo 0x1a901c > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_COMPUTE_DSP_1_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x15050 = 0x151E1050"
    #let "APPS_SMMU_DEBUG_TESTBUS_COMPUTE_DSP_1_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x15058 = 0x151E1058"

    echo 0x151e1050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_COMPUTE_DSP_1_HLOS1_NS(0x151E1050)
    echo 0x151e1058 > $DCC_PATH/config

    echo 0x151e1050 0x80 > $DCC_PATH/config_write
    echo 0x151e1058 > $DCC_PATH/config

    echo 0x151e1050 0xC0 > $DCC_PATH/config_write
    echo 0x151e1058 > $DCC_PATH/config

    echo 0x151e1050 0x87 > $DCC_PATH/config_write
    echo 0x151e1058 > $DCC_PATH/config

    echo 0x151e1050 0xAF > $DCC_PATH/config_write
    echo 0x151e1058 > $DCC_PATH/config

    echo 0x151e1050 0xBC > $DCC_PATH/config_write
    echo 0x151e1058 > $DCC_PATH/config

    ##LPASS
    echo 0x1a0008 > $DCC_PATH/config
    echo 0x1a0004 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_LPASS_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x1D050 = 0x151E9050"
    #let "APPS_SMMU_DEBUG_TESTBUS_LPASS_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x1D058 = 0x151E9058"

    echo 0x151e9050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_LPASS_HLOS1_NS(0x151E9050)
    echo 0x151e9058 > $DCC_PATH/config

    echo 0x151e9050 0x80 > $DCC_PATH/config_write
    echo 0x151e9058 > $DCC_PATH/config

    echo 0x151e9050 0xC0 > $DCC_PATH/config_write
    echo 0x151e9058 > $DCC_PATH/config

    echo 0x151e9050 0x87 > $DCC_PATH/config_write
    echo 0x151e9058 > $DCC_PATH/config

    echo 0x151e9050 0xAF > $DCC_PATH/config_write
    echo 0x151e9058 > $DCC_PATH/config

    echo 0x151e9050 0xBC > $DCC_PATH/config_write
    echo 0x151e9058 > $DCC_PATH/config

    ##ANOC_PCIE
    echo 0x120028 > $DCC_PATH/config
    echo 0x120024 > $DCC_PATH/config

    #let "APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_PCIE_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x21050 = 0x151ED050"
    #let "APPS_SMMU_DEBUG_TESTBUS_ANOC_PCIE_HLOS1_NS = $SMMU_500_APPS_REG_WRAPPER_BASE+0x21058 = 0x151ED058"

    echo 0x151ed050 0x40 > $DCC_PATH/config_write #APPS_SMMU_DEBUG_TESTBUS_SEL_ANOC_PCIE_HLOS1_NS(0x151ED050)
    echo 0x151ed058 > $DCC_PATH/config

    echo 0x151ed050 0x80 > $DCC_PATH/config_write
    echo 0x151ed058 > $DCC_PATH/config

    echo 0x151ed050 0xC0 > $DCC_PATH/config_write
    echo 0x151ed058 > $DCC_PATH/config

    echo 0x151ed050 0x87 > $DCC_PATH/config_write
    echo 0x151ed058 > $DCC_PATH/config

    echo 0x151ed050 0xAF > $DCC_PATH/config_write
    echo 0x151ed058 > $DCC_PATH/config

    echo 0x151ed050 0xBC > $DCC_PATH/config_write
    echo 0x151ed058 > $DCC_PATH/config

    #TCU change
    echo 0x193008 2 > $DCC_PATH/config
    #
    echo 0x15002670 > $DCC_PATH/config
    echo 0x15002204 > $DCC_PATH/config
    echo 0x150025dc > $DCC_PATH/config
    echo 0x150075dc > $DCC_PATH/config
    echo 0x15002300 > $DCC_PATH/config
    echo 0x150022fc > $DCC_PATH/config
    echo 0x15002648 > $DCC_PATH/config

}

config_gpu()
{
    echo 0x3d0201c > $DCC_PATH/config
    echo 0x3d00000 > $DCC_PATH/config
    echo 0x3d00008 > $DCC_PATH/config
    echo 0x3d00044 > $DCC_PATH/config
    echo 0x3d00058 6 > $DCC_PATH/config
    echo 0x3d0007c 20 > $DCC_PATH/config
    echo 0x3d000e0 5 > $DCC_PATH/config
    echo 0x3d00108 > $DCC_PATH/config
    echo 0x3d00110 > $DCC_PATH/config
    echo 0x3d0011c > $DCC_PATH/config
    echo 0x3d00124 2 > $DCC_PATH/config
    echo 0x3d00140 > $DCC_PATH/config
    echo 0x3d00158 > $DCC_PATH/config
    echo 0x3d002b4 2 > $DCC_PATH/config
    echo 0x3d002c0 > $DCC_PATH/config
    echo 0x3d002d0 > $DCC_PATH/config
    echo 0x3d002e0 > $DCC_PATH/config
    echo 0x3d002f0 > $DCC_PATH/config
    echo 0x3d00300 > $DCC_PATH/config
    echo 0x3d00310 > $DCC_PATH/config
    echo 0x3d00320 > $DCC_PATH/config
    echo 0x3d00330 > $DCC_PATH/config
    echo 0x3d00340 > $DCC_PATH/config
    echo 0x3d00350 > $DCC_PATH/config
    echo 0x3d00360 > $DCC_PATH/config
    echo 0x3d00370 > $DCC_PATH/config
    echo 0x3d00380 > $DCC_PATH/config
    echo 0x3d00390 > $DCC_PATH/config
    echo 0x3d003a0 > $DCC_PATH/config
    echo 0x3d003b0 > $DCC_PATH/config
    echo 0x3d003c0 > $DCC_PATH/config
    echo 0x3d003d0 > $DCC_PATH/config
    echo 0x3d003e0 > $DCC_PATH/config
    echo 0x3d00400 > $DCC_PATH/config
    echo 0x3d00410 8 > $DCC_PATH/config
    echo 0x3d0043c 15 > $DCC_PATH/config
    echo 0x3d00800 14 > $DCC_PATH/config
    echo 0x3d00840 4 > $DCC_PATH/config
    echo 0x3d00854 41 > $DCC_PATH/config
    echo 0x3d01444 > $DCC_PATH/config
    echo 0x3d014d4 > $DCC_PATH/config
    echo 0x3d017f0 4 > $DCC_PATH/config
    echo 0x3d99800 8 > $DCC_PATH/config
    echo 0x3d99828 > $DCC_PATH/config
    echo 0x3d9983c > $DCC_PATH/config
    echo 0x3d998ac > $DCC_PATH/config
    echo 0x18101c 2 > $DCC_PATH/config
    echo 0x3d94000 2 > $DCC_PATH/config
    echo 0x3d95000 4 > $DCC_PATH/config
    echo 0x3d96000 4 > $DCC_PATH/config
    echo 0x3d97000 4 > $DCC_PATH/config
    echo 0x3d98000 4 > $DCC_PATH/config
    echo 0x3d99000 6 > $DCC_PATH/config
    echo 0x3d99050 10 > $DCC_PATH/config
    echo 0x3d990a8 2 > $DCC_PATH/config
    echo 0x3d990b8 3 > $DCC_PATH/config
    echo 0x3d990c8 > $DCC_PATH/config
    echo 0x3d99104 8 > $DCC_PATH/config
    echo 0x3d99130 2 > $DCC_PATH/config
    echo 0x3d9913c 7 > $DCC_PATH/config
    echo 0x3d99198 3 > $DCC_PATH/config
    echo 0x3d991e0 3 > $DCC_PATH/config
    echo 0x3d99224 2 > $DCC_PATH/config
    echo 0x3d99280 4 > $DCC_PATH/config
    echo 0x3d992cc 3 > $DCC_PATH/config
    echo 0x3d99314 3 > $DCC_PATH/config
    echo 0x3d99358 3 > $DCC_PATH/config
    echo 0x3d993a0 2 > $DCC_PATH/config
    echo 0x3d993e4 4 > $DCC_PATH/config
    echo 0x3d9942c 2 > $DCC_PATH/config
    echo 0x3d99470 3 > $DCC_PATH/config
    echo 0x3d99500 4 > $DCC_PATH/config
    echo 0x3d99528 39 > $DCC_PATH/config
    echo 0x3d90000 15 > $DCC_PATH/config
    echo 0x3d91000 15 > $DCC_PATH/config
    echo 0x3de0000 21 > $DCC_PATH/config
    echo 0x3de00d0 > $DCC_PATH/config
    echo 0x3de00d8 > $DCC_PATH/config
    echo 0x3de0100 3 > $DCC_PATH/config
    echo 0x3de0200 5 > $DCC_PATH/config
    echo 0x3de0400 3 > $DCC_PATH/config
    echo 0x3de0450 > $DCC_PATH/config
    echo 0x3de0460 2 > $DCC_PATH/config
    echo 0x3de0490 11 > $DCC_PATH/config
    echo 0x3de0500 > $DCC_PATH/config
    echo 0x3de0600 > $DCC_PATH/config
    echo 0x3de0d00 2 > $DCC_PATH/config
    echo 0x3de0d10 4 > $DCC_PATH/config
    echo 0x3de0d30 5 > $DCC_PATH/config
    echo 0x3de0fb0 4 > $DCC_PATH/config
    echo 0x3de0fd0 5 > $DCC_PATH/config
    echo 0x3de1250 4 > $DCC_PATH/config
    echo 0x3de1270 5 > $DCC_PATH/config
    echo 0x3de14f0 4 > $DCC_PATH/config
    echo 0x3de1510 5 > $DCC_PATH/config
    echo 0x3de3d44 > $DCC_PATH/config
    echo 0x3de3d4c 2 > $DCC_PATH/config
    echo 0x3d8ec0c > $DCC_PATH/config
    echo 0x3d8ec14 2 > $DCC_PATH/config
    echo 0x3d8ec30 3 > $DCC_PATH/config
    echo 0x3d8ec40 4 > $DCC_PATH/config
    echo 0x3d8ec54 > $DCC_PATH/config
    echo 0x3d8eca0 > $DCC_PATH/config
    echo 0x3d8ecc0 > $DCC_PATH/config
    echo 0x3d7d018 3 > $DCC_PATH/config
    echo 0x3d7e440 2 > $DCC_PATH/config
    echo 0x3d7e480 2 > $DCC_PATH/config
    echo 0x3d7e490 2 > $DCC_PATH/config
    echo 0x3d7e4a0 2 > $DCC_PATH/config
    echo 0x3d7e4b0 2 > $DCC_PATH/config
    echo 0x3d7e5c0 10 > $DCC_PATH/config
    echo 0x3d7e648 2 > $DCC_PATH/config
    echo 0x3d7e658 9 > $DCC_PATH/config
    echo 0x3d7e7c0 2 > $DCC_PATH/config

}

config_cabo()
{
    echo 0x193d0400 2 > $DCC_PATH/config
    echo 0x193d0410 3 > $DCC_PATH/config
    echo 0x193d0420 2 > $DCC_PATH/config
    echo 0x193d0430 > $DCC_PATH/config
    echo 0x193d0440 > $DCC_PATH/config
    echo 0x193d0448 > $DCC_PATH/config
    echo 0x193d04a0 > $DCC_PATH/config
    echo 0x193d04b0 4 > $DCC_PATH/config
    echo 0x193d04d0 2 > $DCC_PATH/config
    echo 0x193d04e0 > $DCC_PATH/config
    echo 0x192d0400 2 > $DCC_PATH/config
    echo 0x192d0410 3 > $DCC_PATH/config
    echo 0x192d0420 2 > $DCC_PATH/config
    echo 0x192d0430 > $DCC_PATH/config
    echo 0x192d0440 > $DCC_PATH/config
    echo 0x192d0448 > $DCC_PATH/config
    echo 0x192d04a0 > $DCC_PATH/config
    echo 0x192d04b0 4 > $DCC_PATH/config
    echo 0x192d04d0 2 > $DCC_PATH/config
    echo 0x192d04e0 > $DCC_PATH/config
    echo 0x192d1400 2 > $DCC_PATH/config
    echo 0x192d1410 3 > $DCC_PATH/config
    echo 0x192d1420 2 > $DCC_PATH/config
    echo 0x192d1430 > $DCC_PATH/config
    echo 0x192d1440 > $DCC_PATH/config
    echo 0x192d2400 2 > $DCC_PATH/config
    echo 0x192d2410 > $DCC_PATH/config
    echo 0x192d2418 > $DCC_PATH/config
    echo 0x192d3400 5 > $DCC_PATH/config
    echo 0x192d5110 > $DCC_PATH/config
    echo 0x192d5210 > $DCC_PATH/config
    echo 0x192d5230 > $DCC_PATH/config
    echo 0x192d53b0 2 > $DCC_PATH/config
    echo 0x192d5840 > $DCC_PATH/config
    echo 0x192d5920 4 > $DCC_PATH/config
    echo 0x192d5b00 8 > $DCC_PATH/config
    echo 0x192d5b28 5 > $DCC_PATH/config
    echo 0x192d6400 > $DCC_PATH/config
    echo 0x192d6410 > $DCC_PATH/config
    echo 0x192d6418 > $DCC_PATH/config
    echo 0x192d6420 > $DCC_PATH/config
    echo 0x192d9100 > $DCC_PATH/config
}

config_cb()
{
    echo 0xec80010 > $DCC_PATH/config
    echo 0xec81000 > $DCC_PATH/config
    echo 0xec81010 64 > $DCC_PATH/config
    echo 0xec811d0 16 > $DCC_PATH/config
}

config_turing()
{
    echo 0x32310220 3 > $DCC_PATH/config
    echo 0x323102a0 3 > $DCC_PATH/config
    echo 0x323104a0 6 > $DCC_PATH/config
    echo 0x32310520 > $DCC_PATH/config
    echo 0x32310588 > $DCC_PATH/config
    echo 0x32310d10 8 > $DCC_PATH/config
    echo 0x32310f90 6 > $DCC_PATH/config
    echo 0x32311010 6 > $DCC_PATH/config
    echo 0x32311a10 3 > $DCC_PATH/config
    echo 0x323b0228 > $DCC_PATH/config
    echo 0x323b0248 > $DCC_PATH/config
    echo 0x323b0268 > $DCC_PATH/config
    echo 0x323b0288 > $DCC_PATH/config
    echo 0x323b02a8 > $DCC_PATH/config
    echo 0x323b022c > $DCC_PATH/config
    echo 0x323b024c > $DCC_PATH/config
    echo 0x323b026c > $DCC_PATH/config
    echo 0x323b028c > $DCC_PATH/config
    echo 0x323b02ac > $DCC_PATH/config
    echo 0x323b0210 > $DCC_PATH/config
    echo 0x323b0230 > $DCC_PATH/config
    echo 0x323b0250 > $DCC_PATH/config
    echo 0x323b0270 > $DCC_PATH/config
    echo 0x323b0290 > $DCC_PATH/config
    echo 0x323b02b0 > $DCC_PATH/config
    echo 0x323b0400 3 > $DCC_PATH/config
    echo 0x320a4404 > $DCC_PATH/config
    echo 0x32302028 > $DCC_PATH/config
    echo 0x32300304 > $DCC_PATH/config
    echo 0x320a4408 > $DCC_PATH/config
    echo 0x320a4400 > $DCC_PATH/config
    echo 0x320a4208 > $DCC_PATH/config
    echo 0x320b4208 > $DCC_PATH/config
    echo 0x320c4208 > $DCC_PATH/config
    echo 0x320d4208 > $DCC_PATH/config
    echo 0x320a420c > $DCC_PATH/config
    echo 0x320b420c > $DCC_PATH/config
    echo 0x320c420c > $DCC_PATH/config
    echo 0x320d420c > $DCC_PATH/config
    echo 0x320a7d4c > $DCC_PATH/config
    echo 0x323b0208 > $DCC_PATH/config
    echo 0x323c0208 > $DCC_PATH/config
    echo 0x323d0208 > $DCC_PATH/config
    echo 0x323e0208 > $DCC_PATH/config
    echo 0x323b020c > $DCC_PATH/config
    echo 0x323c020c > $DCC_PATH/config
    echo 0x323d020c > $DCC_PATH/config
    echo 0x323e020c > $DCC_PATH/config
    echo 0xb2b1024 > $DCC_PATH/config
    echo 0xb2b4520 > $DCC_PATH/config
    echo 0xb2b1204 > $DCC_PATH/config
    echo 0xb2b1218 > $DCC_PATH/config
    echo 0xb2b122c > $DCC_PATH/config
    echo 0xb2b1240 > $DCC_PATH/config
    echo 0xb2b1208 > $DCC_PATH/config
    echo 0xb2b121c > $DCC_PATH/config
    echo 0xb2b1230 > $DCC_PATH/config
    echo 0xb2b1244 > $DCC_PATH/config

    echo 0x1A915C > $DCC_PATH/config
    echo 0x1A9160 > $DCC_PATH/config
    echo 0x1A9000 > $DCC_PATH/config
    echo 0x1A9004 > $DCC_PATH/config
    echo 0x1A9008 > $DCC_PATH/config
    echo 0x1A9018 > $DCC_PATH/config
    echo 0x1A9020 > $DCC_PATH/config
    }

config_lpass()
{
    echo 0x30b0228 > $DCC_PATH/config
    echo 0x30b0248 > $DCC_PATH/config
    echo 0x30b0268 > $DCC_PATH/config
    echo 0x30b0288 > $DCC_PATH/config
    echo 0x30b02a8 > $DCC_PATH/config
    echo 0x30b022c > $DCC_PATH/config
    echo 0x30b024c > $DCC_PATH/config
    echo 0x30b026c > $DCC_PATH/config
    echo 0x30b028c > $DCC_PATH/config
    echo 0x30b02ac > $DCC_PATH/config
    echo 0x30b0210 > $DCC_PATH/config
    echo 0x30b0230 > $DCC_PATH/config
    echo 0x30b0250 > $DCC_PATH/config
    echo 0x30b0270 > $DCC_PATH/config
    echo 0x30b0290 > $DCC_PATH/config
    echo 0x30b02b0 > $DCC_PATH/config
    echo 0x30b0400 3 > $DCC_PATH/config
    echo 0x3480404 > $DCC_PATH/config
    echo 0x3002028 > $DCC_PATH/config
    echo 0x3000304 > $DCC_PATH/config
    echo 0x3480408 > $DCC_PATH/config
    echo 0x3480400 > $DCC_PATH/config
    echo 0x3480208 > $DCC_PATH/config
    echo 0x3490208 > $DCC_PATH/config
    echo 0x3480204 > $DCC_PATH/config
    echo 0x3490204 > $DCC_PATH/config
    echo 0x3483d4c > $DCC_PATH/config
    echo 0x30b0208 > $DCC_PATH/config
    echo 0x30c0208 > $DCC_PATH/config
    echo 0x30d0208 > $DCC_PATH/config
    echo 0x30e0208 > $DCC_PATH/config
    echo 0x30b020c > $DCC_PATH/config
    echo 0x30c020c > $DCC_PATH/config
    echo 0x30d020c > $DCC_PATH/config
    echo 0x30e020c > $DCC_PATH/config
    echo 0xb251024 > $DCC_PATH/config
    echo 0xb254520 > $DCC_PATH/config
    echo 0xb251218 > $DCC_PATH/config
    echo 0xb25122c > $DCC_PATH/config
    echo 0xb251240 > $DCC_PATH/config
    echo 0xb251254 > $DCC_PATH/config
    echo 0xb251208 > $DCC_PATH/config
    echo 0xb25121c > $DCC_PATH/config
    echo 0xb251230 > $DCC_PATH/config
    echo 0xb251244 > $DCC_PATH/config
}

config_modem()
{
    echo 0x4130228 > $DCC_PATH/config
    echo 0x4130248 > $DCC_PATH/config
    echo 0x4130268 > $DCC_PATH/config
    echo 0x4130288 > $DCC_PATH/config
    echo 0x41302a8 > $DCC_PATH/config
    echo 0x413022c > $DCC_PATH/config
    echo 0x413024c > $DCC_PATH/config
    echo 0x413026c > $DCC_PATH/config
    echo 0x413028c > $DCC_PATH/config
    echo 0x41302ac > $DCC_PATH/config
    echo 0x4130210 > $DCC_PATH/config
    echo 0x4130230 > $DCC_PATH/config
    echo 0x4130250 > $DCC_PATH/config
    echo 0x4130270 > $DCC_PATH/config
    echo 0x4130290 > $DCC_PATH/config
    echo 0x41302b0 > $DCC_PATH/config
    echo 0x4130400 3 > $DCC_PATH/config
    echo 0x4200404 > $DCC_PATH/config
    echo 0x4082028 > $DCC_PATH/config
    echo 0x4080304 > $DCC_PATH/config
    echo 0x4200408 > $DCC_PATH/config
    echo 0x4200400 > $DCC_PATH/config
    echo 0x4200208 > $DCC_PATH/config
    echo 0x4210208 > $DCC_PATH/config
    echo 0x4220208 > $DCC_PATH/config
    echo 0x4230208 > $DCC_PATH/config
    echo 0x420020c > $DCC_PATH/config
    echo 0x421020c > $DCC_PATH/config
    echo 0x422020c > $DCC_PATH/config
    echo 0x423020c > $DCC_PATH/config
    echo 0x4203d4c > $DCC_PATH/config
    echo 0x4130208 > $DCC_PATH/config
    echo 0x4140208 > $DCC_PATH/config
    echo 0x4150208 > $DCC_PATH/config
    echo 0x4160208 > $DCC_PATH/config
    echo 0x413020c > $DCC_PATH/config
    echo 0x414020c > $DCC_PATH/config
    echo 0x415020c > $DCC_PATH/config
    echo 0x416020c > $DCC_PATH/config
    echo 0xb2f1024 > $DCC_PATH/config
    echo 0xb2f4520 > $DCC_PATH/config
    echo 0xb2f1204 > $DCC_PATH/config
    echo 0xb2f1218 > $DCC_PATH/config
    echo 0xb2f122c > $DCC_PATH/config
    echo 0xb2f1240 > $DCC_PATH/config
    echo 0xb2f1208 > $DCC_PATH/config
    echo 0xb2f121c > $DCC_PATH/config
    echo 0xb2f1230 > $DCC_PATH/config
    echo 0xb2f1244 > $DCC_PATH/config
}

config_wpss()
{
    echo 0x8ab0208 > $DCC_PATH/config
    echo 0x8ab0228 > $DCC_PATH/config
    echo 0x8ab0248 > $DCC_PATH/config
    echo 0x8ab0268 > $DCC_PATH/config
    echo 0x8ab0288 > $DCC_PATH/config
    echo 0x8ab02a8 > $DCC_PATH/config
    echo 0x8ab020c > $DCC_PATH/config
    echo 0x8ab022c > $DCC_PATH/config
    echo 0x8ab024c > $DCC_PATH/config
    echo 0x8ab026c > $DCC_PATH/config
    echo 0x8ab028c > $DCC_PATH/config
    echo 0x8ab02ac > $DCC_PATH/config
    echo 0x8ab0210 > $DCC_PATH/config
    echo 0x8ab0230 > $DCC_PATH/config
    echo 0x8ab0250 > $DCC_PATH/config
    echo 0x8ab0270 > $DCC_PATH/config
    echo 0x8ab0290 > $DCC_PATH/config
    echo 0x8ab02b0 > $DCC_PATH/config
    echo 0x8ab0400 3 > $DCC_PATH/config
    echo 0x8b00400 3 > $DCC_PATH/config
    echo 0xb2e1024 > $DCC_PATH/config
    echo 0xb2e4520 > $DCC_PATH/config
    echo 0xb2e1204 > $DCC_PATH/config
    echo 0xb2e1218 > $DCC_PATH/config
    echo 0xb2e122c > $DCC_PATH/config
    echo 0xb2e1240 > $DCC_PATH/config
    echo 0xb2e1208 > $DCC_PATH/config
    echo 0xb2e1244 > $DCC_PATH/config
    echo 0xb2e1258 > $DCC_PATH/config
    echo 0xb2e126c > $DCC_PATH/config
}

config_tme()
{
    echo 0x20c200f0 8 > $DCC_PATH/config
    echo 0xb2c1024 > $DCC_PATH/config
    echo 0xb2c4520 > $DCC_PATH/config
    echo 0xb2c1204 > $DCC_PATH/config
    echo 0xb2c1218 > $DCC_PATH/config
    echo 0xb2c122c > $DCC_PATH/config
    echo 0xb2c1240 > $DCC_PATH/config
    echo 0xb2c1208 > $DCC_PATH/config
    echo 0xb2c121c > $DCC_PATH/config
    echo 0xb2c1230 > $DCC_PATH/config
    echo 0xb2c1244 > $DCC_PATH/config
}

config_cam()
{
    echo 0x136010 > $DCC_PATH/config
    echo 0x136018 > $DCC_PATH/config
    echo 0xac4d000 > $DCC_PATH/config
    echo 0xac40000 > $DCC_PATH/config
    echo 0xad150d0 > $DCC_PATH/config
    echo 0xad10060 2 > $DCC_PATH/config
    echo 0xad10044 2 > $DCC_PATH/config
    echo 0xad10004 2 > $DCC_PATH/config
    echo 0xad10018 2 > $DCC_PATH/config
    echo 0xad10030 > $DCC_PATH/config
    echo 0xad10078 > $DCC_PATH/config
    echo 0xad1005c > $DCC_PATH/config
    echo 0xad10000 > $DCC_PATH/config
    echo 0xad10040 > $DCC_PATH/config
    echo 0xad11004 2 > $DCC_PATH/config
    echo 0xad11018 2 > $DCC_PATH/config
    echo 0xad11030 > $DCC_PATH/config
    echo 0xad11048 > $DCC_PATH/config
    echo 0xad11044 > $DCC_PATH/config
    echo 0xad11000 > $DCC_PATH/config
    echo 0xad11040 > $DCC_PATH/config
    echo 0xad15070 3 > $DCC_PATH/config
    echo 0xad1508c > $DCC_PATH/config
    echo 0xad15094 > $DCC_PATH/config
    echo 0xad13090 > $DCC_PATH/config
    echo 0xad13000 > $DCC_PATH/config
    echo 0xad13038 > $DCC_PATH/config
    echo 0xad13008 > $DCC_PATH/config
    echo 0xad13004 > $DCC_PATH/config
    echo 0xad1308c > $DCC_PATH/config
    echo 0xad13030 > $DCC_PATH/config
    echo 0xad13044 > $DCC_PATH/config
    echo 0xad13018 2 > $DCC_PATH/config
    echo 0xad13060 > $DCC_PATH/config
    echo 0xad13048 2 > $DCC_PATH/config
    echo 0xad14000 > $DCC_PATH/config
    echo 0xad14038 > $DCC_PATH/config
    echo 0xad14070 > $DCC_PATH/config
    echo 0xad14008 > $DCC_PATH/config
    echo 0xad14004 > $DCC_PATH/config
    echo 0xad1406c > $DCC_PATH/config
    echo 0xad14060 > $DCC_PATH/config
    echo 0xad14048 2 > $DCC_PATH/config
    echo 0xad14030 > $DCC_PATH/config
    echo 0xad14044 > $DCC_PATH/config
    echo 0xad14018 2 > $DCC_PATH/config
    echo 0xad14074 > $DCC_PATH/config
    echo 0xad140ac > $DCC_PATH/config
    echo 0xad140e0 > $DCC_PATH/config
    echo 0xad1407c > $DCC_PATH/config
    echo 0xad14078 > $DCC_PATH/config
    echo 0xad140dc > $DCC_PATH/config
    echo 0xad140a4 > $DCC_PATH/config
    echo 0xad1408c 2 > $DCC_PATH/config
    echo 0xad140d0 > $DCC_PATH/config
    echo 0xad140b8 2 > $DCC_PATH/config
    echo 0xad15040 2 > $DCC_PATH/config
    echo 0xad15018 > $DCC_PATH/config
    echo 0xad15000 2 > $DCC_PATH/config
    echo 0xad15034 > $DCC_PATH/config
    echo 0xad1501c 2 > $DCC_PATH/config
    echo 0xad150f0 > $DCC_PATH/config
    echo 0xad150d4 2 > $DCC_PATH/config
    echo 0xad15120 2 > $DCC_PATH/config
    echo 0xad15134 > $DCC_PATH/config
    echo 0xad15150 > $DCC_PATH/config
    echo 0xacef054 > $DCC_PATH/config
    echo 0xac1001c > $DCC_PATH/config
}

config_core_hung()
{
    echo 0x17000000 > $DCC_PATH/config
    echo 0x17000008 18 > $DCC_PATH/config
    echo 0x17000054 8 > $DCC_PATH/config
    echo 0x170000f0 3 > $DCC_PATH/config
    echo 0x17000100 2 > $DCC_PATH/config
    echo 0x17008000 5 > $DCC_PATH/config
    echo 0x17600004 > $DCC_PATH/config
    echo 0x17600010 3 > $DCC_PATH/config
    echo 0x17600024 3 > $DCC_PATH/config
    echo 0x17600034 > $DCC_PATH/config
    echo 0x17600040 2 > $DCC_PATH/config
    echo 0x17600050 7 > $DCC_PATH/config
    echo 0x17600070 7 > $DCC_PATH/config
    echo 0x17600094 3 > $DCC_PATH/config
    echo 0x176000a8 11 > $DCC_PATH/config
    echo 0x176000d8 14 > $DCC_PATH/config
    echo 0x17600118 5 > $DCC_PATH/config
    echo 0x17600134 3 > $DCC_PATH/config
    echo 0x17600148 5 > $DCC_PATH/config
    echo 0x17600160 3 > $DCC_PATH/config
    echo 0x17600170 3 > $DCC_PATH/config
    echo 0x17600180 4 > $DCC_PATH/config
    echo 0x17600210 2 > $DCC_PATH/config
    echo 0x17600234 2 > $DCC_PATH/config
    echo 0x17600240 11 > $DCC_PATH/config
    echo 0x176002b4 2 > $DCC_PATH/config
    echo 0x17600404 3 > $DCC_PATH/config
    echo 0x1760041c 3 > $DCC_PATH/config
    echo 0x17600434 > $DCC_PATH/config
    echo 0x1760043c 2 > $DCC_PATH/config
    echo 0x17600460 2 > $DCC_PATH/config
    echo 0x17600470 2 > $DCC_PATH/config
    echo 0x17600480 2 > $DCC_PATH/config
    echo 0x17600490 2 > $DCC_PATH/config
    echo 0x176004a0 2 > $DCC_PATH/config
    echo 0x176004b0 2 > $DCC_PATH/config
    echo 0x176004c0 2 > $DCC_PATH/config
    echo 0x176004d0 2 > $DCC_PATH/config
    echo 0x176004e0 2 > $DCC_PATH/config
    echo 0x176004f0 > $DCC_PATH/config
    echo 0x17600500 13 > $DCC_PATH/config
    echo 0x176009fc > $DCC_PATH/config
    echo 0x17601000 12 > $DCC_PATH/config
    echo 0x17602000 65 > $DCC_PATH/config
    echo 0x17603000 12 > $DCC_PATH/config
    echo 0x17604000 65 > $DCC_PATH/config
    echo 0x17605000 > $DCC_PATH/config
    echo 0x17606000 > $DCC_PATH/config
    echo 0x17607000 > $DCC_PATH/config
    echo 0x17608004 3 > $DCC_PATH/config
    echo 0x17608020 2 > $DCC_PATH/config
    echo 0x1760f000 6 > $DCC_PATH/config
    echo 0x17800000 > $DCC_PATH/config
    echo 0x17800008 18 > $DCC_PATH/config
    echo 0x17800054 8 > $DCC_PATH/config
    echo 0x178000f0 3 > $DCC_PATH/config
    echo 0x17800100 2 > $DCC_PATH/config
    echo 0x17810000 > $DCC_PATH/config
    echo 0x17810008 18 > $DCC_PATH/config
    echo 0x17810054 8 > $DCC_PATH/config
    echo 0x178100f0 3 > $DCC_PATH/config
    echo 0x17810100 2 > $DCC_PATH/config
    echo 0x17820000 > $DCC_PATH/config
    echo 0x17820008 18 > $DCC_PATH/config
    echo 0x17820054 8 > $DCC_PATH/config
    echo 0x178200f0 3 > $DCC_PATH/config
    echo 0x17820100 2 > $DCC_PATH/config
    echo 0x17830000 > $DCC_PATH/config
    echo 0x17830008 18 > $DCC_PATH/config
    echo 0x17830054 8 > $DCC_PATH/config
    echo 0x178300f0 3 > $DCC_PATH/config
    echo 0x17830100 2 > $DCC_PATH/config
    echo 0x17840000 > $DCC_PATH/config
    echo 0x17840008 18 > $DCC_PATH/config
    echo 0x17840054 8 > $DCC_PATH/config
    echo 0x178400f0 3 > $DCC_PATH/config
    echo 0x17840100 2 > $DCC_PATH/config
    echo 0x17848000 5 > $DCC_PATH/config
    echo 0x17850000 > $DCC_PATH/config
    echo 0x17850008 18 > $DCC_PATH/config
    echo 0x17850054 8 > $DCC_PATH/config
    echo 0x178500f0 3 > $DCC_PATH/config
    echo 0x17850100 2 > $DCC_PATH/config
    echo 0x17858000 5 > $DCC_PATH/config
    echo 0x17860000 > $DCC_PATH/config
    echo 0x17860008 18 > $DCC_PATH/config
    echo 0x17860054 8 > $DCC_PATH/config
    echo 0x178600f0 3 > $DCC_PATH/config
    echo 0x17860100 2 > $DCC_PATH/config
    echo 0x17868000 5 > $DCC_PATH/config
    echo 0x17870000 > $DCC_PATH/config
    echo 0x17870008 18 > $DCC_PATH/config
    echo 0x17870054 8 > $DCC_PATH/config
    echo 0x178700f0 3 > $DCC_PATH/config
    echo 0x17870100 2 > $DCC_PATH/config
    echo 0x17878000 5 > $DCC_PATH/config
    echo 0x17880000 > $DCC_PATH/config
    echo 0x17880008 18 > $DCC_PATH/config
    echo 0x17880068 2 > $DCC_PATH/config
    echo 0x178800f0 6 > $DCC_PATH/config
    echo 0x17888000 6 > $DCC_PATH/config
    echo 0x17890000 > $DCC_PATH/config
    echo 0x17890008 18 > $DCC_PATH/config
    echo 0x17890068 2 > $DCC_PATH/config
    echo 0x178900f0 6 > $DCC_PATH/config
    echo 0x17898000 6 > $DCC_PATH/config
    echo 0x178a0000 > $DCC_PATH/config
    echo 0x178a0008 18 > $DCC_PATH/config
    echo 0x178a0054 13 > $DCC_PATH/config
    echo 0x178a0090 116 > $DCC_PATH/config
    echo 0x178c0000 146 > $DCC_PATH/config
    echo 0x178c8000 > $DCC_PATH/config
    echo 0x178c8008 > $DCC_PATH/config
    echo 0x178c8010 > $DCC_PATH/config
    echo 0x178c8018 > $DCC_PATH/config
    echo 0x178c8020 > $DCC_PATH/config
    echo 0x178c8028 > $DCC_PATH/config
    echo 0x178c8030 > $DCC_PATH/config
    echo 0x178c8038 > $DCC_PATH/config
    echo 0x178c8040 > $DCC_PATH/config
    echo 0x178c8048 > $DCC_PATH/config
    echo 0x178c8050 > $DCC_PATH/config
    echo 0x178c8058 > $DCC_PATH/config
    echo 0x178c8060 > $DCC_PATH/config
    echo 0x178c8068 > $DCC_PATH/config
    echo 0x178c8070 > $DCC_PATH/config
    echo 0x178c8078 > $DCC_PATH/config
    echo 0x178c8080 > $DCC_PATH/config
    echo 0x178c8088 > $DCC_PATH/config
    echo 0x178c8090 > $DCC_PATH/config
    echo 0x178c8098 > $DCC_PATH/config
    echo 0x178c80a0 > $DCC_PATH/config
    echo 0x178c80a8 > $DCC_PATH/config
    echo 0x178c80b0 > $DCC_PATH/config
    echo 0x178c80b8 > $DCC_PATH/config
    echo 0x178c80c0 > $DCC_PATH/config
    echo 0x178c80c8 > $DCC_PATH/config
    echo 0x178c80d0 > $DCC_PATH/config
    echo 0x178c80d8 > $DCC_PATH/config
    echo 0x178c80e0 > $DCC_PATH/config
    echo 0x178c80e8 > $DCC_PATH/config
    echo 0x178c80f0 > $DCC_PATH/config
    echo 0x178c80f8 > $DCC_PATH/config
    echo 0x178c8100 > $DCC_PATH/config
    echo 0x178c8108 > $DCC_PATH/config
    echo 0x178c8110 > $DCC_PATH/config
    echo 0x178c8118 > $DCC_PATH/config
    echo 0x178cc000 > $DCC_PATH/config
    echo 0x17a80000 16 > $DCC_PATH/config
    echo 0x17a82000 16 > $DCC_PATH/config
    echo 0x17a84000 16 > $DCC_PATH/config
    echo 0x17a86000 16 > $DCC_PATH/config
    echo 0x17aa0000 44 > $DCC_PATH/config
    echo 0x17aa00fc 20 > $DCC_PATH/config
    echo 0x17aa0200 2 > $DCC_PATH/config
    echo 0x17aa0300 > $DCC_PATH/config
    echo 0x17aa0400 > $DCC_PATH/config
    echo 0x17aa0500 > $DCC_PATH/config
    echo 0x17aa0600 > $DCC_PATH/config
    echo 0x17aa0700 5 > $DCC_PATH/config
    echo 0x17b00000 70 > $DCC_PATH/config
    echo 0x17b70000 3 > $DCC_PATH/config
    echo 0x17b70010 8 > $DCC_PATH/config
    echo 0x17b70090 5 > $DCC_PATH/config
    echo 0x17b70100 > $DCC_PATH/config
    echo 0x17b70110 2 > $DCC_PATH/config
    echo 0x17b70190 > $DCC_PATH/config
    echo 0x17b701a0 2 > $DCC_PATH/config
    echo 0x17b70220 2 > $DCC_PATH/config
    echo 0x17b702a0 2 > $DCC_PATH/config
    echo 0x17b70320 > $DCC_PATH/config
    echo 0x17b70380 > $DCC_PATH/config
    echo 0x17b70390 12 > $DCC_PATH/config
    echo 0x17b70410 > $DCC_PATH/config
    echo 0x17b70420 12 > $DCC_PATH/config
    echo 0x17b704a0 12 > $DCC_PATH/config
    echo 0x17b70520 2 > $DCC_PATH/config
    echo 0x17b70580 6 > $DCC_PATH/config
    echo 0x17b70600 > $DCC_PATH/config
    echo 0x17b70610 12 > $DCC_PATH/config
    echo 0x17b70690 12 > $DCC_PATH/config
    echo 0x17b70710 12 > $DCC_PATH/config
    echo 0x17b70790 12 > $DCC_PATH/config
    echo 0x17b70810 12 > $DCC_PATH/config
    echo 0x17b70890 12 > $DCC_PATH/config
    echo 0x17b70910 12 > $DCC_PATH/config
    echo 0x17b70990 12 > $DCC_PATH/config
    echo 0x17b70a10 12 > $DCC_PATH/config
    echo 0x17b70a90 12 > $DCC_PATH/config
    echo 0x17b70b00 > $DCC_PATH/config
    echo 0x17b70b10 12 > $DCC_PATH/config
    echo 0x17b70b90 12 > $DCC_PATH/config
    echo 0x17b70c10 12 > $DCC_PATH/config
    echo 0x17b70c90 12 > $DCC_PATH/config
    echo 0x17b70d10 12 > $DCC_PATH/config
    echo 0x17b70d90 12 > $DCC_PATH/config
    echo 0x17b70e00 > $DCC_PATH/config
    echo 0x17b70e10 10 > $DCC_PATH/config
    echo 0x17b70e90 10 > $DCC_PATH/config
    echo 0x17b70f10 10 > $DCC_PATH/config
    echo 0x17b70f90 10 > $DCC_PATH/config
    echo 0x17b71010 10 > $DCC_PATH/config
    echo 0x17b71090 10 > $DCC_PATH/config
    echo 0x17b71100 > $DCC_PATH/config
    echo 0x17b71110 8 > $DCC_PATH/config
    echo 0x17b71190 8 > $DCC_PATH/config
    echo 0x17b71210 128 > $DCC_PATH/config
    echo 0x17b71a10 8 > $DCC_PATH/config
    echo 0x17b71a90 8 > $DCC_PATH/config
    echo 0x17b71b00 2 > $DCC_PATH/config
    echo 0x17b71b10 8 > $DCC_PATH/config
    echo 0x17b71b90 5 > $DCC_PATH/config
    echo 0x17b71bb0 8 > $DCC_PATH/config
    echo 0x17b71c30 2 > $DCC_PATH/config
    echo 0x17b71c40 8 > $DCC_PATH/config
    echo 0x17b71cc0 4 > $DCC_PATH/config
    echo 0x17b71d00 11 > $DCC_PATH/config
    echo 0x17b78000 3 > $DCC_PATH/config
    echo 0x17b78010 4 > $DCC_PATH/config
    echo 0x17b78090 5 > $DCC_PATH/config
    echo 0x17b78100 > $DCC_PATH/config
    echo 0x17b78110 2 > $DCC_PATH/config
    echo 0x17b78190 > $DCC_PATH/config
    echo 0x17b781a0 2 > $DCC_PATH/config
    echo 0x17b78220 2 > $DCC_PATH/config
    echo 0x17b782a0 2 > $DCC_PATH/config
    echo 0x17b78320 > $DCC_PATH/config
    echo 0x17b78380 > $DCC_PATH/config
    echo 0x17b78390 12 > $DCC_PATH/config
    echo 0x17b78410 > $DCC_PATH/config
    echo 0x17b78420 12 > $DCC_PATH/config
    echo 0x17b784a0 12 > $DCC_PATH/config
    echo 0x17b78520 2 > $DCC_PATH/config
    echo 0x17b78580 6 > $DCC_PATH/config
    echo 0x17b78600 > $DCC_PATH/config
    echo 0x17b78610 8 > $DCC_PATH/config
    echo 0x17b78690 8 > $DCC_PATH/config
    echo 0x17b78710 8 > $DCC_PATH/config
    echo 0x17b78790 8 > $DCC_PATH/config
    echo 0x17b78810 8 > $DCC_PATH/config
    echo 0x17b78890 8 > $DCC_PATH/config
    echo 0x17b78910 8 > $DCC_PATH/config
    echo 0x17b78990 8 > $DCC_PATH/config
    echo 0x17b78a10 8 > $DCC_PATH/config
    echo 0x17b78a90 8 > $DCC_PATH/config
    echo 0x17b78b00 > $DCC_PATH/config
    echo 0x17b78b10 8 > $DCC_PATH/config
    echo 0x17b78b90 8 > $DCC_PATH/config
    echo 0x17b78c10 8 > $DCC_PATH/config
    echo 0x17b78c90 8 > $DCC_PATH/config
    echo 0x17b78d10 8 > $DCC_PATH/config
    echo 0x17b78d90 8 > $DCC_PATH/config
    echo 0x17b78e00 > $DCC_PATH/config
    echo 0x17b78e10 6 > $DCC_PATH/config
    echo 0x17b78e90 6 > $DCC_PATH/config
    echo 0x17b78f10 6 > $DCC_PATH/config
    echo 0x17b78f90 6 > $DCC_PATH/config
    echo 0x17b79010 6 > $DCC_PATH/config
    echo 0x17b79090 6 > $DCC_PATH/config
    echo 0x17b79100 > $DCC_PATH/config
    echo 0x17b79110 4 > $DCC_PATH/config
    echo 0x17b79190 4 > $DCC_PATH/config
    echo 0x17b79210 64 > $DCC_PATH/config
    echo 0x17b79a10 4 > $DCC_PATH/config
    echo 0x17b79a90 4 > $DCC_PATH/config
    echo 0x17b79b00 2 > $DCC_PATH/config
    echo 0x17b79b10 4 > $DCC_PATH/config
    echo 0x17b79b90 5 > $DCC_PATH/config
    echo 0x17b79bb0 4 > $DCC_PATH/config
    echo 0x17b79c30 2 > $DCC_PATH/config
    echo 0x17b79c40 4 > $DCC_PATH/config
    echo 0x17b79cc0 4 > $DCC_PATH/config
    echo 0x17b79d00 11 > $DCC_PATH/config
    echo 0x17b90000 6 > $DCC_PATH/config
    echo 0x17b90020 5 > $DCC_PATH/config
    echo 0x17b90050 > $DCC_PATH/config
    echo 0x17b90070 > $DCC_PATH/config
    echo 0x17b90080 25 > $DCC_PATH/config
    echo 0x17b90100 > $DCC_PATH/config
    echo 0x17b90120 > $DCC_PATH/config
    echo 0x17b90140 > $DCC_PATH/config
    echo 0x17b90200 12 > $DCC_PATH/config
    echo 0x17b90700 > $DCC_PATH/config
    echo 0x17b9070c 3 > $DCC_PATH/config
    echo 0x17b90780 32 > $DCC_PATH/config
    echo 0x17b90808 > $DCC_PATH/config
    echo 0x17b90c48 > $DCC_PATH/config
    echo 0x17b9080c > $DCC_PATH/config
    echo 0x17b90c4c > $DCC_PATH/config
    echo 0x17b90810 > $DCC_PATH/config
    echo 0x17b90c50 > $DCC_PATH/config
    echo 0x17b90814 > $DCC_PATH/config
    echo 0x17b90c54 > $DCC_PATH/config
    echo 0x17b90818 > $DCC_PATH/config
    echo 0x17b90c58 > $DCC_PATH/config
    echo 0x17b9081c > $DCC_PATH/config
    echo 0x17b90c5c > $DCC_PATH/config
    echo 0x17b90824 > $DCC_PATH/config
    echo 0x17b90c64 > $DCC_PATH/config
    echo 0x17b90828 > $DCC_PATH/config
    echo 0x17b90c68 > $DCC_PATH/config
    echo 0x17b9082c > $DCC_PATH/config
    echo 0x17b90c6c > $DCC_PATH/config
    echo 0x17b90840 > $DCC_PATH/config
    echo 0x17b90c80 > $DCC_PATH/config
    echo 0x17b90844 > $DCC_PATH/config
    echo 0x17b90c84 > $DCC_PATH/config
    echo 0x17b90848 > $DCC_PATH/config
    echo 0x17b90c88 > $DCC_PATH/config
    echo 0x17b9084c > $DCC_PATH/config
    echo 0x17b90c8c > $DCC_PATH/config
    echo 0x17b90850 > $DCC_PATH/config
    echo 0x17b90c90 > $DCC_PATH/config
    echo 0x17b90854 > $DCC_PATH/config
    echo 0x17b90c94 > $DCC_PATH/config
    echo 0x17b90858 > $DCC_PATH/config
    echo 0x17b90c98 > $DCC_PATH/config
    echo 0x17b9085c > $DCC_PATH/config
    echo 0x17b90c9c > $DCC_PATH/config
    echo 0x17b90860 > $DCC_PATH/config
    echo 0x17b90ca0 > $DCC_PATH/config
    echo 0x17b90864 > $DCC_PATH/config
    echo 0x17b90ca4 > $DCC_PATH/config
    echo 0x17b90868 > $DCC_PATH/config
    echo 0x17b90ca8 > $DCC_PATH/config
    echo 0x17b9086c > $DCC_PATH/config
    echo 0x17b90cac > $DCC_PATH/config
    echo 0x17b90870 > $DCC_PATH/config
    echo 0x17b90cb0 > $DCC_PATH/config
    echo 0x17b90874 > $DCC_PATH/config
    echo 0x17b90cb4 > $DCC_PATH/config
    echo 0x17b90878 > $DCC_PATH/config
    echo 0x17b90cb8 > $DCC_PATH/config
    echo 0x17b9087c > $DCC_PATH/config
    echo 0x17b90cbc > $DCC_PATH/config
    echo 0x17b93500 80 > $DCC_PATH/config
    echo 0x17b93a80 3 > $DCC_PATH/config
    echo 0x17b93aa8 50 > $DCC_PATH/config
    echo 0x17b93c00 2 > $DCC_PATH/config
    echo 0x17b93c20 3 > $DCC_PATH/config
    echo 0x17b93c30 8 > $DCC_PATH/config
    echo 0x17b93c60 2 > $DCC_PATH/config
    echo 0x17b93c70 2 > $DCC_PATH/config
    echo 0x17ba0000 6 > $DCC_PATH/config
    echo 0x17ba0020 5 > $DCC_PATH/config
    echo 0x17ba0050 > $DCC_PATH/config
    echo 0x17ba0070 > $DCC_PATH/config
    echo 0x17ba0080 25 > $DCC_PATH/config
    echo 0x17ba0100 > $DCC_PATH/config
    echo 0x17ba0120 > $DCC_PATH/config
    echo 0x17ba0140 > $DCC_PATH/config
    echo 0x17ba0200 8 > $DCC_PATH/config
    echo 0x17ba0700 > $DCC_PATH/config
    echo 0x17ba070c 3 > $DCC_PATH/config
    echo 0x17ba0780 32 > $DCC_PATH/config
    echo 0x17ba0808 > $DCC_PATH/config
    echo 0x17ba0c48 > $DCC_PATH/config
    echo 0x17ba080c > $DCC_PATH/config
    echo 0x17ba0c4c > $DCC_PATH/config
    echo 0x17ba0810 > $DCC_PATH/config
    echo 0x17ba0c50 > $DCC_PATH/config
    echo 0x17ba0814 > $DCC_PATH/config
    echo 0x17ba0c54 > $DCC_PATH/config
    echo 0x17ba0818 > $DCC_PATH/config
    echo 0x17ba0c58 > $DCC_PATH/config
    echo 0x17ba081c > $DCC_PATH/config
    echo 0x17ba0c5c > $DCC_PATH/config
    echo 0x17ba0824 > $DCC_PATH/config
    echo 0x17ba0c64 > $DCC_PATH/config
    echo 0x17ba0828 > $DCC_PATH/config
    echo 0x17ba0c68 > $DCC_PATH/config
    echo 0x17ba082c > $DCC_PATH/config
    echo 0x17ba0c6c > $DCC_PATH/config
    echo 0x17ba0840 > $DCC_PATH/config
    echo 0x17ba0c80 > $DCC_PATH/config
    echo 0x17ba0844 > $DCC_PATH/config
    echo 0x17ba0c84 > $DCC_PATH/config
    echo 0x17ba0848 > $DCC_PATH/config
    echo 0x17ba0c88 > $DCC_PATH/config
    echo 0x17ba084c > $DCC_PATH/config
    echo 0x17ba0c8c > $DCC_PATH/config
    echo 0x17ba0850 > $DCC_PATH/config
    echo 0x17ba0c90 > $DCC_PATH/config
    echo 0x17ba0854 > $DCC_PATH/config
    echo 0x17ba0c94 > $DCC_PATH/config
    echo 0x17ba0858 > $DCC_PATH/config
    echo 0x17ba0c98 > $DCC_PATH/config
    echo 0x17ba085c > $DCC_PATH/config
    echo 0x17ba0c9c > $DCC_PATH/config
    echo 0x17ba0860 > $DCC_PATH/config
    echo 0x17ba0ca0 > $DCC_PATH/config
    echo 0x17ba0864 > $DCC_PATH/config
    echo 0x17ba0ca4 > $DCC_PATH/config
    echo 0x17ba0868 > $DCC_PATH/config
    echo 0x17ba0ca8 > $DCC_PATH/config
    echo 0x17ba086c > $DCC_PATH/config
    echo 0x17ba0cac > $DCC_PATH/config
    echo 0x17ba0870 > $DCC_PATH/config
    echo 0x17ba0cb0 > $DCC_PATH/config
    echo 0x17ba0874 > $DCC_PATH/config
    echo 0x17ba0cb4 > $DCC_PATH/config
    echo 0x17ba0878 > $DCC_PATH/config
    echo 0x17ba0cb8 > $DCC_PATH/config
    echo 0x17ba087c > $DCC_PATH/config
    echo 0x17ba0cbc > $DCC_PATH/config
    echo 0x17ba3500 80 > $DCC_PATH/config
    echo 0x17ba3a80 3 > $DCC_PATH/config
    echo 0x17ba3aa8 50 > $DCC_PATH/config
    echo 0x17ba3c00 2 > $DCC_PATH/config
    echo 0x17ba3c20 3 > $DCC_PATH/config
    echo 0x17ba3c30 8 > $DCC_PATH/config
    echo 0x17ba3c60 2 > $DCC_PATH/config
    echo 0x17ba3c70 2 > $DCC_PATH/config
    echo 0x17d80000 3 > $DCC_PATH/config
    echo 0x17d80010 2 > $DCC_PATH/config
    echo 0x17d80100 256 > $DCC_PATH/config
    echo 0x17d90000 4 > $DCC_PATH/config
    echo 0x17d90014 26 > $DCC_PATH/config
    echo 0x17d90080 5 > $DCC_PATH/config
    echo 0x17d900b0 > $DCC_PATH/config
    echo 0x17d900b8 2 > $DCC_PATH/config
    echo 0x17d900d0 9 > $DCC_PATH/config
    echo 0x17d90100 40 > $DCC_PATH/config
    echo 0x17d90200 40 > $DCC_PATH/config
    echo 0x17d90300 5 > $DCC_PATH/config
    echo 0x17d90320 > $DCC_PATH/config
    echo 0x17d9034c 31 > $DCC_PATH/config
    echo 0x17d903e0 2 > $DCC_PATH/config
    echo 0x17d90404 > $DCC_PATH/config
    echo 0x17d91000 4 > $DCC_PATH/config
    echo 0x17d91014 26 > $DCC_PATH/config
    echo 0x17d91080 8 > $DCC_PATH/config
    echo 0x17d910b0 > $DCC_PATH/config
    echo 0x17d910b8 2 > $DCC_PATH/config
    echo 0x17d910d0 9 > $DCC_PATH/config
    echo 0x17d91100 40 > $DCC_PATH/config
    echo 0x17d91200 40 > $DCC_PATH/config
    echo 0x17d91300 5 > $DCC_PATH/config
    echo 0x17d91320 4 > $DCC_PATH/config
    echo 0x17d9134c 35 > $DCC_PATH/config
    echo 0x17d913e0 5 > $DCC_PATH/config
    echo 0x17d91404 > $DCC_PATH/config
    echo 0x17d92000 4 > $DCC_PATH/config
    echo 0x17d92014 26 > $DCC_PATH/config
    echo 0x17d92080 7 > $DCC_PATH/config
    echo 0x17d920b0 > $DCC_PATH/config
    echo 0x17d920b8 2 > $DCC_PATH/config
    echo 0x17d920d0 9 > $DCC_PATH/config
    echo 0x17d92100 40 > $DCC_PATH/config
    echo 0x17d92200 40 > $DCC_PATH/config
    echo 0x17d92300 5 > $DCC_PATH/config
    echo 0x17d92320 3 > $DCC_PATH/config
    echo 0x17d9234c 34 > $DCC_PATH/config
    echo 0x17d923e0 4 > $DCC_PATH/config
    echo 0x17d92404 > $DCC_PATH/config
    echo 0x17d93000 4 > $DCC_PATH/config
    echo 0x17d93014 26 > $DCC_PATH/config
    echo 0x17d93080 5 > $DCC_PATH/config
    echo 0x17d930b0 > $DCC_PATH/config
    echo 0x17d930b8 2 > $DCC_PATH/config
    echo 0x17d930d0 9 > $DCC_PATH/config
    echo 0x17d93100 40 > $DCC_PATH/config
    echo 0x17d93200 40 > $DCC_PATH/config
    echo 0x17d93300 5 > $DCC_PATH/config
    echo 0x17d93320 > $DCC_PATH/config
    echo 0x17d9334c 32 > $DCC_PATH/config
    echo 0x17d933e0 2 > $DCC_PATH/config
    echo 0x17d93404 > $DCC_PATH/config
    echo 0x17d98000 10 > $DCC_PATH/config
    echo 0x17e00000 > $DCC_PATH/config
    echo 0x17e00008 > $DCC_PATH/config
    echo 0x17e00010 > $DCC_PATH/config
    echo 0x17e00018 > $DCC_PATH/config
    echo 0x17e00020 > $DCC_PATH/config
    echo 0x17e00028 > $DCC_PATH/config
    echo 0x17e00030 > $DCC_PATH/config
    echo 0x17e00038 > $DCC_PATH/config
    echo 0x17e00040 > $DCC_PATH/config
    echo 0x17e00048 > $DCC_PATH/config
    echo 0x17e00050 > $DCC_PATH/config
    echo 0x17e00060 > $DCC_PATH/config
    echo 0x17e10000 > $DCC_PATH/config
    echo 0x17e10008 > $DCC_PATH/config
    echo 0x17e10018 > $DCC_PATH/config
    echo 0x17e10020 > $DCC_PATH/config
    echo 0x17e10030 > $DCC_PATH/config
    echo 0x17e100f0 > $DCC_PATH/config
    echo 0x17e100f8 > $DCC_PATH/config
    echo 0x17e10100 > $DCC_PATH/config
    echo 0x17e11000 > $DCC_PATH/config
    echo 0x17e20000 > $DCC_PATH/config
    echo 0x17e20008 > $DCC_PATH/config
    echo 0x17e20010 > $DCC_PATH/config
    echo 0x17e20018 > $DCC_PATH/config
    echo 0x17e20020 > $DCC_PATH/config
    echo 0x17e20028 > $DCC_PATH/config
    echo 0x17e20030 > $DCC_PATH/config
    echo 0x17e20038 > $DCC_PATH/config
    echo 0x17e20800 > $DCC_PATH/config
    echo 0x17e20808 > $DCC_PATH/config
    echo 0x17e20810 > $DCC_PATH/config
    echo 0x17e20e00 > $DCC_PATH/config
    echo 0x17e20e10 > $DCC_PATH/config
    echo 0x17e20fa8 > $DCC_PATH/config
    echo 0x17e20fbc > $DCC_PATH/config
    echo 0x17e20fc8 > $DCC_PATH/config
    echo 0x17e20fd0 12 > $DCC_PATH/config
    echo 0x17e30000 3 > $DCC_PATH/config
    echo 0x17e30010 6 > $DCC_PATH/config
    echo 0x17e30030 6 > $DCC_PATH/config
    echo 0x17e30050 3 > $DCC_PATH/config
    echo 0x17e30170 2 > $DCC_PATH/config
    echo 0x17e30fb0 2 > $DCC_PATH/config
    echo 0x17e30fc8 14 > $DCC_PATH/config
    echo 0x17e80000 3 > $DCC_PATH/config
    echo 0x17e80010 6 > $DCC_PATH/config
    echo 0x17e80030 6 > $DCC_PATH/config
    echo 0x17e80050 3 > $DCC_PATH/config
    echo 0x17e80170 2 > $DCC_PATH/config
    echo 0x17e80fb0 2 > $DCC_PATH/config
    echo 0x17e80fc8 14 > $DCC_PATH/config
    echo 0x17f80000 3 > $DCC_PATH/config
    echo 0x17f80010 6 > $DCC_PATH/config
    echo 0x17f80030 6 > $DCC_PATH/config
    echo 0x17f80050 3 > $DCC_PATH/config
    echo 0x17f80170 2 > $DCC_PATH/config
    echo 0x17f80fb0 2 > $DCC_PATH/config
    echo 0x17f80fc8 14 > $DCC_PATH/config
    echo 0x18080000 3 > $DCC_PATH/config
    echo 0x18080010 6 > $DCC_PATH/config
    echo 0x18080030 6 > $DCC_PATH/config
    echo 0x18080050 3 > $DCC_PATH/config
    echo 0x18080170 2 > $DCC_PATH/config
    echo 0x18080fb0 2 > $DCC_PATH/config
    echo 0x18080fc8 14 > $DCC_PATH/config
    echo 0x18180000 3 > $DCC_PATH/config
    echo 0x18180010 6 > $DCC_PATH/config
    echo 0x18180030 6 > $DCC_PATH/config
    echo 0x18180050 3 > $DCC_PATH/config
    echo 0x18180170 2 > $DCC_PATH/config
    echo 0x18180fb0 2 > $DCC_PATH/config
    echo 0x18180fc8 14 > $DCC_PATH/config
    echo 0x18280000 3 > $DCC_PATH/config
    echo 0x18280010 6 > $DCC_PATH/config
    echo 0x18280030 6 > $DCC_PATH/config
    echo 0x18280050 3 > $DCC_PATH/config
    echo 0x18280170 2 > $DCC_PATH/config
    echo 0x18280fb0 2 > $DCC_PATH/config
    echo 0x18280fc8 14 > $DCC_PATH/config
    echo 0x18380000 3 > $DCC_PATH/config
    echo 0x18380010 6 > $DCC_PATH/config
    echo 0x18380030 6 > $DCC_PATH/config
    echo 0x18380050 3 > $DCC_PATH/config
    echo 0x18380170 2 > $DCC_PATH/config
    echo 0x18380fb0 2 > $DCC_PATH/config
    echo 0x18380fc8 14 > $DCC_PATH/config
    echo 0x18480000 3 > $DCC_PATH/config
    echo 0x18480010 6 > $DCC_PATH/config
    echo 0x18480030 6 > $DCC_PATH/config
    echo 0x18480050 3 > $DCC_PATH/config
    echo 0x18480170 2 > $DCC_PATH/config
    echo 0x18480fb0 2 > $DCC_PATH/config
    echo 0x18480fc8 14 > $DCC_PATH/config
    echo 0x18580000 3 > $DCC_PATH/config
    echo 0x18580010 6 > $DCC_PATH/config
    echo 0x18580030 6 > $DCC_PATH/config
    echo 0x18580050 3 > $DCC_PATH/config
    echo 0x18580170 2 > $DCC_PATH/config
    echo 0x18580fb0 2 > $DCC_PATH/config
    echo 0x18580fc8 14 > $DCC_PATH/config
    echo 0x17e90000 > $DCC_PATH/config
    echo 0x17e90008 > $DCC_PATH/config
    echo 0x17e90010 > $DCC_PATH/config
    echo 0x17e90018 > $DCC_PATH/config
    echo 0x17e90100 > $DCC_PATH/config
    echo 0x17e90108 > $DCC_PATH/config
    echo 0x17e90110 > $DCC_PATH/config
    echo 0x17e90400 4 > $DCC_PATH/config
    echo 0x17e90480 3 > $DCC_PATH/config
    echo 0x17e90c00 2 > $DCC_PATH/config
    echo 0x17e90c20 2 > $DCC_PATH/config
    echo 0x17e90ce0 > $DCC_PATH/config
    echo 0x17e90e00 3 > $DCC_PATH/config
    echo 0x17e90fa8 2 > $DCC_PATH/config
    echo 0x17e90fbc > $DCC_PATH/config
    echo 0x17e90fcc 2 > $DCC_PATH/config
    echo 0x17e90fe0 8 > $DCC_PATH/config
    echo 0x17eb0000 > $DCC_PATH/config
    echo 0x17eb0010 > $DCC_PATH/config
    echo 0x17f90000 > $DCC_PATH/config
    echo 0x17f90008 > $DCC_PATH/config
    echo 0x17f90010 > $DCC_PATH/config
    echo 0x17f90018 > $DCC_PATH/config
    echo 0x17f90100 > $DCC_PATH/config
    echo 0x17f90108 > $DCC_PATH/config
    echo 0x17f90110 > $DCC_PATH/config
    echo 0x17f90400 4 > $DCC_PATH/config
    echo 0x17f90480 3 > $DCC_PATH/config
    echo 0x17f90c00 2 > $DCC_PATH/config
    echo 0x17f90c20 2 > $DCC_PATH/config
    echo 0x17f90ce0 > $DCC_PATH/config
    echo 0x17f90e00 3 > $DCC_PATH/config
    echo 0x17f90fa8 2 > $DCC_PATH/config
    echo 0x17f90fbc > $DCC_PATH/config
    echo 0x17f90fcc 2 > $DCC_PATH/config
    echo 0x17f90fe0 8 > $DCC_PATH/config
    echo 0x17fb0000 > $DCC_PATH/config
    echo 0x17fb0010 > $DCC_PATH/config
    echo 0x18090000 > $DCC_PATH/config
    echo 0x18090008 > $DCC_PATH/config
    echo 0x18090010 > $DCC_PATH/config
    echo 0x18090018 > $DCC_PATH/config
    echo 0x18090100 > $DCC_PATH/config
    echo 0x18090108 > $DCC_PATH/config
    echo 0x18090110 > $DCC_PATH/config
    echo 0x18090400 4 > $DCC_PATH/config
    echo 0x18090480 3 > $DCC_PATH/config
    echo 0x18090c00 2 > $DCC_PATH/config
    echo 0x18090c20 2 > $DCC_PATH/config
    echo 0x18090ce0 > $DCC_PATH/config
    echo 0x18090e00 3 > $DCC_PATH/config
    echo 0x18090fa8 2 > $DCC_PATH/config
    echo 0x18090fbc > $DCC_PATH/config
    echo 0x18090fcc 2 > $DCC_PATH/config
    echo 0x18090fe0 8 > $DCC_PATH/config
    echo 0x180b0000 > $DCC_PATH/config
    echo 0x180b0010 > $DCC_PATH/config
    echo 0x18190000 > $DCC_PATH/config
    echo 0x18190008 > $DCC_PATH/config
    echo 0x18190010 > $DCC_PATH/config
    echo 0x18190018 > $DCC_PATH/config
    echo 0x18190100 > $DCC_PATH/config
    echo 0x18190108 > $DCC_PATH/config
    echo 0x18190110 > $DCC_PATH/config
    echo 0x18190400 4 > $DCC_PATH/config
    echo 0x18190480 3 > $DCC_PATH/config
    echo 0x18190c00 2 > $DCC_PATH/config
    echo 0x18190c20 2 > $DCC_PATH/config
    echo 0x18190ce0 > $DCC_PATH/config
    echo 0x18190e00 3 > $DCC_PATH/config
    echo 0x18190fa8 2 > $DCC_PATH/config
    echo 0x18190fbc > $DCC_PATH/config
    echo 0x18190fcc 2 > $DCC_PATH/config
    echo 0x18190fe0 8 > $DCC_PATH/config
    echo 0x181b0000 > $DCC_PATH/config
    echo 0x181b0010 > $DCC_PATH/config
    echo 0x18290000 > $DCC_PATH/config
    echo 0x18290008 > $DCC_PATH/config
    echo 0x18290010 > $DCC_PATH/config
    echo 0x18290018 > $DCC_PATH/config
    echo 0x18290100 > $DCC_PATH/config
    echo 0x18290108 > $DCC_PATH/config
    echo 0x18290110 > $DCC_PATH/config
    echo 0x18290400 4 > $DCC_PATH/config
    echo 0x18290480 4 > $DCC_PATH/config
    echo 0x18290c00 2 > $DCC_PATH/config
    echo 0x18290c20 2 > $DCC_PATH/config
    echo 0x18290ce0 > $DCC_PATH/config
    echo 0x18290e00 3 > $DCC_PATH/config
    echo 0x18290fa8 2 > $DCC_PATH/config
    echo 0x18290fbc > $DCC_PATH/config
    echo 0x18290fcc 2 > $DCC_PATH/config
    echo 0x18290fe0 8 > $DCC_PATH/config
    echo 0x18390000 > $DCC_PATH/config
    echo 0x18390008 > $DCC_PATH/config
    echo 0x18390010 > $DCC_PATH/config
    echo 0x18390018 > $DCC_PATH/config
    echo 0x18390100 > $DCC_PATH/config
    echo 0x18390108 > $DCC_PATH/config
    echo 0x18390110 > $DCC_PATH/config
    echo 0x18390400 4 > $DCC_PATH/config
    echo 0x18390480 4 > $DCC_PATH/config
    echo 0x18390c00 2 > $DCC_PATH/config
    echo 0x18390c20 2 > $DCC_PATH/config
    echo 0x18390ce0 > $DCC_PATH/config
    echo 0x18390e00 3 > $DCC_PATH/config
    echo 0x18390fa8 2 > $DCC_PATH/config
    echo 0x18390fbc > $DCC_PATH/config
    echo 0x18390fcc 2 > $DCC_PATH/config
    echo 0x18390fe0 8 > $DCC_PATH/config
    echo 0x18490000 > $DCC_PATH/config
    echo 0x18490008 > $DCC_PATH/config
    echo 0x18490010 > $DCC_PATH/config
    echo 0x18490018 > $DCC_PATH/config
    echo 0x18490100 > $DCC_PATH/config
    echo 0x18490108 > $DCC_PATH/config
    echo 0x18490110 > $DCC_PATH/config
    echo 0x18490400 4 > $DCC_PATH/config
    echo 0x18490480 4 > $DCC_PATH/config
    echo 0x18490c00 2 > $DCC_PATH/config
    echo 0x18490c20 2 > $DCC_PATH/config
    echo 0x18490ce0 > $DCC_PATH/config
    echo 0x18490e00 3 > $DCC_PATH/config
    echo 0x18490fa8 2 > $DCC_PATH/config
    echo 0x18490fbc > $DCC_PATH/config
    echo 0x18490fcc 2 > $DCC_PATH/config
    echo 0x18490fe0 8 > $DCC_PATH/config
    echo 0x18590000 > $DCC_PATH/config
    echo 0x18590008 > $DCC_PATH/config
    echo 0x18590010 > $DCC_PATH/config
    echo 0x18590018 > $DCC_PATH/config
    echo 0x18590100 > $DCC_PATH/config
    echo 0x18590108 > $DCC_PATH/config
    echo 0x18590110 > $DCC_PATH/config
    echo 0x18590400 4 > $DCC_PATH/config
    echo 0x18590480 4 > $DCC_PATH/config
    echo 0x18590c00 2 > $DCC_PATH/config
    echo 0x18590c20 2 > $DCC_PATH/config
    echo 0x18590ce0 > $DCC_PATH/config
    echo 0x18590e00 3 > $DCC_PATH/config
    echo 0x18590fa8 2 > $DCC_PATH/config
    echo 0x18590fbc > $DCC_PATH/config
    echo 0x18590fcc 2 > $DCC_PATH/config
    echo 0x18590fe0 8 > $DCC_PATH/config
    echo 0x17a90000 23 > $DCC_PATH/config
    echo 0x17a90080 9 > $DCC_PATH/config
    echo 0x17a900ac 2 > $DCC_PATH/config
    echo 0x17a90100 > $DCC_PATH/config
    echo 0x17a92000 23 > $DCC_PATH/config
    echo 0x17a92080 9 > $DCC_PATH/config
    echo 0x17a920ac 2 > $DCC_PATH/config
    echo 0x17a92100 > $DCC_PATH/config
    echo 0x17a94000 23 > $DCC_PATH/config
    echo 0x17a94080 9 > $DCC_PATH/config
    echo 0x17a940ac 2 > $DCC_PATH/config
    echo 0x17a94100 > $DCC_PATH/config
    echo 0x17a96000 23 > $DCC_PATH/config
    echo 0x17a96080 9 > $DCC_PATH/config
    echo 0x17a960ac 2 > $DCC_PATH/config
}

config_spmi()
{
    echo 0xc42f000 > $DCC_PATH/config
    echo 0xc42c02c > $DCC_PATH/config
    echo 0xc42e804 > $DCC_PATH/config
    echo 0xc42e85c > $DCC_PATH/config
    echo 0xc2a8174 6 > $DCC_PATH/config
}

config_cbcr()
{
    echo 0x193008 > $DCC_PATH/config
    echo 0x193140 > $DCC_PATH/config
    echo 0x193004 > $DCC_PATH/config
    echo 0x120024 > $DCC_PATH/config
    echo 0x12C018 > $DCC_PATH/config
    echo 0x12C020 > $DCC_PATH/config
    echo 0x12C028 > $DCC_PATH/config
    echo 0x12C030 > $DCC_PATH/config
    echo 0x12C038 > $DCC_PATH/config
    echo 0x12C040 > $DCC_PATH/config
    echo 0x157008 > $DCC_PATH/config
    echo 0x17B090 > $DCC_PATH/config
    echo 0x1A0004 > $DCC_PATH/config
    echo 0x1A000C > $DCC_PATH/config
    echo 0x1A0014 > $DCC_PATH/config
    echo 0x1A9014 > $DCC_PATH/config
    echo 0x1A901C > $DCC_PATH/config
}

config_apps_smmu()
{
    echo 0x15000800 159 > $DCC_PATH/config
    echo 0x15000C00 159 > $DCC_PATH/config
    echo 0x15001000 95 > $DCC_PATH/config
    echo 0x15002670 > $DCC_PATH/config
    echo 0x15002204 > $DCC_PATH/config
    echo 0x150025DC > $DCC_PATH/config
    echo 0x15002648 > $DCC_PATH/config
    echo 0x151CC010 > $DCC_PATH/config
    echo 0x151D0810 > $DCC_PATH/config
    echo 0x151D0818 > $DCC_PATH/config
    echo 0x151D0820 > $DCC_PATH/config
    echo 0x151D0828 > $DCC_PATH/config
    echo 0x151D0860 > $DCC_PATH/config
    echo 0x151D0868 > $DCC_PATH/config
    echo 0x151D0870 > $DCC_PATH/config
    echo 0x151D0878 > $DCC_PATH/config
    echo 0x151D0880 > $DCC_PATH/config
    echo 0x151D0888 > $DCC_PATH/config
    echo 0x151D0890 > $DCC_PATH/config
    echo 0x151D5810 > $DCC_PATH/config
    echo 0x151D5818 > $DCC_PATH/config
    echo 0x151D5820 > $DCC_PATH/config
    echo 0x151D5828 > $DCC_PATH/config
    echo 0x151D5860 > $DCC_PATH/config
    echo 0x151D5868 > $DCC_PATH/config
    echo 0x151D5870 > $DCC_PATH/config
    echo 0x151D5878 > $DCC_PATH/config
    echo 0x151D5880 > $DCC_PATH/config
    echo 0x151D5888 > $DCC_PATH/config
    echo 0x151D5890 > $DCC_PATH/config
}

enable_dcc()
{
    #TODO: Add DCC configuration

    DCC_PATH="/sys/bus/platform/devices/100ff000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 6 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_dcc_tsens
    #config_apss_pwr_state
    config_dcc_core
    #config_smmu

    gemnoc_dump
    config_gpu
    config_dcc_ddr
    config_adsp
    config_core_hung
    config_dcc_pcie

    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    dc_noc_dump
    lpass_ag_noc_dump
    lpass_qdsp_dump
    mmss_noc_dump
    system_noc_dump
    aggre_noc_dump
    config_noc_dump

    config_dcc_gic
    config_dcc_rpmh
    config_dcc_apss_rscc
    config_dcc_misc
    config_dcc_gict
    config_cabo
    config_cb
    config_turing
    config_lpass
    config_modem
    config_wpss
    config_tme
    config_cam
    config_spmi
    config_cbcr
    config_apps_smmu

    #config_confignoc
    #enable_dcc_pll_status


    echo  1 > $DCC_PATH/enable
}

##################################
# ACTPM trace API - usage example
##################################

actpm_traces_configure()
{
  echo ++++++++++++++++++++++++++++++++++++++
  echo actpm_traces_configure
  echo ++++++++++++++++++++++++++++++++++++++

  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/reset
  ### CMB_MSR : [10]: debug_en, [7:6] : 0x0-0x3 : clkdom0-clkdom3 debug_bus
  ###         : [5]: trace_en, [4]: 0b0:continuous mode 0b1 : legacy mode
  ###         : [3:0] : legacy mode : 0x0 : combined_traces 0x1-0x4 : clkdom0-clkdom3
  echo 0 0x420 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_msr
  echo 0 > /sys/bus/coresight/devices/coresight-tpdm-actpm/mcmb_lanes_select
  echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_mode
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_ts_all
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_ts
  echo 0 0x20000000 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_mask
  echo 0 0x20000000 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_val

}

actpm_traces_start()
{
  echo ++++++++++++++++++++++++++++++++++++++
  echo actpm_traces_start
  echo ++++++++++++++++++++++++++++++++++++++
  # "Start actpm Trace collection "
  echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-actpm/enable_datasets
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/enable_source
}

stm_traces_configure()
{
  echo ++++++++++++++++++++++++++++++++++++++
  echo stm_traces_configure
  echo ++++++++++++++++++++++++++++++++++++++
  echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
}

stm_traces_start()
{
  echo ++++++++++++++++++++++++++++++++++++++
  echo stm_traces_start
  echo ++++++++++++++++++++++++++++++++++++++
  echo 1 > /sys/bus/coresight/devices/coresight-stm/enable_source
}

ipm_traces_configure()
{
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/reset
  echo 0x0 0x3f 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
  echo 0x0 0x3f 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
  #gic HW events
  echo 0xfb 0xfc 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl_mask
  echo 0xfb 0xfc 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_edge_ctrl
  echo 0 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 1 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 2 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 3 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 4 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 5 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 6 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 7 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_msr
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_ts
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_type
  echo 0 > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_trig_ts
  echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask
  echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss/dsb_patt_mask

  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/reset
  echo 0x0 0x2 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_edge_ctrl_mask
  echo 0x0 0x2 0 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_edge_ctrl
  echo 0x8a 0x8b 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_edge_ctrl_mask
  echo 0x8a 0x8b 0 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_edge_ctrl
  echo 0xb8 0xca 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_edge_ctrl_mask
  echo 0xb8 0xca 0 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_edge_ctrl
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_ts
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_type
  echo 0 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_trig_ts
  echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask
  echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/dsb_patt_mask

}

ipm_traces_start()
{
  # "Start ipm Trace collection "
  echo 2 > /sys/bus/coresight/devices/coresight-tpdm-apss/enable_datasets
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss/enable_source
  echo 2 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/enable_datasets
  echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-llm/enable_source

}

enable_cpuss_hw_events()
{
    actpm_traces_configure
    ipm_traces_configure
    stm_traces_configure

    ipm_traces_start
    stm_traces_start
    actpm_traces_start
}

enable_core_hang_config()
{
    CORE_PATH="/sys/devices/system/cpu/hang_detect_core"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to max
    echo 0xffffffff > $CORE_PATH/threshold

    #To enable core hang detection
    #It's a boolean variable. Do not use Hex value to enable/disable
    echo 1 > $CORE_PATH/enable
}

adjust_permission()
{
    #add permission for block_size, mem_type, mem_size nodes to collect diag over QDSS by ODL
    #application by "oem_2902" group
    chown -h root.oem_2902 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/block_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/block_size
    chown -h root.oem_2902 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/buffer_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/buffer_size
}

enable_schedstats()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    if [ -f /proc/sys/kernel/sched_schedstats ]
    then
        echo 1 > /proc/sys/kernel/sched_schedstats
    fi
}

enable_cpuss_register()
{
    MEM_DUMP_PATH="/sys/bus/platform/devices/soc:mem_dump"
    echo 1 > $MEM_DUMP_PATH/register_reset

    format_ver=1
    if [ -r $MEM_DUMP_PATH/format_version ]; then
        format_ver=$(cat $MEM_DUMP_PATH/format_version)
    fi

    echo 0x17000000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17000008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17000054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x170000f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17000100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17008000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17100000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17100020 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17100030 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17100084 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100184 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100204 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100284 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100304 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100384 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100420 0x3a0 > $MEM_DUMP_PATH/register_config
    echo 0x17100c08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0x17100d04 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17100e08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0x17106100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171061f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171062f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171063f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171064f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171065f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171066f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171067f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171068f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171069f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106e98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ea0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ea8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106eb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106eb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ec0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ec8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ed0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ed8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ee0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ee8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ef0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ef8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106f98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fe0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106fe8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ff0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17106ff8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171070f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171071f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171072f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171073f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171074f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171075f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171076f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171077f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171078f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171079f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17107df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710e008 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0x1710e104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x1710e184 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x1710e204 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x1710ea00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ea70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710f000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1710ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17110008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17110fcc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1711ffd0 0x34 > $MEM_DUMP_PATH/register_config
    echo 0x17120008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171200e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171201e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171202e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171203e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171204e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171205e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17120698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171206e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1712e000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1712e800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1712e808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1712ffbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1712ffc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1712ffd0 0x44 > $MEM_DUMP_PATH/register_config
    echo 0x17130400 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17130600 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17130a00 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17130c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130e00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17130e50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17130fb8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17130fcc 0x34 > $MEM_DUMP_PATH/register_config
    echo 0x17140000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17140010 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17140020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17140110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1714c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1714c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1714c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1714f000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1714ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17180000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17180014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17180070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17180078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171800c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1718ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17190080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17190c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17190d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17190e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1719c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1719c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1719c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1719c018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1719c100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1719c180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1719f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1719f010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171a0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171a0078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171a0088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171a0120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171ac000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171ac100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171ae100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171c0000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x171c0014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x171c0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171c0078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171c00c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171cffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x171d0080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x171d0c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x171d0d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171d0e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171dc000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171dc008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171dc010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171dc018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171dc100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171dc180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171df000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x171df010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171e0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171e0078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171e0088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171e0120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171ec000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171ec100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x171ee100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17200000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17200014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17200070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17200078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172000c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1720ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17210080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17210c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17210d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17210e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1721c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1721c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1721c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1721c018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1721c100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1721c180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1721f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1721f010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17220070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17220078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17220088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17220120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1722c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1722c100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1722e100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17240000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17240014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17240070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17240078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172400c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1724ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17250080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17250c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17250d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17250e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1725c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1725c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1725c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1725c018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1725c100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1725c180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1725f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1725f010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17260070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17260078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17260088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17260120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1726c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1726c100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1726e100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17280000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17280014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17280070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17280078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172800c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1728ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17290080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17290c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17290d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17290e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1729c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1729c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1729c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1729c018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1729c100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1729c180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1729f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1729f010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172a0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172a0078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172a0088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172a0120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172ac000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172ac100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172ae100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172c0000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x172c0014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x172c0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172c0078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172c00c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172cffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x172d0080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x172d0c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x172d0d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172d0e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172dc000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172dc008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172dc010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172dc018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172dc100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172dc180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172df000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x172df010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172e0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172e0078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172e0088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172e0120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172ec000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172ec100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x172ee100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17300000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17300014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17300070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17300078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173000c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1730ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17310080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17310c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17310d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17310e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1731c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1731c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1731c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1731c018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1731c100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1731c180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1731f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1731f010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17320070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17320078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17320088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17320120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1732c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1732c100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1732e100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17340000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17340014 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17340070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17340078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173400c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1734ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17350080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350400 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17350c00 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17350d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17350e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1735c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1735c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1735c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1735c018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1735c100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1735c180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1735f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1735f010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17360070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17360078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17360088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17360120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1736c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1736c100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1736e100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17380000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17380020 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17380030 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17380084 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380184 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380204 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380284 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380304 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380384 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380420 0x3a0 > $MEM_DUMP_PATH/register_config
    echo 0x17380c08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0x17380d04 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x17380e08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0x17386100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173861f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173862f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173863f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173864f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173865f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173866f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173867f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173868f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173869f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386e98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ea0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ea8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386eb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386eb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ec0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ec8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ed0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ed8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ee0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ee8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ef0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ef8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386f98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fe0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386fe8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ff0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17386ff8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173870f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173871f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173872f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173873f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173874f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173875f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173876f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173877f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173878f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x173879f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17387df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738e008 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0x1738e104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x1738e184 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x1738e204 0x74 > $MEM_DUMP_PATH/register_config
    echo 0x1738ea00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ea70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738f000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1738ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17400004 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17400038 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17400044 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x174000f0 0x84 > $MEM_DUMP_PATH/register_config
    echo 0x17400200 0x84 > $MEM_DUMP_PATH/register_config
    echo 0x17400438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17400444 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17410000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1741000c 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17410020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17411000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1741100c 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17411020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17420000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17420040 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17420080 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x17420fc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17420fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17420fe0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17420ff0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17421000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17421fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17422000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17422020 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17422fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17423000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17423fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17425000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17425fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17426000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17426020 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17426fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17427000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17427fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17429000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17429fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1742b000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x1742bfd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1742d000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x1742dfd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17600004 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17600010 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17600024 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17600034 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17600040 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600050 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17600070 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17600094 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176000a8 0x2c > $MEM_DUMP_PATH/register_config
    echo 0x176000d8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x17600118 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17600134 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17600148 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17600160 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17600170 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17600180 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17600210 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600234 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600240 0x2c > $MEM_DUMP_PATH/register_config
    echo 0x176002b4 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600404 0xc > $MEM_DUMP_PATH/register_config
    echo 0x1760041c 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17600434 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1760043c 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600460 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600470 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600480 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17600490 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176004a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176004b0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176004c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176004d0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176004e0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176004f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17600500 0x34 > $MEM_DUMP_PATH/register_config
    echo 0x176009fc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17601000 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17602000 0x104 > $MEM_DUMP_PATH/register_config
    echo 0x17603000 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17604000 0x104 > $MEM_DUMP_PATH/register_config
    echo 0x17605000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17606000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17607000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17608004 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17608020 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1760f000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17610000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17610010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17610020 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17611000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17611010 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17612000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17612100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17612208 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17612304 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17612500 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17613000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761300c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613014 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613040 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761304c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613054 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613080 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761308c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613094 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176130b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176130c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176130cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176130d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176130f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761310c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613114 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613140 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761314c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613154 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613180 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761318c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613194 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176131b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176131c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176131cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176131d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176131f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761320c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613214 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613240 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761324c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613254 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613280 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761328c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613294 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176132b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176132c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176132cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176132d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176132f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613300 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761330c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613314 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613340 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761334c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613354 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613380 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761338c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613394 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176133b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176133c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176133cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176133d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176133f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613400 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761340c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613414 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613440 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761344c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613454 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613480 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761348c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613494 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176134b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176134c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176134cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176134d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176134f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613500 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761350c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613514 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613540 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761354c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613554 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613580 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761358c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613594 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176135b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176135c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176135cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176135d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176135f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613600 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761360c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613614 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613640 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761364c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613654 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613680 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761368c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613694 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176136b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176136c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176136cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176136d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176136f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613700 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761370c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613714 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613740 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761374c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613754 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17613770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613780 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x1761378c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17613794 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176137b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176137c0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x176137cc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x176137d4 0xc > $MEM_DUMP_PATH/register_config
    echo 0x176137f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17800000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17800008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17800054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178000f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17800100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17810000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17810008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17810054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178100f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17810100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17820000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17820008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17820054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178200f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17820100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17830000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17830008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17830054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178300f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17830100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17840000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17840008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17840054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178400f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17840100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17848000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17850000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17850008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17850054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178500f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17850100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17858000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17860000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17860008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17860054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178600f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17860100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17868000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17870000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17870008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17870054 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x178700f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17870100 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17878000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17880000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17880008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17880068 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x178800f0 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17888000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17890000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17890008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x17890068 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x178900f0 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17898000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x178a0000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178a0008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x178a0054 0x34 > $MEM_DUMP_PATH/register_config
    echo 0x178a0090 0x1d0 > $MEM_DUMP_PATH/register_config
    echo 0x178c0000 0x248 > $MEM_DUMP_PATH/register_config
    echo 0x178c8000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c80f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178c8118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178cc000 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x178cc030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x178cc040 0x48 > $MEM_DUMP_PATH/register_config
    echo 0x178cc090 0x88 > $MEM_DUMP_PATH/register_config
    echo 0x17900000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1790000c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17900040 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17900900 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17900c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17900c0c 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17900c40 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17900fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17901000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x1790100c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17901040 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17901900 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17901c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17901c0c 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17901c40 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17901fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a00000 0xd4 > $MEM_DUMP_PATH/register_config
    echo 0x17a000d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a00100 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a00200 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17a00224 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00244 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00264 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00284 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a002a4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a002c4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a002e4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00400 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a00450 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17a00490 0x2c > $MEM_DUMP_PATH/register_config
    echo 0x17a00500 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00600 0x200 > $MEM_DUMP_PATH/register_config
    echo 0x17a00d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a00d10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00d30 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a00fb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a00fd0 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a01250 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a01270 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a014f0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a01510 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a03d44 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a03d4c 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a10000 0x4c > $MEM_DUMP_PATH/register_config
    echo 0x17a10050 0x84 > $MEM_DUMP_PATH/register_config
    echo 0x17a100d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a10100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a10108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a10204 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10224 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10244 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10264 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10284 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a102a4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a102c4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a102e4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10400 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a10450 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17a104a0 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17a10500 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10600 0x200 > $MEM_DUMP_PATH/register_config
    echo 0x17a10d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a10d10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10d30 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a10fb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a10fd0 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a11250 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a11270 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a114f0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a11510 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a13d44 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a13d4c 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a13e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a20000 0x4c > $MEM_DUMP_PATH/register_config
    echo 0x17a20050 0x84 > $MEM_DUMP_PATH/register_config
    echo 0x17a200d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a20100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a20108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a20204 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20224 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20244 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20264 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20284 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a202a4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a202c4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a202e4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20400 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a20450 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17a204a0 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17a20500 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20600 0x200 > $MEM_DUMP_PATH/register_config
    echo 0x17a20d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a20d10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20d30 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a20fb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a20fd0 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a21250 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a21270 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a214f0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a21510 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a21790 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a217b0 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a21a30 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a21a50 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a21cd0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a21cf0 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a21f70 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a21f90 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a23d44 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a23d4c 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a23e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a30000 0x4c > $MEM_DUMP_PATH/register_config
    echo 0x17a30050 0x84 > $MEM_DUMP_PATH/register_config
    echo 0x17a300d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a30100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a30108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a30204 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30224 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30244 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30264 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30284 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a302a4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a302c4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a302e4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30400 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a30450 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17a304a0 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17a30500 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30600 0x200 > $MEM_DUMP_PATH/register_config
    echo 0x17a30d00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a30d10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30d30 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a30fb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a30fd0 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a31250 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17a31270 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17a33d44 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a33d4c 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a33e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17a80000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17a82000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17a84000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17a86000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17a8c000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17a8e000 0x400 > $MEM_DUMP_PATH/register_config
    echo 0x17a90000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0x17a90080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17a900ac 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a90100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a92000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0x17a92080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17a920ac 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a92100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a94000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0x17a94080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17a940ac 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a94100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17a96000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0x17a96080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17a960ac 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17a96100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17aa0000 0xb0 > $MEM_DUMP_PATH/register_config
    echo 0x17aa00fc 0x50 > $MEM_DUMP_PATH/register_config
    echo 0x17aa0200 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17aa0300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17aa0400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17aa0500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17aa0600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17aa0700 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17b00000 0x118 > $MEM_DUMP_PATH/register_config
    echo 0x17b70000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b70010 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b70090 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17b70100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70110 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b70190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b701a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b70220 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b702a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b70320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70390 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70420 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b704a0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70520 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b70580 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b70600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70610 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70690 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70710 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70790 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70810 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70890 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70910 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70990 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70a10 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70a90 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70b10 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70b90 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70c10 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70c90 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70d10 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70d90 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b70e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b70e10 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17b70e90 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17b70f10 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17b70f90 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17b71010 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17b71090 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17b71100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b71110 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71190 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71210 0x200 > $MEM_DUMP_PATH/register_config
    echo 0x17b71a10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71a90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71b00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b71b10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71b90 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17b71bb0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71c30 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b71c40 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b71cc0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b71d00 0x2c > $MEM_DUMP_PATH/register_config
    echo 0x17b78000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b78010 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b78090 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17b78100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78110 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b78190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b781a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b78220 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b782a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b78320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78390 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b78410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78420 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b784a0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b78520 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b78580 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b78600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78610 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78690 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78710 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78790 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78810 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78890 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78910 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78990 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78a10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78a90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78b10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78b90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78c10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78c90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78d10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78d90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b78e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b78e10 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b78e90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b78f10 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b78f90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b79010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b79090 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b79100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b79110 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79190 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79210 0x100 > $MEM_DUMP_PATH/register_config
    echo 0x17b79a10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79a90 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79b00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b79b10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79b90 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17b79bb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79c30 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b79c40 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79cc0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17b79d00 0x2c > $MEM_DUMP_PATH/register_config
    echo 0x17b90000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b90020 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17b90050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b90070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b90080 0x64 > $MEM_DUMP_PATH/register_config
    echo 0x17b90100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b90120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b90140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b90200 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17b90700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17b9070c 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b90780 0x80 > $MEM_DUMP_PATH/register_config
    echo 0x17b90808 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b90824 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b90840 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17b90c48 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17b90c64 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b90c80 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17b93500 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17b93a80 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b93aa8 0xc8 > $MEM_DUMP_PATH/register_config
    echo 0x17b93c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b93c20 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17b93c30 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17b93c60 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17b93c70 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0020 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17ba0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17ba0080 0x64 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17ba0120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17ba0140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17ba0200 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17ba070c 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17ba0780 0x80 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0808 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0824 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17ba0840 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0c48 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17ba0c64 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17ba0c80 0x40 > $MEM_DUMP_PATH/register_config
    echo 0x17ba3500 0x140 > $MEM_DUMP_PATH/register_config
    echo 0x17ba3a80 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17ba3aa8 0xc8 > $MEM_DUMP_PATH/register_config
    echo 0x17ba3c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17ba3c20 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17ba3c30 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17ba3c60 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17ba3c70 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17c000e8 0x104 > $MEM_DUMP_PATH/register_config
    echo 0x17c01000 0x1d8 > $MEM_DUMP_PATH/register_config
    echo 0x17c20000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17c21000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17d80000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17d80010 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d80100 0x400 > $MEM_DUMP_PATH/register_config
    echo 0x17d90000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17d90014 0x68 > $MEM_DUMP_PATH/register_config
    echo 0x17d90080 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d900b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d900b8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d900d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17d90100 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d90200 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d90300 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d90320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d9034c 0x7c > $MEM_DUMP_PATH/register_config
    echo 0x17d903e0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d90404 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d91000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17d91014 0x68 > $MEM_DUMP_PATH/register_config
    echo 0x17d91080 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17d910b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d910b8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d910d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17d91100 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d91200 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d91300 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d91320 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17d9134c 0x8c > $MEM_DUMP_PATH/register_config
    echo 0x17d913e0 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d91404 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d92000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17d92014 0x68 > $MEM_DUMP_PATH/register_config
    echo 0x17d92080 0x1c > $MEM_DUMP_PATH/register_config
    echo 0x17d920b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d920b8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d920d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17d92100 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d92200 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d92300 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d92320 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17d9234c 0x88 > $MEM_DUMP_PATH/register_config
    echo 0x17d923e0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17d92404 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d93000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17d93014 0x68 > $MEM_DUMP_PATH/register_config
    echo 0x17d93080 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d930b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d930b8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d930d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0x17d93100 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d93200 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0x17d93300 0x14 > $MEM_DUMP_PATH/register_config
    echo 0x17d93320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d9334c 0x80 > $MEM_DUMP_PATH/register_config
    echo 0x17d933e0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17d93404 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17d98000 0x28 > $MEM_DUMP_PATH/register_config
    echo 0x17e00000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e00060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e100f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e100f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e100f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e100f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e10100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e11000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e11000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20e10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20fa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20fc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e20fd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0x17e30000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17e30010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17e30030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17e30050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17e30170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e30fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e30fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x17e80000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17e80010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17e80030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17e80050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17e80170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e80fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e80fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x17e90000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17e90480 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17e90c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e90c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e90ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17e90fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e90fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17e90fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17e90fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17eb0000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17eb0010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f80000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17f80010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17f80030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x17f80050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17f80170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17f80fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17f80fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x17f90000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x17f90480 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17f90c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17f90c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17f90ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x17f90fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17f90fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17f90fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x17f90fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17fb0000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x17fb0010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18080000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18080010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18080030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18080050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18080170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18080fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18080fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x18090000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18090480 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18090c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18090c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18090ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18090fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18090fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18090fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18090fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x180b0000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x180b0010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18180000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18180010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18180030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18180050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18180170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18180fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18180fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x18190000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18190480 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18190c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18190c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18190ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18190fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18190fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18190fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18190fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x181b0000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x181b0010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18280000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18280010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18280030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18280050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18280170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18280fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18280fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x18290000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18290480 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18290c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18290c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18290ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18290fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18290fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18290fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18290fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x18380000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18380010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18380030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18380050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18380170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18380fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18380fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x18390000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18390480 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18390c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18390c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18390ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18390fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18390fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18390fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18390fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x18480000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18480010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18480030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18480050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18480170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18480fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18480fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x18490000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18490480 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18490c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18490c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18490ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18490fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18490fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18490fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18490fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x18580000 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18580010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18580030 0x18 > $MEM_DUMP_PATH/register_config
    echo 0x18580050 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18580170 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18580fb0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18580fc8 0x38 > $MEM_DUMP_PATH/register_config
    echo 0x18590000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590400 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18590480 0x10 > $MEM_DUMP_PATH/register_config
    echo 0x18590c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18590c20 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18590ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590e00 0xc > $MEM_DUMP_PATH/register_config
    echo 0x18590fa8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18590fbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0x18590fcc 0x8 > $MEM_DUMP_PATH/register_config
    echo 0x18590fe0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0x17D00000 0x10000 > $MEM_DUMP_PATH/register_config
}

create_stp_policy()
{
    mkdir /config/stp-policy/coresight-stm:p_ost.policy
    chmod 660 /config/stp-policy/coresight-stm:p_ost.policy
    mkdir /config/stp-policy/coresight-stm:p_ost.policy/default
    chmod 660 /config/stp-policy/coresight-stm:p_ost.policy/default
    echo 0x10 > /sys/bus/coresight/devices/coresight-stm/traceid
}

#function to enable cti flush for etf
enable_cti_flush_for_etf()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    echo 1 >/sys/bus/coresight/devices/coresight-cti-swao_cti/enable
    echo 0 24 >/sys/bus/coresight/devices/coresight-cti-swao_cti/channels/trigin_attach
    echo 0 1 >/sys/bus/coresight/devices/coresight-cti-swao_cti/channels/trigout_attach
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
coresight_config=`getprop persist.debug.coresight.config`
tracefs=/sys/kernel/tracing
srcenable="enable"
enable_debug()
{
    echo "taro debug"
    etr_size="0x2000000"
    srcenable="enable_source"
    sinkenable="enable_sink"
    create_stp_policy
    echo "Enabling STM events on taro."
    adjust_permission
    enable_stm_events
    enable_cti_flush_for_etf
    #enable_lpm_with_dcvs_tracing
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing
    fi
    # removing core hang config from postboot as core hang detection is enabled from sysini
    # enable_core_hang_config
    enable_dcc
    enable_cpuss_hw_events
    enable_schedstats
    setprop ro.dbg.coresight.stm_cfg_done 1
    enable_cpuss_register
    enable_memory_debug
    if [ -d $tracefs ] && [ "$(getprop persist.vendor.tracing.enabled)" -eq "1" ]; then
        mkdir $tracefs/instances/hsuart
        #UART
        echo 800 > $tracefs/instances/hsuart/buffer_size_kb
        echo 1 > $tracefs/instances/hsuart/events/serial/enable
        echo 1 > $tracefs/instances/hsuart/tracing_on

        #SPI
        mkdir $tracefs/instances/spi_qup
        echo 1 > $tracefs/instances/spi_qup/events/qup_spi_trace/enable
        echo 1 > $tracefs/instances/spi_qup/tracing_on

        #I2C
        mkdir $tracefs/instances/i2c_qup
        echo 1 > $tracefs/instances/i2c_qup/events/qup_i2c_trace/enable
        echo 1 > $tracefs/instances/i2c_qup/tracing_on

        #GENI_COMMON
        mkdir $tracefs/instances/qupv3_common
        echo 1 > $tracefs/instances/qupv3_common/events/qup_common_trace/enable
        echo 1 > $tracefs/instances/qupv3_common/tracing_on

        #SLIMBUS
        mkdir $tracefs/instances/slimbus
        echo 1 > $tracefs/instances/slimbus/events/slimbus/slimbus_dbg/enable
        echo 1 > $tracefs/instances/slimbus/tracing_on
    fi
}



enable_debug
