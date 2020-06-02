import logging

import tornado.web

logger = logging.getLogger(__name__)


class UnVoteRequestHandler(tornado.web.RequestHandler):
    def initialize(self, core, vote_data):
        self.core = core
        self.vote_data = vote_data

    def data_received(self, chunk):
        pass

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header("Access-Control-Allow-Methods", "POST, OPTIONS")

    def post(self, track_list_id):
        def get_new_index(track_id):
            from itertools import count

            track_queue = self.core.tracklist.get_tl_tracks().get()
            track_queue.pop(0)
            sorted_queue = sorted(
                track_queue,
                key=lambda track: (
                    -self.vote_data.get(str(track.tlid), 0),
                    track.tlid,
                ),
            )
            return [
                i for i, j in zip(count(), sorted_queue) if j.tlid == track_id
            ][0] + 1

        logger.info("Unvoting for track with id {}".format(track_list_id))
        existing_votes = self.vote_data.get(track_list_id, 0)
        if existing_votes > 0:
            self.vote_data[track_list_id] = existing_votes - 1
            current_index = self.core.tracklist.index(
                tlid=int(track_list_id)
            ).get()
            logger.debug("Track needs a new index")
            new_index = get_new_index(int(track_list_id))
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
        else:
            self.write("No votes for track")
            self.set_status(status_code=400, reason="No votes for track")
