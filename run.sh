#!/bin/bash

if [ "$EUID" -eq 0 ]; then
  echo "Running as root is not allowed"
  exit $RC_ERROR
fi

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma"}

source $PROJ_ROOT_DIR/utility/utility.sh

# say hello
source $PROJ_ROOT_DIR/modules/greetings.sh dialog_greetings

# show main menu
source $PROJ_ROOT_DIR/modules/modules.sh dialog_modules_main
