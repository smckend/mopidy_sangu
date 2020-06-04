import logging
import sqlite3

from mopidy_sangu import Extension
from mopidy_sangu.storage.storage import (
    create_connection,
    create_vote_table,
    clear,
    get_votes,
    increase_votes,
    decrease_votes,
    get_all_votes,
)

logger = logging.getLogger(__name__)


class VoteDatabaseProvider:
    def __init__(self, config):
        self._data_dir = Extension.get_data_dir(config)
        self._db_path = self._data_dir / "vote_data.db"
        self._connection = None
        logger.info("Database path: {}".format(self._db_path))

    def setup(self):
        with self._connect() as connection:
            logger.info("SQLite version: {}".format(sqlite3.version))
            create_vote_table(connection)

    def close(self):
        if self._connection:
            self._connection.commit()
            self._connection.close()
            self._connection = None
        else:
            logger.error("Attempting to close database while not connected")

    def clear(self):
        logger.info("Clearing database")
        try:
            clear(self._connect())
            return True
        except sqlite3.Error as e:
            logger.error("Error clearing database: %s", e)
            return False

    def get_all_votes(self):
        with self._connect() as connection:
            results = get_all_votes(connection)
            all_votes = {result[0]: result[1] for result in results}
            return all_votes

    def get_votes_for_track(self, track_id) -> int:
        with self._connect() as connection:
            result = get_votes(connection, track_id)
        if result is None:
            return int(0)
        return int(result[0])

    def vote_for_track(self, track_id):
        with self._connect() as connection:
            increase_votes(connection, track_id)

    def revert_vote_for_track(self, track_id):
        with self._connect() as connection:
            decrease_votes(connection, track_id)

    def _connect(self):
        if not self._connection:
            self._connection = create_connection(self._db_path)
        return self._connection
