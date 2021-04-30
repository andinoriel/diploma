#!/bin/bash

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma"}

source $PROJ_ROOT_DIR/utility.sh

# if [[ "$EUID" -ne 0 ]]; then
#   echo "Please run as root"
#   exit $RC_ERROR
# fi

# say hello
source $PROJ_ROOT_DIR/greetings.sh dialog_greetings

# show main menu
while true; do
  source $PROJ_ROOT_DIR/modules/main.sh dialog_modules_main

  if [[ $? -eq $DIALOG_CANCEL ]]; then
    break
  fi
done
