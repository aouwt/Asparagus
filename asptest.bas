OPEN "./atest" FOR OUTPUT AS #1
'PRINT #1, CHR$(1) + CHR$(1) + "1" + CHR$(7) + CHR$(0) + CHR$(0) + CHR$(1) + CHR$(13) + "Hello, World!" + CHR$(2) + CHR$(1) + CHR$(1) + CHR$(0) + CHR$(8) + CHR$(0);
'PRINT #1, CHR$(1) + CHR$(13) + "Hello, World!" + CHR$(2) + CHR$(1) + CHR$(1)
PRINT #1, CHR$(0) + CHR$(13) + "Hello, World!" + CHR$(20) + CHR$(0) + CHR$(0)
CLOSE 1
'CHR$(4) + CHR$(0) + CHR$(2) + CHR$(1) + CHR$(1) + CHR$(0) + CHR$(5) + CHR$(1)


