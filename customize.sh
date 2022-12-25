cd "$MODPATH" || abort
chmod +x "$MODPATH"/post-fs-data.sh
cp -af /data/adb/magisk/. $ADDOND/magisk
exec "$MODPATH"/post-fs-data.sh
