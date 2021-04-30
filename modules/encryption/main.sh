#!/bin/bash

source $PROJ_ROOT_DIR/utility.sh

dialog_modules_encryption_main() {
  tempfile=$(mktemp 2>/dev/null)
  trap "rm -f $tempfile" 0 1 2 5 15

  $DIALOG --clear --title "Choose app" \
    --menu "Please select app:" 20 50 4 \
    "1" "TrueCrypt" \
    "2" "VeraCrypt" \
    "3" "Placeholder" 2>$tempfile

  case $? in
  $DIALOG_OK) ;;

  $DIALOG_CANCEL)
    return $DIALOG_CANCEL
    ;;
  $DIALOG_ESC)
    exit
    ;;
  esac
}

RESOLVE_FUNC_CALL $1
