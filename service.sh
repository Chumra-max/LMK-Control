#!/system/bin/sh

MODDIR=${0%/*}

sleep 5

TOTAL_RAM_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))

log -p i -t HyperOS-LMK "Detected RAM: ${TOTAL_RAM_GB}GB"

if [ "$TOTAL_RAM_GB" -le 4 ]; then
    log -p i -t HyperOS-LMK "Applying 4GB configuration"
    chmod 755 "$MODDIR/4gb.sh"
    sh "$MODDIR/4gb.sh"

elif [ "$TOTAL_RAM_GB" -le 6 ]; then
    log -p i -t HyperOS-LMK "Applying 6GB configuration"
    chmod 755 "$MODDIR/6gb.sh"
    sh "$MODDIR/6gb.sh"

else
    log -p i -t HyperOS-LMK "Applying 8GB configuration"
    chmod 755 "$MODDIR/8gb.sh"
    sh "$MODDIR/8gb.sh"
fi

CONFIG="$MODDIR/config.txt"
LOGTAG="HyperOS-Mod"

log -p i -t "$LOGTAG" "service.sh started"

# Make sure config exists
if [ ! -f "$CONFIG" ]; then
  log -p e -t "$LOGTAG" "config.txt not found, exiting"
  exit 0
fi

# Load config
. "$CONFIG"

log -p i -t "$LOGTAG" "Config loaded: log=$log zram=$zram ui=$ui"

####################################
# ZRAM RESIZING
####################################
if [ "$zram" = "1" ]; then
  log -p i -t "$LOGTAG" "ZRAM resizing enabled"

  # Wait for system zram init
  sleep 8

  TOTAL_RAM_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  TOTAL_RAM_BYTES=$((TOTAL_RAM_KB * 1024))
  ZRAM_SIZE_BYTES=$((TOTAL_RAM_BYTES * 3 / 4))

  log -p i -t "$LOGTAG" "Detected RAM: $((TOTAL_RAM_BYTES / 1024 / 1024))MB"
  log -p i -t "$LOGTAG" "Setting ZRAM size to $((ZRAM_SIZE_BYTES / 1024 / 1024))MB"

  swapoff /dev/block/zram0 2>/dev/null
  echo 1 > /sys/block/zram0/reset
  echo "$ZRAM_SIZE_BYTES" > /sys/block/zram0/disksize
  mkswap /dev/block/zram0
  swapon /dev/block/zram0

  log -p i -t "$LOGTAG" "ZRAM resizing applied"
else
  log -p i -t "$LOGTAG" "ZRAM resizing skipped"
fi

####################################
# UI SMOOTHNESS TWEAKS
####################################
if [ "$ui" = "1" ]; then
  log -p i -t "$LOGTAG" "Applying UI smoothness tweaks"

  # SurfaceFlinger / UI
  setprop persist.sys.sf.disable_blurs true
  setprop persist.sys.sf.native_mode 258
  setprop persist.sys.sf.enable_gl_backpressure 0
  setprop persist.sys.smart_gc.enable true
  setprop persist.sys.smartpower.display.enable true
  setprop persist.sys.sf.enable_transaction_tracing false
  setprop persist.sys.sf.enable_hwc_vds 1

  # ART
  setprop dalvik.vm.dex2oat-threads 6
  setprop dalvik.vm.heapgrowthlimit 512m
  setprop dalvik.vm.heapsize 1024m
  setprop dalvik.vm.useartservice true
  setprop dalvik.vm.usejit true
  setprop dalvik.vm.dexopt.secondary true
  setprop dalvik.vm.dex2oat-max-image-block-size 1048576

  # CPU / GPU
  setprop persist.sys.computility.cpulevel 4
  setprop persist.sys.computility.gpulevel 4
  setprop persist.sys.perf_turbo_type 19

  # Preload / scheduling
  setprop persist.sys.enable_miui_booster 1
  setprop persist.sys.precache.appstrs1 "ru.zdevs.zarchiver,com.android.settings,com.whatsapp,com.miui.securitycenter"
  setprop persist.sys.precache.enable true
  setprop persist.sys.precache.number 5
  setprop persist.sys.perf_scenario_recognition.enable true
  setprop persist.sys.turbosched.coreApp.enable true
  setprop persist.sys.turbosched.coreAppTop20.enable true
  setprop persist.sys.hyper_transition true

  log -p i -t "$LOGTAG" "UI smoothness tweaks applied"
else
  log -p i -t "$LOGTAG" "UI smoothness tweaks skipped"
fi

####################################
# LOGGING DISABLE
####################################
if [ "$log" = "1" ]; then
  log -p i -t "$LOGTAG" "Disabling system logging"

  resetprop persist.log.tag S
  setprop log.tag S

  resetprop persist.logd.size 65536
  resetprop persist.logd.size.main 65536
  resetprop persist.logd.size.system 65536
  resetprop persist.logd.size.crash 65536

  setprop debug.atrace.tags.enableflags 0
  setprop debug.sf.enable_transaction_tracing false
  setprop debug.hwui.skia_tracing_enabled false
  setprop debug.renderengine.skia_tracing_enabled false

  resetprop persist.device_config.runtime_native.metrics.write-to-statsd false
  resetprop persist.vendor.log.tel_log_ctrl 0
  resetprop persist.vendor.connsys.dynamic.dump 0

  # SHUT UP LOGTAGS
  resetprop -n persist.log.tag.misight S
  resetprop -n log.tag.AF::MmapTrack S
  resetprop -n log.tag.AF::OutputTrack S
  resetprop -n log.tag.AF::PatchRecord S
  resetprop -n log.tag.AF::PatchTrack S
  resetprop -n log.tag.AF::RecordHandle S
  resetprop -n log.tag.AF::RecordTrack S
  resetprop -n log.tag.AF::Track S
  resetprop -n log.tag.AF::TrackBase S
  resetprop -n log.tag.AF::TrackHandle S
  resetprop -n log.tag.APM::AudioCollections S
  resetprop -n log.tag.APM::AudioInputDescriptor S
  resetprop -n log.tag.APM::AudioOutputDescriptor S
  resetprop -n log.tag.APM::AudioPatch S
  resetprop -n log.tag.APM::AudioPolicyEngine S
  resetprop -n log.tag.APM::AudioPolicyEngine::Base S
  resetprop -n log.tag.APM::AudioPolicyEngine::Config S
  resetprop -n log.tag.APM::AudioPolicyEngine::ProductStrategy S
  resetprop -n log.tag.APM::AudioPolicyEngine::VolumeGroup S
  resetprop -n log.tag.APM::Devices S
  resetprop -n log.tag.APM::IOProfile S
  resetprop -n log.tag.APM::Serializer S
  resetprop -n log.tag.APM::VolumeCurve S
  resetprop -n log.tag.APM_AudioPolicyManager S
  resetprop -n log.tag.APM_ClientDescriptor S
  resetprop -n log.tag.AudioAttributes S
  resetprop -n log.tag.AudioEffect S
  resetprop -n log.tag.AudioFlinger S
  resetprop -n log.tag.AudioFlinger::DeviceEffectProxy S
  resetprop -n log.tag.AudioFlinger::DeviceEffectProxy::ProxyCallback S
  resetprop -n log.tag.AudioFlinger::EffectBase S
  resetprop -n log.tag.AudioFlinger::EffectChain S
  resetprop -n log.tag.AudioFlinger::EffectHandle S
  resetprop -n log.tag.AudioFlinger::EffectModule S
  resetprop -n log.tag.AudioFlingerImpl S
  resetprop -n log.tag.AudioFlinger_Threads S
  resetprop -n log.tag.AudioHwDevice S
  resetprop -n log.tag.AudioPolicy S
  resetprop -n log.tag.AudioPolicyEffects S
  resetprop -n log.tag.AudioPolicyIntefaceImpl S
  resetprop -n log.tag.AudioPolicyManagerImpl S
  resetprop -n log.tag.AudioPolicyService S
  resetprop -n log.tag.AudioProductStrategy S
  resetprop -n log.tag.AudioRecord S
  resetprop -n log.tag.AudioSystem S
  resetprop -n log.tag.AudioTrack S
  resetprop -n log.tag.AudioTrackImpl S
  resetprop -n log.tag.AudioTrackShared S
  resetprop -n log.tag.AudioVolumeGroup S
  resetprop -n log.tag.FastCapture S
  resetprop -n log.tag.FastMixer S
  resetprop -n log.tag.FastMixerState S
  resetprop -n log.tag.FastThread S
  resetprop -n log.tag.IAudioFlinger S
  resetprop -n log.tag.ToneGenerator S

  resetprop -n events.cpu false
  resetprop -n persist.sys.traceopt 0
  resetprop sys.wifitracing.started 0
  setprop wifi.supplicant_scan_interval 300

  log -p i -t "$LOGTAG" "Logging disabled"
else
  log -p i -t "$LOGTAG" "Logging tweaks skipped"
fi

log -p i -t "$LOGTAG" "service.sh completed"
exit 0



