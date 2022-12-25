cd "$MODPATH" || abort
. "$MODPATH"/util_functions.sh
chmod +x "$MODPATH"/post-fs-data.sh
set_systemblk_rw
ADDOND=/system/addon.d
mkdir -p "$ADDOND"/magisk
cp -af "$MODPATH"/addon.d.sh $ADDOND/99-magisk.sh
cp -af /data/adb/magisk/. "$ADDOND"/magisk
exec "$MODPATH"/post-fs-data.sh
