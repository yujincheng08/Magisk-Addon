#!/sbin/sh
# ADDOND_VERSION=2
########################################################
#
# Magisk Survival Script for ROMs with addon.d support
# by topjohnwu and osm0sis
#
########################################################

DYNAMIC_PARTITIONS=$(getprop ro.boot.dynamic_partitions)
if [ "$DYNAMIC_PARTITIONS" = "true" ]; then
    BLK_PATH="/dev/block/mapper"
else
    BLK_PATH="/dev/block/bootdevice/by-name"
fi

get_block_for_mount_point() {
  grep -v "^#" /etc/recovery.fstab | grep "[[:blank:]]$1[[:blank:]]" | tail -n1 | tr -s "[:blank:]" ' ' | cut -d' ' -f1
}

find_block() {
  local name="$1"
  local fstab_entry="$(get_block_for_mount_point "/$name")"

  local dev
    if [ -z "$fstab_entry" ]; then
      dev="${BLK_PATH}/${name}"
    fi

  if [ -b "$dev" ]; then
    echo "$dev"
  fi
}
DATA_BLOCK=$(find_block "userdata")
mount_data() {
    mkdir -p "/data" || true
    mount -o ro "$DATA_BLOCK" "/data" && ui_print "/data mounted"
}
MAGISKBIN=/data/adb/magisk
[ -f $MAGISKBIN/util_functions.sh ] || mount_data

V1_FUNCS=/tmp/backuptool.functions
V2_FUNCS=/postinstall/tmp/backuptool.functions

if [ -f $V1_FUNCS ]; then
  . $V1_FUNCS
  backuptool_ab=false
elif [ -f $V2_FUNCS ]; then
  . $V2_FUNCS
else
  return 1
fi

initialize() {
  # Load utility functions
  . $MAGISKBIN/util_functions.sh

  if $BOOTMODE; then
    # Override ui_print when booted
    ui_print() { log -t Magisk -- "$1"; }
  fi
  setup_flashable
}

main() {
  if ! $backuptool_ab; then
    # Wait for post addon.d-v1 processes to finish
    sleep 5
  fi

  # Ensure we aren't in /tmp/addon.d anymore (since it's been deleted by addon.d)
  mkdir -p "$TMPDIR"
  cd "$TMPDIR" || return 1

  $BOOTMODE || recovery_actions

  if echo "$MAGISK_VER" | grep -q '\.'; then
    PRETTY_VER=$MAGISK_VER
  else
    PRETTY_VER="$MAGISK_VER($MAGISK_VER_CODE)"
  fi
  print_title "Magisk $PRETTY_VER addon.d"

  mount_partitions
  check_data
  get_flags

  if $backuptool_ab; then
    # Swap the slot for addon.d-v2
    if [ -n "$SLOT" ]; then
      case $SLOT in
        _a) SLOT=_b;;
        _b) SLOT=_a;;
      esac
    fi
  fi

  find_boot_image

  [ -z "$BOOTIMAGE" ] && abort "! Unable to detect target image"
  ui_print "- Target image: $BOOTIMAGE"

  remove_system_su
  find_magisk_apk
  api_level_arch_detect
  install_magisk

  # Cleanups
  cd /
  $BOOTMODE || recovery_cleanup
  rm -rf "$TMPDIR"

  ui_print "- Done"
  exit 0
}

case "$1" in
  backup)
    # Stub
  ;;
  restore)
    # Stub
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    initialize
    if $backuptool_ab; then
      su=sh
      $BOOTMODE && su=su
      exec $su -c "sh $0 addond-v2"
    else
      # Run in background, hack for addon.d-v1
      (main) &
    fi
  ;;
  addond-v2)
    initialize
    main
  ;;
esac
