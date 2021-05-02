#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_truecrypt_decrypt() {
  local filepath=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "Decryption" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Choose file..." \
      "$DMENU_OPTION_2" "Enter password..." \
      "$DMENU_OPTION_3" "Process" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_choose_filepath
        filepath=$retval
        ;;

      $DMENU_OPTION_2)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_enter_password
        password=$retval
        ;;

      $DMENU_OPTION_3)
        if [ "$filepath" == "" ]; then
          $DIALOG --title "Error" --msgbox "Please select filepath..." 10 40
        else
          if [ "$password" == "" ]; then
            $DIALOG --title "Error" --msgbox "Please enter the password..." 10 40
          else
            $DIALOG --title "NOT Error" --msgbox "HURRAY" 10 40
          fi
        fi
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
