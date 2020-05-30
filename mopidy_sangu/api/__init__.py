import string
import random

from mopidy_sangu.api.admin import AdminRequestHandler
from mopidy_sangu.api.unvote import UnVoteRequestHandler
from mopidy_sangu.api.vote import VoteRequestHandler
from mopidy_sangu.api.config import ConfigRequestHandler
from mopidy_sangu.api.vote_data import VoteDataRequestHandler


def sangu_factory(config, core):
    vote_data = {}
    session_id = get_random_alpha_numeric_string()

    return [
        ('/api/track/(\\d+)?/vote', VoteRequestHandler, {'core': core, "vote_data": vote_data}),
        ('/api/track/(\\d+)?/unvote', UnVoteRequestHandler, {'core': core, "vote_data": vote_data}),
        ('/api/config', ConfigRequestHandler, {'core': core, "config": config, 'session_id': session_id}),
        ('/api/votes', VoteDataRequestHandler, {'core': core, "vote_data": vote_data}),
        ('/api/admin/login', AdminRequestHandler, {'core': core, "config": config})
    ]


def get_random_alpha_numeric_string(length=8):
    return ''.join((random.choice(string.ascii_letters + string.digits) for i in range(length)))
