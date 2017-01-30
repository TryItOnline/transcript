TRANSCRIPT
An esoteric language based on IF game transcripts.
Ryan N. Freebern / rfreebern@corknut.org
Release 08May2002

--

I've always wanted to write a silly little esoteric language. It struck me that IF transcripts
would be easy to parse as a set of commands, and objects and NPCs within the game could be
used as variables. So I wrote TRANSCRIPT, an interpreted language that looks like an IF game
transcript.

There are only about 20 diffferent commands in the TRANSCRIPT language, but with them you can
perform initialisation of variables, addition, subtraction, multiplication, incrementation,
decrementation, string assignment, newline addition and subtraction (to or from strings), user
input, for loops, if-then blocks and more. I'm pretty sure TRANSCRIPT is Turing-complete, but
I don't care enough to prove it.

Almost all of the commands in TRANSCRIPT are prefixed by the character ">" and are almost
always typed entirely in uppercase letters. Spaces are important - the parser expects one space
between words, no more, and no less.

TRANSCRIPT can be considered a literate language, since the code and comments are written
together and the interpreter can easily distinguish between the two.

Here's a simple TRANSCRIPT program.

  In the House
  You are inside the small blue house on Pine St. The floor is carpeted and the walls are
  paneled in a light coloured wood. The door is to the north.
  Julie is here.

  >JULIE, Hello, World!
  Julie doesn't respond.

  >X JULIE
  Julie is a twentysomething woman with short brunette hair.

  >QUIT

When run through the TRANSCRIPT interpreter (transcript.pl) this produces the output

  ryan@Neverend:/home/ryan$ ./transcript.pl helloworld.trn
  Hello, World!

which is by far the most useful thing to spend your time on in any language. Let's dissect
this first program, line by line.

  In the House
  You are inside the small blue house on Pine St. The floor is carpeted and the walls are
  paneled in a light coloured wood. The door is to the north.

The first three lines are completely useless. They're just used to make the code look more like
a real IF game transcript. You don't need to have them, or you can have as much as you want.

  Julie is here.

This line establishes Julie as an NPC, which is a variable used to store strings (primarily).

  >JULIE, Hello, World!

This line places the string "Hello, World!" in Julie's memory.

  Julie doesn't respond.

More prettification.

  >X JULIE

This line causes Julie to print her contents (currently, "Hello, World!") to STDOUT.

  Julie is a twentysomething woman with short brunette hair.

Even more prettification.

  >QUIT

This marks the end of the program. When the parser reaches this line, it exits. This program is
very simplistic and doesn't do much. To see more complex programs, look at the other .trn files
included in this package. They are:

  test.trn
   - A sample program that performs several arithmetic functions.

  count.trn
   - A program that uses a for loop to count from 1 to 5.

  compare.trn
   - A program that takes two numbers as user input and tests their equality.
  
  fibonacci.trn
   - A program to compute the Fibonacci series value of any positive number.

An overview of all TRANSCRIPT functions follows. In this overview, the placeholders OBJ# and
NPC# will be used to indicate object and NPC variables, respectively. In the TRANSCRIPT
interpreter, there are three global variables: obj1, obj2, and obj3. These will be referred to
periodically to explain some functions.

VARIABLE DEFINITIONS
 NPC definition lines:
  NPC1 is here.
  NPC1 and NPC2 are here.
  NPC1, NPC2, and NPC3 are here.

 Object definition lines:
  You can see a OBJ1 here.
  You can see an OBJ1 and your OBJ2 here.
  You can see a OBJ1, a OBJ2, an OBJ3, the OBJ4, your OBJ5, and some OBJ6 here.

 Variables can only be single words (although names like foo_bar will work). They are not case-sensitive.
 Redeclaring variables later in a program causes them to be reset to their initial values: an empty string
 for NPCs, and 0 for objects.

GENERAL FUNCTIONS
 X OBJ1
 EX OBJ1
 -- Causes OBJ1 (or NPC1) to print its value to STDOUT.

 EXAMINE NPC1
 -- Causes OBJ1 (or NPC1) to print its value to STDOUT with variable values interpolated.
    When the string contains variable names preceded by a plus sign (like "+OBJ1") the EXAMINE
    function will replace these variable names with the actual value of the variable.

 G
 AGAIN
 -- Repeats the last command.

 QUIT
 -- Causes the interpreter to exit.

NPC FUNCTIONS
 NPC1, any string goes here.
 -- Sets NPC1's value to "any string goes here." with a newline on the end.

 KISS NPC1
 -- Adds a newline character to the end of NPC1's string.

 HIT NPC1
 -- Removes a newline character from the end of NPC1's string.
 
 TELL NPC1 ABOUT NPC2
 -- Concatenates NPC2's string. onto the end of NPC1's string.

OBJECT FUNCTIONS
 TAKE OBJ1
 GET OBJ1
 -- Sets global variable obj1 to OBJ1.

 LIFT OBJ1
 -- Increments OBJ1's value by 1.

 DROP OBJ1
 -- Decrements OBJ1's value by 1.
 
 TOSS OBJ1
 -- Set OBJ1 to a random value between 0 and OBJ1's current value (rounded down).
 
 SET OBJ1 TO 15
 -- Sets OBJ1's value to 15 (or any number, rounded down to nearest integer).

 HIT OBJ1 WITH OBJ2
 -- Sets OBJ1 to the product of OBJ1's value and OBJ2's value. OBJ2 remains unchanged.

 CUT OBJ1 WITH OBJ2
 -- Sets OBJ1 to the quotient of OBJ1's value and OBJ2's value, rounded down. OBJ2 remains unchanged.

 PUT OBJ1 IN OBJ2
 PUT OBJ1 ON OBJ2
 -- Adds OBJ1's value to OBJ2's value. OBJ1 remains unchanged.

 TAKE OBJ1 FROM OBJ2
 TAKE OBJ1 OUT OF OBJ2
 -- Subtracts OBJ1's value from OBJ2's value. OBJ1 remains unchanged.

IF-THEN BLOCKS
 TELL NPC1 ABOUT OBJ1
 -- Sets global variable obj3 to the value of OBJ1 (for use in if-then statements).
 
 SHOW OBJ1 TO NPC1
 -- Sets global variable obj1 to OBJ1 (for use in if-then statements).

 ASK NPC1 ABOUT OBJ2
 -- Sets global variable obj2 to OBJ2 (for use in if-then statements) and begins if-then.

 Once obj1 and obj3 are set, and the ASK NPC1 ABOUT OBJ2 statement occurs, an if-then block
 is evaluated. The condition tested is based on the value of obj3, as follows:

  obj3 value   condition
 ------------ -----------
      0            =
     <0            <
     >0            >

 The actual if-then statement is if(obj1 obj3 obj2), so if obj3 is 0, then the obj1 and obj2 are
 tested for equality, and if obj3 is 1, obj1 is tested for being greater than obj2.

 Every statement following an ASK NPC1 ABOUT OBJ2 is inside the if-then block until the parser
 encounters the following:

 SHOW OBJ2 TO NPC1
 -- Marks end of if-then block.

 In this case, OBJ2 and NPC1 must be the same as in the opening ASK NPC1 ABOUT OBJ2 statement.

FOR LOOPS
 ATTACH OBJ1 TO OBJ2
 TIE OBJ1 TO OBJ2
 FASTEN OBJ1 TO OBJ2
 HOOK OBJ1 TO OBJ2
 ATTACH OBJ1 TO OBJ2 WITH OBJ3
 TIE OBJ1 TO OBJ2 WITH OBJ3
 FASTEN OBJ1 TO OBJ2 WITH OBJ3
 HOOK OBJ1 TO OBJ2 WITH OBJ3
 -- These statements mark the beginning of a for loop.

 For loops will loop from the value of OBJ1 to the value of OBJ2 inclusive, stepping by the
 value of OBJ3 if OBJ3 is specified (or 1 if not). All statements following the above
 statement will be looped over until the parser encounters a similar

 DETACH OBJ1 FROM OBJ2
 UNHOOK OBJ1 FROM OBJ2
 UNTIE OBJ1 FROM OBJ2
 UNFASTEN OBJ1 FROM OBJ2
 -- These statements mark the end of a for loop.
 
 OBJ1 is incremented by 1 (or OBJ3's value, if OBJ3 is given) each execution of the loop, so
 at the end of the loop, OBJ1 will be equal to OBJ2's value plus 1 (or plus OBJ3's value). If
 OBJ2 or OBJ3 are modified within the loop, the actual loop will be modified accordingly (so,
 if you increment OBJ3 by 1 each time through the loop, the step will be 1 larger in the next
 loop iteration.)

USER INPUT
 You may retrieve user input via the following:

 RESTORE
 -- Cue user-input function.

 OBJ1.sav
 NPC1.sav
 -- Specify which variable to store input data in.

 For instance, the following code snippet takes a bit of user input and puts it in a variable:

  >RESTORE
  Specify name of saved game file to restore:

  >BOOK.sav
  Restored.

 When the RESTORE command is encountered, the program waits for the user to type a value and hit
 the enter key. The newline is truncated from the value and the value is stored in the object
 specified by the "saved game file" (i.e. BOOK.sav specifies the BOOK variable, etc.) Numeric
 data input should be stored in objects and string data input should be stored in NPCs, but
 there is no enforcement to this rule.

---

I'm open to suggestions and fixes. Email me.
Ryan N. Freebern / rfreebern@corknut.org
