#!/usr/bin/env python3

# =================================================================
#
#   MODULE: extern:server
#   LOCAL ENTRY POINT: .
#
#   extern
#   |-- docker-compose.yml
#   |-- Dockerfile
#   |-- server.py *CURRENT*
#   |-- server.sh
#
#   COMMENT: test server that giving random KB of data
#
# =================================================================

# see more https://github.com/andinoriel/diploma-nms

import falcon

import random
import string


class MainController:
    def on_get(self, req, resp):
        resp.text = "".join(random.choice(string.digits) for i in range(1024))
        resp.status = falcon.HTTP_200


app = falcon.App()
app.add_route("/", MainController())
