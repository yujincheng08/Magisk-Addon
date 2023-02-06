#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR"/util_functions.sh
ADDOND=/system/addon.d
[ -d $ADDOND ] || abort "- System unsupport addon.d !"
set_systemblk_rw
mkdir -p $ADDOND/magisk
cp -af /data/adb/magisk/. $ADDOND/magisk
cp -af $ADDOND/99-magisk.sh $ADDOND/magisk/addon.d.sh
[ -n "$REMOUNTED" ] && mount -o remount,ro $REMOUNTED || true
