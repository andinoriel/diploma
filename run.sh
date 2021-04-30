#!/bin/bash

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma"}

source $PROJ_ROOT_DIR/utility/utility.sh

# if [ "$EUID" -ne 0 ]; then
#   echo "Please run as root"
#   exit $RC_ERROR
# fi

# say hello
source $PROJ_ROOT_DIR/greetings.sh dialog_greetings

# show main menu
source $PROJ_ROOT_DIR/modules/modules.sh dialog_modules_main
