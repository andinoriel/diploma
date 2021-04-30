#!/bin/bash

source $PROJ_ROOT_DIR/utility.sh

dialog_greetings() {
  $DIALOG --title "Greetings" --msgbox "Welcome aboard" 10 40

  case $? in
  $DIALOG_OK)
    return $STATUS_TRUE
    ;;
  $DIALOG_CANCEL)
    return $STATUS_FALSE
    ;;
  $DIALOG_ESC)
    exit
    ;;
  esac
}

RESOLVE_FUNC_CALL $1
