SLOT=$(resetprop -n ro.boot.slot_suffix)
remount_system_rw() {
    blockdev --setrw "/dev/block/mapper/system$SLOT" 2>/dev/null
}
