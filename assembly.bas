$CONSOLE:ONLY
'$INCLUDE:'/files/assemblerData.bas'
_DEST _CONSOLE
DIM SHARED i AS _UNSIGNED _INTEGER64

'yes, i do realize that 99% of this is spaghet
'yes, there is a chance that i will fix it
'no, that chance is not 100%
SELECT CASE COMMAND$(1)
    CASE "help"
        helloSc
        PRINT "-Help-------------------------------------------------------"
        PRINT ""
        PRINT " ./assembly <COMMAND> [<ARGUMENTS>]"
        PRINT ""
        PRINT "Valid commands:"
        PRINT "       help: prints this help screen"
        PRINT "   assemble: loads an Asparagus Assembly file and outputs an"
        PRINT "                Asparagus program"

        'PRINT "disassemble:  loads an Asparagus program and outputs an"
        'PRINT "                 Asparagus Assembly file"
        'PRINT "    diagram:  loads an Asparagus/Asparagus Assembly file and"
        'print "                 shows a diagram showing how it works"
        PRINT ""
        PRINT " Put '--help' after any command to display more information"
        PRINT "               about that specific command"

    CASE "assemble"
        IF COMMAND$(2) = "--help" THEN
            helloSc
            PRINT "-Assemble Help----------------------------------------------"
            PRINT
            PRINT " ./assembly assemble <INPUT FILE> <OUTPUT FILE>"
            PRINT "    [<ARGUMENTS>]"
            PRINT
            PRINT "Loads an Asparagus Assembly file and outputs an Asparagus"
            PRINT "   program"
            PRINT
            PRINT "Valid arguments:"
            PRINT "     --help: prints this help screen"
            PRINT "         -h: saves the file as a hex representation of the"
            PRINT "                program instead of the program itself"
            PRINT "       --hd: saves the file as a hex dump representation of"
            PRINT "                the program instead of the program itself;"
            PRINT "                implies '-h'"
            PRINT "       "
            $IF LINUX THEN
                PRINT "Note: Specifying output file as 'stdout$' writes the output"
                PRINT "         to STDOUT instead of a file."
                PRINT "      Additionally, specifying input file as 'stdin$' reads"
                PRINT "         the input from STDIN instead of from a file."
            $END IF
        END IF
        IF UCASE$(COMMAND$(3)) = "STDOUT$" AND INSTR(_OS$, "[LINUX]") THEN _DEST 0: OPEN "/dev/stdout" FOR OUTPUT AS #2 ELSE OPEN COMMAND$(3) FOR OUTPUT AS #2
        helloSc
        IF UCASE$(COMMAND$(2)) = "STDIN$" AND INSTR(_OS$, "[LINUX]") THEN
            OPEN "/dev/stdin" FOR INPUT AS #1
        ELSEIF NOT _FILEEXISTS(COMMAND$(2)) THEN PRINT "[FATAL] Could not find file "; COMMAND$(2); ".": SYSTEM
        ELSE OPEN COMMAND$(2) FOR INPUT AS #1
        END IF

        'DIM lbl(1024) AS labelType
        out$ = assemblePrgm(1)
        CLOSE 1
        PRINT "Assemble completed. Output:"
        FOR i = 1 TO LEN(out$)
            h$ = HEX$(ASC(out$, i))
            IF LEN(h$) = 1 THEN h$ = "0" + h$
            PRINT h$; " ";
        NEXT
        $IF LINUX THEN
            IF UCASE$(COMMAND$(3)) = "STDOUT$" THEN
                PRINT #2, out$;
                CLOSE 2
            END IF
        $END IF
        'CASE "disassemble"

    CASE "test"
        PRINT "[WARN ] 'test' is for use for debugging the interpreter, use at your own risk!"
        SELECT CASE COMMAND$(2)
            CASE "stdin"
                ON ERROR GOTO 0
                OPEN "/dev/stdin" FOR BINARY AS #1
                DO
                    GET #1, , a~%%
                    PRINT CHR$(a~%%);
                LOOP UNTIL EOF(1)
                CLOSE 1
            CASE "stdout"
                ON ERROR GOTO 0
                OPEN "/dev/stdout" FOR OUTPUT AS #1
                DO
                    PRINT #1, "this is a test";
                LOOP
        END SELECT
    CASE ELSE
        PRINT "[FATAL] Invalid command '" + COMMAND$(1) + "'. Type './assembly help' for info on valid commands."
END SELECT
SYSTEM


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

FUNCTION assemblePrgm$ (inpFile&)
    DO
        i = i + 1
        INPUT #inpFile&, s$
        s$ = UCASE$(RTRIM$(LTRIM$(s$)))
        IF ASC(s$) = ASC(":") THEN i = i - 1: _CONTINUE
        out$ = out$ + CHR$(assembleVal(s$))
        IF s$ = "SET" THEN
            INPUT #inpFile&, s$, a$
            IF LEN(a$) > 255 THEN PRINT "String too long @"; i; ": "; a$: _CONTINUE
            out$ = out$ + CHR$(assembleVal(s$)) + CHR$(LEN(a$)) + a$
            i = i + 2 + LEN(a$)
        END IF
    LOOP UNTIL EOF(inpFile&)
    assemblePrgm = out$
END FUNCTION

SUB helloSc
    PRINT "############################################################"
    PRINT "Asparagus Assembly (nov 15)          Licensed under GNU AGPL"
    PRINT "https://github.com/all-other-usernames-were-taken/Asparagus"
    PRINT "############################################################"
    PRINT ""
END SUB
