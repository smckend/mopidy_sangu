import logging

import pykka
from random import shuffle
from mopidy.core import CoreListener

logger = logging.getLogger(__name__)


class FallbackMusicActor(pykka.ThreadingActor, CoreListener):
    def __init__(self, config, core):
        super().__init__()

        self.fallback_uri = config["sangu"].get("fallback_playlist_uri", None)
        self.shuffle_fallback_playlist = config["sangu"].get(
            "shuffle_fallback_playlist", False
        )
        self.core = core
        self.fallback_track_list = None
        self.fallback_index = 0
        logger.info("FallbackPlaylist is: {}".format(self.fallback_uri))

    def tracklist_changed(self):
        logger.info("Checking state of tracklist...")
        if self.fallback_track_list is None:
            logger.info("Fetching fallback tracklist...")
            lookup_result = self.core.library.lookup(
                uris=[self.fallback_uri]
            ).get()
            lookup_track_list = lookup_result[self.fallback_uri]
            if self.shuffle_fallback_playlist:
                shuffle(lookup_track_list)
            self.fallback_track_list = lookup_track_list
            logger.info(
                "Fetched {} track(s).".format(len(self.fallback_track_list))
            )
        track_list = self.core.tracklist.get_tl_tracks().get()
        if (
            len(track_list) <= 1
            and len(self.fallback_track_list) > 0
            and self.core.playback.get_state().get() == "playing"
        ):
            logger.info("Adding fallback tracks...")
            for i in range(0, 2 - len(track_list)):
                self.core.tracklist.add(
                    uris=[self.fallback_track_list[self.fallback_index].uri]
                ).get()
                logger.info(
                    "Added track at index {}.".format(self.fallback_index)
                )
                self.fallback_index += 1
                if self.fallback_index > len(self.fallback_track_list) - 1:
                    self.fallback_index = 0
        logger.info("Check finished.")
