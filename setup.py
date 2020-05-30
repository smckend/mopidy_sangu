import re

from setuptools import setup


def get_version(filename):
    with open(filename) as fh:
        metadata = dict(re.findall('__([a-z]+)__ = "([^"]+)"', fh.read()))
        return metadata["version"]


setup(version=get_version("mopidy_sangu/__version__.py"))
