#!/bin/zsh

function log {
    logfile=/home/max/.sync-log

    echo "$(date) -- $*" >> $logfile
}

log "Starting round."

# get connected wifi
ssid=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d: -f2)
if [[ "$ssid" != "Watatsumi" ]]
then
    # only do in home wifi
    log "Not in home wifi."
    exit
fi

# only do on AC power
ac=$(cat /sys/class/power_supply/AC/online)
if [[ "$ac" -eq 0 ]]
then
    log "Not on AC."
    exit
fi

# only do under 75% load (4 cores)
load=$(cat /proc/loadavg | cut -d' ' -f2)
if (( $load >= 3 ))
then
    log "Load to high."
    exit
fi

# get last synctime
timefile="/home/max/.cache/ytdl_last_successful_sync"
if [[ -a $timefile ]]
then
    lastsync=$(cat $timefile)
else
    lastsync=0
fi

now=$(date +%s)
diff=$(($now - $lastsync))

# only sync if last successful sync was more than two hours ago
if (( $diff <= 7200 ))
then
    log "Last sync too recent."
    exit
fi

# all succeeded, do sync now
(
    log "Syncing."
    cd ~/Videos
    ./dl.sh
)

# update lastsync
date +%s > $timefile
