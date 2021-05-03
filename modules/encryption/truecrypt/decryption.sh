#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_truecrypt_decrypt() {
  local filepath=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "TrueCrypt - Decryption" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Choose TrueCrypt container..." \
      "$DMENU_OPTION_2" "Enter password..." \
      "$DMENU_OPTION_3" "Process" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_choose_filepath
        filepath=$retval
        ;;

      $DMENU_OPTION_2)
        title=""
        text="Enter password"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_enter_password "\${title}" "\${text}"
        password=$retval
        ;;

      $DMENU_OPTION_3)
        correct=1

        if [ "$filepath" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose file..." 10 40
        fi
        if [ "$password" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please enter password..." 10 40
        fi

        if [ $correct -eq 1 ]; then

          filename=$(basename "$filepath")

          #region ROOT IS REQUIRED

          sudo -k
          faillock --reset

          #region GET ROOT & VALIDATE

          title="ROOT ACCESS IS REQUIRED"
          text="\nEnter your ROOT password"
          source $PROJ_ROOT_DIR/utility/common.sh dialog_enter_password "\${title}" "\${text}"
          rpass=$retval

          export HISTIGNORE='*sudo -S*'

          # validate root password(just random command)
          prompt=$(
            echo "$rpass" | sudo -S uname -a 2>&1
            sudo -S -nv 2>&1
          )
          if [ $? -ne 0 ]; then
            $DIALOG --title "Error" --msgbox "Wrong password" 10 40
            continue
          fi

          #endregion

          mntdir=$PROJ_ROOT_DIR/out/mnt$$
          mkdir -p $mntdir
          mkdir -p $PROJ_ROOT_DIR/out/$filename.dir

          # mount volume from a given path
          echo "$rpass" | sudo -S -k truecrypt \
            --password="$password" --mount "$filepath" "$mntdir"

          # move file(s) from the volume
          mv "$mntdir"/* $PROJ_ROOT_DIR/out/"$filename".dir

          # unmount volume
          echo "$rpass" | sudo -S -k truecrypt -d "$filepath"

          # delete volume
          rm -f "$filepath"

          rmdir "$mntdir"

          sudo -k
          faillock --reset

          #endregion

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
