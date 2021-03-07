#!/usr/bin/env python

from __future__ import print_function

import os

def print_bold(s):
    print()
    print("-" * len(s))
    print(s)
    print("-" * len(s))
    print()

try:
    import IPython
    os.environ["PYTHONSTARTUP"] = os.environ.get("PYTHONSTARTUPBASE", "")
    print_bold("Starting IPython")
    IPython.start_ipython()
    raise SystemExit
except ImportError:
    print_bold("IPython not found; falling back to default interpretter")

