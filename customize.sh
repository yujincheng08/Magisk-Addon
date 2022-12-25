cd "$MODPATH" || abort
. "$TMPDIR"/util_functions.sh
chmod +x "$MODPATH"/post-fs-data.sh
set_systemblk_rw
mkdir -p /system/addon.d/magisk
cp -af /data/adb/magisk/. /system/addon.d/magisk
exec "$MODPATH"/post-fs-data.sh
