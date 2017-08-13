#!/usr/bin/env perl

while (<>) {
    chomp;
    my $str = $_;
    my $len = length;

    if ($len > 50) {
        print substr($str, 0, 50) . "…";
    }
    else {
        print;
    }
    exit 0;
}
