#!/system/bin/sh

resetprop ro.lmk.kill_timeout_ms 1000
resetprop ro.lmk.psi_partial_stall_ms 120
resetprop ro.lmk.psi_complete_stall_ms 1200
resetprop ro.lmk.thrashing_limit 130
resetprop ro.lmk.thrashing_limit_critical 260
setprop dalvik.vm.usap_pool_enabled true
setprop dalvik.vm.usap_pool_size_min 3
setprop dalvik.vm.usap_pool_size_max 6
setprop sys.lmk.minfree_levels \
10240:0,12288:100,15360:200,18432:300,24576:600,32768:900