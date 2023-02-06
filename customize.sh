cd "$MODPATH" || abort
. "$MODPATH"/util_functions.sh
chmod +x "$MODPATH"/post-fs-data.sh
set_systemblk_rw
ADDOND=/system/addon.d
. "$MODPATH"/uninstall.sh
mkdir -p "$ADDOND"/magisk
cp -af /data/adb/magisk/. "$ADDOND"/magisk
export MODDIR=$MODPATH
. "$MODPATH"/post-fs-data.sh
