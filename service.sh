#!/system/bin/sh
. "$MODDIR"/util_functions.sh
set_systemblk_rw
cp -af /data/adb/magisk/. /system/addon.d/magisk
