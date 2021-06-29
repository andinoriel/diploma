#!/bin/bash

# =================================================================
#
#   TOP-LEVEL: run:run
#   LOCAL ENTRY POINT: .
#
#   ./
#   |-- extern
#   |-- modules
#   |-- utility
#   |-- run.sh *CURRENT*
#
#   COMMENT: application entry point
#
# =================================================================

if [ "$EUID" -eq 0 ]; then
  echo "Running as root is not allowed"
  exit $RC_ERROR
fi

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma"}

export DIALOGRC=$PROJ_ROOT_DIR/utility/.default.dialogrc

app_cleanup() {
  rm -rf $PROJ_ROOT_DIR/out/*.log

  truecrypt -t -d # #?
  vearcrypt -t -d # #?

  source $PROJ_ROOT_DIR/utility/common.sh network_stop_test_server

  unset DIALOGRC
}

trap ctrl_c INT
ctrl_c() {
  app_cleanup
  CLEAR_EXIT
}

mkdir -p $PROJ_ROOT_DIR/out/

source $PROJ_ROOT_DIR/utility/utility.sh

# say hello
source $PROJ_ROOT_DIR/modules/greetings.sh dialog_greetings

# show main menu
source $PROJ_ROOT_DIR/modules/modules.sh dialog_modules_main

ctrl_c
