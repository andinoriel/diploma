#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

stop_test_server() {
  if [ $server_online -eq 1 ]; then
    curl -X GET localhost:4723/stop
    server_online=0
    rm -f $log
  fi
}

dialog_module_network_main() {
  local server_online=0
  local log=""

  while true; do
    option=$($DIALOG --clear --title "Choose app" \
      --menu "Please select app:" 20 50 4 \
      "$DMENU_OPTION_1" "Nmap" \
      "$DMENU_OPTION_2" "Siege" \
      "$DMENU_OPTION_3" "httperf" \
      "" "" \
      "$DMENU_OPTION_4" "Run test server $([ $server_online -eq 0 ] && echo [offline] || echo [online])" \
      "$DMENU_OPTION_5" "Stop test server" \
      3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show nmap main menu
        source $PROJ_ROOT_DIR/modules/network/nmap/nmap.sh dialog_modules_network_nmap_main
        ;;

      $DMENU_OPTION_2) # show siege main menu
        source $PROJ_ROOT_DIR/modules/network/siege/siege.sh dialog_modules_network_siege_main
        ;;

      $DMENU_OPTION_3) # show httperf main menu
        source $PROJ_ROOT_DIR/modules/network/httperf/httperf.sh dialog_modules_network_httperf_main
        ;;

      $DMENU_OPTION_4) # run test server
        log=$PROJ_ROOT_DIR/out/nohup_ts$(date +%F_%H-%M-%S)
        nohup bash $PROJ_ROOT_DIR/run-ts.sh &>$log &
        server_online=1
        ;;

      $DMENU_OPTION_5) # stop test server
        stop_test_server
        ;;

      esac

      ;;

    $DIALOG_CANCEL)
      stop_test_server
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      stop_test_server
      CLEAR_EXIT
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
