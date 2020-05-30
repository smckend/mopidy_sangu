from mopidy_sangu import Extension


def test_get_default_config():
    ext = Extension()

    config = ext.get_default_config()

    assert "[sangu]" in config
    assert "enabled = true" in config
    assert "admin_password = sangu" in config
    assert "enable_play_button = false" in config
    assert "shuffle_fallback_playlist = false" in config


def test_get_config_schema():
    ext = Extension()

    schema = ext.get_config_schema()

    assert "username" in schema
    assert "admin_password" in schema
    assert "enable_play_button" in schema
    assert "shuffle_fallback_playlist" in schema
    assert "fallback_playlist_uri" in schema
    assert "stream_url" in schema
