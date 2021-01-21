# Configuration file for ipython-notebook.

c = get_config()

# Don't open browser by default (usually SSH'ing in).
c.NotebookApp.open_browser = False

# Set path to notebooks directory.
import platform
from pathlib import Path

system = platform.system()
if system == "Linux":
    path = Path("~/notebooks").expanduser()
else:
    path = Path("~/Notebooks").expanduser()
path.mkdir(exist_ok=True)

c.NotebookManager.notebook_dir = c.NotebookApp.notebook_dir = str(path)

# Avoid colliding with common port numbers, and fail if occupied.
c.NotebookApp.port = 9906
c.NotebookApp.port_retries = 0
