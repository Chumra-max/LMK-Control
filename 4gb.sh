#!/system/bin/sh

resetprop ro.lmk.kill_timeout_ms 500
resetprop ro.lmk.psi_partial_stall_ms 60
resetprop ro.lmk.psi_complete_stall_ms 800
resetprop ro.lmk.thrashing_limit 80
resetprop ro.lmk.thrashing_limit_critical 180
setprop dalvik.vm.usap_pool_enabled true
setprop dalvik.vm.usap_pool_size_min 1
setprop dalvik.vm.usap_pool_size_max 3
setprop sys.lmk.minfree_levels 6144:0,8192:100,10240:200,12288:300,15360:600,18432:800

