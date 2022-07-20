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
