#!/usr/bin/perl
use strict;
use File::Basename;
my $file_list=shift;
my $alt=shift;
open IN,$file_list || die $!;
open OUT1,">all.substitutions_6.stat.txt" || die $!;
print OUT1 "sample\tC->A\tC->G\tC->T\tT->A\tT->C\tT->G\n";
open OUT2,">all.substitutions_6.stat.filter.$alt.txt" || die $!;
print OUT2 "sample\tC->A\tC->G\tC->T\tT->A\tT->C\tT->G\n";
while(<IN>){
   chomp;
   my $base=basename($_);
   my $sample=$1 if ($base=~/(\S*?)\./);
   open IN2,$_ || die $!;
   my %hash1;
   my %hash2; 
   while(<IN2>){
       chomp;
       next if (/^#/);
       next if (/^Hugo_Symbol/);
       my @info=split(/\t/);
       my $sub="$info[10]#$info[12]";
           $hash1{$sub}++;
       if($info[41] >= $alt){
           $hash2{$sub}++;
      }
    }
    close IN2;
    my @want=('C#A','C#G','C#T','T#A','T#C','T#G');
    foreach my $k (@want){
        if(!exists $hash1{$k}){
             $hash1{$k}=0;
        }
        if(!exists $hash2{$k}){
             $hash2{$k}=0;
        }
    }
    print OUT1 "$sample\t$hash1{'C#A'}\t$hash1{'C#G'}\t$hash1{'C#T'}\t$hash1{'T#A'}\t$hash1{'T#C'}\t$hash1{'T#G'}\n";
    print OUT2 "$sample\t$hash2{'C#A'}\t$hash2{'C#G'}\t$hash2{'C#T'}\t$hash2{'T#A'}\t$hash2{'T#C'}\t$hash2{'T#G'}\n";       
#   print "$sample\n";
}

close IN;
close OUT1;
close OUT2; 
