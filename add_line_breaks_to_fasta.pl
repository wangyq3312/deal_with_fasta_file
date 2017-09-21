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
my ($in,$out,$num);
GetOptions(
			"h|?"	=>	\&help,
			"in:s"	=>	\$in,
			"out:s"	=>	\$out,
			"n:s"	=>	\$num,
			) || &help;
&help unless ($in);
#——————————————————————————————————add-line-breaks———————————————————————————————————————————#
my $BEGIN=time();
my $Time_Start = &format_datetime(localtime(time()));
print "\n{Start:$Time_Start}\n\n";

$num ||= 60;
$out ||= "out.fasta";
open (IN,$in) or die $!;
open (OUT,">$out") or die $!;
$/=">";	
<IN>;
while (<IN>) {
	chomp;
	my ($id,$seqs)=split/\n/,$_,2;
	$seqs=~s/\R//g;								#如果序列分了很多行,但是不等长,先合并为一行
	my $length=length $seqs;						#获取序列长度
	
	my ($i,@seqs);
	for ($i=0;$i<$length;$i += $num) {				#$i循环一次 + $num
		my $after = substr($seqs,$i,$num-1);			#不能重新赋值给$seqs
		push @seqs,$after;
	}
	$seqs = join "\n",@seqs;					#用 \n 把数组里的序列连起来
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
		This script is used to add line breaks for fasta sequences.
	Usage:
		-in		<file>	fasta file, sequence in one line forced
		-out		<file>	results file, default "out.fasta"
		-n		<int> character number of each line,default=60
		-h		Help document

	Example: 
		perl Script -in *.fasta  -out * -n 60
---------------------------------------------------------------------------------------------------
	Usage End.
	exit;
}
