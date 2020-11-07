---
#### *The following is copy-pasted from the [esolangs article](https://esolangs.org/wiki/Asparagus), which is still a work in progress...*
---
<div>
<dl><dd><i>This is still a work in progress. It may be changed in the future.</i></dd></dl>
<p><b>Asparagus</b> is an esoteric programming language created by yours truly, and was designed just to be an abomination to use. The name "<i>Asparagus</i>" is short for <i>Asparagus</i>. Isn't that helpful?
</p>
<div id="toc" class="toc"><input type="checkbox" role="button" id="toctogglecheckbox" class="toctogglecheckbox" style="display:none"><div class="toctitle" dir="ltr" lang="en"><h2>Contents</h2><span class="toctogglespan"><label class="toctogglelabel" for="toctogglecheckbox"></label></span></div>
<ul>
<li class="toclevel-1 tocsection-1"><a href="#Syntax"><span class="tocnumber">1</span> <span class="toctext">Syntax</span></a>
<ul>
<li class="toclevel-2 tocsection-2"><a href="#Math"><span class="tocnumber">1.1</span> <span class="toctext">Math</span></a>
<ul>
<li class="toclevel-3 tocsection-3"><a href="#Conditionals"><span class="tocnumber">1.1.1</span> <span class="toctext">Conditionals</span></a></li>
</ul>
</li>
<li class="toclevel-2 tocsection-4"><a href="#Numbers"><span class="tocnumber">1.2</span> <span class="toctext">Numbers</span></a></li>
<li class="toclevel-2 tocsection-5"><a href="#Subroutines"><span class="tocnumber">1.3</span> <span class="toctext">Subroutines</span></a></li>
<li class="toclevel-2 tocsection-6"><a href="#Environment_Variables"><span class="tocnumber">1.4</span> <span class="toctext">Environment Variables</span></a></li>
</ul>
</li>
<li class="toclevel-1 tocsection-7"><a href="#Using_the_dreaded_Asparagus_interpreter"><span class="tocnumber">2</span> <span class="toctext">Using the dreaded Asparagus interpreter</span></a>
<ul>
<li class="toclevel-2 tocsection-8"><a href="#Special_modes"><span class="tocnumber">2.1</span> <span class="toctext">Special modes</span></a></li>
<li class="toclevel-2 tocsection-9"><a href="#Errors.2C_Warnings.2C_and_Status_Messages"><span class="tocnumber">2.2</span> <span class="toctext">Errors, Warnings, and Status Messages</span></a></li>
</ul>
</li>
<li class="toclevel-1 tocsection-10"><a href="#Sample_Programs"><span class="tocnumber">3</span> <span class="toctext">Sample Programs</span></a>
<ul>
<li class="toclevel-2 tocsection-11"><a href="#Hello.2C_World.21"><span class="tocnumber">3.1</span> <span class="toctext">Hello, World!</span></a></li>
<li class="toclevel-2 tocsection-12"><a href="#Cat"><span class="tocnumber">3.2</span> <span class="toctext">Cat</span></a></li>
</ul>
</li>
</ul>
</div>

<h1><span class="mw-headline" id="Syntax">Syntax</span></h1>
<p>Syntax in Asparagus isn't like normal languages: each command and argument is treated as a 1 byte unsigned integer, effectively making every program a primitive binary file. There also is no way to determine if a value is an argument or a command, making it fun for all!
</p><p>There are 65536 variables in 256 groups of 256, which are all treated as strings. When doing math, they are converted to single-precision float, the math is done, then converted back to a string. If the variable does not contain just numbers, then when it is converted it is changed to 0 except if it follows the number prefixes <i>(see Numbers)</i>.
</p><p>Only one group of variables can be accessed at one time and can be switched by using a command. All variables EXCEPT for variables in group 0 are treated as private/local/whatever <i>(see Variables.)</i>
</p><p>Note: all arguments refer to variable numbers, unless otherwise noted.
</p>
<table class="wikitable">

<tbody><tr>
<th>Command value</th>
<th>Arguments</th>
<th>Description
</th></tr>
<tr>
<td>0</td>
<td>1</td>
<td>Prints a "notice" to the log, containing the current index line and argument 1 (literal)
</td></tr>
<tr>
<td>1</td>
<td>2+</td>
<td>Sets variable argument 1 to argument 2 (literal) number of characters after the location of argument 2 as a string <i>(needs clarification)</i>
</td></tr>
<tr>
<td>2</td>
<td>3</td>
<td>Prints the contents of argument 3 at position argument 1 (literal) x and argument 2 (literal also) y*
</td></tr>
<tr>
<td>3</td>
<td>2+</td>
<td>Does argument 1 (literal) math operation <i>(see Math)</i>
</td></tr>
<tr>
<td>4</td>
<td>1</td>
<td>Adds the current key on the keyboard pressed to the variable argument 1. If no key is pressed, the variable does not change
</td></tr>
<tr>
<td>5</td>
<td>1</td>
<td>Sets the index location to argument 1*
</td></tr>
<tr>
<td>6</td>
<td>2</td>
<td>If argument 1 is not equal to 0, then set the index location to the argument 2*
</td></tr>
<tr>
<td>7</td>
<td>2</td>
<td>Sets the start of subroutine argument 1 (literal) to position argument 2 <i>(see Subroutines.)</i>*
</td></tr>
<tr>
<td>8</td>
<td>1</td>
<td>Runs subroutine argument 1 (literal) <i>(see Subroutines)</i>
</td></tr>
<tr>
<td>9</td>
<td>1</td>
<td>Sets the variable group to argument 1 (literal)
</td></tr>
<tr>
<td>10</td>
<td>2</td>
<td>Sets variable argument 1 to enviroment variable argument 2 (literal) <i>(see Enviroment Variables)</i>
</td></tr>
<tr>
<td>11</td>
<td>3</td>
<td>Sets variable argument 1 (in current slot) to variable argument 3 in slot argument 2 (literal)
</td></tr>
<tr>
<td>12</td>
<td>4</td>
<td>Sets variable argument 4 to result of the conditional statement argument 1 (literal) <i>(see Math/Conditionals)</i>
</td></tr>
<tr>
<td>255</td>
<td>0</td>
<td>Ends program/subroutine <i>(see Subroutines)</i>
</td></tr></tbody></table>
<p><i>*Remember: if a variable contains non-numeric characters, then it is treated as 0 unless it follows the number prefixes (see Numbers)</i>
</p>
<h2><span class="mw-headline" id="Math">Math</span></h2>
<p>See command 3 if you don't know what this is.
</p><p>The result of each operation is put in variable argument 2, and just like above, all arguments refer to variables unless noted (which actually never happens.)
</p>
<table class="wikitable">

<tbody><tr>
<th>ID</th>
<th>Additional arguments</th>
<th>Description
</th></tr>
<tr>
<td>0</td>
<td>2</td>
<td>Argument 3 + argument 4*
</td></tr>
<tr>
<td>1</td>
<td>2</td>
<td>Argument 3 - argument 4*
</td></tr>
<tr>
<td>2</td>
<td>2</td>
<td>Argument 3 * argument 4*
</td></tr>
<tr>
<td>3</td>
<td>2</td>
<td>Argument 3 / argument 4*
</td></tr>
<tr>
<td>4</td>
<td>2</td>
<td>Argument 3 ^ argument 4*
</td></tr>
<tr>
<td>5</td>
<td>2</td>
<td>Argument 3 mod argument 4*
</td></tr>
<tr>
<td>6</td>
<td>1</td>
<td>Value of argument 3* <sup>†</sup>
</td></tr>
<tr>
<td>7</td>
<td>1</td>
<td>Argument 2 = argument 3 as a string
</td></tr>
<tr>
<td>8</td>
<td>2</td>
<td>Argument 3 and argument 4 joined together as strings
</td></tr>
<tr>
<td>9</td>
<td>1</td>
<td>Length of argument 3 as a string
</td></tr>
<tr>
<td>10</td>
<td>1</td>
<td>Argument 3 rounded*
</td></tr>
<tr>
<td>11</td>
<td>0</td>
<td>Generates a single-precision random number 0-1
</td></tr>
<tr>
<td>12</td>
<td>1</td>
<td><a rel="nofollow" class="external text" href="https://en.wikipedia.org/wiki/Bitwise_operation">Bitwise</a> NOT argument 3*
</td></tr>
<tr>
<td>13</td>
<td>2</td>
<td>Bitwise argument 3 AND argument 4*
</td></tr>
<tr>
<td>14</td>
<td>2</td>
<td>Bitwise argument 3 OR argument 4*
</td></tr>
<tr>
<td>15</td>
<td>2</td>
<td>Bitwise argument 3 XOR argument 4*
</td></tr></tbody></table>
<p><i><sup>*</sup>Remember! If a string contains non-numeric characters in it, it always returns 0 unless it follows the number prefixes (see Numbers.)</i>
</p><p><i><sup>†</sup>Is pretty much useless unless you need to convert a number prefix or decide whether a variable is a number or not.</i>
</p>
<h3><span class="mw-headline" id="Conditionals">Conditionals</span></h3>
<p>Conditionals have the same behavior as the bitwise math operations, except they are <b>not</b> bitwise, they are simply logical. That means that anything that is NOT a 0 is true, while anything that IS 0 is treated as false.
</p><p>Again, all arguments represent variables unless noted, which doesn't happen because nothing here is literal. And also the results of these calculations are put into variable argument 4.
</p>
<table class="wikitable">

<tbody><tr>
<th>ID</th>
<th>Description
</th></tr>
<tr>
<td>0</td>
<td>Argument 2 = argument 3
</td></tr>
<tr>
<td>1</td>
<td>Argument 2 AND argument 3
</td></tr>
<tr>
<td>2</td>
<td>Argument 2 OR argument 3
</td></tr>
<tr>
<td>3</td>
<td>Argument 2 XOR argument 3
</td></tr>
<tr>
<td>4</td>
<td>Argument 2 &gt; argument 3
</td></tr>
<tr>
<td>5</td>
<td>Argument 2 ≥ argument 3
</td></tr></tbody></table>
<h2><span class="mw-headline" id="Numbers">Numbers</span></h2>
<p>Numbers in Asparagus can be represented in a variable in 4 ways:
</p>
<ol><li>As a number</li>
<li>As a hexadecimal value prefixed with <code>&amp;H</code></li>
<li>As a octal value prefixed with <code>&amp;O</code></li>
<li>As a binary value prefixed with <code>&amp;B</code></li></ol>
<p>Seem familiar?
</p><p>Any time it needs to be used, it is converted to decimal then equated. It does <i>not</i> convert it back, meaning that when you add two numbers together, no matter the inputs, would always return a decimal value out. To convert a number to another type, use command 13.
</p>
<h2><span class="mw-headline" id="Subroutines">Subroutines</span></h2>
<p>Alright! Now for the <i>fun</i> stuff. Subroutines aren't like any other program's subroutines. Well, maybe it is a little bit, but that's not the point.
</p><p>To define a subroutine, you use command 7, with argument 1 (literal) being the slot of the subroutine to put it in, and argument 2 being the variable storing the position that the subroutine starts at. The end of the subroutine is marked by command 255. Note that 255 also can stop the execution of the program if used outside of a subroutine.
</p><p>In a subroutine, all variables EXCEPT those used in group 255 are treated as local, which means that they do not affect any of the variables in the main program and they are immediately deleted when execution of the subroutine is completed. In other words, local variables are completely separate from a subroutine and the main program. You can use group 255 variables to contain data like arguments and outputs.
</p><p>To call a subroutine, you use command 8 with argument 1 being the number of the subroutine to call. A new instance of the interpreter runs and execution is halted on the main routine.
</p>
<h2><span class="mw-headline" id="Environment_Variables">Environment Variables</span></h2>
<p>Using command 10, you can set variable argument 1 to environment variable argument 2. Additionally, you can write to environment variables using command 14.
</p><p>Here is a list of the environment variables you can use:
</p><p><i>UI=Unsigned Integer, RO=Read only, FL=Float, ST=String, RW=Read and write</i>
</p>
<table class="wikitable">

<tbody><tr>
<th>ID</th>
<th>Properties</th>
<th>Description
</th></tr>
<tr>
<td>0</td>
<td>UI,RO*</td>
<td>The current variable group
</td></tr>
<tr>
<td>1</td>
<td>UI,RO<sup>†</sup></td>
<td>The byte position of the command. In subroutines, these would be in relation to the start of the subroutine.
</td></tr>
<tr>
<td>2</td>
<td>FL,RO</td>
<td>The number of seconds past midnight
</td></tr>
<tr>
<td>3</td>
<td>ST,RO</td>
<td>The current time in the 24 hour form <pre>HH:MM:SS</pre>
</td></tr>
<tr>
<td>4</td>
<td>ST,RO</td>
<td>The current date in the form <pre>MM-DD-YYYY</pre>
</td></tr>
<tr>
<td>5</td>
<td>UI,RW</td>
<td>The program window's height
</td></tr>
<tr>
<td>6</td>
<td>UI,RW</td>
<td>The program window's width
</td></tr>
<tr>
<td>7</td>
<td>UI,RW</td>
<td>The font being used for the program window
</td></tr>
<tr>
<td>8</td>
<td>ST,RW</td>
<td>The contents of the OS clipboard
</td></tr>
<tr>
<td>9</td>
<td>ST,RW</td>
<td>The title of the program window
</td></tr>
<tr>
<td>255</td>
<td>ST,RW<sup>‡</sup></td>
<td>The program itself, can be used for [quine]s
</td></tr></tbody></table>
<p><i>*Can be written to using command 9.</i>
</p><p><i><sup>†</sup>Can be written to using commands 5, 6, and 8.</i>
</p><p><i><sup>‡</sup>Can be written to, but use with extreme caution.</i>
</p><p><br>
</p>
<h1><span class="mw-headline" id="Using_the_dreaded_Asparagus_interpreter">Using the dreaded Asparagus interpreter</span></h1>
<p>Finding said dreaded interpreter can be found <a rel="nofollow" class="external text" href="https://github.com/all-other-usernames-were-taken/Asparagus">at my repository</a> and yet I still don't know how the hell to use GitHub.
</p><p>You can use the interpreter through the command line. Here's how you use it:
</p>
<pre>asparagus [-h] [{-f | -p}] [-wx=(width) -wy=(height)] [-v(verbosity)] "{(path to file) | (program code)}"</pre>
<table class="wikitable">

<tbody><tr>
<td><code>-h</code></td>
<td>Displays the help message, then exits <i>(see Help.)</i>
</td></tr>
<tr>
<td><code>-f</code></td>
<td>Specifies that the quoted text is the path to the program to execute.
</td></tr>
<tr>
<td><code>-p</code></td>
<td>Specifies that the quoted text is the program to execute.
</td></tr>
<tr>
<td><code>-wx</code>, <code>-wy</code></td>
<td>Sets the width and height of the program window on startup, in columns/rows.
</td></tr>
<tr>
<td><code>-v</code></td>
<td>Sets the verbosity level, default is 4. <i>(see Errors, Warnings, and Status Messages.</i>
</td></tr></tbody></table>
<p>All invalid arguments are ignored.
</p>
<h2><span class="mw-headline" id="Special_modes">Special modes</span></h2>
<p>This section goes over special modes for the interpreter.
</p><p><br>
</p>
<h2><span id="Errors,_Warnings,_and_Status_Messages"></span></h2>
<p>Using opetion <code>-v</code>, you can specify how many messages are printed to the console. The number following <code>-v</code> indicates that that level of messages and higher are displayed. <i>Example: <code>-v0</code> shows all, <code>-v7</code> shows none, <code>-v3</code> shows 3 and above.</i>
</p><p>The interpreter has 7 levels of messages printed to the console:
</p>
<table class="wikitable">

<tbody><tr>
<th>Level</th>
<th>Prefix</th>
<th>Description
</th></tr>
<tr>
<td>0</td>
<td><pre>   </pre></td>
<td>Way, WAY too many status messages fall under this. It shows everything, including when it moves on to the next command.
</td></tr>
<tr>
<td>1</td>
<td><pre>.  </pre></td>
<td>Only contains program markers.
</td></tr>
<tr>
<td>2</td>
<td><pre>!  </pre></td>
<td>
</td></tr>
<tr>
<td>3</td>
<td><pre>!! </pre></td>
<td>Contains errors like out of range.
</td></tr>
<tr>
<td>4</td>
<td><pre>!!!</pre></td>
<td>Contains severe errors like syntax errors.
</td></tr>
<tr>
<td>5</td>
<td><pre>FAT</pre></td>
<td>Fatal errors. These are weird, as they are the only errors that get printed to the main program window, in addition to being the only errors that halt program execution.
</td></tr>
<tr>
<td>6</td>
<td><pre>###</pre></td>
<td>Internal errors. These <i>should</i> never happen, but yet they can. These can ONLY be caused by an error INSIDE of the interpreter itself, not outside of it. But, despite their severity, they aren't as intrusive as fatal errors (they don't get printed to the main display and they don't halt execution.)
</td></tr></tbody></table>
<p>The errors are printed to the log in the following way:
</p><p><code>(Prefix)(Description)[ @ Pos (position)]</code>
</p>
<h1><span class="mw-headline" id="Sample_Programs">Sample Programs</span></h1>
<p>The programs below are represented like a hex dump, where on the left is the hexadecimal value of each byte, and the middle is the ASCII character corresponding with each value.
</p><p><br>
</p>
<h2><span id="Hello,_World!"></span><span class="mw-headline" id="Hello.2C_World.21">Hello, World!</span></h2>
<pre>01 00 0D 48 65 6C 6C 6F 2C 20 57 6F 72 6C 64 21   ...Hello, World!  # Sets variable 0 to "Hello, World!"
02 01 01 00                                       ....              # Prints variable 0 at 0,0</pre>
<h2><span class="mw-headline" id="Cat">Cat</span></h2>
<pre>04 00        ..    # Inputs keypress into variable 0
02 01 01 00  ....  # Prints variable 0 at 0,0
05 01        ..    # Goto 0</pre>
</div>
