#!/sbin/sh
MODDIR=${0%/*}
. "$MODDIR"/util_functions.sh
ADDOND=/system/addon.d/99-magisk.sh
set_systemblk_rw
rm -rf ${ADDOND:?}
