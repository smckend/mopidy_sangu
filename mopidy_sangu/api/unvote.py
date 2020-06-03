import logging

import tornado.web

from mopidy_sangu.storage import VoteDatabaseProvider
from mopidy_sangu.api.vote import get_new_index

logger = logging.getLogger(__name__)


class UnVoteRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, votes: VoteDatabaseProvider):
        self.core = core
        self.votes = votes

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "POST, OPTIONS")

    def post(self, track_list_id):
        logger.info("Unvoting for track with id {}".format(track_list_id))
        current_index = self.core.tracklist.index(tlid=int(track_list_id)).get()
        existing_votes = self.votes.get_votes_for_track(track_list_id)
        if current_index is None:
            self.write("No record of track with ID {}".format(track_list_id))
            self.set_status(status_code=400, reason="Bad track ID")
        elif existing_votes <= 0:
            self.write("No votes for track")
            self.set_status(status_code=400, reason="Invalid vote")
        else:
            self.votes.revert_vote_for_track(track_list_id)
            logger.debug("Track needs a new index")
            new_index = get_new_index(self.core, self.votes, int(track_list_id))
            track_length = self.core.playback.get_current_track().get().length
            current_seek_time = self.core.playback.get_time_position().get()
            if (
                current_index == 1
                and new_index > 1
                and current_seek_time + 5000 > track_length
            ):
                logger.debug(
                    "Playing track is nearly finished - not moving track"
                )
                new_index = current_index
            self.core.tracklist.move(
                current_index, current_index, new_index
            ).get()
            self.write("Unvoted")
