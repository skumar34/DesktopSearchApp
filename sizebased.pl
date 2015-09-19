#!/usr/bin/perl
use strict;
use warnings;

#uses the the perl5.10.1
require v5.18.2;

#load the given modules at run time
use File::Find;
use DB_File;
use Fcntl;

open (OUTFILE, ">>output.txt") or die ("Unable to open output file");

my $option = $main::size_boundry;
my $size = ($main::file_size);

#the directory which is going to be searched
my $input_dir = $main::path;

#print"check 3";
#to traverse the $input_dir and hence implementing the function of the crawler
my $y = find(\&search,$input_dir);

close(OUTFILE);

sub search{
   my $path = $File::Find::name;
   if(-d "$path")
   {
     return;
   }
   my $fsize = (stat($path))[7];                           #(stat(filename))[7]this gives the file size in bytes
   $fsize = $fsize / 1000;
   if($option == '1'){
     if($fsize > $size || $size == $fsize)
     {
       print OUTFILE "$path\n";
      }
   }
   if($option == '-1'){
     if($fsize < $size || $size == $fsize)
     {
       print OUTFILE "$path\n";
       }
    }
}       
