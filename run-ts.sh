#!/bin/bash

if [ "$EUID" -eq 0 ]; then
  echo "Running as root is not allowed"
  exit $RC_ERROR
fi

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma"}

source $PROJ_ROOT_DIR/utility/utility.sh

# run test server
source $PROJ_ROOT_DIR/extern/server.sh init
source $PROJ_ROOT_DIR/extern/server.sh run