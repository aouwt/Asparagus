# Asparagus

*the language that makes you sat "what"*

# Syntax

In Asparagus, commands are all stored as 1 byte unsigned integers (`char`) in files. That means that instead of having text commands, it's like machine code: numbers represent commands. There are a possible 256 commands, and more are being added as development progresses.

Commands' arguments are also stored as 1 byte unsigned integers following the command itself. In addition, some arguments **must** be literal, but most **must** represent a variable. That means in one command, the argument `FF` would mean 255, but in another it would mean the value of variable 255.

When we show commands, arguments, and whole programs, they are shown as hexadecimal.

The table below shows all commands in breif detail. Because of how many commands take variables as an input, whenever we say *argument 1*, we're referring to the contents of variable argument 1 unless we specify that the argument is literal.

| Command ID | Description                                                                                                                                 |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `0`        | Set variable argument 1 to argument 2 (literal) characters succeeding it  *(see [Variables](#Variables).)*                                  |
| `1`        | Set variable argument 1 in slot argument 2 (literal) to variable argument 3 in current slot *(see [Variables](#Variables).)*                |
| `2`        | Set the current variable slot to argument 1 (literal) *(see [Variables](#Variables).)*                                                      |
| `3`        | Set variable argument 1 to environment variable argument 2 (literal) *(see [Variables/Environment Variables](#Environment-Variables).)*     |
| `4`        | Set environment variable argument 2 (literal) to argument 1\* *(see [Variables/Environment Variables](#Environment-Variables).)*            |
| `10`       | If conditional argument 1 (literal) of argument 2\* and argument 3\* then set argument 4 to "1" *(see [Math/Conditionals](#Conditionals).)* |
| `11`       | Set variable argument 2 to math equation argument 1 (literal) of argument 2\* and argument 4\* *(see [Math](#Math).)*                       |
| `12`       | Set variable argument 2 to conversion argument 1 (literal) of argument 3\* *(see [Math/Conversion](#Conversion).)*                          |
| `20`       | Print argument 3 at screen position argument 1\* (literal) x, argument 2\* (literal) y.                                                     |
| `21`       | Adds current key press into variable argument 1. Equivalent to `INKEY$`.                                                                    |
| `22`       | Equivalent to `input`.                                                                                                                      |
| `30`       | Sets the command index to argument 1\* *(see [Subroutines/via Goto](#via-Goto))*                                                            |
| `31`       | If argument 1\* is not equal to 0 then goto argument 2.                                                                                     |
| `32`       | Sets the start of subroutine argument 1 (literal) to position argument 1\* *(see [Subroutines](#Subroutines).)*                             |
| `33`       | Calls subroutine argument 1 (literal) *(see [Subroutines](#Subroutines).)*                                                                  |
| `34`       | Exits a subroutine/the main program *(see [Subroutines](#Subroutines).)*                                                                    |
| `50`       | Plays argument 1 as a ML string *(see [Sound/ML](#ML).)*                                                                                    |
| `51`       | Plays argument 1 as a raw sound string *(see [Sound/Raw](#Raw).)*                                                                           |

*\*If a number is needed for an argument and the variable used contains non-numeric characters and does not follow the [conversion prefixes](#Prefixes), it's value is represented as 0. (see [Variables](#Variables).)*

## Variables

There are 65536 variables in total, 256 variables in 256 groups. All user variables are treated as strings, but when it needs to be used as a number, it is converted to a float, then converted back. When it is being converted, there are two ways the output could be modified:

- If it follows the [conversion prefixes](#Prefixes), it can be treated as a number of a different base.

- If it does not follow the conversion prefixes and it contains non-numeric characters (or is empty), it is returned as 0.

The 256 different groups of variables can be switched using command `2`, or you can write to it quickly using command `1`. All groups are treated as local **except** for group 255 *(see [Subroutines](#Subroutines).)*

### System Variables

System variables can be read and written to using commands `3` and `4`, respectively. Not all system variables can be written to, however.

There are nine writable system variables:

| ID   | Description                                              |
| ---- | -------------------------------------------------------- |
| `1`  | Command location (equivalent to goto)<sup>\*</sup>       |
| `3`  | System time<sup>†</sup>                                  |
| `4`  | System date<sup>†</sup>                                  |
| `5`  | Program window width                                     |
| `6`  | Program window height                                    |
| `8`  | Clipboard<sup>‡</sup>                                    |
| `9`  | Program window title                                     |
| `FF` | The source code of the program (for quines!)<sup>•</sup> |

<small><sup>\*</sup>*Not recommended, consider using goto instead.*
*<sup>†</sup>May require the interpreter to be run with sufficient permissions.*
*<sup>‡</sup>Only supported on the Windows version due to QB64 limitations.*
*<sup>•</sup>Use at your own risk! Writing to this can cause the program to break, and is extremely hard to debug!*</small>

There are an additional 4 read-only environment variables:

| ID  | Description                                                                                                                                                                                                   |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `0` | Current variable slot                                                                                                                                                                                         |
| `2` | Number of seconds past midnight                                                                                                                                                                               |
| `A` | Version number of the interpreter *(see [Using the Interpreter/Version Numbering](#Version-Numbering).)*                                                                                                      |
| `B` | The current operating system being used. It is represented in the following format:<br/>`[OS][TYPE]`<br/>where `[OS]` can be `[WINDOWS]`, `[LINUX]`, or `[MACOS]` and `[TYPE]` can be `[32BIT]` or `[64BIT]`. |

## Math

Using command `11`, you can perform several math operations on a variable. Argument 1 (literal) specifies which operation to do, argument 2 is the variable to hold the output of the math equation, and the following arguments (if any) are the variables to perform the math equation on.

The possible values for argument 1 are:

| ID  | Description                                    |
| --- | ---------------------------------------------- |
| `0` | Argument 3 + argument 4                        |
| `1` | Argument 3 - argument 4                        |
| `2` | Argument 3 • argument 4                        |
| `3` | <sup>Argument 3</sup>/<sub>argument 4</sub>    |
| `4` | Argument 3<sup>argument 4</sup>                |
| `5` | Argument 3 MOD argument 4                      |
| `6` | Value of argument 3                            |
| `7` | Argument 3 rounded                             |
| `8` | Single-precision random number between 0 and 1 |
| `9` | Bitwise NOT of argument 3                      |
| `A` | Bitwise AND of argument 3 and argument 4       |
| `B` | Bitwise OR of argument 3 and argument 4        |
| `C` | Bitwise XOR of argument 3 and argument 4       |

### Conditionals

### Conversion

#### Prefixes

## Subroutines

### Via Goto

## Sound

### ML
