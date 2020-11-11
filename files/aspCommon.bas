IntpErr:
PrintLog 6, "QB64 error #" + LTRIM$(RTRIM$(STR$(ERR))) + "on line " + LTRIM$(RTRIM$(STR$(_ERRORLINE))), I
RESUME NEXT

SUB ParseCMD
    _DEST _CONSOLE
    PRINT cmd$
    Intp.Verbose = 4
    DO
        c~%% = c~%% + 1
        PrintLog 0, "checking option " + COMMAND$(c~%%), -1
        SELECT CASE LEFT$(COMMAND$(c~%%), 2)
            CASE "-h"
                PrintLog 0, "reading help", -1
                RESTORE Intp_Helpv3
                DO
                    READ s$
                    PRINT s$
                LOOP UNTIL s$ = "."
                ON ERROR GOTO IntpErr
                SYSTEM
            CASE "-f": isfile` = -1
            CASE "-p": isfile` = 0
            CASE "-w"
                SELECT CASE LEFT$(COMMAND$(c~%%), 4)
                    CASE "-wx=": WIDTH VAL(MID$(COMMAND$(c~%%), 4))
                    CASE "-wy=": WIDTH , VAL(MID$(COMMAND$(c~%%), 4))
                    CASE ELSE: PrintLog 4, "unknown window parameter '" + COMMAND$(c~%%) + "'", -1
                END SELECT
            CASE "-v": Intp.Verbose = VAL(MID$(COMMAND$(c~%%), 3))
            CASE "": EXIT DO
            CASE ELSE
                IF ASC(COMMAND$(c~%%)) = ASC("-") THEN PrintLog 4, "unknown parameter '" + COMMAND$(c~%%) + "'", -1
                PrintLog 0, "setting file/program to '" + COMMAND$(c~%%) + "'", -1
                s$ = COMMAND$(c~%%)
        END SELECT
        ON ERROR GOTO IntpErr
    LOOP
    a$ = s$
    IF isfile` THEN
        PrintLog 0, "opening file " + s$, -1
        f = FREEFILE
        OPEN s$ FOR BINARY AS #f
        ON ERROR GOTO IntpErr
        a$ = ""
        DO
            GET #f, , c~%%
            a$ = a$ + CHR$(c~%%)
            ON ERROR GOTO IntpErr
        LOOP UNTIL EOF(f)
        ON ERROR GOTO IntpErr
        CLOSE f
    END IF
    ON ERROR GOTO IntpErr
    PrintLog 0, "opening window", -1
    _SCREENSHOW
    _DEST 0
    PrintLog 0, "running " + a$, -1
    ex%%=IntpA1(a$)
    PrintLog 0, "done", -1
    _dest _console
    print "program exited with error code ";ex%%
    ON ERROR GOTO IntpErr
    SYSTEM
END SUB


SUB PrintLog (level~%%, s$, i~&&)
    IF Intp.Verbose <= level~%% THEN
        a& = _DEST
        _DEST _CONSOLE
        s$ = " " + s$
        SELECT CASE level~%%
            CASE 0: PRINT "   ";
            CASE 1: PRINT ".  ";
            CASE 2: PRINT "!  ";
            CASE 3: PRINT "!! ";
            CASE 4: PRINT "!!!";
            CASE 5: PRINT "FAT"; s$: _DEST a&: PRINT "[FATAL]"; s$: END
            CASE 6: PRINT "###";
            CASE ELSE: PrintLog 6, "printlog out of range", 0
        END SELECT
        IF i~&& > -1 THEN PRINT s$; " @ Pos"; i~&& ELSE PRINT s$
        _DEST a&
    END IF
END SUB

