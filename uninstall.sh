#!/sbin/sh
SLOT=$(resetprop -n ro.boot.slot_suffix)
ADDOND=/system/addon.d
if [ -f $ADDOND ]; then
    blockdev --setrw "/dev/block/mapper/system$SLOT" 2>/dev/null
    REMOUNTED=""
    if mount | grep ' /system ' | grep -q 'ro'; then
        mount -o remount,rw /system
        REMOUNTED="/system"
    elif mount | grep ' / ' | grep -q 'ro'; then
        mount -o remount,rw /
        REMOUNTED="/"
    fi
    rm -f ${ADDOND:?}/99-magisk.sh
    rm -rf ${ADDOND:?}/magisk
    [ -n "$REMOUNTED" ] && mount -o remount,ro $REMOUNTED || true
fi
