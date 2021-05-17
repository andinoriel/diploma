#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

init() {
  /usr/bin/pip3 install falcon==3.0.0
}

run() {
  /usr/bin/env python3 $PROJ_ROOT_DIR/extern/server.py
}

RESOLVE_FUNC_CALL $@
