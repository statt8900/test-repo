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

from typer.testing import CliRunner

from app import __version__
from app.cli.main import app

runner = CliRunner()


def test_basic_execute():
    result = runner.invoke(app, "--help")
    assert result.exit_code == 0


def test_basic_hello():
    result = runner.invoke(app, "hello")
    assert result.exit_code == 0
    assert result.stdout.strip() == 'hello world'


def test_basic_version():
    result = runner.invoke(app, "version")
    assert result.exit_code == 0
    assert result.stdout.strip() == __version__
