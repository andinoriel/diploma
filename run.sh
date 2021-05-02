#!/bin/bash

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma"}

source $PROJ_ROOT_DIR/utility/utility.sh

# say hello
source $PROJ_ROOT_DIR/modules/greetings.sh dialog_greetings

# show main menu
source $PROJ_ROOT_DIR/modules/modules.sh dialog_modules_main
