cd "$MODPATH" || abort
chmod +x "$MODPATH"/post-fs-data.sh
exec "$MODPATH"/post-fs-data.sh
