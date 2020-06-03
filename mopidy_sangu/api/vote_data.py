import logging

import tornado.web

from mopidy_sangu.storage import VoteDatabaseProvider

logger = logging.getLogger(__name__)


class VoteDataRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, votes: VoteDatabaseProvider):
        self.core = core
        self.votes = votes

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

    def get(self):
        logger.info("Getting vote data")
        vote_data = self.votes.get_all_votes()
        self.write({"votes": vote_data})
