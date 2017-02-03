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
    s2 = s.replace(" days", "d").replace(" day", "d").replace(" hours", "h").replace(" hour", "h").replace(" minutes", "m").replace(" minute", "m").replace(",","")
    s3 = "%s"%s2

    minutes=0
    vec = s3.split()
    for r in vec:
        if r[-1] == 'd':
            minutes += 60 * 24 * int(r[:-1])
        elif r[-1] == 'h':
            minutes += 60 * int(r[:-1])
        elif r[-1] == 'm':
            minutes += int(r[:-1])

    if minutes < 60:         c = 0
    elif minutes <   6 * 60: c = 1
    elif minutes <  12 * 60: c = 2
    elif minutes <  24 * 60: c = 3
    elif minutes <  48 * 60: c = 4
    elif minutes < 3 * 24 * 60: c = 5
    elif minutes < 4 * 24 * 60: c = 6
    elif minutes < 5 * 24 * 60: c = 7
    elif minutes < 6 * 24 * 60: c = 8
    elif minutes < 7 * 24 * 60: c = 9
    else: c = 6

    return format_json_part(s3, colormap(c))

def part_cputemp():
    out = subprocess.check_output(["sensors", "-u"]).decode()
    m = re.search('  temp1_input: (\\d+)\..*', out)
    if m:
        cputemp = int(m.group(1))
        cputempstr = "%d°C"%cputemp
    else:
        cputemp = 105
        cputempstr = "??°C"

    m = re.search('  fan1_input: (\\d+)\..*', out)
    if m:
        fanrpm = int(m.group(1))
        if fanrpm > 6000: fanrpm = 0
        fanrpm = "%dRPM"%fanrpm
    else:
        fanrpm = "??RPM"

    urg = max(0, min(10, int(10*float(cputemp-37)/(105.0-37.0))))

    return format_json_part("%s, %s"%(cputempstr, fanrpm), colormap(urg))

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

def part_diskspace_fs(fsname):
    out = subprocess.check_output(["df", fsname]).decode()
    m = re.search('/dev/sda\\w*\\s+\\d+\\s+\\d+\\s+\\d+\\s+(\\d+%).*', out)
    if m:
        fs_occ = m.group(1)
        fs_num = int(fs_occ.replace("%", ""))
        urg = fs_num//10
    else:
        fs_occ = "??%"
        urg = 10
    return format_json_part("%s %s"%(fsname, fs_occ), colormap(urg))

def part_internet_status(adapter, show_symbol):
    out = subprocess.check_output(["ip", "addr", "show", adapter]).decode()
    ipv4 = False
    ipv6 = False
    up = False

    if re.search('.* UP .*', out):
        up = True
    if re.search('.* inet .* scope global .*', out):
        ipv4 = True
    if re.search('.* inet6 .* scope global .*', out):
        ipv6 = True

    s = "%s%s%s"%(show_symbol, "4" if ipv4 else " ", "6" if ipv6 else " ")
    col = colormap(4) if up else "#333333"
    return format_json_part(s, col)

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
    print("%s,"%part_diskspace_fs('/'))
    print("%s,"%part_diskspace_fs('/home'))
    print("%s,"%part_cputemp())
    print("%s,"%part_internet_status("enp0s25", "E"))
    print("%s,"%part_internet_status("wlp3s0", "W"))
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
        time.sleep(5.0)
