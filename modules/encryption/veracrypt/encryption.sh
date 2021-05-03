#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

choose_encalg() {
  local tempfile=$(mktemp 2>/dev/null)
  trap "rm -f $tempfile" 0 1 2 5 15

  $DIALOG --clear --title "Choose the encryption algorithm" \
    --menu "" 20 50 4 \
    "$DMENU_OPTION_1" "AES" \
    "$DMENU_OPTION_2" "Camellia" \
    "$DMENU_OPTION_3" "Kuznyechik" \
    "$DMENU_OPTION_4" "Serpent" \
    "$DMENU_OPTION_5" "Twofish" \
    "$DMENU_OPTION_6" "AES-Twofish" \
    "$DMENU_OPTION_7" "AES-Twofish-Serpent" \
    "$DMENU_OPTION_8" "Camellia-Kuznyechik" \
    "$DMENU_OPTION_9" "Camellia-Serpent" \
    "$DMENU_OPTION_10" "Kuznyechik-AES" \
    "$DMENU_OPTION_11" "Kuznyechik-Serpent-Camellia" \
    "$DMENU_OPTION_12" "Kuznyechik-Twofish" \
    "$DMENU_OPTION_13" "Serpent-AES" \
    "$DMENU_OPTION_14" "Serpent-Twofish-AES" \
    "$DMENU_OPTION_15" "Twofish-Serpent" 2>$tempfile

  case $? in
  $DIALOG_OK)
    local option=$(cat $tempfile)

    case $option in
    $DMENU_OPTION_1)
      retval="AES"
      ;;

    $DMENU_OPTION_2)
      retval="Camellia"
      ;;

    $DMENU_OPTION_3)
      retval="Kuznyechik"
      ;;

    $DMENU_OPTION_4)
      retval="Serpent"
      ;;

    $DMENU_OPTION_5)
      retval="Twofish"
      ;;

    $DMENU_OPTION_6)
      retval="AES-Twofish"
      ;;

    $DMENU_OPTION_7)
      retval="AES-Twofish-Serpent"
      ;;

    $DMENU_OPTION_8)
      retval="Camellia-Kuznyechik"
      ;;

    $DMENU_OPTION_9)
      retval="Camellia-Serpent"
      ;;

    $DMENU_OPTION_10)
      retval="Kuznyechik-AES"
      ;;

    $DMENU_OPTION_11)
      retval="Kuznyechik-Serpent-Camellia"
      ;;

    $DMENU_OPTION_12)
      retval="Kuznyechik-Twofish"
      ;;

    $DMENU_OPTION_13)
      retval="Serpent-AES"
      ;;

    $DMENU_OPTION_14)
      retval="Serpent-Twofish-AES"
      ;;

    $DMENU_OPTION_15)
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

dialog_modules_encryption_veracrypt_encrypt() {
  local filepath=""
  local encalg=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "VeraCrypt - Encryption" \
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

          # creating vc volume
          # note: --hash=<RIPEMD-160|SHA-256|SHA-512|Whirlpool|Streebog>
          (veracrypt -t --size=$size --password="$password" -k "" \
            --random-source=/dev/urandom --volume-type=normal \
            --encryption=$encalg --hash=SHA-512 --filesystem=FAT \
            --pim=0 -c "$PROJ_ROOT_DIR/out/$filename.vc" 2>&1) | dialog --programbox 20 70

          # mount created volume
          echo "$rpass" | sudo -S -k veracrypt \
            --password="$password" --mount "$PROJ_ROOT_DIR/out/$filename.vc" "$mntdir"

          # copy selected file to the volume
          cp "$filepath" "$mntdir"

          # unmount created volume
          echo "$rpass" | sudo -S -k veracrypt -d "$PROJ_ROOT_DIR/out/$filename.vc"

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
