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

dialog_get_sup() {
  title="ROOT ACCESS IS REQUIRED"
  text="\nEnter your ROOT password"
  source $PROJ_ROOT_DIR/utility/common.sh dialog_enter_password "\${title}" "\${text}"
  rpass=$retval

  export HISTIGNORE='*sudo -S*'

  # validate root password(just random command)
  prompt=$(
    echo "$rpass" | sudo -S uname -a 2>&1
    sudo -S -nv 2>&1
  )
  if [ $? -ne 0 ]; then
    $DIALOG --title "Error" --msgbox "Wrong password" 10 40
    return $RC_ERROR
  fi

  retval=$rpass
}

RESOLVE_FUNC_CALL $@
