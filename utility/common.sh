#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_choose_filepath() {
  local filename=$($DIALOG --stdout --title "Choose file" --fselect $HOME/ 100 100)

  case $? in
  $DIALOG_OK)
    retval=$filename
    ;;

  $DIALOG_CANCEL)
    return $DIALOG_CANCEL
    ;;

  $DIALOG_ESC)
    CLEAR_EXIT
    ;;

  esac
}

RESOLVE_FUNC_CALL $1
