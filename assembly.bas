$CONSOLE:ONLY
'$INCLUDE:'/files/commandData.bas'
_DEST _CONSOLE
PRINT "############################################################"
PRINT "Asparagus Assembly (nov 15)          Licensed under GNU AGPL"
PRINT "https://github.com/all-other-usernames-were-taken/Asparagus"
PRINT "############################################################"

DIM SHARED i AS _UNSIGNED _INTEGER64
SELECT CASE COMMAND$(1)
    CASE "help"
        PRINT "-Help-------------------------------------------------------"
        PRINT ""
        PRINT " ./assembly <COMMAND> [<ARGUMENTS>]"
        PRINT ""
        PRINT "Valid commands:"
        PRINT "       help:  prints this help screen"
        PRINT "   assemble:  loads an Asparagus Assembly file and outputs"
        PRINT "                 an Asparagus program"
        'PRINT "disassemble:  loads an Asparagus program and outputs an"
        'PRINT "                 Asparagus Assembly file"
        'PRINT "    diagram:  loads an Asparagus/Asparagus Assembly file and"
        'print "                 shows a diagram showing how it works"
    CASE "assemble"
        OPEN COMMAND$(2) FOR INPUT AS #1
        DO
            i = i + 1
            INPUT #1, s$
            s$ = UCASE$(RTRIM$(LTRIM$(s$)))
            out$ = out$ + CHR$(assembleVal(s$))
            IF s$ = "SET" THEN
                INPUT #1, s$, a$
                IF LEN(a$) > 255 THEN PRINT "String too long @"; i; ": "; a$: _CONTINUE
                out$ = out$ + CHR$(assembleVal(s$)) + CHR$(LEN(a$)) + a$
                i = i + 1 + LEN(a$)
            END IF
        LOOP UNTIL EOF(1)
        CLOSE 1
        PRINT "Assemble completed. Output:"
        FOR i = 1 TO LEN(out$)
            h$ = HEX$(ASC(out$, i))
            IF LEN(h$) = 1 THEN h$ = "0" + h$
            PRINT h$; " ";
        NEXT
        OPEN COMMAND$(3) FOR OUTPUT AS #2
        PRINT #2, out$;
        CLOSE 2
END SELECT

FUNCTION assembleVal~%% (s$)
    DIM h AS INTEGER
    RESTORE assembleCmds:
    DO
        READ h, r$
    LOOP UNTIL r$ = s$ OR r$ = "end of list"
    IF r$ = "end of list" THEN
        h = VAL("&H" + s$)
        IF NOT s$ = HEX$(VAL(LTRIM$(RTRIM$(STR$(h))))) THEN PRINT "Invalid command @"; i; ": "; s$: EXIT FUNCTION
        IF h > 255 OR h < 0 THEN PRINT "Out of range @"; i; ": "; s$: h = 255
    END IF
    assembleVal = h
END FUNCTION
