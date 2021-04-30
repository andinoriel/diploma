#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

enter_password() {
  local tempfile=$(mktemp 2>/dev/null)
  trap "rm -f $tempfile" 0 1 2 5 15

  response=$(
    $DIALOG --clear --ok-label "Submit" \
      --title "Enter password" \
      --insecure "$@" \
      --passwordform "" \
      0 0 0 \
      "Password:" 1 1 "$password" 1 10 20 0 \
      3>&1 1>&2 2>&3 3>&-
  )
  response=($response)

  case $? in
  $DIALOG_OK)
    retval=$response
    ;;

  $DIALOG_CANCEL)
    return $DIALOG_CANCEL
    ;;

  $DIALOG_ESC)
    exit
    ;;

  esac
}

dialog_modules_encryption_truecrypt_decrypt() {
  local filepath=""
  local password=""

  while true; do
    local tempfile=$(mktemp 2>/dev/null)
    trap "rm -f $tempfile" 0 1 2 5 15

    $DIALOG --clear --title "Decryption" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Choose file..." \
      "$DMENU_OPTION_2" "Enter password..." \
      "$DMENU_OPTION_3" "Process" 2>$tempfile

    case $? in
    $DIALOG_OK)
      local variant=$(cat $tempfile)

      case $variant in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_choose_filepath
        filepath=$retval
        ;;

      $DMENU_OPTION_2)
        enter_password
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
      exit
      ;;
    esac
  done
}

RESOLVE_FUNC_CALL $1
