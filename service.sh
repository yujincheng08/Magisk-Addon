#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR"/util_functions.sh
set_systemblk_rw
mkdir -p /system/addon.d/magisk
cp -af /data/adb/magisk/. /system/addon.d/magisk
[ -n "$REMOUNTED" ] && mount -o remount,ro $REMOUNTED || true
