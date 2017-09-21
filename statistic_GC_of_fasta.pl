#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
my ($in,$out);
GetOptions(
			"h|?"	=>	\&help,
			"in:s"	=>	\$in,
			"out:s"	=>	\$out,
			) || &help;
&help unless ($in &&  $out);

sub help
{
	print <<"	Usage End.";
---------------------------------------------------------------------------------------------------
	Description:
		This Script is used to statistic the content of GC.
	Usage:
		-in		<file>	file fa forced
		-out		<file>	results file,default "GC_content.txt"
		-h		Help document
	Example: perl -in *.fasta -out GC_content.txt
----------------------------------------------------------------------------------------------------
	Usage End.
	exit;
}
#——————————————————————————————————————————————————————————————————————————————————————————————————#
$out ||= "GC_content.txt";

open (IN,$in) or die $!;
open (OUT,">$out") or die $!;

$/=">";											#按>读入
<IN>;
print OUT "#Chr\tGC\tlength\n";
while (<IN>) {
	chomp;
	my ($id,$seq)=split/\r*\n/,$_,2;
	my $chr=(split/\s/,$id)[0];
	$seq=~ s/\r*\n//g;

	my $length=length $seq;							#计算序列长度
	my @seq=($seq=~/(G|C)/g);
	my $GC=@seq;									#统计GC出现次数
	my $content=sprintf "%.1f%%",($GC/$length)*100;
	print OUT "$chr\t$content\t$length\n";			#输出结果
}
$/="\n";
close OUT;
close IN;






