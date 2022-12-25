#!/sbin/sh
export BBBIN=/system/addon.d/magisk/busybox
export ASH_STANDALONE=1
SLOT=$(resetprop -n ro.boot.slot_suffix)
ADDOND=/system/addon.d
if echo "$3" | $BBBIN grep -q "uninstall"; then
    if [ -f $ADDOND ]; then
        blockdev --setrw "/dev/block/mapper/system$SLOT" 2>/dev/null
        rm -f ${ADDOND:?}/99-magisk.sh
        rm -rf ${ADDOND:?}/magisk
    fi
fi
