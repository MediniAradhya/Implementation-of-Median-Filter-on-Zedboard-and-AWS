#!/usr/bin/perl

use strict;
use warnings;

my $TOTAL_POINTS = 50;
my $PRCT_PER_ERROR = 0.05;
my $MIN_GRADE = 25;
my $TOTAL_TESTS = 2**15;

if (scalar @ARGV != 1) {

    print "File name missing.\n";
    exit;
}

my $errors = 0;
my $inputs = 0;
my $filename = $ARGV[0];
open INFILE, "$filename" or die "Cannot open $filename\n";

while (<INFILE>) {

    if (/(\d*):\s*HW\s*=\s*(\d*),\s*SW\s*=\s*(\d*)/) {
	
	my $i = $1;
	my $hw = $2;
	my $sw = $3;
	#my $result = fib($i);

	$inputs ++;

	if ($sw != $hw) {

	    print "HW result incorrect for input $i: ";
	    print "Error for output $i: HW=$hw, Correct=$sw\n";
	    $errors ++;
	}
    }
}

if ($inputs != $TOTAL_TESTS) {

    print "Error: detected $inputs out of $TOTAL_TESTS results.\n";
}
else {

    print "Total Errors: $errors\n";
    my $grade = $TOTAL_POINTS - $TOTAL_POINTS*$PRCT_PER_ERROR*$errors;
    if ($grade < $MIN_GRADE) {
	$grade = $MIN_GRADE;
    }
    print "Corresponding Grade: $grade" . '%' . "\n";
}

print "Grading Complete\n";
close INFILE;
1;
