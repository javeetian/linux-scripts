#!/usr/bin/perl -w
# cscope-indexer.pl --- 
# Author: Ye Wenbin <wenbinye@gmail.com>
# Created: 10 Sep 2008
# Version: 0.01

use warnings;
use strict;
use Getopt::Long qw/:config pass_through/;
use File::Find;

# May have to edit this:
if ( $^O =~ /win/ ) {
 $ENV{PATH} = "d:\\Programs\\cygwin\\usr\\local\\bin;$ENV{PATH}";
}
else {
 $ENV{PATH} = "/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:$ENV{PATH}";
}
my $LIST_ONLY;
my $DIR='.';
my $LIST_FILE='cscope.files';
my $DATABASE_FILE='cscope.out';
my $RECURSE;
my $VERBOSE;

GetOptions(
 "file=s" => \$DATABASE_FILE,
 "index=s" => \$LIST_FILE,
 "list" => \$LIST_ONLY,
 "recurse" => \$RECURSE,
 "verbose" => \$VERBOSE,
);
$DIR = shift if @ARGV;
message("Creating list of files to index ...");

my @files;
if ( $RECURSE ) {
 find( sub {
 if ( -f $_ || -l $_ ) {
 push @files, $File::Find::name;
 }
 }, $DIR);
} else {
 @files = <$DIR/*>;
}
@files = sort map {s{^\./}{}; $_} grep { /\.([chly](xx|pp)?|cc|hh)$/
 && $_ !~ m{/CVS/}
 && $_ !~ m{/RCS/}
 } @files;
open(my $fh, ">", $LIST_FILE) or die "Can't create file $LIST_FILE: $!";
print {$fh} join("\n", @files), "\n";
close $fh;
message("Creating list of files to index ... done");
if ( $LIST_ONLY ) {
 exit;
}
message("Indexing files ...");
system("cscope", "-b", "-i", $LIST_FILE, "-f", $DATABASE_FILE) == 0 or die "$!";
message("Indexing files ... done");

sub message {
 print @_, "\n" if $VERBOSE;
}