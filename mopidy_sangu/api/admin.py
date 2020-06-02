import logging

import tornado.web

logger = logging.getLogger(__name__)


class AdminRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, config):
        self.core = core
        self.password = config["sangu"]["admin_password"]

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

    def post(self):
        logger.info("Attempting to log in")
        password = self.get_body_argument(name="password", default="")
        self.write({"logged_in": password == self.password})
