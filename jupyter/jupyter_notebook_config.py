# Configuration file for ipython-notebook.

import os
import platform
from pathlib import Path


# ----------------
# Helper functions
# ----------------


def set_notebook_directory(directory: str) -> None:
    path = Path(directory).expanduser()
    path.mkdir(exist_ok=True)
    path = str(path)
    c.NotebookManager.notebook_dir = path
    c.NotebookApp.notebook_dir = path
    c.ServerApp.notebook_dir = path


def general_config() -> None:
    c.NotebookApp.answer_yes = True  # Answer yes to any prompts.
    c.JupyterApp.answer_yes = True
    c.InteractiveShellApp.extensions = ['autoreload']
    c.InteractiveShellApp.exec_lines = ['%autoreload 2']
    c.NotebookApp.port = int(os.environ['JUPYTER_NOTEBOOK_PORT'])
    c.ServerApp.port = int(os.environ['JUPYTER_NOTEBOOK_PORT'])


# -----
# MacOS
# -----


def jupyter_notebook_config_macos() -> None:
    general_config()
    set_notebook_directory("~/Notebooks")


# -----
# Linux
# -----


def jupyter_notebook_config_linux() -> None:
    general_config()
    set_notebook_directory("~/notebooks")
    c.NotebookApp.open_browser = False


# Hiding this behind an environment variable because other Jupyter
# sessions might not want to use these configurations.
if os.environ.get("USE_JUPYTER_CONF"):
    system = platform.system()
    if system == "Linux":
        jupyter_notebook_config_linux()
    elif system == "Darwin":
        jupyter_notebook_config_macos()
    else:
        raise RuntimeError(f"System config not supported: {system}")

