#! /usr/bin/env python
from subprocess import check_output

def get_pass():
    return check_output("pass sniff@mumintroll.org", shell=True).splitlines()[0]
