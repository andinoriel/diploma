#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_module_network_main() {
  local server_online=0
  local log=""

  while true; do
    option=$($DIALOG --clear --title "Choose an app" \
      --menu "Please select an app:" 20 50 4 \
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
        if [ $server_online -eq 0 ]; then
          log=$PROJ_ROOT_DIR/out/test_server$(date +%F_%H-%M-%S).log
          nohup bash -c \
            "PROJ_ROOT_DIR=$PROJ_ROOT_DIR; source $PROJ_ROOT_DIR/utility/common.sh network_run_test_server" &>$log &
          server_online=1

          $DIALOG --title "Success" --msgbox "\nTest server is available on https://127.0.0.1:4723" 7 55 3>&1 1>&2 2>&3
        fi
        ;;

      $DMENU_OPTION_5) # stop test server
        if [ $server_online -eq 1 ]; then
          source $PROJ_ROOT_DIR/utility/common.sh network_stop_test_server
          server_online=0
        fi
        ;;

      esac

      ;;

    $DIALOG_CANCEL)
      source $PROJ_ROOT_DIR/utility/common.sh network_stop_test_server
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      source $PROJ_ROOT_DIR/utility/common.sh network_stop_test_server
      clear
      return $DIALOG_ESC
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
