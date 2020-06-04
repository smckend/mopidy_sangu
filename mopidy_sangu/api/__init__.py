import logging
import string
import random

from mopidy_sangu.storage import VoteDatabaseProvider
from mopidy_sangu.api.admin import AdminRequestHandler
from mopidy_sangu.api.unvote import UnVoteRequestHandler
from mopidy_sangu.api.vote import VoteRequestHandler
from mopidy_sangu.api.config import ConfigRequestHandler
from mopidy_sangu.api.vote_data import VoteDataRequestHandler

logger = logging.getLogger(__name__)


def sangu_factory(config, core):
    session_id = get_random_alpha_numeric_string()
    votes = VoteDatabaseProvider(config)
    votes.setup()
    votes.clear()
    core.tracklist.set_consume(value=True).get()

    return [
        (
            "/api/track/(\\d+)?/vote",
            VoteRequestHandler,
            {"core": core, "votes": votes},
        ),
        (
            "/api/track/(\\d+)?/unvote",
            UnVoteRequestHandler,
            {"core": core, "votes": votes},
        ),
        ("/api/votes", VoteDataRequestHandler, {"core": core, "votes": votes},),
        (
            "/api/config",
            ConfigRequestHandler,
            {"core": core, "config": config, "session_id": session_id},
        ),
        (
            "/api/admin/login",
            AdminRequestHandler,
            {"core": core, "config": config},
        ),
    ]


def get_random_alpha_numeric_string(length=8):
    return "".join(
        (
            random.choice(string.ascii_letters + string.digits)
            for i in range(length)
        )
    )
