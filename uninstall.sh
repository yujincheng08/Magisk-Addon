#!/sbin/sh
MODDIR=${0%/*}
. "$MODDIR"/util_functions.sh
ADDOND=/system/addon.d/99-magisk.sh
remount_system_rw
rm -rf ${ADDOND:?}
