#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

check_input() {
  local correct=1

  if [ "$ipp" == "" ]; then
    correct=0
    $DIALOG --title "Error" --msgbox "Please specify ip and port..." 10 40
  fi
  if [ $concurrent -eq 0 ]; then
    correct=0
    $DIALOG --title "Error" --msgbox "Please specify concurrent users count..." 10 40
  fi
  if [ $repeat -eq 0 ]; then
    correct=0
    $DIALOG --title "Error" --msgbox "Please specify repeat times count..." 10 40
  fi

  retval=$correct
}

dialog_modules_network_siege_main() {
  local ipp=""
  local concurrent=0
  local repeat=0

  while true; do
    option=$($DIALOG --clear --title "Siege - Set up stress-test" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Specify IP:port $([ -z $ipp ] && echo || echo [$ipp])" \
      "$DMENU_OPTION_2" "Specify concurrent users count $([ $concurrent -eq 0 ] && echo || echo [$concurrent])" \
      "$DMENU_OPTION_3" "Specify repeat times count $([ $repeat -eq 0 ] && echo || echo [$repeat])" \
      "" "" \
      "$DMENU_OPTION_4" "Run benchmark stress-test" \
      "$DMENU_OPTION_5" "Pull down HTTP headers" \
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
        text="Enter concurrent users count"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_num "\${title}" "\${text}"
        concurrent=$retval
        ;;

      $DMENU_OPTION_3)
        title=""
        text="Enter repeat times count"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_num "\${title}" "\${text}"
        repeat=$retval
        ;;

      $DMENU_OPTION_4)
        check_input
        correct=$retval

        if [ $correct -eq 1 ]; then
          if $DIALOG --clear --stdout --title "Note" \
            --yesno "Please note that the operation may take a long time" 10 40; then

            local log=$PROJ_ROOT_DIR/out/siege$(date +%F_%H-%M-%S).log
            siege -c $concurrent -r $repeat -b "$ipp" 2>&1 1>/dev/null | tee "$log" |
              $DIALOG --clear --progressbox 40 100
            $DIALOG --clear --textbox "$log" 40 100
            rm -rf $log

          else
            continue
          fi
        fi
        ;;

      $DMENU_OPTION_5)
        correct=1
        if [ "$ipp" == "" ]; then
          $DIALOG --title "Error" --msgbox "Please specify ip and port..." 10 40
          correct=0
        fi

        if [ $correct -eq 1 ]; then
          local log=$PROJ_ROOT_DIR/out/siege$(date +%F_%H-%M-%S).log
          siege -g "$ipp" 2>/dev/null | tee "$log" | $DIALOG --clear --progressbox 40 100
          $DIALOG --clear --textbox "$log" 40 100 # TODO: fix empty output
          rm -rf $log
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
