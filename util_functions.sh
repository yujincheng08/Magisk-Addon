SLOT=$(resetprop -n ro.boot.slot_suffix)
if [ "$DYNAMIC_PARTITIONS" = "true" ]; then
    BLK_PATH="/dev/block/mapper"
else
    BLK_PATH="/dev/block/bootdevice/by-name"
fi
set_systemblk_rw() {
    blockdev --setrw "$BLK_PATH/system$SLOT" 2>/dev/null
}
