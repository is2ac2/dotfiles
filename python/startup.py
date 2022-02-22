#!/usr/bin/env python

import os
import sys


def update_env():
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
