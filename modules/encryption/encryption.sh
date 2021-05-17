#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_main() {
  while true; do
    option=$($DIALOG --clear --title "Choose an app" \
      --menu "Please select an app:" 20 50 4 \
      "$DMENU_OPTION_1" "TrueCrypt" \
      "$DMENU_OPTION_2" "Veracrypt" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show truecrypt main menu
        source $PROJ_ROOT_DIR/modules/encryption/truecrypt/truecrypt.sh dialog_modules_encryption_truecrypt_main
        ;;

      $DMENU_OPTION_2) # show veracrypt main menu
        source $PROJ_ROOT_DIR/modules/encryption/veracrypt/veracrypt.sh dialog_modules_encryption_veracrypt_main
        ;;

      esac

      ;;

    $DIALOG_CANCEL)
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      clear
      return $DIALOG_ESC
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
