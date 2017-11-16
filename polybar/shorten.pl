#!/usr/bin/env perl

while (<>) {
    chomp;
    my $str = $_;
    my $len = length;

    if ($len > 60) {
        print substr($str, 0, 60) . "…";
    }
    else {
        print;
    }
    exit 0;
}
