#!/system/bin/sh

resetprop ro.lmk.kill_timeout_ms 700
resetprop ro.lmk.psi_partial_stall_ms 80
resetprop ro.lmk.psi_complete_stall_ms 1000
resetprop ro.lmk.thrashing_limit 100
resetprop ro.lmk.thrashing_limit_critical 220
setprop dalvik.vm.usap_pool_enabled true
setprop dalvik.vm.usap_pool_size_min 2
setprop dalvik.vm.usap_pool_size_max 4
setprop sys.lmk.minfree_levels \
8192:0,10240:100,12288:200,15360:300,20480:600,24576:800