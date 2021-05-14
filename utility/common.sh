#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_input_path() {
  while true; do
    path=$($DIALOG --title "Choose file" --fselect $HOME/ 100 100 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      if !([ -f "$path" ] || [ -d "$path" ]); then
        $DIALOG --title "Error" --msgbox "Wrong path!" 10 40
        continue
      fi
      retval=$path
      return
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

dialog_input_password() {
  eval local title="$1"
  eval local text="$2"

  pass=$($DIALOG --clear --title "$title" --insecure --passwordbox "$text" 10 30 3>&1 1>&2 2>&3)

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

dialog_input_num() {
  eval local title="$1"
  eval local text="$2"

  while true; do
    num=$($DIALOG --clear --title "$title" --inputbox "$text" 10 30 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      if [[ $num =~ ^[0-9]+$ ]]; then
        retval=$num
        return
      else
        $DIALOG --title "Error" --msgbox "Wrong number" 10 40
      fi

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

dialog_get_sup() {
  #region ROOT IS REQUIRED

  SUDO_CRED_LOCK_RESET

  local title="ROOT ACCESS IS REQUIRED"
  local text="\nEnter your ROOT password"
  source $PROJ_ROOT_DIR/utility/common.sh dialog_input_password "\${title}" "\${text}"
  if [ $? -eq $DIALOG_CANCEL ]; then
    return $RC_ERROR
  fi
  local rpass=$retval

  export HISTIGNORE='*sudo -S*'

  # validate root password(just random command)
  prompt=$(
    sudo -S uname -a 2>&1 <<<"$rpass"
    sudo -S -nv 2>&1
  )
  if [ $? -ne 0 ]; then
    $DIALOG --clear --title "Error" --msgbox "Wrong password" 10 40
    return $RC_ERROR
  fi

  retval=$rpass

  SUDO_CRED_LOCK_RESET

  #endregion
}

dialog_get_all_partitions() {
  #region ROOT IS REQUIRED

  SUDO_CRED_LOCK_RESET

  source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
  if [ $? -eq $RC_ERROR ]; then
    return $RC_ERROR
  fi
  local rpass=$retval

  local partitions=$(sudo -S -k -p "" fdisk -l <<<"$rpass" | grep "^/dev" | cut -d" " -f1 | tr "\n" " ")

  SUDO_CRED_LOCK_RESET

  #endregion

  retval=$partitions
}

dialog_input_ip() {
  mode=$1

  if [ "$mode" = "ip_only" ]; then
    local regex="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
  fi
  if [ "$mode" = "ip_port" ]; then
    local regex="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]):[0-9]+$"
  fi

  eval local title="$2"
  eval local text="$3"

  while true; do
    ip=$($DIALOG --clear --title "$title" --inputbox "$text" 10 30 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      if [[ $ip =~ $regex ]]; then
        retval=$ip
        return
      else
        $DIALOG --title "Error" --msgbox "Wrong format" 10 40
      fi

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

network_run_test_server() {
  source $PROJ_ROOT_DIR/extern/server.sh init
  source $PROJ_ROOT_DIR/extern/server.sh run
}

network_stop_test_server() {
  curl -X GET localhost:4723/stop
}

RESOLVE_FUNC_CALL $@
