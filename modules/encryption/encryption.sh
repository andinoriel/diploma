#!/bin/bash

source $PROJ_ROOT_DIR/utility.sh

dialog_modules_encryption_main() {
  while true; do
    local tempfile=$(mktemp 2>/dev/null)
    trap "rm -f $tempfile" 0 1 2 5 15

    $DIALOG --clear --title "Choose app" \
      --menu "Please select app:" 20 50 4 \
      "$DMENU_OPTION_1" "TrueCrypt" 2>$tempfile

    case $? in
    $DIALOG_OK)
      local option=$(cat $tempfile)

      case $option in
      $DMENU_OPTION_1) # show truecrypt main menu
        source $PROJ_ROOT_DIR/modules/encryption/truecrypt/truecrypt.sh dialog_modules_encryption_truecrypt_main
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

  done
}

RESOLVE_FUNC_CALL $1
