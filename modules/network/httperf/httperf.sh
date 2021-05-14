#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

check_input() {
  local correct=1

  if [ "$ipp" == "" ]; then
    correct=0
    $DIALOG --title "Error" --msgbox "Please specify ip and port..." 10 40
  fi
  if [ $req_total -eq 0 ]; then
    correct=0
    $DIALOG --title "Error" --msgbox "Please specify total HTTP requests count..." 10 40
  fi
  if [ $req_ps -eq 0 ]; then
    correct=0
    $DIALOG --title "Error" --msgbox "Please specify HTTP requests count per 1 sec..." 10 40
  fi

  retval=$correct
}

dialog_modules_network_httperf_main() {
  local ipp=""
  local req_total=0
  local req_ps=0

  while true; do
    option=$($DIALOG --clear --title "Siege - Set up stress-test" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Specify IP:port $([ -z $ipp ] && echo || echo [$ipp])" \
      "$DMENU_OPTION_2" "Specify total HTTP requests count $([ $req_total -eq 0 ] && echo || echo [$req_total])" \
      "$DMENU_OPTION_3" "Specify HTTP requests count per 1 sec $([ $req_ps -eq 0 ] && echo || echo [$req_ps])" \
      "" "" \
      "$DMENU_OPTION_4" "Run repformance test" \
      3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        title="Enter target ip:port"
        text=""
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_ip ip_port "\${title}" "\${text}"
        ipp=$retval
        ;;

      $DMENU_OPTION_2)
        title=""
        text="Enter total HTTP requests count"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_num "\${title}" "\${text}"
        req_total=$retval
        ;;

      $DMENU_OPTION_3)
        title=""
        text="Enter HTTP requests count per 1 sec"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_num "\${title}" "\${text}"
        req_ps=$retval
        ;;

      $DMENU_OPTION_4)
        check_input
        correct=$retval

        if [ $correct -eq 1 ]; then
          if $DIALOG --clear --stdout --title "Note" \
            --yesno "Please note that the operation may take a long time" 10 40; then

            local ip=$(echo "$ipp" | grep -Po "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])")
            local port=$(echo "$ipp" | grep -Po "((?:))(?:[0-9]+)$")

            local log=$PROJ_ROOT_DIR/out/httperf$(date +%F_%H-%M-%S).log
            httperf --server "$ip" --port "$port" --num-conns "$req_total" --rate "$req_ps" |
              tee "$log" | $DIALOG --clear --progressbox 40 100
            $DIALOG --clear --textbox "$log" 40 100
            rm -f $log

          else
            continue
          fi
        fi
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
