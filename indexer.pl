#!/usr/bin/perl
use strict;
use warnings;

#uses the the perl5.10.1
require v5.18.2;

#load the given modiles at run time
use File::Find;
use DB_File;
use Fcntl;

#the directory which is going to be indexed

my $input_dir = $main::path ;

our $mod_index_file;                               #variable for storing the modification time of the index file

if(-e "indexer.db")
{
$mod_index_file = (-M "indexer.db");
}else
{
$mod_index_file = 2000000.00;
}

#Associative array uses (filepath/uniquewords) pair as key/value pair
my %hash;

#If the index if not created previously
if(! -e "indexer.db")
{
   unlink("indexer.db");                             #delete the index if already present
   #print"check 1";
   #setting DB_TREE Variables
   $DB_File::DB_TREE->{cachesize} = 100_000_000;     #100 mb of cache
   $DB_File::DB_TREE->{psize} = 32*1024;             #32k page size
   $DB_File::DB_TREE->{flags} = R_DUP; 
}

#print"check 2";
#For creating the berkeley database file for storing the unique tokens of the file
my $x = tie(%hash,"DB_File","indexer.db",O_RDWR|O_CREAT ,0766 , $DB_BTREE) or die("error opening the index file");

#print"check 3";
#to traverse the $input_dir and hence implementing the function of the crawler
my $y = find(\&split,$input_dir);
#print"check 4";
print "*" x155;
print("\n\t\t\tINDEX UPDATED\n\n");
print "*" x155;print("\n");
undef $x;
untie %hash;

sub split{
	my $path = $File::Find::name;
	
	my $mod_data_file = (-M "$path");
	#checks is the file is most recently changed as compared to updation of index
	if( $mod_data_file > $mod_index_file){
	return;
	}
	
        #check for the given file i.e file belonks to which category either script, source or text document or word document
        if("$path" =~ m/\.doc$/){
           #print("file found is a word file $path\n");
           $_ = lc(`catdoc -w "$path" | sort | uniq -`);                           #file found is MS Word file
        }else {
        
           if("$path" =~ m/\.pdf$/){                                               #file found is PDF file
               $_ = lc(`pdftotext "$path" - | sort | uniq -`);
               #print("File found $path\n");
           }else{
                 if(/.(c|cpp|js|java|pl|pm|db|css|json|0|sh|xml|png|gif|h)$/ || -d _ || -z _){      
                      return ;
                 }else {
                            if(-T _ && -r _){                                                           #if file is regular TEXT file
                                 #print("File found $path\n");
	                         $_ = lc(`cat -s "$path" | sort | uniq -`);
	                    }
	         }
        }
        }
        
        #PREPROCESSING OF THE CONTENT OF FILE FOUND
        s/_+/_/g;                              #removes the multiple occurances of _
        s/\W+/ /g;                             #remove non character words from the file to be indexed
        s/\s+/ /g;                             #removes the whitespace characters from the file to be indexed
        #print"$_ \n";
	$_ = &uniquetokens($_);                #calls uniquetoken subrotine to identify and extract unique searchable words
        s/\s+/ /g;                             #removes the multiple whitespace characters   
        #print ("$_ \n");
        &index_tokens($path,$_);               #calls index_tokens subroutine to create the index block 
} 	                                       #END OF split SUBROUTINE 	  


#subroutine to extract out the searchable unique tokens from the given file 
sub uniquetokens{
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
        #foreach (@arr)
        #{
         #print"$_   " ;
        #}
        return (join(" ",@arr));
}                                               #END OF uniquetokens SUBROUTINE

#subroutine for to enter the key/value pair in the database of the index 
sub index_tokens{
         my $path = $_[0];
         my $tokens = $_[1];
         $hash{$path} = $tokens;
         #print "$path\n";

}		                               #END OF index_tokens SUBROUTINE
