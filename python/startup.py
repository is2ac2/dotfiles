#!/usr/bin/env python3

import os
import sys


def update_env():
    try:
        import ipdb
        os.environ["PYTHONBREAKPOINT"] = "ipdb.set_trace"
    except Exception:
        pass

    if "PYTHONDOTENV" in os.environ:
        dotenv = os.environ["PYTHONDOTENV"]
        if os.path.isfile(dotenv):
            sys_paths = set(sys.path)
            with open(dotenv, "r") as f:
                for line in f:
                    key, value = line.strip().split("=")
                    os.environ[key] = value
                    if key == "PYTHONPATH":
                        paths = value.split(":")
                        for path in paths:
                            if path not in sys_paths:
                                sys.path.append(path)


update_env()
del update_env
