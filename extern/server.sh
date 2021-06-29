#!/bin/bash

# =================================================================
#
#   MODULE: extern:server
#   LOCAL ENTRY POINT: *multiple*
#
#   extern
#   |-- docker-compose.yml
#   |-- Dockerfile
#   |-- server.py
#   |-- server.sh *CURRENT*
#
#   COMMENT: functions to work with test server
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

init() {
  /usr/bin/env pip3 install falcon==3.0.0 gunicorn==20.1.0
}

run() {
  gunicorn extern.server:app --reload -b 0.0.0.0:4723
}

RESOLVE_FUNC_CALL $@
