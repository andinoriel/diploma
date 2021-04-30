#!/bin/bash

source ./variables.sh

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

if declare -f "$1" >/dev/null; then
  "$@"
else
  echo "'$1' is not a known function name" >&2
  exit $RC_ERROR
fi
