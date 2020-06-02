import logging

import tornado.web

logger = logging.getLogger(__name__)


class VoteDataRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, vote_data):
        self.core = core
        self.vote_data = vote_data

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

    def get(self):
        logger.info("Getting vote data")
        self.write({"votes": self.vote_data})
