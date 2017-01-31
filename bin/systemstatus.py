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

def part_cpustatus():
    # TODO
    return ""

def part_cputemp():
    basepath = "/sys/class/thermal"
    # get fan status?
    fs = []
    for i in range(5):
        with open(basepath + "/cooling_device%d/cur_state"%i) as f:
            fs.append(f.readline().strip().replace("\\n", ""))

    fans = " ".join(fs)

    # get cpu temps
    ct = []
    for i in range(2):
        with open(basepath + "/thermal_zone%d/temp"%i) as f:
            ct.append(f.readline().strip().replace("\\n", ""))

    cpu = " ".join(["%.1f°C"%(float(c)/1000.0) for c in ct])

    return format_json_part("%s, %s"%(fans, cpu), "\#0000FF")

def part_mem():
    pass

def part_diskspace_fs():
    pass

def part_diskspace_home():
    pass

def part_internet_status():
    pass

def part_battery_timeleft():
    pass

def mainloop_once():
    '''
    Execute the mainloop once.
    '''
    d = datetime.datetime.now()
    print("[")
    print(", ".join([
        part_uptime(),
        part_cpustatus(),
        part_cputemp(),
        part_time()
        ]))
    print("],")

if __name__=='__main__':
    print("{\"version\"}: 1}")
    print("[[],")
    while True:
        time.sleep(1)
        mainloop_once()

