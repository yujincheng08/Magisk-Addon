#!/sbin/sh
# ADDOND_VERSION=2
########################################################
#
# Magisk Survival Script for ROMs with addon.d support
# by topjohnwu and osm0sis
#
########################################################

SYSTEM_MAGISKBIN=$S/addon.d/magisk
MAGISKTMP=/tmp/magisk
[ -f "$SYSTEM_MAGISKBIN"/util_functions.sh ] || return 1

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
  . $MAGISKTMP/util_functions.sh
  readonly NVBASE=/tmp
  resolve_vars

  if $BOOTMODE; then
    # Override ui_print when booted
    ui_print() { log -t Magisk -- "$1"; }
  fi
  unset OUTFD
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
  resolve_vars
  get_flags

  if $backuptool_ab; then
    # Swap the slot for addon.d-v2
    if [ ! -z "$SLOT" ]; then
      case $SLOT in
      _a) SLOT=_b ;;
      _b) SLOT=_a ;;
      esac
    fi
  fi

  find_boot_image

  [ -z "$BOOTIMAGE" ] && abort "! Unable to detect target image"
  ui_print "- Target image: $BOOTIMAGE"

  remove_system_su
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
  cp -af "$SYSTEM_MAGISKBIN" $MAGISKTMP
  ;;
restore)
  cp -af $MAGISKTMP "$SYSTEM_MAGISKBIN"
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
