# <mark>NOTICE: Many parts of the interpreter ***AND*** this README are unfinished.</mark>
If you see a line half-written or with a syntax error, this is normal. Under no circumstance should you actively try to develop programs for this. Many of the commands are not set in stone, and even simple commands like the print equivalents change alot.

<sup><small>just wanted to say that; go on with your day</small></sup>

---
# Asparagus

*the language that makes you sat "what"*

# Syntax

In Asparagus, commands are all stored as 1 byte unsigned integers (`char`) in files. That means that instead of having text commands, it's like machine code: numbers represent commands. There are a possible 256 commands, and more are being added as debvelopment progresses.

Commands' arguments are also stored as 1 byte unsigned integers following the command itself. In addition, some arguments **must** be literal, but most **must** represent a variable. That means in one command, the argument `FF` would mean 255, but in another it would mean the value of variable 255.

When we show commands, arguments, and whole programs, they are shown as hexadecimal.

The table below shows all commands in breif detail. Because of how many commands take variables as an input, whenever we say *argument 1*, we're referring to the contents of variable argument 1 unless we specify that the argument is literal.

| Command ID | Description |
| --- | --- |
| 0   | Set variable argument 1 to argument 2 (literal) characters succeeding it *(see [Variables/User](#User).)* |
| 1   | Set variable argument 1 in slot argument 2 (literal) to variable argument 3 in current slot *(see [Variables/User](#User).)* |
| 2   | Set the current variable slot to argument 1 (literal) *(see [Variables/User](#User).)* |
| 3   | Set variable argument 1 to system variable argument 2 (literal) *(see [Variables/System Variables](#System).)* |
| 4   | Set system variable argument 2 (literal) to argument 1\* *(see [Variables/System](#System).)* |
| 10  | If conditional argument 1 (literal) of argument 2\* and argument 3\* then set argument 4 to "1" *(see [Math/Conditionals](#Conditionals).)* |
| 11  | Set variable argument 2 to math equation argument 1 (literal) of argument 2\* and argument 4\* *(see [Math](#Math).)* |
| 12  | Set variable argument 2 to conversion argument 1 (literal) of argument 3\* *(see [Math/Conversion](#Conversion).)* |
| 20  | Print argument 3 at screen position argument 1\* (literal) x, argument 2\* (literal) y. |
| 21  | Adds current key press into variable argument 1. Equivalent to `INKEY$`. |
| 22  | Equivalent to `input`. |
| 30  | Sets the command index to argument 1\* *(see [Subroutines/via Goto](#via-Goto))* |
| 31  | If argument 1\* is not equal to 0 then goto argument 2. |
| 32  | Sets the start of subroutine argument 1 (literal) to position argument 1\* *(see [Subroutines](#Subroutines).)* |
| 33  | Calls subroutine argument 1 (literal) *(see [Subroutines](#Subroutines).)* |
| 34  | Exits a subroutine/the main program *(see [Subroutines](#Subroutines).)* |
| 50  | Plays argument 1 as a ML string *(see [Sound/ML](#ML).)* |
| 51  | Plays argument 1 as a raw sound string *(see [Sound/Raw](#Raw).)* |
| F0  | Sets variable argument 1 to meta variable argument 2 (literal) *(see [Variables/Meta](#Meta).)* |

*\*If a number is needed for an argument and the variable used contains non-numeric characters and does not follow the [conversion prefixes](#Prefixes), it's value is represented as 0. (see [Variables/User](#User).)*

## Variables

In Asparagus, there are several types of variables: user, system, and meta.

### User

There are 65536 user variables in total, 256 variables in 256 groups. All user variables are treated as strings, but when it needs to be used as a number, it is converted to a float, then converted back. When it is being converted, there are two ways the output could be modified:

- If it follows the [conversion prefixes](#Prefixes), it can be treated as a number of a different base.
  
- If it does not follow the conversion prefixes and it contains non-numeric characters (or is empty), it is returned as 0.
  

The 256 different groups of variables can be switched using command 2, or you can write to it quickly using command 1. All groups are treated as local **except** for group 255 *(see [Subroutines](#Subroutines).)*

### System

System variables can be read and written to using commands 3 and 4, respectively. Not all system variables can be written to, however.

There are nine writable system variables:

| ID  | Description |
| --- | --- |
| 1   | Command location (equivalent to goto)<sup>\*</sup> |
| 3   | System time<sup>†</sup> |
| 4   | System date<sup>†</sup> |
| 5   | Program window width |
| 6   | Program window height |
| 8   | Clipboard<sup>‡</sup> |
| 9   | Program window title |
| FF  | The source code of the program (for quines!)<sup>•</sup> |

<small><sup>\*</sup>*Not recommended, consider using goto instead.*
*<sup>†</sup>May require the interpreter to be run with sufficient permissions.*
*<sup>‡</sup>Only supported on the Windows version due to QB64 limitations.*
*<sup>•</sup>Use at your own risk! Writing to this can cause the program to break, and is extremely hard to debug!*</small>

There are an additional 2 read-only system variables:

| ID  | Description |
| --- | --- |
| 0   | Current variable slot |
| 2   | Number of seconds past midnight |

### Meta

Me

## Math

### Conditionals

### Conversion

#### Prefixes

## Subroutines

### Via Goto

## Sound

### ML
