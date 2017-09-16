#!/usr/bin/env perl

while (<>) {
    chomp;
    my $str = $_;
    my $len = length;

    if ($len > 40) {
        print substr($str, 0, 40) . "…";
    }
    else {
        print;
    }
    exit 0;
}
