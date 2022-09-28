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

import typer
from rich.console import Console

from app import __version__

console = Console()
app = typer.Typer(name="app", no_args_is_help=True)


@app.command("hello")
def hello_world():
    """Print the app version."""
    console.print("hello world")


@app.command()
def version():
    """Print the app version."""
    console.print(__version__)


@app.command()
def new_command():
    """Print the app version."""
    console.print('newer command')


def main():
    app()  # pragma: no cover
