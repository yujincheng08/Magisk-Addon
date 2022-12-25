cd "$MODPATH" || abort
. "$MODDIR"/util_functions.sh
chmod +x "$MODPATH"/post-fs-data.sh
set_systemblk_rw
cp -af /data/adb/magisk/. /system/addon.d/magisk
exec "$MODPATH"/post-fs-data.sh
