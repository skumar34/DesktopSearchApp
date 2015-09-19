#!/usr/bin/perl
require v5.18.2;

use strict;
use warnings;

use DB_File;
use Fcntl;

#keyword to search
my $keyword = $main::content_keyword;
#directory to be searched
my $input_dir = $main::path;
#print "\n\t\tAre You Want To Reindex The Home Directory[y/n]: ";
#my $choice_reindex = lc<STDIN>;
#chop($choice_reindex);
#if($choice_reindex =~ m/y/){
                     do("indexer.pl");
                     #}

my %hash;
my $x= tie(%hash,"DB_File",'indexer.db', O_RDONLY, 0, $DB_File::DB_BTREE) or die("unable to read the database");

#open a file output.txt for writing the files founds
open (OUTFILE, ">>output.txt") or die ("Unable to open output file");
print OUTFILE "\n";
$keyword = &uniqueword($keyword);
&search_keyword($keyword);
close(OUTFILE);

sub uniqueword { 
         my @arr = sort split(" ",$_[0]);
         my $low = 0;
         my $high = $low + 1;
         #Extracting the unique tokens from the given file
         for(;$high < @arr; $high++)
         {
                  if($arr[$low] eq $arr[$high]){
                  $arr[$low] = "";
                  }
                  $low++;
         }
         
         return (join(" ",@arr));
}

sub search_keyword{
         my @arr = split(" ",$_[0]);
         while((my $path,my $words) = each %hash){    
              my $count = 0;
              if("$path" =~ m/$input_dir/ && -e "$path"){
                  foreach (@arr){
                      if("$words" =~ m/$_/){
                           $count++
                      }
                  }
                  if($count > 0){
                  print OUTFILE "$path\n";                               #writes the file found to output.txt file                                        
              }
         }
         }               
}
