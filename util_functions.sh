export BBBIN=/system/addon.d/magisk/busybox
export ASH_STANDALONE=1
if echo "$3" | $BBBIN grep -q "uninstall"; then
  exec $BBBIN sh "/tmp/magisk/addon.d/uninstaller.sh" "$@"
fi
