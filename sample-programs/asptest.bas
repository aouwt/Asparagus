OPEN "helloworldloop.asp" FOR OUTPUT AS #1
0 PRINT #1, CHR$(0) + CHR$(1) + CHR$(2) + "21";
6 PRINT #1, CHR$(0) + CHR$(0) + CHR$(13) + "Hello, World!";
22 PRINT #1, CHR$(&H13) + CHR$(7) + CHR$(0) + CHR$(0) + CHR$(0);
27 PRINT #1, CHR$(&H20) + CHR$(0) + CHR$(0) + CHR$(0);
31 PRINT #1, CHR$(&H30) + CHR$(1);
CLOSE 1

OPEN "helloworld.asp" FOR OUTPUT AS #1
PRINT #1, CHR$(0) + CHR$(0) + CHR$(13) + "Hello, World!";
PRINT #1, CHR$(&H20) + CHR$(0) + CHR$(0) + CHR$(0);
CLOSE 1

SYSTEM
