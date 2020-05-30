****************************
Mopidy-Sangu
****************************

.. image:: https://img.shields.io/pypi/v/Mopidy-Sangu
    :target: https://pypi.org/project/Mopidy-Sangu/
    :alt: Latest PyPI version

Frontend for mopidy to manage a playlist in a diplomatic fashion. Collaborators can add and vote for songs they'd like
to hear, and everyone's song choice will be played eventually with no skipping currently allowed. Democracy.


Installation
============

Install by running::

    pip install Mopidy-Sangu

Configuration
=============

Before starting Mopidy, you must add configuration for
Mopidy-Sangu to your Mopidy configuration file::

    [sangu]
    enabled = true
    admin_password = <some-pass>
    enable_play_button = <bool> # optional
    fallback_playlist_uri = <some-supported-uri-of-playlist-or-album> # optional
    shuffle_fallback_playlist = <bool> # optional
    stream_url = <url-mopidy-output-is-streamed-to> # optional


Project resources
=================

- `Source code <https://github.com/smckend/mopidy-sangu>`_
- `Issue tracker <https://github.com/smckend/mopidy-sangu/issues>`_
- `Changelog <https://github.com/smckend/mopidy-sangu/blob/master/CHANGELOG.rst>`_


Credits
=======

- Original authors: `Samuel McKendrick <https://github.com/smckend>`__, Agnieszka Lewicka
- Current maintainer(s): `Samuel McKendrick <https://github.com/smckend>`__
- `Contributors <https://github.com/smckend/mopidy-sangu/graphs/contributors>`_
