#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_choose_filepath() {
  filename=$($DIALOG --title "Choose file" --fselect $HOME/ 100 100 3>&1 1>&2 2>&3)

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

dialog_enter_password() {
  eval title="$1"
  eval text="$2"

  pass=$($DIALOG --title "$title" --insecure --passwordbox "$text" 10 30 3>&1 1>&2 2>&3)

  case $? in
  $DIALOG_OK)
    retval=$pass
    ;;

  $DIALOG_CANCEL)
    return $DIALOG_CANCEL
    ;;

  $DIALOG_ESC)
    CLEAR_EXIT
    ;;

  esac
}

RESOLVE_FUNC_CALL $@
