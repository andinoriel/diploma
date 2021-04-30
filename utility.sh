#!/bin/bash

: ${DIALOG=${DIALOG=dialog}}

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

# if [ -z $DISPLAY ]
# then
#     DIALOG=dialog
# else
#     DIALOG=Xdialog
# fi

: ${RC_OK=0}
: ${RC_ERROR=1}

# RESOLVE_FUNC_CALL $1
RESOLVE_FUNC_CALL() {
  if declare -f "$1" >/dev/null; then
    "$@"
  else
    echo "'$1' is not a known function name" >&2
    exit $RC_ERROR
  fi
}
