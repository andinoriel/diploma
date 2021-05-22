#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

init() {
  /usr/bin/env pip3 install falcon==3.0.0 gunicorn==20.1.0
}

run() {
  gunicorn extern.server:app --reload -b 0.0.0.0:4723
}

RESOLVE_FUNC_CALL $@
