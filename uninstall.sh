#!/sbin/sh
SLOT=$(resetprop -n ro.boot.slot_suffix)
ADDOND=/system/addon.d
if [ -f $ADDOND ]; then
    blockdev --setrw "/dev/block/mapper/system$SLOT" 2>/dev/null
    rm -f ${ADDOND:?}/99-magisk.sh
    rm -rf ${ADDOND:?}/magisk
fi
