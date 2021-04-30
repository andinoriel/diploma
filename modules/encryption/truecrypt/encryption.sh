#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

choose_encalg() {
  local tempfile=$(mktemp 2>/dev/null)
  trap "rm -f $tempfile" 0 1 2 5 15

  $DIALOG --clear --title "Choose the encryption algorithm" \
    --menu "" 20 50 4 \
    "$DMENU_OPTION_1" "Algorithm 1" \
    "$DMENU_OPTION_2" "Algorithm 2" \
    "$DMENU_OPTION_3" "Algorithm 3" 2>$tempfile

  case $? in
  $DIALOG_OK)
    local option=$(cat $tempfile)

    case $option in
    $DMENU_OPTION_1)
      return $DMENU_OPTION_1
      ;;

    $DMENU_OPTION_2)
      return $DMENU_OPTION_2
      ;;

    $DMENU_OPTION_3)
      return $DMENU_OPTION_3
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
}

dialog_modules_encryption_truecrypt_encrypt() {
  local filepath=""
  local encalg=0

  while true; do
    local tempfile=$(mktemp 2>/dev/null)
    trap "rm -f $tempfile" 0 1 2 5 15

    $DIALOG --clear --title "Encryption" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Choose file..." \
      "$DMENU_OPTION_2" "Choose algorithm..." \
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
        choose_encalg
        encalg=$?
        ;;

      $DMENU_OPTION_3)
        if [ "$filepath" == "" ]; then
          $DIALOG --title "Error" --msgbox "Please select filepath..." 10 40
        else
          if [ $encalg -eq 0 ]; then
            $DIALOG --title "Error" --msgbox "Please select encryption algorithm..." 10 40
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

RESOLVE_FUNC_CALL $1
