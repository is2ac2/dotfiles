import sys


def set_trace():
    try:
        import ipdb
        ipdb.set_trace(sys._getframe().f_back)
    except Exception:
        from pdb import Pdb
        pdb = Pdb()
        pdb.set_trace(sys._getframe().f_back)

