#!/usr/bin/perl
#
#Created by Walter Cocca 03 January 2019

#Example for usage: perl fasta_filtering.v1.pl fasta_files/ 100

if ((!$ARGV[0]) && (!$ARGV[1])) {   
print "Please introduce the directory where the .fasta files are stored:\n";
$dir=<STDIN>;                    
chomp $dir;
print "Please introduce the value of aln length you want to cut of: \nRemeber, the files where the aln is shorter than this valuse will be moved in a new folder\n";
$filter_val=<STDIN>; #this value can be whatever value the user wants. Can also be =1 if you want to eliminate only the 
#files where the sequnces lines are empty and you have only the name of the sequnces
chomp $filter_val;
}else{
$dir=$ARGV[0];
chomp $dir;
$filter_val=$ARGV[1];
chomp $filter_val;
}
my $excluded_folders =`mkdir excluded_fasta`; #creating the folder where to move the excluded .fasta files
@files = <$dir/*.fasta>;
foreach $file (@files) {
#  print "Processing file $file\n";
  open(input,$file);
  $mark="";
  $seq="";
  while(<input>){ #since the files at this point are all aln sequences of the same length, i will store the length
  #of all the sequences together and then divide it by the number of sequences, sotred in the varible $mark.
    chomp $_;
    if($_ =~ /^>/){ 
      $mark++;
      $length=length($seq);
      }else{
      $seq.=$_;
    }
  }
 $aln_length = int($length/$mark); 
  if($aln_length <= $filter_val){ #if the length of asequence is <= to the value indicated in the commnad line, that file will be moved to a new folder.
    print "This alignement is $aln_length nucleotides long. The file $file will be moved\n";
    my $excluded_files =`mv $file excluded_fasta/`;
  }
close(input);
}