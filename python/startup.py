#!/usr/bin/env python

from __future__ import print_function

import inspect
import os


def print_bold(s):
    print()
    print("-" * len(s))
    print(s)
    print("-" * len(s))
    print()


# Don't run IPython when in the debugger.
in_debugger = False
for frame in inspect.stack():
    if frame[1].endswith("ipdb/__main__.py"):
        in_debugger = True
        break


if not in_debugger:
    try:
        import IPython
        os.environ["PYTHONSTARTUP"] = ""
        print_bold("Starting IPython")
        IPython.start_ipython()
        raise SystemExit
    except ImportError:
        print_bold("IPython not found; falling back to default interpretter")

