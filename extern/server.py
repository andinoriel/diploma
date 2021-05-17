#!/usr/bin/env python3

## see more https://github.com/andinoriel/diploma-nms

import wsgiref.simple_server
import falcon

import random
import string
import sys


class Server:
    server: wsgiref.simple_server = None

    @staticmethod
    def run(app):
        Server.server = wsgiref.simple_server.make_server("", 4723, app)
        print('Serving on port 4723...')
        Server.server.serve_forever()

    @staticmethod
    def stop():
        Server.server.server_close()
        sys.stderr.close()


class MainController:
    def on_get(self, req, resp):
        resp.text = "".join(random.choice(string.digits) for i in range(1024))
        resp.status = falcon.HTTP_200


class StopController:
    def on_get(self, req, resp):
        Server.stop()


if __name__ == '__main__':
    app = falcon.App()
    app.add_route("/", MainController())
    app.add_route("/stop", StopController())

    Server().run(app)
