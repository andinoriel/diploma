#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

choose_encalg() {
  local tempfile=$(mktemp 2>/dev/null)
  trap "rm -f $tempfile" 0 1 2 5 15

  $DIALOG --clear --title "Choose the encryption algorithm" \
    --menu "" 20 50 4 \
    "$DMENU_OPTION_1" "AES" \
    "$DMENU_OPTION_2" "Serpent" \
    "$DMENU_OPTION_3" "Twofish" \
    "$DMENU_OPTION_4" "AES-Twofish" \
    "$DMENU_OPTION_5" "AES-Twofish-Serpent" \
    "$DMENU_OPTION_6" "Serpent-AES" \
    "$DMENU_OPTION_7" "Serpent-Twofish-AES" \
    "$DMENU_OPTION_8" "Twofish-Serpent" 2>$tempfile

  case $? in
  $DIALOG_OK)
    local option=$(cat $tempfile)

    case $option in
    $DMENU_OPTION_1)
      retval="AES"
      ;;

    $DMENU_OPTION_2)
      retval="Serpent"
      ;;

    $DMENU_OPTION_3)
      retval="Twofish"
      ;;

    $DMENU_OPTION_4)
      retval="AES-Twofish"
      ;;

    $DMENU_OPTION_5)
      retval="AES-Twofish-Serpent"
      ;;

    $DMENU_OPTION_6)
      retval="Serpent-AES"
      ;;

    $DMENU_OPTION_7)
      retval="Serpent-Twofish-AES"
      ;;

    $DMENU_OPTION_8)
      retval="Twofish-Serpent"
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
}

dialog_modules_encryption_truecrypt_encrypt() {
  local filepath=""
  local encalg=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "Encryption" \
      --menu "" 20 50 4 \
      "$DMENU_OPTION_1" "Choose file..." \
      "$DMENU_OPTION_2" "Choose algorithm..." \
      "$DMENU_OPTION_3" "Enter password..." \
      "$DMENU_OPTION_4" "Process" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_choose_filepath
        filepath=$retval
        ;;

      $DMENU_OPTION_2)
        choose_encalg
        encalg=$retval
        ;;

      $DMENU_OPTION_3)
        title=""
        text="Enter password"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_enter_password "\${title}" "\${text}"
        password=$retval
        ;;

      $DMENU_OPTION_4)
        correct=1

        if [ "$filepath" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose file..." 10 40
        fi
        if [ "$encalg" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose encryption algorithm..." 10 40
        fi
        if [ "$password" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please enter password..." 10 40
        fi

        if [ $correct -eq 1 ]; then

          filesize=$(wc -c <$filepath)
          [ $filesize -lt 299008 ] && size=299008 || size=$filesize

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
          mkdir -p "$mntdir"

          # creating tc volume
          # note: --hash=<RIPEMD-160|SHA-512|Whirlpool>
          (truecrypt -t --size=$size --password="$password" -k "" \
            --random-source=/dev/urandom --volume-type=normal \
            --encryption=$encalg --hash=SHA-512 --filesystem=FAT \
            -c "$PROJ_ROOT_DIR/out/$filename.tc" 2>&1) | dialog --programbox 20 70

          # mount created volume
          echo "$rpass" | sudo -S -k truecrypt \
            --password="$password" --mount "$PROJ_ROOT_DIR/out/$filename.tc" "$mntdir"

          # copy selected file to the volume
          cp "$filepath" "$mntdir"

          # unmount created volume
          echo "$rpass" | sudo -S -k truecrypt -d "$PROJ_ROOT_DIR/out/$filename.tc"

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
