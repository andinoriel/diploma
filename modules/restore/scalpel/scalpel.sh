#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_restore_scalpel_main() {
  #region ROOT IS REQUIRED

  SUDO_CRED_LOCK_RESET

  source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
  if [ $? -eq $RC_ERROR ]; then
    return
  fi
  local rpass=$retval

  local type=$1
  eval local title="$3"
  partitions=$(echo "$rpass" | sudo -S -k fdisk -l /dev/sda | grep "^/dev" | cut -d" " -f1 | tr "\n" " ")

  SUDO_CRED_LOCK_RESET

  #endregion

  IFS=', ' read -r -a partitions <<<"$partitions"
  menulist=()
  for i in $(seq 1 ${#partitions[@]}); do
    menulist+=("$DMENU_OPTION_$i" "${partitions[i - 1]}")
  done

  while true; do
    option=$($DIALOG --clear --title "Scalpel - choose partition" \
      --menu "" 20 50 4 \
      "${menulist[@]}" \
      3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      outdir=$PROJ_ROOT_DIR/out/scalpel$(date +%F_%H-%M-%S)
      mkdir -p "$outdir"

      let len=$(expr ${#menulist[@]} / 2)
      for i in $(seq 1 $len); do
        if [ $option -eq $i ]; then
          let index=$(expr $i + $i)
          let index=$(expr $index - 1)

          #region ROOT IS REQUIRED
          echo "$rpass" | sudo -S -k scalpel -b -r "${menulist[$index]}" -o "$outdir" |
            dialog --clear --title "test" --programbox 20 100
          #endregion
        fi
      done

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
