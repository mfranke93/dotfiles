#!/usr/bin/env python3
#
# This is a program to generate conky-like output for i3bar.
# This is in a JSON format like this:
# {"version": 1}
# [
# [],
# [{ ... }, { ... }, ... ],
# ...

import datetime
import time
import subprocess
import os

def format_json_part(s, c):
    return '{full_text": "%s", "color": "%s"}'%(s,c)

def part_time():
    d = datetime.datetime.now()
    s = d.strftime("%a, %d.%m %H:%M")
    return format_json_part(s, "\#FF0000")

def part_uptime():
    out = subprocess.check_output(["uptime", "-p"])
    s = str(out).strip().replace("up ", "").replace("\\n", "")

    s2 = s.replace(" days", "d").replace(" day", "d").replace(" hours", "h").replace(" hour", "h").replace(" minutes", "m").replace(" minute", "m")

    return format_json_part(s2.replace(",",""), "\#00FF00")

def mainloop_once():
    '''
    Execute the mainloop once.
    '''
    d = datetime.datetime.now()
    print("[")
    print(", ".join([
        part_uptime(),
        part_time()
        ]))
    #print(", ")
    print("]")

if __name__=='__main__':
    print("{\"version\"}: 1}")
    print("[[],")
    while True:
        time.sleep(1)
        mainloop_once()

