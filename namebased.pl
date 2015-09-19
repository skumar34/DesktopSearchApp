#!/usr/bin/perl
use strict;
use warnings;

#uses the the perl5.10.1
require v5.18.2;

#load the given modules at run time
use File::Find;
use DB_File;
use Fcntl;

my @keyword =split(" ",$main::name_keyword);

#the directory which is going to be indexed
my $input_dir = $main::path ;

#print"check 3";
#open a file for output
open (OUTFILE, ">>output.txt") or die ("Unable to open output file");
print OUTFILE "\n";
#to traverse the $input_dir and hence implementing the function of the crawler
my $y = find(\&search_name,$input_dir);
close(OUTFILE);

#SUBROUTINES
sub search_name{
	my $path = $File::Find::name;
        #check for the given file i.e file belonks to which category either script, source or text document or word document
        stat($path);
        if(-d _ || -z _) 
                {return ;
                }
        $_ = lc( $_ );
        foreach my $each (@keyword)
        {     
          if($_ !~ /$each/si)
          {
            return;
          }
        }
        print OUTFILE "$path\n";                               #writes the file found to output.txt file
} 	
	  
