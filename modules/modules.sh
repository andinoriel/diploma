#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_main() {
  while true; do
    local tempfile=$(mktemp 2>/dev/null)
    trap "rm -f $tempfile" 0 1 2 5 15

    $DIALOG --clear --title "Choose module" \
      --menu "Please select app module:" 20 50 4 \
      "$DMENU_OPTION_1" "Data encryption" 2>$tempfile

    case $? in
    $DIALOG_OK)
      local option=$(cat $tempfile)

      case $option in
      $DMENU_OPTION_1) # show encryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/encryption.sh dialog_modules_encryption_main
        ;;
      esac
      ;;

    $DIALOG_CANCEL)
      clear
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      CLEAR_EXIT
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $1
