#!python

#   Copyright 2022 Modelyst LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

"""
Module to check bump version
"""
import re


def write_development_version(new_version: str = "0.0.0"):
    version_pattern = r"^__version__\s*=\s*\"(.*)\""
    init_file = "./src/app/__init__.py"
    with open(init_file) as f:
        contents = f.read()
        new_contents = re.sub(version_pattern, f'__version__ = "{new_version}"', contents, flags=re.MULTILINE)
    with open(init_file, 'w') as f:
        f.write(new_contents)

    version_pattern = r"^version\s*=\s*\"(.*)\""
    with open('pyproject.toml') as f:
        contents = f.read()
        new_contents = re.sub(version_pattern, f'version = "{new_version}"', contents, flags=re.MULTILINE)
    with open("pyproject.toml", 'w') as f:
        f.write(new_contents)

    return 0


if __name__ == '__main__':
    write_development_version()
