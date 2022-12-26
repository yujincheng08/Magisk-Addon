#!/system/bin/sh
[ -z $MODDIR ] && MODDIR=${0%/*}
# addon.d
. "$MODDIR"/util_functions.sh
if [ -d /system/addon.d ]; then
  log -t Magisk "\- Adding addon.d survival script"
  set_systemblk_rw
  ADDOND=/system/addon.d/99-magisk.sh
  cp -af "$MODDIR"/addon.d.sh $ADDOND
  chmod 755 $ADDOND
  [ -n "$REMOUNTED" ] && mount -o remount,ro $REMOUNTED || true
fi
