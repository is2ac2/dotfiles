#!/usr/bin/env python

c.TerminalIPythonApp.display_banner = False

# Autoreload extension.
c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = [
    '%autoreload 2',
    '%matplotlib inline',
]

