#!/system/bin/sh

MODDIR=${0%/*}
# addon.d
. "$MODDIR"/util_functions.sh
if [ -d /system/addon.d ]; then
  log -t Magisk "- Adding addon.d survival script"
  remount_system_rw
  REMOUNTED=""
  if mount | grep ' /system ' | grep -q 'ro'; then
    mount -o remount,rw /system
    REMOUNTED="/system"
  elif mount | grep ' / ' | grep -q 'ro'; then
    mount -o remount,rw /
    REMOUNTED="/"
  fi
  ADDOND=/system/addon.d/99-magisk.sh
  cp -af "$MODDIR"/addon.d.sh $ADDOND
  chmod 755 $ADDOND
  [ -n "$REMOUNTED" ] && mount -o remount,ro $REMOUNTED || true
fi
