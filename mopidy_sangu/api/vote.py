import logging

import tornado.web

from mopidy_sangu.storage import VoteDatabaseProvider

logger = logging.getLogger(__name__)


def get_new_index(core, votes: VoteDatabaseProvider, track_id):
    from itertools import count

    index = core.tracklist.index().get()
    track_queue = core.tracklist.slice(start=index, end=None).get()
    track_queue.pop(0)
    sorted_queue = sorted(
        track_queue,
        key=lambda track: (
            -votes.get_votes_for_track(str(track.tlid)),
            track.tlid,
        ),
    )
    return (
        [i for i, j in zip(count(), sorted_queue) if j.tlid == track_id][0]
        + 1
        + index
    )


class VoteRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, votes: VoteDatabaseProvider):
        self.core = core
        self.votes = votes

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

    def post(self, track_list_id):
        logger.info("Voting for track with id {}".format(track_list_id))
        current_index = self.core.tracklist.index(tlid=int(track_list_id)).get()
        self.votes.vote_for_track(track_list_id)
        if current_index is None:
            self.write("No record of track with ID {}".format(track_list_id))
            self.set_status(status_code=400, reason="Bad track ID")
        else:
            if current_index > 1:
                logger.debug("Track needs a new index")
                new_index = get_new_index(
                    self.core, self.votes, int(track_list_id)
                )
                track_length = (
                    self.core.playback.get_current_track().get().length
                )
                current_seek_time = self.core.playback.get_time_position().get()
                if new_index == 1 and current_seek_time + 5000 > track_length:
                    logger.debug(
                        "Playing track is nearly finished - moving song after the next track"
                    )
                    new_index = new_index + 1
            else:
                logger.debug("Track doesn't need to move")
                new_index = current_index
            self.core.tracklist.move(
                current_index, current_index, new_index
            ).get()
            self.write("Voted")

    def get(self, track_list_id):
        logger.info("Getting votes for track with id {}".format(track_list_id))
        votes: int = self.votes.get_votes_for_track(track_list_id)
        self.write({"votes": votes})
