#!/usr/bin/perl
use strict;
use warnings;

#uses the the perl5.10.1
require v5.18.2;

#load the given modules at run time
use File::Find;
use DB_File;
use Fcntl;

my $option = $main::day_boundry;
my $days_access = $main::days;

#the directory which is going to be searched
my $input_dir = $main::path;

#print"check 3";
open (OUTFILE, ">>output.txt") or die ("Unable to open output file");
print OUTFILE "\n";
#to traverse the $input_dir and hence implementing the function of the crawler
my $y = find(\&search,$input_dir);

close(OUTFILE);


#SUBROUTINES
sub search{
   my $path = $File::Find::name;
   if(-d $path)
   {
     return;
   }
   my $temp_day = (-A "$path");                           #this gives the times since the file is last accessed
   if($option > 0){                                       #check for file if file is access more than $temp_day
     if($temp_day > $days_access)
     {
       print OUTFILE "$path\n";                               #writes the file found to output.txt file 
       
      }
   }
   if($option < 0){                                       #check for file if file is modified less than $temp_day
     if($temp_day < $days_access)
     {
       print OUTFILE "$path\n";                               #writes the file found to output.txt file 
       }
    }
}
