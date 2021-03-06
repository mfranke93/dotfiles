#!/usr/bin/env perl

use strict;
use IO::Handle;
#use Imager::Color;

# turn of buffering
STDOUT->autoflush(1);

my @colors;
@colors = ( "72A1FF", "72A9FF", "72B1FF", "72B8FF", "72C0FF", "72C8FF", "72D0FF", "72D8FF", "72DFFF", "72E7FF", "72EFFF", "72F7FF", "72FFFF", "72FFF7", "72FFEF", "72FFE7", "72FFDF", "72FFD8", "72FFD0", "72FFC8", "72FFC0", "72FFB8", "72FFB1", "72FFA9", "72FFA1", "72FF99", "72FF91", "72FF8A", "72FF82", "72FF7A", "72FF72", "76FF72", "7AFF72", "7EFF72", "82FF72", "86FF72", "8AFF72", "8EFF72", "92FF72", "96FF72", "9AFF72", "9EFF72", "A2FF72", "A6FF72", "AAFF72", "AEFF72", "B2FF72", "B6FF72", "BAFF72", "BEFF72", "C2FF72", "C6FF72", "CAFF72", "CEFF72", "D2FF72", "D6FF72", "DAFF72", "DEFF72", "E2FF72", "E6FF72", "EAFF72", "EEFF72", "F2FF72", "F6FF72", "FAFF72", "FFFF72", "FFFA72", "FFF672", "FFF272", "FFEE72", "FFEA72", "FFE672", "FFE272", "FFDE72", "FFDA72", "FFD672", "FFD272", "FFCE72", "FFCA72", "FFC672", "FFC272", "FFBE72", "FFBA72", "FFB672", "FFB272", "FFAE72", "FFAA72", "FFA672", "FFA272", "FF9E72", "FF9A72", "FF9672", "FF9272", "FF8E72", "FF8A72", "FF8672", "FF8272", "FF7E72", "FF7A72", "FF7672", "FF7272");
#my $r,my $g,my $b;
#for(my $i = 0; $i <= 100; ++$i) {
#    my $hue;
#    if ($i < 30) {
#        $hue = 220 - 100 * $i / 30;
#    }
#    else {
#        $hue = 120 - 120 * ($i - 30)/70;
#    }
#
#
#    my $hsv = Imager::Color->new(
#        hsv => [ $hue, 0.55, 1.0 ]
#    );
#    my @rgb = $hsv->rgba;
#
#    my $r = $rgb[0];
#    my $g = $rgb[1];
#    my $b = $rgb[2];
#
#    $colors[$i] = sprintf "%02X%02X%02X", $r, $g, $b;
#}

# get color from severity
sub color {
    my $idx = int( shift);
    if ($idx>100) { $idx = 100; }
    if ($idx<0) {$idx = 0; }

    return $colors[$idx];
};

sub uptime {
    # read uptime in seconds from /proc/uptime
    my $secs;
    open my $fh, '<', '/proc/uptime';
    while ( <$fh> ) {
        s/(\d+\.\d+) .*/$1/;
        $secs = $_;
        last;
    }
    
    # get severity of uptime: 1 month is BAD
    my $severity = log($secs)/log(31*24*3600) * 100;
    my $json_color = color $severity;

    # format uptime in xw xd xh xm format
    my $str = "";
    if ($secs > 7*24*3600) {
        my $days = int($secs / (7*24*3600));
        $str .= $days . "w ";
        $secs -= $days * 7 * 24 *3600;
    }
    if ($secs > 24*3600) {
        my $hours = int($secs / (24*3600));
        $str .= $hours . "d ";
        $secs -= $hours * 24 *3600;
    }
    if ($secs > 3600) {
        my $hours = int($secs / (3600));
        $str .= $hours . "h ";
        $secs -= $hours * 3600;
    }
    if ($secs > 60) {
        my $hours = int($secs / (60));
        $str .= $hours . "m ";
        $secs -= $hours * 60;
    }

    $str =~ s/\s+$//g;

    return ($str, $json_color);
}

# get memory and swap usage
sub memory {
    my ($memtotal, $memavailable, $memcached, $swaptotal, $swapfree);
    open my $fh, '<', '/proc/meminfo';
    while (<$fh>) {
        if (/^MemTotal/) {
            s/[^\d]//g;
            $memtotal = $_;
        }
        elsif (/^MemAvailable/) {
            s/[^\d]//g;
            $memavailable = $_;
        }
        elsif (/^SwapTotal/) {
            s/[^\d]//g;
            $swaptotal = $_;
        }
        elsif (/^SwapFree/) {
            s/[^\d]//g;
            $swapfree = $_;
        }
        elsif (/^Cached/) {
            s/[^\d]//g;
            $memcached = $_;
        }
    }
    my $memperc = ($memtotal - $memavailable)/$memtotal * 100.0;
    my $swapperc = ($swaptotal - $swapfree)/$swaptotal * 100.0;
    my $cachedperc = $memcached / $memtotal * 100.0;

    my $str = sprintf "Mem: %2.0f%%  (%2.0f%%), Swap: %2.0f%%", $memperc, $cachedperc, $swapperc;
    my $color = color $memperc;

    return ($str, $color);
}

# get number of new mail (offlineimap folder formats)
sub newmail {
    my $newmailnumber = `find ~/mail -type f | grep '/INBOX[^\/]*/new/' | wc -l`;
    my $str = " ";
    if ($newmailnumber > 0) {
        $str = "✉";
    }
    my $color = color 100;

    return ($str, $color);
}

# get disk usage 
sub diskusage {
    my $disk = shift;
    my $output = `df --output=pcent $disk | tail -n1`;
    chomp $output;
    $output =~ s/%//g;

    my $str = sprintf "%s: %3d%%", $disk, $output;
    my $color = color $output;
    return ($str, $color);
}

# get network status: IPv4, IPv6
sub inet_iface {
    my $iface = shift;
    my $ifacename = shift;
    my @output = `ip addr show $iface`;
    chomp @output;

    my $up = 0;
    my $ipv4 = " ";
    my $ipv6 = " ";

    foreach (@output) {
        if (/\sinet\s/) {
            if (/\sglobal\s/) {
                $up = 1;
                $ipv4 = 4;
            }
        }
        elsif (/\sinet6\s/) {
            if (/\sglobal\s/) {
                $up = 1;
                $ipv6 = 6;
            }
        }
    }

    my $short = " ";
    if ($up > 0) {
        $short = $ifacename;
    }

    my $str = $short.$ipv4.$ipv6;
    my $color = color 0;
    if ($ipv4 + $ipv6 == 10) {
        $color = color 30;
    }

    return ($str, $color);
}

# battery and power status
sub power {
    my $ac_online = 0;
    my $bat_status = "";
    my $bat_percent = 0;
    my $bat_energy = 0;
    my $power_current = 0;

    # read /sys/class/power_supply/AC/uevent if exists
    open my $fh, '<', '/sys/class/power_supply/AC/uevent';
    while (<$fh>) {
        chomp;
        if (/^POWER_SUPPLY_ONLINE/) {
            s/.*=//g;
            $ac_online = $_;
        }
    }

    # read /sys/class/power_supply/BAT0/uevent if exists
    close $fh;
    open $fh, '<', '/sys/class/power_supply/BAT0/uevent';
    while (<$fh>) {
        chomp;
        if (/^POWER_SUPPLY_STATUS/) {
            s/.*=//g;
            $bat_status = $_;
        }
        elsif (/^POWER_SUPPLY_CAPACITY=/) {
            s/.*=//g;
            $bat_percent = $_;
        }
        elsif (/^POWER_SUPPLY_POWER_NOW/) {
            s/.*=//g;
            $power_current = $_;
        }
        elsif (/^POWER_SUPPLY_ENERGY_NOW/) {
            s/.*=//g;
            $bat_energy = $_;
        }
    }
    
    # calculate time left and power
    my $power_now = $power_current / 1000000.0;

    my $power_str = "";
    my $time_str = "";
    if ($bat_status eq "Discharging") {
        if ($power_current) {
            my $hours_left = $bat_energy / $power_current;
            $power_str = sprintf ", %4.1fW", $power_now;
            $time_str  = sprintf ", %3.1fh", $hours_left;
        }
    }

    # symbols and stuff
    # status: charging    z^
    #         discharging  v
    #         unknown     z
    my $power_symbol = " ";
    my $battery_symbol = " ";

    if ($bat_status eq "Charging") {
        $battery_symbol = "▲";
    }
    elsif ($bat_status eq "Discharging") {
        $battery_symbol = "▼";
    }

    if ($ac_online > 0) {
        $power_symbol = "⚡";
    }

    my $color = color (100-$bat_percent);
    my $str = sprintf "%s%s %3d%%%s%s", $power_symbol, $battery_symbol, $bat_percent, $power_str, $time_str;

    return ($str, $color);
}

# cpu temperature
sub temperature {
    my $temp;

    open my $fh, '<', '/sys/class/thermal/thermal_zone0/temp';
    while (<$fh>) {
        chomp;
        s/(\d\d\d)$/.$1/g;
        $temp = $_;
        last;
    }

    my $ratio = ($temp - 30) / (85 - 30) * 100;
    my $str = sprintf "%2.0f°C", $temp;
    my $color = color $ratio;

    return ($str, $color);
}

# PulseAudio volume information
sub volume {
    my $muted = 0;
    my $vol   = 0;

    my @output = `pactl list sinks`;
    foreach (@output) {
        chomp;
        if (/^\s*Volume: /) {
            $_ =~ /.*( \d+)%.*/;
            $vol = $1;
            chomp $vol;
        }
        elsif (/^\s*Mute: /) {
            if (/yes/) {
                $muted = 1;
            }
        }
    }

    my $status = "♫";
    if ($muted) {
        $status = "∅";
    }

    my $str = sprintf "%s %3d%%", $status, $vol;
    my $color = color $vol;
    if ($muted) {
        $color = "888888";
    }

    return ($str, $color);
}

# date and time
sub datetime {
    my $datetime = `LANG=ja_JP.utf8 date +"%A %b%d日 %r"`;
    chomp $datetime;
    # remove seconds
    $datetime =~ s/\d\d秒//g;
    my $color    = '00dddd';

    return ($datetime, $color);
}

# tasks (due today and overdue)
sub tasks {
    my $overdue = `task +OVERDUE count`;
    my $today   = `task +TODAY -OVERDUE count`;
    my $tomorrow= `task +TOMORROW count`;

    # task gives Sunday to Saturday weeks always, so calculate own week
    my $week    = `task due.before:Monday due.after:"tomorrow+24h" +DUE count`;
    # make color red if overdue
    my $color1 = color 100;
    my $color2 = color 95;
    my $color3 = color 70;
    my $color4 = color 30;

    # print overdue
    print "\t\t\t";
    print '{ "full_text": "';
    print "◀"x$overdue;
    print '", "color": "'.$color1.'", "separator": false, "separator_block_width": 0 },';
    print "\n";

    # print due today
    print "\t\t\t";
    print '{ "full_text": "';
    print "◆"x$today;
    print '", "color": "'.$color2.'", "separator": false, "separator_block_width": 0 },';
    print "\n";

    # print due tomorrow
    print "\t\t\t";
    print '{ "full_text": "';
    print "▶"x$tomorrow;
    print '", "color": "'.$color3.'", "separator": false, "separator_block_width": 0 },';
    print "\n";

    # print due rest of week
    print "\t\t\t";
    print '{ "full_text": "';
    print "▷"x$week;
    print " ";
    print '", "color": "'.$color4.'" },';
    print "\n";
}


# print start JSON header
print "{ \"version\": 1 }\n";
print "[ [],\n";

while () 
{
    print "\t[\n";

    # tasks
    tasks;

    # new emails
    my ($json_text, $json_color) = newmail;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\", \"separator\": true },\n", $json_text, $json_color;

    # uptime
    ($json_text, $json_color) = uptime;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\", \"min_width\": \"22h 14m\", \"align\": \"right\" },\n", $json_text, $json_color;

    # memory and swap
    ($json_text, $json_color) = memory;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;

    # / and /home disk usage
    ($json_text, $json_color) = diskusage '/';
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;
    ($json_text, $json_color) = diskusage '/home';
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;

    # network interfaces
    ($json_text, $json_color) = inet_iface 'wlp3s0', 'W';
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;
    ($json_text, $json_color) = inet_iface 'enp0s25', 'E';
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;

    ($json_text, $json_color) = power;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;

    ($json_text, $json_color) = temperature;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;

    ($json_text, $json_color) = volume;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" },\n", $json_text, $json_color;

    ($json_text, $json_color) = datetime;
    printf "\t\t\t{ \"full_text\": \"%s\", \"color\": \"#%s\" }\n", $json_text, $json_color;

    print "\t],\n";
    sleep 1;
};

# vim: ft=perl:foldmethod=syntax
