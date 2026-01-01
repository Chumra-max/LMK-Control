#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

CONFIG="$MODPATH/config.txt"

# Volume key selector
choose() {
  # Flush old key events
  getevent -qlc 1 >/dev/null 2>&1

  while true; do
    key=$(getevent -qlc 1 2>/dev/null | awk '{print $3}')
    case "$key" in
      KEY_VOLUMEUP)
        sleep 0.3
        return 0
        ;;
      KEY_VOLUMEDOWN)
        sleep 0.3
        return 1
        ;;
    esac
  done
}

ui_print " "
ui_print "HyperOS Background Control Module"
ui_print "--------------------------------"
ui_print " "

# Reset config
> "$CONFIG"

# 1️⃣ Disable logging (FIRST)
ui_print "Disable system logging?"
ui_print "Vol + = Yes"
ui_print "Vol - = No"

if choose; then
  ui_print "✓ Logging tweaks enabled"
  echo "log=1" >> "$CONFIG"
else
  ui_print "✗ Logging tweaks skipped"
  echo "log=0" >> "$CONFIG"
fi

ui_print " "

# 2️⃣ ZRAM resizing
ui_print "Enable ZRAM resizing?"
ui_print "Vol + = Yes"
ui_print "Vol - = No"

if choose; then
  ui_print "✓ ZRAM resizing enabled"
  echo "zram=1" >> "$CONFIG"
else
  ui_print "✗ ZRAM resizing skipped"
  echo "zram=0" >> "$CONFIG"
fi

ui_print " "

# 3️⃣ UI smoothness tweaks
ui_print "Apply extra UI smoothness tweaks?"
ui_print "Vol + = Yes"
ui_print "Vol - = No"

if choose; then
  ui_print "✓ UI smoothness tweaks enabled"
  echo "ui=1" >> "$CONFIG"
else
  ui_print "✗ UI smoothness tweaks skipped"
  echo "ui=0" >> "$CONFIG"
fi

ui_print " "

# 4️⃣ Set service.sh permission (LAST)
ui_print "Setting service permissions..."
chmod 755 "$MODPATH/service.sh"
ui_print "✓ service.sh permission set"