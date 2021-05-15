#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

nmap_scan() {
  local ip=$2
  if [ -z "$ip" ]; then
    $DIALOG --title "Error" --msgbox "Please specify the IP address..." 10 40
  else
    local type=$1
    eval local title="$3"

    local log=$PROJ_ROOT_DIR/out/nmap$(date +%F_%H-%M-%S).log
    nmap "$type" "$ip" $([ $force -eq 0 ] && echo "" || echo -Pn) 2>/dev/null |
      tee "$log" | $DIALOG --clear --title "$title" --progressbox 40 120
    $DIALOG --clear --title "$title" --textbox "$log" 40 120
    rm -f $log
  fi
}

nmap_su_scan() {
  local ip=$2
  if [ -z "$ip" ]; then
    $DIALOG --title "Error" --msgbox "Please specify the IP address..." 10 40
  else
    #region ROOT IS REQUIRED

    SUDO_CRED_LOCK_RESET

    source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
    if [ $? -eq $RC_ERROR ]; then
      return
    fi
    rpass=$retval

    local type=$1
    eval local title="$3"

    local log=$PROJ_ROOT_DIR/out/nmap$(date +%F_%H-%M-%S)
    sudo -S -k -p "" nmap "$type" "$ip" <<<"$rpass" | tee "$log" |
      $DIALOG --clear --title "$title" --progressbox 40 120
    $DIALOG --clear --title "$title" --textbox "$log" 40 120
    rm -f $log

    SUDO_CRED_LOCK_RESET

    #endregion
  fi
}

dialog_modules_network_nmap_main() {
  local ip=""
  local force=0

  while true; do
    option=$($DIALOG --clear --title "NMap - Choose scan type" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Specify IP $([ -z $ip ] && echo || echo [$ip])" \
      "$DMENU_OPTION_2" "Force mode $([ $force -eq 0 ] && echo [off] || echo [on])" \
      "" "" \
      "$DMENU_OPTION_3" "tcp scan" \
      "$DMENU_OPTION_4" "tcp syn scan" \
      "$DMENU_OPTION_5" "FIN scan" \
      "$DMENU_OPTION_6" "Xmas Tree scan" \
      "$DMENU_OPTION_7" "NULL scan" \
      "$DMENU_OPTION_8" "IP scan" \
      "$DMENU_OPTION_9" "ack scan" \
      "$DMENU_OPTION_10" "tcp window scan" \
      "$DMENU_OPTION_11" "rpc scan" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        title="Enter scan target ip"
        text=""
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_ip ip_only "\${title}" "\${text}"
        ip=$retval
        ;;

      $DMENU_OPTION_2)
        if [ $force -eq 0 ]; then
          force=1
        else
          force=0
        fi
        ;;

      $DMENU_OPTION_3)
        title="tcp scan - $ip"
        nmap_scan -sT "$ip" "\${title}"
        ;;

      $DMENU_OPTION_4)
        title="tcp syn scan - $ip"
        nmap_su_scan -sS "$ip" "\${title}"
        ;;

      $DMENU_OPTION_5)
        title="FIN scan - $ip"
        nmap_su_scan -sF "$ip" "\${title}"
        ;;

      $DMENU_OPTION_6)
        title="Xmas Tree scan - $ip"
        nmap_su_scan -sX "$ip" "\${title}"
        ;;

      $DMENU_OPTION_7)
        title="NULL scan - $ip"
        nmap_su_scan -sN "$ip" "\${title}"
        ;;

      $DMENU_OPTION_8)
        title="IP scan - $ip"
        nmap_su_scan -sO "$ip" "\${title}"
        ;;

      $DMENU_OPTION_9)
        title="ack scan - $ip"
        nmap_su_scan -sA "$ip" "\${title}"
        ;;

      $DMENU_OPTION_10)
        title="tcp window scan - $ip"
        nmap_su_scan -sW "$ip" "\${title}"
        ;;

      $DMENU_OPTION_11)
        title="rpc scan - $ip"
        nmap_scan -sV "$ip" "\${title}"
        ;;

      esac

      ;;
    $DIALOG_CANCEL)
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      clear
      return $DIALOG_ESC
      ;;

    esac
  done
}

RESOLVE_FUNC_CALL $@
