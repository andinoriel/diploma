#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

is_ip_valid() {
  local ip=${1:-1.2.3.4}
  local IFS=.
  local -a a=($ip)

  [[ $ip =~ ^[0-9]+(\.[0-9]+){3}$ ]] || return 1

  local quad
  for quad in {0..3}; do
    [[ "${a[$quad]}" -gt 255 ]] && return 1
  done
  return 0
}

get_scan_target() {
  while true; do
    ip=$($DIALOG --clear --title "Enter scan target ip" --inputbox "ip:" 10 30 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      if is_ip_valid "$ip"; then
        retval=$ip
        return
      else
        $DIALOG --title "Error" --msgbox "Wrong ip format" 10 40
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

dialog_show_ip_error() {
  $DIALOG --title "Error" --msgbox "Please specify the IP address" 10 40
}

nmap_scan() {
  local ip=$2
  if [ -z "$ip" ]; then
    dialog_show_ip_error
  else

    local type=$1
    eval local title="$3"
    nmap "$type" "$ip" | dialog --clear --title "$title" --programbox 20 100
  fi
}

nmap_su_scan() {
  local ip=$2
  if [ -z "$ip" ]; then
    dialog_show_ip_error
  else
    SUDO_CRED_LOCK_RESET
    source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
    if [[ $? -eq $RC_ERROR ]]; then
      continue
    fi
    rpass=$retval

    local type=$1
    eval local title="$3"
    echo "$rpass" | sudo -S -k nmap "$type" "$ip" | dialog --clear --title "$title" --programbox 20 100

    SUDO_CRED_LOCK_RESET
  fi
}

dialog_modules_network_nmap_main() {
  local ip=""

  while true; do
    option=$($DIALOG --clear --title "NMap - Choose scan type" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Specify IP" \
      "" "" \
      "$DMENU_OPTION_2" "tcp scan" \
      "$DMENU_OPTION_3" "tcp syn scan" \
      "$DMENU_OPTION_4" "FIN scan" \
      "$DMENU_OPTION_5" "Xmas Tree scan" \
      "$DMENU_OPTION_6" "NULL scan" \
      "$DMENU_OPTION_7" "IP scan" \
      "$DMENU_OPTION_8" "ack scan" \
      "$DMENU_OPTION_9" "tcp window scan" \
      "$DMENU_OPTION_10" "rpc scan" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        get_scan_target
        ip=$retval
        ;;

      $DMENU_OPTION_2)
        title="tcp scan"
        nmap_scan -sT "$ip" "\${title}"
        ;;

      $DMENU_OPTION_3)
        title="tcp syn scan"
        nmap_su_scan -sS "$ip" "\${title}"
        ;;

      $DMENU_OPTION_4)
        title="FIN scan"
        nmap_su_scan -sF "$ip" "\${title}"
        ;;

      $DMENU_OPTION_5)
        title="Xmas Tree scan"
        nmap_su_scan -sX "$ip" "\${title}"
        ;;

      $DMENU_OPTION_6)
        title="NULL scan"
        nmap_su_scan -sN "$ip" "\${title}"
        ;;

      $DMENU_OPTION_7)
        title="IP scan"
        nmap_su_scan -sO "$ip" "\${title}"
        ;;

      $DMENU_OPTION_8)
        title="ack scan"
        nmap_su_scan -sA "$ip" "\${title}"
        ;;

      $DMENU_OPTION_9)
        title="tcp window scan"
        nmap_su_scan -sW "$ip" "\${title}"
        ;;

      $DMENU_OPTION_10)
        title="rpc scan"
        nmap_scan -sV "$ip" "\${title}"
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
