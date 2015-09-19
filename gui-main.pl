#!/usr/bin/perl

require v5.18.2;

use strict;
use warnings;

use Tk;

package main;

#subroutines used 
sub DirectorySelection;
sub credit;
sub search_proc;

#global variables for input values
our ($path, $content_keyword, $name_keyword,$days);
our ($file_size, $size_boundry,$day_boundry);
$size_boundry = 1;
$day_boundry = 1;

#create a main window 
my $mw = MainWindow->new();
$mw->title("Search For Files");
$mw->geometry("800x640");

#divide the main window into frames
my $top = $mw ->Frame(-relief=>'groove',-borderwidth=>'4',,-label=>"DESKTOP SEARCH")->pack(-fill=>'both',-expand=>'1');
my $io_frame = $top ->Frame(-relief=>'groove')->pack(-side=>'top',-fill=>'both',-expand=>'1');
my $input_frame = $io_frame ->Frame(-relief=>'groove',-borderwidth=>'2',-label=>"INPUT")->pack(-side=>'left',-ipadx=>'50',-expand=>'1');
my $output_frame = $io_frame ->Frame(-relief=>'groove',-borderwidth=>'2',-label=>"SEARCH RESULTS: ")->pack(-side=>'left',-fill=>'both',-expand=>'1');
my $command_frame = $top ->Frame(-relief=>'groove')->pack(-side=>'bottom', -fill=>'x',-expand=>'1');

#specify the labels for the input_frame widget
my $lab1 = $input_frame ->Label(-text=>"  Look in Folder:  ")->pack();
my $lab2 = $input_frame ->Label(-text=>"  File Name contains:  ")->pack();
my $lab3 = $input_frame ->Label(-text=>"  File contains the text:  ")->pack();
my $lab4 = $input_frame ->Label(-text=>"  Size of file(in Kb):  ")->pack();
my $space_lab1 = $input_frame ->Label(-text=>"")->pack();
my $lab5 = $input_frame ->Label(-text=>"  File last accessed(days):  ")->pack();
my $space_lab2 = $input_frame ->Label(-text=>"")->pack();

#create the browse button, entry widget and the radiobutton to their corresponding labels in input_frame widget
my $Dir_Sel = $input_frame -> Button(-text => "choose Folder", -command =>\&DirectorySelection)-> pack(-after=>$lab1);
my $ent1 = $input_frame ->Entry(-width=>30,-background=>'white',-state=>'normal')->pack(-after=>$lab1); 
my $ent2 = $input_frame ->Entry(-width=>30,-background=>'white',-state=>'normal')->pack(-after=>$lab2);
my $ent3 = $input_frame ->Entry(-width=>30,-background=>'white',-state=>'normal')->pack(-after=>$lab3);
my $ent4 = $input_frame ->Entry(-width=>30,-background=>'white',-state=>'normal',-justify=>'right')->pack(-after=>$lab4);
$input_frame->Radiobutton(-variable => \$size_boundry,-value => '1',-text => 'Atleast',)->pack(-after=>$lab4);
$input_frame->Radiobutton(-variable => \$size_boundry,-value => '-1',-text => 'Atmost',)->pack(-after=>$lab4);
my $ent5 = $input_frame ->Entry(-width=>30,-background=>'white',-state=>'normal',-justify=>'right')->pack(-after=>$lab5);
$input_frame->Radiobutton(-variable => \$day_boundry,-value => '1',-text => 'Atleast',)->pack(-after=>$lab5);
$input_frame->Radiobutton(-variable => \$day_boundry,-value => '-1',-text => 'Atmost',)->pack(-after=>$lab5);

#create a text area in the output_frame
our $output = $output_frame->Scrolled('Text',-background => 'white', -wrap=>'none',-scrollbars=>'osoe')->pack(-fill=>'both',-expand=>'1');	

#create the credit, search and close buttons in the command_frame widget
my $credit_button = $command_frame->Button(-text=>"credit",-command=>\&credit)->pack(-side=>'left');
my $close_button = $command_frame->Button(-text=>"Close",-command=>sub { exit })->pack(-side=>'right');
my $search_button = $command_frame->Button(-text=>"Search",-command=>\&search_proc)->pack(-side=>'right');

Tk::MainLoop();

sub DirectorySelection{
    $ent1 ->delete(0,'end');
    $path = $input_frame->chooseDirectory(-initialdir => '~',-title => 'Choose a directory');
    #warn "selected $dir";
    $ent1 -> insert(0,"$path");
}
      
sub credit{
    $mw -> messageBox(-message=>"This Desktop Search Tool is designed and developed by Sanjeev Kumar.",-type=>'ok');
}

sub search_proc{

    $name_keyword = $ent2->get();
    $content_keyword = $ent3->get();
    $file_size = $ent4->get();
    $days = $ent5->get(); 
    
    my $empty_status = 1;
    my %unique_files = ();
    $output ->delete('0.0','end');                                                                #clears the output text area
    execute();
    open (OUTFILE, "<output.txt") or die($output->insert('end',"NO FILE FOUND\n"));
    my (@file_name) = <OUTFILE>;
    foreach my $line (@file_name)
    {
      chomp($line);
      if($line ne "")
      {
        $unique_files{$line}++;
        $empty_status = 0;
      }
    }
    if($empty_status)
    {
      $output->insert('end',"NO FILE FOUND \n");
    }else
    { my $no_files=0;
      while(my ($key,$value)=each(%unique_files))
      { 
        $no_files++;
        my $size = ((stat($key))[7])/1000;
        $output->insert('end',"$key \t $size kb\n");
      }
      $output->insert('end',"\t$no_files files are found\n");
    }
    close(OUTFILE);
    unlink("output.txt");   
}

sub execute{
if(!(defined $path))
    {
     die($mw -> messageBox(-message=>"Folder to be searched can't be empty",-type=>'ok'));
    }
    if(defined $file_size && ($file_size < 0 || $file_size =~ /\D+/))
    {
     die($mw -> messageBox(-message=>"Invalid File Size",-type=>'ok'));
     }
    if(defined $days && ($days < 0 || $days =~ /\D+/))
    {
      die($mw -> messageBox(-message=>"Invalid Modification Date",-type=>'ok'));
    }
    if(defined $content_keyword && $content_keyword ne "")
    { 
      do("contentbased.pl");
    }
    if(defined $name_keyword && $name_keyword ne "")
    {
      do("namebased.pl");
    }
    if(defined $file_size && $file_size ne "")
    {
      do("sizebased.pl");
    }
    if(defined $days && $days ne "")
    {
      do("access_datebased.pl");
    }
}
