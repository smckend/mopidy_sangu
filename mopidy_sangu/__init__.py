import logging
import pathlib

import pkg_resources
from mopidy import config, ext

__version__ = pkg_resources.get_distribution("Mopidy-Sangu").version

logger = logging.getLogger(__name__)


class Extension(ext.Extension):
    dist_name = "Mopidy-Sangu"
    ext_name = "sangu"
    version = __version__

    def get_default_config(self):
        return config.read(pathlib.Path(__file__).parent / "ext.conf")

    def get_config_schema(self):
        schema = super().get_config_schema()
        schema["admin_password"] = config.Secret()
        schema["stream_url"] = config.String(optional=True)
        schema["fallback_playlist_uri"] = config.String(optional=True)
        schema["shuffle_fallback_playlist"] = config.Boolean(optional=True)
        schema["enable_play_button"] = config.Boolean(optional=True)
        return schema

    def setup(self, registry):
        from mopidy_sangu.actor.fallback_music_actor import FallbackMusicActor

        registry.add("frontend", FallbackMusicActor)

        from mopidy_sangu.api import sangu_factory

        registry.add(
            "http:app", {"name": self.ext_name, "factory": sangu_factory,}
        )

        registry.add(
            "http:static",
            {
                "name": self.ext_name,
                "path": str(pathlib.Path(__file__).parent / "static"),
            },
        )
