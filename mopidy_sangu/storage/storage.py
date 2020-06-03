import logging
import sqlite3

from sqlite3 import Error

logger = logging.getLogger(__name__)


def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by db_file
    :param db_file: database file
    :return: Connection object or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db_file, check_same_thread=False)
    except Error as e:
        print(e)

    return conn


def create_vote_table(conn):
    """ create VoteData table
    :param conn: Connection object
    :return:
    """
    try:
        cur = conn.cursor()
        create_table_sql = """ CREATE TABLE IF NOT EXISTS votedata (
                                track_id integer PRIMARY KEY,
                                votes integer NOT NULL); """
        cur.execute(create_table_sql)
    except Error as e:
        print(e)


def get_votes(conn, track_id):
    """
    Get votes for track_id from VoteData table
    :param conn:
    :param track_id:
    :return votes:
    """
    sql = """
    SELECT votes FROM votedata WHERE track_id = ?;
    """
    cur = conn.cursor()
    cur.execute(sql, (track_id,))
    return cur.fetchone()


def get_all_votes(conn):
    """
    Get all data from VoteData table
    :param conn:
    :return all_votes:
    """
    sql = """ SELECT * FROM votedata; """
    cur = conn.cursor()
    cur.execute(sql)
    return cur.fetchall()


def increase_votes(conn, track_id):
    """
    Increase the votes for a given track_id in the VoteData table
    :param conn:
    :param track_id:
    :return:
    """
    sql = """
    INSERT INTO votedata(track_id,votes) VALUES(?,1)
    ON CONFLICT(track_id) DO UPDATE SET votes=votes+1;
    """
    cur = conn.cursor()
    cur.execute(sql, (track_id,))


def decrease_votes(conn, track_id):
    """
    Decrease the votes for a given track_id in the VoteData table
    :param conn:
    :param track_id:
    :return:
    """
    sql = """ UPDATE votedata SET votes = votes - 1 WHERE track_id = ?; """
    cur = conn.cursor()
    cur.execute(sql, (track_id,))


def clear(conn):
    conn.executescript(
        """
    DELETE FROM votedata;
    VACUUM;
    """
    )
