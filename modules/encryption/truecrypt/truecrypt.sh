#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_truecrypt_main() {
  while true; do
    local tempfile=$(mktemp 2>/dev/null)
    trap "rm -f $tempfile" 0 1 2 5 15

    $DIALOG --clear --title "Choose mode" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Encrypt file" \
      "$DMENU_OPTION_2" "Decrypt file" 2>$tempfile

    case $? in
    $DIALOG_OK)
      local option=$(cat $tempfile)

      case $option in
      $DMENU_OPTION_1) # show truecrypt encryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/truecrypt/encryption.sh dialog_modules_encryption_truecrypt_encrypt
        ;;

      $DMENU_OPTION_2) # show truecrypt decryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/truecrypt/decryption.sh dialog_modules_encryption_truecrypt_decrypt
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
