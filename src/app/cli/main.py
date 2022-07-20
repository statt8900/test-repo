import typer
from app import __version__
from rich.console import Console

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


def main():
    app()
