#!/usr/bin/env perl

use Cwd 'abs_path';
use File::Spec::Functions 'abs2rel';

while (my $line = <>) {
  if ($line =~ /runtime error:/) {
    $line =~ /(?<file>[^:]+):(?<line>[0-9]+):(?<col>[0-9]+): runtime error: (?<msg>.+)/;
    my $file = abs2rel(abs_path($+{file}), $ENV{GITHUB_WORKSPACE});
    print "::notice file=$file,line=$+{line},col=$+{col},title=Sanitizer::$+{msg}";
  } elsif ($line =~ /SUMMARY: AddressSanitizer: [^0-9]/) {
    $line =~ /AddressSanitizer: (?<id>[A-Za-z-]+) (?<file>[^:]+):(?<line>[0-9]+):(?<col>[0-9]+) (?<msg>.+)/;
    my $file = abs2rel(abs_path($+{file}), $ENV{GITHUB_WORKSPACE});
    print "::error file=$file,line=$+{line},col=$+{col},title=Sanitizer::$+{id} $+{msg}";
  } elsif ($line =~ /ERROR: LeakSanitizer:/) {
    readline STDIN; readline STDIN;
    my $line = readline STDIN;
    my $line = readline(STDIN) if $line =~ /in __interceptor/;
    $line =~ /#1 0x[a-f0-9]+ (?<msg>in [A-Za-z0-9_]+) (?<file>[^:]+):(?<line>[0-9]+):(?<col>[0-9]+)/;
    my $file = abs2rel(abs_path($+{file}), $ENV{GITHUB_WORKSPACE});
    print "::error file=$file,line=$+{line},col=$+{col},title=Sanitizer::detected memory leak $+{msg}";
  } elsif (/ERROR: libFuzzer: out-of-memory/) {
    readline STDIN; readline STDIN; readline STDIN;
    while ($line =~ /in (__|fuzzer)/) {
      my $line = readline STDIN;
    }
    if ($line =~ /^Live Heap Allocations/) {
      print '::error file=src/scanner.c,title=Sanitizer::out of memory (potential infinite loop)';
    } else {
      $line =~ /#[0-9]+ 0x[a-f0-9]+ (?<msg>in [A-Za-z0-9_]+) (?<file>[^:]+):(?<line>[0-9]+):(?<col>[0-9]+)/;
      my $file = abs2rel(abs_path($+{file}), $ENV{GITHUB_WORKSPACE});
      print "::error file=$file,line=$+{line},col=$+{col},title=Sanitizer::out of memory $+{msg}";
    }
  }
}
