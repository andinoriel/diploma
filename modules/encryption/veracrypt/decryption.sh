#!/bin/bash

# =================================================================
#
#   SUBMODULE: veracrypt:decryption
#   LOCAL ENTRY POINT: dialog_modules_encryption_veracrypt_decrypt
#
#   veracrypt
#   |-- veracrypt.sh
#   |-- bench.sh
#   |-- encryption.sh
#   |-- decryption.sh *CURRENT*
#
#   COMMENT: encryption:veracrypt decrypt menu DIALOG
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_veracrypt_decrypt() {
  local path=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "VeraCrypt - Decryption" \
      --menu "" 20 70 4 \
      "$DMENU_OPTION_1" "Choose TrueCrypt container... $([ -z $path ] && echo || echo [$(basename "$path")])" \
      "$DMENU_OPTION_2" "Enter password... $([ -z $password ] && echo || echo [*])" \
      "$DMENU_OPTION_3" "Process" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_path
        path=$retval
        ;;

      $DMENU_OPTION_2)
        title=""
        text="Enter password"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_password "\${title}" "\${text}"
        password=$retval
        ;;

      $DMENU_OPTION_3)
        correct=1

        if [ "$path" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose VeraCrypt container..." 10 40
        fi
        if [ "$password" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please enter password..." 10 40
        fi

        if [ $correct -eq 1 ]; then

          fdname=$(basename "$path")

          #region ROOT IS REQUIRED

          SUDO_CRED_LOCK_RESET

          source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
          if [ $? -eq $RC_ERROR ]; then
            continue
          fi
          rpass=$retval

          mntdir=$PROJ_ROOT_DIR/out/mnt$(date +%F_%H-%M-%S)
          mkdir -p $mntdir
          mkdir -p $PROJ_ROOT_DIR/out/$fdname.dir

          # mount volume from a given path
          sudo -S -k -p "" veracrypt -t --pim=0 --keyfiles="" --protect-hidden=no \
            --password="$password" --mount "$path" "$mntdir" <<<"$rpass"

          # move file(s) from the volume
          shopt -s dotglob nullglob
          mv "$mntdir"/* $PROJ_ROOT_DIR/out/"$fdname".dir

          # unmount volume
          sudo -S -k -p "" veracrypt -t -d "$path" <<<"$rpass"

          # delete volume
          rm -f "$path"

          rmdir "$mntdir"

          SUDO_CRED_LOCK_RESET

          #endregion

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
