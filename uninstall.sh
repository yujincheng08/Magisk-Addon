#!/sbin/sh
MODDIR=${0%/*}
SLOT=$(resetprop -n ro.boot.slot_suffix)
blockdev --setrw "/dev/block/mapper/system$SLOT" 2>/dev/null
ADDOND=/system/addon.d/99-magisk.sh
set_systemblk_rw
rm -rf ${ADDOND:?}
