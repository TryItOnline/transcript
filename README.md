# [TRANSCRIPT](http://web.archive.org/web/20071018030927/http://www.corknut.org/code/transcript/)

**The materials in this repository were not produced by the owner of the repository. Please click on the link below to go to the original web site these materials were copied from. The purpose of this copy is to automate setup of a mirror for https://tryitonline.net. It's more straight forward to clone a repository than to parse a web page.**

Implementation of [this language](https://esolangs.org/wiki/TRANSCRIPT) from [here](https://web.archive.org/web/20071018030927/http://www.corknut.org/code/transcript/transcript15May2002.tar.gz).

An esoteric language that looks like interactive fiction game transcripts.

## Simple Overview

I've always wanted to write a silly little esoteric language. It struck me that IF transcripts would be easy to parse as a set of commands, and objects and NPCs within the game could be used as variables. So I wrote TRANSCRIPT, an interpreted language that looks like an IF game transcript.

## Documentation

All documentation for TRANSCRIPT can be found in the file README.txt within the tarball, or in the same file [here](README.txt). Perl coders can learn more about the script's operation by reading the source code, which is ugly but well-commented.

## Known Problems

TRANSCRIPT is finicky about syntax, but hey, I designed the language, so that's my prerogative.
TRANSCRIPT is very limited, but it's not supposed to really be a useful language, so who cares.
Reporting Bugs

TRANSCRIPT is still very much a work in progress. If you find any bugs, omissions, errors, or if you have any questions or suggestions, please feel free to email me and let me know. When reporting bugs/problems please be as specific and include as much information about your script and setup as possible. Including a TRANSCRIPT source file that reproduces the errant behaviour will help expedite a timely and accurate solution to the problem.

## Sample Programs

Along with the sample programs included in the download below, the following sample programs are available here:

[rect.txt](samples/rect.txt) - A program that prints X-by-Y rectangles based on user input. Uses nested for loops.
Philipp Winterberg, creator of ZT, wrote a TRANSCRIPT version of [99 Bottles of Beer](samples/Bottles.trn.txt). Excellent!
If you write any programs that you want featured here, just email me and I'll gladly put them up.

## Download

The TRANSCRIPT tarball contains the following files:

- [transcript.pl](transcript.pl) - the TRANSCRIPT interpreter
- [README.txt](README.txt) - my introduction to the language
- [helloworld.trn](samples/helloworld.txt) - Hello, World! sample source file.
- [test.trn](samples/test.txt) - Arithmetic demonstration sample source file.
- [count.trn](samples/count.txt) - For loop demonstration source file.
- [compare.trn](samples/compare.txt) - Numeric comparison (if-then) sample source file.
- [fibonacci.trn](samples/fibonacci.txt) - Fibonacci calculator sample source file.

## Plans

The following things are in the works:

Subroutines with any number of input parameters and return values.
Better error reporting and debugging information.
Thanks to...

My thanks go out to the following people for helping make TRANSCRIPT better.

Mark Musante / <http://world.std.com/~olorin/>
Doug Jones / <http://www.plover.net/~limax>
