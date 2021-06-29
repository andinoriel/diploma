#!/bin/bash

# =================================================================
#
#   TOP-MODULE: modules:modules
#   LOCAL ENTRY POINT: dialog_modules_main
#
#   modules
#   |-- encryption
#   |-- network
#   |-- restore
#   |-- greetings.sh
#   |-- modules.sh *CURRENT*
#
#   COMMENT: main modules dialog
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_main() {
  while true; do
    option=$($DIALOG --clear --title "Choose an module" \
      --menu "Please select an app module:" 20 50 4 \
      "$DMENU_OPTION_1" "Data encryption" \
      "$DMENU_OPTION_2" "Networking" \
      "$DMENU_OPTION_3" "Restoring" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show encryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/encryption.sh dialog_modules_encryption_main
        ;;

      $DMENU_OPTION_2) # show network main menu
        source $PROJ_ROOT_DIR/modules/network/network.sh dialog_module_network_main
        ;;

      $DMENU_OPTION_3) # show restore main menu
        source $PROJ_ROOT_DIR/modules/restore/restore.sh dialog_module_restore_main
        ;;

      esac
      ;;

    $DIALOG_CANCEL)
      clear
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
