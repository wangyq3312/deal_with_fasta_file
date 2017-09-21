#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use File::Basename qw(dirname basename);
use FindBin qw($Bin $Script);

my $version    =	"1.0";
my $writer     =	"wangyq";
my $date       =	"2017/02/27";

#——————————————————————————————————————————————————————————————————————————————————————————————————————————#
my ($in,$out);
GetOptions(   
			"h|?"	=>	\&help,
			"in:s"	=>	\$in,		#fa file
			"out:s"	=>	\$out,
			) || &help;
&help unless ($in and $out);

#------------------------------------------------------------------------#
sub help
{
	print <<"	Usage End.";
---------------------------------------------------------------------------------------------------
	Version: $version
	Date: $date
	Writer: $writer

	function:statistic fasta sequence 

	Usage:
		-in		<file>	fasta file, forced
		-out		<file>	results file, forced
		-h		Help document

	Example: 
		perl $Script -in *.fa -out *.fa.sta.xls
---------------------------------------------------------------------------------------------------
	Usage End.
	exit;
}

#——————————————————————————————————————————————————————————————————————————————————————————————————————————#
my $BEGIN=time();
my $Time_Start = &format_datetime(localtime(time()));
print "\n{$Script Start:$Time_Start}\n\n";

open (IN,$in) or die $!;
open (OUT,">$out") or die $!;


my (%len,@len,$max,$min,$average,$total,$N_50,$num,$half_total,$N50,$N90,$ninty_total,$N_90);
my ($GC_content,$num_GC,$num_1000,$num_2000,$num_3000);
$/=">";

$max=0;

while (<IN>) {
	chomp;
	next if (/^$/ or /^#/);
	my ($id,$seq)=split /\r*\n/ ,$_ ,2;
#	print "$id\n";
	if ($id=~/\s/) {
		$id=~/(.+?)\s/;
		$id=$1;
	}
	
	
	$seq=~s/\r*\n//g;

	my $len=length $seq;
	$total += $len;			#总长度
	$num++;					#序列个数
	
	my @seq=($seq=~/(G|C)/g);
	my $GC=@seq;		
	$num_GC += $GC;       
	

	$len{$id}=$len;

	if ($len > $max) {
		$max=$len;			#最大值
	}

}
$/="\n";

$GC_content=sprintf "%.1f%%",($num_GC/$total)*100;  #GC含量
$average=$total/$num;		#平均长度


@len=values %len;
my @len_new=sort { $a <=> $b } @len;
$min = $len_new[0];			#最小值


$half_total=$total/2;
$ninty_total=$total*0.9;


foreach my $id (sort keys %len) {
	my $len=$len{$id};

	if ($len >= 1000) {			#长度大于1000的序列个数
		$num_1000++;
	} 
	
	if ($len >=2000) {		#长度大于2000的序列个数
		$num_2000++;
	} 
		
	if ($len >=3000) {		#长度大于3000的序列个数
		$num_3000++;
		
	}

}


foreach my $id (sort { $len{$b} <=> $len{$a} } keys  %len) {
	
	$N50 += $len{$id};

	if ($N50 >= $half_total){
		$N_50=$len{$id};
		last;
	}

}

foreach my $id (sort { $len{$b} <=> $len{$a} } keys  %len) {
	$N90 += $len{$id};
	if ($N90 >= $ninty_total) {
		$N_90=$len{$id};
		last;                
	}
}




my $sample=basename $in;
print OUT "Sample\tTotal_length\tNumber\tLongest\tShortest\t>=1kb\t>=2kb\t>=3kb\tAverage\tN50\tN90\tGC%\n";
print OUT "$sample\t$total\t$num\t$max\t$min\t$num_1000\t$num_2000\t$num_3000\t$average\t$N_50\t$N_90\t$GC_content\n";




close IN;
close OUT;



my $Time_End = &format_datetime(localtime(time()));
my $run=time()-$BEGIN;
print "$Script runs $run.\n\n";
print "\n{$Script End:$Time_End}\n";




#——————————————————————————————————————————————————————————————————————————————————————————————————————————#
sub format_datetime {#Time calculation subroutine
    my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time());
    sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);
}
