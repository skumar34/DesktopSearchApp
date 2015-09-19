#!usr/bin/perl

require v5.18.2;

use strict;
use warnings;

unlink("output.txt");
package main;

#GLOBAL VARIABLES
our ($path, $content_keyword, $name_keyword,$days);
our ($file_size, $size_boundry,$day_boundry);

print "*" x155;
print("\n\t\tEnter the directory to search: ");
$path = <STDIN>;                                                         #Read the requested directory to be searched
chomp($path);
if($path eq ""){
die "FOLDER TO BE SEARCHED CANNOT BE EMPTY";
}

print("\n\t\tEnter the keyword to search: ");                           #Read the keywords to be searched in files
$content_keyword = <STDIN>;
chomp($content_keyword);

print("\n\t\tEnter the file name contains: ");                          #Read the keywords that may be contained in file name
$name_keyword = <STDIN>;
chomp($name_keyword);

print("\n\t\tEnter the size of file : ");                               #Read the file size in KB
$file_size = <STDIN>;
chomp($file_size);

if(!($file_size eq ""))
{
print("\n\t\tSIZE is (1). atleast or (-1). atmost");
$size_boundry=<STDIN>;
chomp($size_boundry);
}

print("\n\t\tEnter the no.of days modified : ");
$days = <STDIN>;
chomp($days);

if(!($days eq ""))
{
print("\n\t\tDays modified is (1). more than or (-1). less than");
$day_boundry=<STDIN>;
chomp($day_boundry);
}


if(!($content_keyword eq ""))
{
do("contentbased.pl");
}
if(!($name_keyword eq ""))
{
do("namebased.pl");
}
if(!($file_size eq ""))
{
if(!($size_boundry eq "")){
do("sizebased.pl");
}
}
if(!($days eq ""))
{
if(!($day_boundry eq "")){
do("mod_datebased.pl");
}
}


