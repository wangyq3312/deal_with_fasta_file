#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use File::Basename qw(dirname basename);

my $version    =	"1.0";
my $writer     =	"wangyq";
my $date       =	"2016/10/14";
#——————————————————————————————————————————————————————————————————————————#
my ($in,$out);
GetOptions(
			"h|?"	=>	\&help,
			"in:s"	=>	\$in,
			"out:s"	=>	\$out,
			) || &help;
&help unless ($in &&  $out);
#—————————————————————————————————————————————————————————————————————————————————#
my $BEGIN=time();
my $Time_Start = &format_datetime(localtime(time()));
print "\n{Start:$Time_Start}\n\n";

open (IN,$in) or die $!;
open (OUT,">$out") or die $!;
$/=">";		
<IN>;								#读进fa文件
while (<IN>) {
	chomp;
	my ($id,$seqs)=split/\n/,$_,2;
	$seqs=~s/\R//g;
	print OUT ">$id\n$seqs\n";
}
$/="\n";

close OUT;
close IN;

my $Time_End = &format_datetime(localtime(time()));
print "\n{End:$Time_End}\n";
my $run=time()-$BEGIN;
print "This script runs $run.\n\n";




#———————————————————————————————————————————————————————————————————————————————————#
sub format_datetime {#Time calculation subroutine
    my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time());
    sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);
}
#——————————————————————————————————————————————————————————————————————————————————#
sub help
{
	print <<"	Usage End.";
---------------------------------------------------------------------------------------------------
	Version: $version
	Date: $date
	writer: $writer

	function:
		This script is used to drop line breaks of sequeces from fasta file
	Usage:
		-in		<file>	fasta file  forced
		-out		<file>	results file forced
		-h		Help document

	Example: 
		perl Script -in *.fasta -out * 
---------------------------------------------------------------------------------------------------
	Usage End.
	exit;
}
