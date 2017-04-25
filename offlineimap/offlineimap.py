#! /usr/bin/env python
from subprocess import check_output

def get_pass(for_="sniff@mumintroll.org"):
    return check_output("pass {}".format(for_), shell=True).splitlines()[0]
