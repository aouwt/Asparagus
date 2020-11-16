IntpErr:
PrintLog 6, "QB64 error #" + LTRIM$(RTRIM$(STR$(ERR))) + " on line " + LTRIM$(RTRIM$(STR$(_ERRORLINE))) + "(" + errstate$ + ")", -1
RESUME NEXT

SUB ParseCMD
    _DEST _CONSOLE
    PRINT cmd$
    Intp.Verbose = 4
    IF COMMAND$(1) = "help" THEN PRINT "how about no": SYSTEM
    DO
        c~%% = c~%% + 1
        PrintLog 0, "checking option " + COMMAND$(c~%%), -1
        SELECT CASE LEFT$(COMMAND$(c~%%), 2)
            CASE "-h"
                PrintLog 0, "reading help", -1
                RESTORE Intp_Helpv3
                DO
                    READ s$
                    'IF s$ = "!warn" THEN PRINT warns(RND(1))
                    PRINT s$
                LOOP UNTIL s$ = "."
                ON ERROR GOTO IntpErr
                SYSTEM
            CASE "-f": isfile = -1
            CASE "-p": isfile = 1
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
    IF isfile = -1 THEN
        IF NOT _FILEEXISTS(s$) THEN PrintLog 5, "file does not exist", -1
        PrintLog 0, "opening file " + s$, -1
        f = FREEFILE
        OPEN s$ FOR BINARY AS #f
        ON ERROR GOTO IntpErr
        a$ = SPACE$(LOF(f))
        GET #f, , a$
        ON ERROR GOTO IntpErr
        CLOSE f
    ELSEIF isfile = 0 THEN
        PrintLog 5, "no program", -1
    END IF
    ON ERROR GOTO IntpErr
    PrintLog 0, "opening window", -1
    _SCREENSHOW
    _DEST 0
    PrintLog 0, "running " + a$, -1
    ex%%=IntpA1(a$)
    PrintLog 0, "done", -1
    _DEST _CONSOLE
    PRINT "program exited with error code "; ex%%
    ON ERROR GOTO IntpErr
    'SYSTEM
END SUB


SUB PrintLog (level~%%, s$, i&&)' STATIC
    IF Intp.Verbose <= level~%% THEN
        a& = _DEST
        _DEST _CONSOLE
        s$ = " " + s$
        SELECT CASE level~%%
            CASE 0: PRINT "   ";
            CASE 1: PRINT ".  ";
            CASE 2: PRINT "!  ";: warns = warns + 1
            CASE 3: PRINT "!! ";: warns = warns + 1
            CASE 4: PRINT "!!!";: errors = errors + 1
            CASE 5: PRINT "FAT"; s$:end': _DEST a&: PRINT "[FATAL]"; s$: END: errors = errors + 1
            CASE 6: PRINT "###";: errors = errors + 1
            CASE ELSE: PrintLog 6, "printlog out of range", 0
        END SELECT
        IF i&& > -1 THEN PRINT s$; " @ Pos"; i&& ELSE PRINT s$
        _DEST a&
    END IF
END SUB

