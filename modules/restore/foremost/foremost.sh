#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_restore_foremost_main() {
  #region ROOT IS REQUIRED

  source $PROJ_ROOT_DIR/utility/common.sh dialog_get_all_partitions
  if [ $? -eq $RC_ERROR ]; then
    return
  fi
  partitions=$retval

  #endregion

  IFS=', ' read -r -a partitions <<<"$partitions"
  local menulist=()
  for i in $(seq 1 ${#partitions[@]}); do
    menulist+=("$DMENU_OPTION_$i" "${partitions[i - 1]}")
  done

  while true; do
    option=$($DIALOG --clear --title "Foremost - Choose partition" \
      --menu "" 20 50 4 \
      "${menulist[@]}" \
      3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      outdir=$PROJ_ROOT_DIR/out/foremost$(date +%F_%H-%M-%S)
      mkdir -p "$outdir"

      let len=$(expr ${#menulist[@]} / 2)
      for i in $(seq 1 $len); do
        if [ $option -eq $i ]; then
          let index=$(expr $i + $i)
          let index=$(expr $index - 1)

          #region ROOT IS REQUIRED

          SUDO_CRED_LOCK_RESET

          source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
          if [ $? -eq $RC_ERROR ]; then
            continue
          fi
          rpass=$retval

          echo "$rpass" | sudo -S -k foremost -t all -a -i "${menulist[$index]}" -o "$outdir" -v |
            $DIALOG --clear --title "Foremost - Restoring" --programbox 30 100

          SUDO_CRED_LOCK_RESET

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
