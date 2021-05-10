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
          if dialog --clear --stdout --title "Note" \
            --yesno "Please note that the operation may take a long time" 20 40; then
            echo "" | $DIALOG --clear --progressbox 20 70

            outd=$PROJ_ROOT_DIR/out/siege$(date +%F_%H-%M-%S)
            mkdir -p "$outd"
            tmp=$outd/log.json
            touch $tmp

            siege -c $concurrent -r $repeat -b -j "$ipp" >$tmp 2>/dev/null
            $PROJ_ROOT_DIR/modules/network/siege/jparse.py $tmp |
              $DIALOG --clear --title "=== SUMMARY ===" --programbox 20 70

            rm -rf $outd

          else
            continue
          fi

        fi

        ;;

      $DMENU_OPTION_5)
        check_input
        correct=$retval

        if [ $correct -eq 1 ]; then
          outd=$PROJ_ROOT_DIR/out/siege$(date +%F_%H-%M-%S)
          mkdir -p "$outd"
          tmp=$outd/log
          touch $tmp

          siege -g "$ipp" >$tmp 2>/dev/null
          cat $tmp | $DIALOG --clear --programbox 40 100
          rm -rf $outd
        fi
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
