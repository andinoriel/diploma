#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

choose_encalg() {
  option=$($DIALOG --clear --title "Choose the encryption algorithm" \
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
    "$DMENU_OPTION_15" "Twofish-Serpent" 3>&1 1>&2 2>&3)

  case $? in
  $DIALOG_OK)
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
  local path=""
  local encalg=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "VeraCrypt - Encryption" \
      --menu "" 20 70 4 \
      "$DMENU_OPTION_1" "Choose file or dir... $([ -z $path ] && echo || echo [$(basename "$path")])" \
      "$DMENU_OPTION_2" "Choose algorithm... $([ -z $encalg ] && echo || echo [$encalg])" \
      "$DMENU_OPTION_3" "Enter password... $([ -z $password ] && echo || echo [*])" \
      "$DMENU_OPTION_4" "Process" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_path
        path=$retval
        ;;

      $DMENU_OPTION_2)
        choose_encalg
        encalg=$retval
        ;;

      $DMENU_OPTION_3)
        title=""
        text="Enter password"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_password "\${title}" "\${text}"
        password=$retval
        ;;

      $DMENU_OPTION_4)
        correct=1

        if [ "$path" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose file or dir..." 10 40
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

          fdsize=$(du -sb $path | cut -f1)
          # case 1: min FAT size - 299008
          # case 2: $fdsize + extra space at 2 percent
          [ $fdsize -lt 299008 ] && size=299008 || size=$(($fdsize + $fdsize / 100 * 2))

          fdname=$(basename "$path")

          #region ROOT IS REQUIRED

          SUDO_CRED_LOCK_RESET
          source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
          if [ $? -eq $RC_ERROR ]; then
            continue
          fi
          rpass=$retval

          mntdir=$PROJ_ROOT_DIR/out/mnt$(date +%F_%H-%M-%S)
          mkdir -p "$mntdir"

          # creating vc volume
          # note: --hash=<RIPEMD-160|SHA-256|SHA-512|Whirlpool|Streebog>
          (veracrypt -t --size=$size --password="$password" -k "" \
            --random-source=/dev/urandom --volume-type=normal \
            --encryption=$encalg --hash=SHA-512 --filesystem=FAT \
            --pim=0 -c "$PROJ_ROOT_DIR/out/$fdname.vc" 2>&1) | dialog --programbox 20 70

          # mount created volume
          echo "$rpass" | sudo -S -k veracrypt \
            --password="$password" --mount "$PROJ_ROOT_DIR/out/$fdname.vc" "$mntdir"

          # copy selected file or dir to the volume
          cp -r "$path" "$mntdir"

          # unmount created volume
          echo "$rpass" | sudo -S -k veracrypt -d "$PROJ_ROOT_DIR/out/$fdname.vc"

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
      CLEAR_EXIT
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
