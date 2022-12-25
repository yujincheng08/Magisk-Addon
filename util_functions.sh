SLOT=$(resetprop -n ro.boot.slot_suffix)
set_systemblk_rw() {
    blockdev --setrw "/dev/block/mapper/system$SLOT" 2>/dev/null
}
