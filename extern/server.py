#!/usr/bin/env python3

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
