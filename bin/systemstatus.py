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
import os, sys
import re

def colormap(i):
    """
    Function from int (0..10) -> colors, where 10 is very urgent and 0 is very okay.
    """
    cmap = [
                '#424dce',
                '#4270ce',
                '#428ace',
                '#42ce94',
                '#42ce5b',
                '#5ece42',
                '#94ce42',
                '#c2ce42',
                '#cebe42',
                '#ce8842',
                '#ce4242'
                ]
    return cmap[i]

def format_json_part(s, c):
    return '{"full_text": "%s", "color": "%s"}'%(s,c)

def part_time():
    d = datetime.datetime.now()
    s = d.strftime("%a, %d.%m %H:%M")
    return format_json_part(s, colormap(0))

def part_uptime():
    # ugh
    out = subprocess.check_output(["uptime", "-p"]).decode()
    s = out.strip().replace("up ", "")
    s2 = s.replace(" days", "d").replace(" day", "d").replace(" hours", "h").replace(" hour", "h").replace(" minutes", "m").replace(" minute", "m")
    s3 = "%s"%s2

    # TODO: make other color if abovee values
    return format_json_part(s3.replace(",",""), colormap(0))

def part_cpustatus():
    # TODO
    return "{\"full_text\": \"\"}"

def part_cputemp():
    # TODO: use sensors -u 
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

    return format_json_part("%s, %s"%(fans, cpu), "#4444FF")

def part_mem():
    out = subprocess.check_output(["free", "-m"]).decode()
    m = re.search('Mem:( *)([0-9]*)( *)([0-9]*)', out)
    if m:
        memtotal = int(m.group(2))
        memused  = int(m.group(4))
        mempercnum  = int(100.0 * float(memused) / float(memtotal))
        memperc  = "%d%%"%mempercnum
    else:
        mempercnum = 0
        memperc  = "??%"

    m = re.search('Swap:( *)([0-9]*)( *)([0-9]*)', out)
    if m:
        swaptotal = int(m.group(2))
        swapused  = int(m.group(4))
        swapperc  = "%d%%"%int(100.0 * float(swapused) / float(swaptotal))
    else:
        swapperc  = "??%"

    col = colormap(mempercnum//10)
    s = "Mem: %s, Swap: %s"%(memperc, swapperc)
    return format_json_part(s, col)

def part_diskspace_fs():
    pass

def part_diskspace_home():
    pass

def part_internet_status():
    pass

def part_battery_timeleft():
    symbol_ac = "⚡"
    symbol_full = " "
    symbol_chr  = "▲"
    symbol_dis  = "▼"

    out = subprocess.check_output(["upower", "-i", "/org/freedesktop/UPower/devices/battery_BAT0", "--dump"]).decode()
    # state:, time to empty:, percentage: 
    # find state
    # map from state to symbol
    state_to_symbol = {'discharging': symbol_dis, 'fully-charged': symbol_full, 'charging': symbol_chr} 
    m = re.search('( +)state:( *)(.*)', out)
    if m:
        state = m.group(3)
        if state in state_to_symbol:
            chr_state = state_to_symbol[state]
        else:
            chr_state = '?'
    else:
        chr_state = '#'
    
    # find percentage
    m = re.search('( +)percentage:( *)(.*)', out)
    if m:
        bat_perc = m.group(3)
        bperc_num = (100 - int(bat_perc.replace("%", ""))) // 10
    else:
        bat_perc = "??%"
        bperc_num = 10

    # find time to discharge/fill
    m = re.search('( +)time to empty:( *)(.*)', out)
    if m:
        time_to_empty = ", " + m.group(3)
    else:
        time_to_empty = ""

    # find if on AC
    out = subprocess.check_output(["upower", "-i", "/org/freedesktop/UPower/devices/line_power_ac", "--dump"]).decode()
    m = re.search('( +)online:( +)yes', out)
    if m:
        ac_connected = symbol_ac
    else:
        ac_connected = " "

    s = "%s%s %s%s"%(ac_connected, chr_state, bat_perc, time_to_empty)
    return format_json_part(s, colormap(bperc_num))

def mainloop_once():
    '''
    Execute the mainloop once.
    '''
    print("[")
    print("%s,"%part_uptime())
    print("%s,"%part_mem())
    print("%s,"%part_cpustatus())
    print("%s,"%part_cputemp())
    print("%s,"%part_battery_timeleft())
    print(part_time())
    print("],")
    

if __name__=='__main__':
    print("{\"version\": 1}")
    print("[")
    print("[],")
    while True:
        mainloop_once()
        sys.stdout.flush()
        time.sleep(1.0)
