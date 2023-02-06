SLOT=$(resetprop -n ro.boot.slot_suffix)
if [ "$DYNAMIC_PARTITIONS" = "true" ]; then
  BLK_PATH="/dev/block/mapper"
else
  BLK_PATH="/dev/block/bootdevice/by-name"
fi
set_systemblk_rw() {
  blockdev --setrw "$BLK_PATH/system$SLOT" 2>/dev/null
  local REMOUNTED=""
  if mount | grep ' /system ' | grep -q 'ro'; then
    export REMOUNTED="/system"
    mount -o remount,rw /system
  elif mount | grep ' / ' | grep -q 'ro'; then
    export REMOUNTED="/"
    mount -o remount,rw /
  fi
}
