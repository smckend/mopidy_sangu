import logging

import tornado.web

logger = logging.getLogger(__name__)


class ConfigRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, config, session_id):
        self.core = core
        self.enable_play_button = config["sangu"]["enable_play_button"]
        self.stream_url = config["sangu"]["stream_url"]
        self.session_id = session_id

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "GET, OPTIONS")

    def get(self):
        logger.info("Getting config")
        self.write(
            {
                "config": {
                    "sessionId": self.session_id,
                    "streamUrl": self.stream_url,
                    "enablePlayButton": self.enable_play_button,
                }
            }
        )
