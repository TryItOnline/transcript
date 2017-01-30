#!/usr/bin/perl -w

# TRANSCRIPT
# A parser for an esoteric language based on IF game transcripts.
# Ryan N. Freebern / rfreebern@corknut.org

use strict;
use vars qw(@code %npcs %objs $line $prevcmd @cmds $cmd $obj1 $obj2 $obj3);
my $debug = 0;

# Read specified file.
my $file = $ARGV[0];
if($file) {
 open(T, "<$file") or die "Can't open $file for reading.\n";
 @code = <T>;
 close(T);
}
@code = reverse @code;

# $prevcmd is used to hold the previous successful command, so 'G' works correctly.
$prevcmd = "";

# Loop through all lines of code and process them.
while ($line = &getLine()) {
 if($line =~ /^>/) {
  @cmds = split(/\. /, $line);
  foreach $cmd (@cmds) {
   $cmd =~ s/^\s+|\s+$|^>//;
   &parseLine(">" . $cmd);
  }
 } else {
  &parseLine($line);
 }
}

# Parses each command and does the specified action.
sub parseLine {
 my $line = shift;
 my $temp;

 # Catch NPC definitions.
 if    ($line =~ /^\w+ is here./) { &setupNPCs($line); }
 elsif ($line =~ /^\w+(, \w+)*?(,)? and \w+ are here./) { &setupNPCs($line); }
 
 # Catch object definitions.
 elsif ($line =~ /^You can see (a|an|the|your|some) \w+ here./) { &setupObjs($line); }
 elsif ($line =~ /^You can see (a|an|the|your|some) \w+(, (a|an|the|your|some) \w+)*?(,)? and (a|an|the|your|some) \w+ here./) { &setupObjs($line); }
 
 # Generic commands.
 elsif ($line =~ /^>(X|EX) (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $npcs{lc($2)}) { print $npcs{lc($2)}; }
  elsif (exists $objs{lc($2)}) { print $objs{lc($2)}, "\n"; }
  else { print "Error: no such NPC/object $2.\n"; }
 }
 elsif ($line =~ /^>EXAMINE (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $npcs{lc($1)}) { &processPrint($npcs{lc($1)}); }
  elsif (exists $objs{lc($1)}) { &processPrint($objs{lc($1)}); }
  else { print "Error: no such NPC/objext $1.\n"; }
 }
 elsif ($line =~ /^>(G|AGAIN)\.?$/) { if ($debug) { print "Doing $prevcmd AGAIN.\n"; }  &parseLine($prevcmd); }
 elsif ($line =~ /^>QUIT\.?$/) { exit 1; }
 
 # NPC commands.
 elsif ($line =~ /^>(\w+), (.*?)$/) {
  $prevcmd = $line;
  if (exists $npcs{lc($1)}) { $npcs{lc($1)} = "$2\n"; if ($debug) { print "$1 gets message $2\n"; } }
  else { print "Error: no such NPC $1\n"; }
 }
 elsif ($line =~ /^>KISS (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $npcs{lc($1)}) { $npcs{lc($1)} .= "\n"; if ($debug) { print "$1 gets newline."; } }
  else { print "Error: no such NPC $1\n"; }
 }
 elsif ($line =~ /^>HIT (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $npcs{lc($1)}) { chomp $npcs{lc($1)}; if ($debug) { print "$1 gets chomped."; } }
  else { print "Error: no such NPC $1\n"; }
 }
 elsif ($line =~ /^>SHOW (\w+) TO (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)} && exists $npcs{lc($2)}) { $obj1 = $1; }
  else { print "Error: no such NPC $2 or no such object $1.\n"; }
 }
 elsif ($line =~ /^>TELL (\w+) ABOUT (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $npcs{lc($1)}) {
   if (exists $npcs{lc($2)}) {
    $npcs{lc($1)} .= $npcs{lc($2)};
   } elsif (exists $objs{lc($2)}) {
    $obj3 = $objs{lc($2)};
   } else {
    print "Error: no such object or NPC $2\n";
   }
  } else { print "Error: no such NPC $1.\n"; }
 }
 elsif ($line =~ /^>ASK (\w+) ABOUT (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($2)} && exists $npcs{lc($1)}) {
   $obj2 = $2; $temp = $1;
   &doIfThen($obj1, $obj2, $obj3, $temp);
  } else { print "Error: no such NPC $2 or no such object $1.\n"; }
 }
 
 # Object commands.
 elsif ($line =~ /^>(TAKE|GET) (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($2)}) { $obj1 = lc($2); if ($debug) { print "obj1 now $2.\n"; } }
  else { print "Error: no such object $2\n"; }
 }
 elsif ($line =~ /^>LIFT (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)}) { $objs{lc($1)}++; if ($debug) { print "$1 incremented to $objs{lc($1)}.\n"; } }
  else { print "Error: no such object $1\n"; }
 }
 elsif ($line =~ /^>DROP (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)}) { $objs{lc($1)}--; if ($debug) { print "$1 decremented to $objs{lc($1)}.\n"; } }
  else { print "Error: no such object $1\n"; }
 }
 elsif ($line =~ /^>TOSS (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)}) {
   $objs{lc($1)} = rand $objs{lc($1)};
   $objs{lc($1)} =~ s/\..*//;
   if ($debug) { print "$1 randomised to $objs{lc($1)}.\n"; }
  } else { print "Error: no such object $1\n"; }
 }
 elsif ($line =~ /^>SET (\w+) TO (\d+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)}) {
   $objs{lc($1)} = $2;
   $objs{lc($1)} =~ s/\..*//;
   if ($debug) { print "$1 set to $objs{lc($1)}.\n"; }
  } else { print "Error: no such object $1\n"; }
 }
 elsif ($line =~ /^>HIT (\w+) WITH (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)} && exists $objs{lc($2)}) {
   $objs{lc($1)} *= $objs{lc($2)};
   if ($debug) { print "$1 multiplied by $2 ($objs{lc($2)}) giving $objs{lc($1)}.\n"; }
  } else { print "Error: no such object $1 or $2\n"; }
 }
 elsif ($line =~ /^>CUT (\w+) WITH (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)} && exists $objs{lc($2)}) {
   $objs{lc($1)} /= $objs{lc($2)};
   $objs{lc($1)} =~ s/\..*//;
   if ($debug) { print "$1 divided by $2 ($objs{lc($2)}) giving $objs{lc($1)}.\n"; }
  } else { print "Error: no such object $1 or $2\n"; }
 }
 elsif ($line =~ /^>PUT (\w+) (IN|ON) (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)} && exists $objs{lc($3)}) {
   $objs{lc($3)} += $objs{lc($1)};
   if ($debug) { print "$1 added to $3 giving $objs{lc($3)}.\n"; }
  } else { print "Error: no such object $1 or $3\n"; }
 }
 elsif ($line =~ /^>TAKE (\w+) (OUT OF|FROM) (\w+)\.?$/) {
  $prevcmd = $line;
  if (exists $objs{lc($1)} && exists $objs{lc($3)}) {
   $objs{lc($3)} -= $objs{lc($1)};
   if ($debug) { print "$1 subtracted from $3 giving $objs{lc($3)}.\n"; }
  } else { print "Error: no such object $1 or $3.\n"; }
 }
 elsif ($line =~ /^>(ATTACH|FASTEN|HOOK|TIE) (\w+) TO (\w+)( WITH )?(\w+)?\.?$/) {
  if (exists $objs{lc($2)} && exists $objs{lc($3)}) {
   $obj1 = lc($2);
   $obj2 = lc($3);
   if (exists $objs{lc($5)}) { $obj3 = lc($5); } else { $obj3 = " "; }
   if ($debug) {
    print "Looping from $objs{$obj1} to $objs{$obj2}";
    if ($obj3 ne " ") { print " step $objs{$obj3}.\n"; } else { print ".\n"; }
   }
   &doForLoop($obj1, $obj2, $obj3);
   if ($debug) { print "Exited loop.\n"; }
  } else { print "Error: no such object $2 or $3.\n"; }
 }
 elsif ($line =~ /^>RESTORE\.?$/) {
  $prevcmd = $line;
  $temp = 1;
  while($temp) { $line = getLine(); if($line =~ /^>(\w+)\.sav$/) { $temp = 0; } }
  $line =~ s/^>(\w+)\.sav$/$1/; $temp = $line; chomp $temp;
  if (exists $objs{lc($temp)}) { $objs{lc($temp)} = <STDIN>; chomp $objs{lc($temp)}; if ($debug) { print "Read $objs{lc($temp)} into $temp.\n" } }
  else { print "Error: no such object $temp.\n"; }
 }
}

# Return the next line of code.
sub getLine { return pop @code; }

# Parse NPC declaration line into NPC names.
sub setupNPCs {
 my $line = shift;
 if ($debug) { print "Found NPCs line: $line"; }
 
 chomp $line;
  
 # Split line into character names.
 my @ns = split(/\s+/, $line);
 my $n;
 foreach $n (@ns) {
  if($n =~ /([A-Z]\w+)/) { $n = lc($1); } else { next; }
  $npcs{$n} = ""; if ($debug) { print "Added NPC $n.\n"; }
 }
}

# Parse objects line into object names.
sub setupObjs {
 my $line = shift;
 if ($debug) { print "Found objects line: $line"; }
 
 while($line =~ /(You can see | a | an | and | the | your | some |, | here\.)/) {
  $line =~ s/$1/ /g;
 }
 chomp $line;
 
 # Split line into object names.
 my @ns = split(/\s+/, $line);
 my $n;
 foreach $n (@ns) {
  if($n =~ /(\w+)/) { $n = lc($1); } else { next; }
  $objs{$n} = 0; if ($debug) { print "Added object $n with value $objs{$n}.\n"; }
 }
}

# Interpolate variable values into a string.
sub processPrint {
 my $text = shift;
 my ($lckey, $uckey);
 
 foreach $lckey (keys %objs) {
  $uckey = uc($lckey);
  $text =~ s/\+$uckey/$objs{$lckey}/ge;
 }
 
 foreach $lckey (keys %npcs) {
  $uckey = uc($lckey);
  $text =~ s/\+$uckey/$npcs{$lckey}/ge;
 }
 
 print $text;
}

# Process a for loop.
sub doForLoop {
 my ($from, $to, $step) = @_;
 my (@cmds, $cmd, $i, @tmp);
 $from = uc($from);
 $to = uc($to);
 $step = uc($step);
 
 $cmd = getLine();
 while($cmd !~ /^>(DETACH|UNTIE|UNHOOK|UNFASTEN) $from FROM $to\.?/) {
  push @cmds, $cmd;
  $cmd = &getLine();
 }
 
 if ($objs{lc($from)} <= $objs{lc($to)}) {
  push @tmp, @cmds;
  
  if($step eq " ") {
   push @tmp, ">LIFT $from";
   push @tmp, ">ATTACH $from TO $to";
  } else {
   push @tmp, ">PUT $step IN $from";
   push @tmp, ">ATTACH $from TO $to WITH $step";
  }
  push @tmp, @cmds;
  
  push @tmp, ">DETACH $from FROM $to";
  @tmp = reverse @tmp;
  push @code, @tmp;
 }
}

# Process an if-then block.
sub doIfThen {
 my ($first, $second, $compop, $npc) = @_;
 my (@cmds, $cmd, $i);
 $first = uc($first);
 $second = uc($second);
 $npc = uc($npc);
 
 chomp $first; chomp $second;
 $cmd = getLine();
 while($cmd !~ /^>SHOW $second TO $npc\.?$/) {
  if ($cmd =~ /^>$npc, /) {
   $cmd =~ s/$first/$objs{lc($first)}/ge;
   $cmd =~ s/$second/$objs{lc($second)}/ge;
  }
  push @cmds, $cmd;
  $cmd = getLine();
 }
 
 $first = $objs{lc($first)};
 $second = $objs{lc($second)};
 @cmds = reverse @cmds;
 if ($compop == 0) { if ($first == $second) { push @code, @cmds; } }
 elsif ($compop < 0) { if ($first < $second) { push @code, @cmds; } }
 elsif ($compop > 0) { if ($first > $second) { push @code, @cmds; } }
}
