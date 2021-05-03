#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_veracrypt_main() {
  while true; do
    option=$($DIALOG --clear --title "VeraCrypt - Choose mode" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Encrypt file" \
      "$DMENU_OPTION_2" "Decrypt file" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show veracrypt encryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/veracrypt/encryption.sh dialog_modules_encryption_veracrypt_encrypt
        ;;

      $DMENU_OPTION_2) # show veracrypt decryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/veracrypt/decryption.sh dialog_modules_encryption_veracrypt_decrypt
        ;;

      esac

      ;;

    $DIALOG_CANCEL)
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      CLEAR_EXIT
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
