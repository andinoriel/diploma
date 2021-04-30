#!/bin/bash

source $PROJ_ROOT_DIR/utility.sh

dialog_modules_main() {
  tempfile=$(mktemp 2>/dev/null)
  trap "rm -f $tempfile" 0 1 2 5 15

  $DIALOG --clear --title "Choose module" \
    --menu "Please select app module:" 20 50 4 \
    "1" "Data encryption" \
    "2" "Placeholder" 2>$tempfile

  case $? in
  $DIALOG_OK)
    module=$(cat $tempfile)
    case $module in
    1) # show encryption main menu
      while true; do
        source $PROJ_ROOT_DIR/modules/encryption/main.sh dialog_modules_encryption_main

        if [[ $? -eq $DIALOG_CANCEL ]]; then
          break
        fi
      done
      ;;
    2)
      source $PROJ_ROOT_DIR/modules/placeholder/placeholder.sh placeholder
      ;;
    esac
    ;;
  $DIALOG_CANCEL)
    return $DIALOG_CANCEL
    ;;
  $DIALOG_ESC)
    exit
    ;;
  esac
}

RESOLVE_FUNC_CALL $1
