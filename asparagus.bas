'ON ERROR GOTO emain
$CONSOLE
$SCREENHIDE
DIM SHARED IntpVarsShared(255) AS STRING, Verbose AS _UNSIGNED _BYTE
ParseCMD

SYSTEM
e:
PrintLog 6, "QB64 error #" + LTRIM$(RTRIM$(STR$(ERR))) + "on line " + LTRIM$(RTRIM$(STR$(_ERRORLINE))), I
RESUME NEXT

SUB ParseCMD
    _DEST _CONSOLE
    PRINT cmd$
    Verbose = 4
    DO
        c~%% = c~%% + 1
        PrintLog 0, "checking option " + COMMAND$(c~%%), -1
        SELECT CASE LEFT$(COMMAND$(c~%%), 2)
            CASE "-h"
                PrintLog 0, "reading help", -1
                RESTORE help
                DO
                    READ s$
                    PRINT s$
                LOOP UNTIL s$ = "."
                ON ERROR GOTO e
                SYSTEM
            CASE "-f": isfile` = -1
            CASE "-p": isfile` = 0
            CASE "-w"
                SELECT CASE LEFT$(COMMAND$(c~%%), 4)
                    CASE "-wx=": WIDTH VAL(MID$(COMMAND$(c~%%), 4))
                    CASE "-wy=": WIDTH , VAL(MID$(COMMAND$(c~%%), 4))
                    CASE ELSE: PrintLog 4, "unknown window parameter '" + COMMAND$(c~%%) + "'", -1
                END SELECT
            CASE "-v": Verbose = VAL(MID$(COMMAND$(c~%%), 3))
            CASE "": EXIT DO
            CASE ELSE: IF ASC(COMMAND$(c~%%)) = 34 THEN
                    PrintLog 0, "setting file/program to '" + COMMAND$(c~%%) + "'", -1
                    s$ = MID$(COMMAND$(c~%%), 1, LEN(COMMAND$(c~%%)) - 2)
                ELSE PrintLog 4, "unknown parameter '" + COMMAND$(c~%%) + "'", -1
                END IF
        END SELECT
        ON ERROR GOTO e
    LOOP
    a$ = s$
    IF isfile` THEN
        PrintLog 0, "opening file " + s$, -1
        f = FREEFILE
        OPEN s$ FOR BINARY AS #f
        ON ERROR GOTO e
        a$ = ""
        DO
            GET #f, , s$
            a$ = a$ + s$
            ON ERROR GOTO e
        LOOP UNTIL EOF(f)
        ON ERROR GOTO e
        CLOSE f
    END IF
    ON ERROR GOTO e
    IntpA1 a$
    ON ERROR GOTO e
    SYSTEM
    help:
    DATA "------------------------------------------------------------"
    DATA "Asparagus v.PB-.1.2 Nov.      2020 Licensed under GNU AGPLv3"
    DATA ""
    DATA "https://github.com/all-other-usernames-were-taken/Asparagus"
    DATA "https://esolangs.org/wiki/Asparagus"
    DATA "------------------------------------------------------------"
    DATA "asparagus [-h] [{-f | -c}] [-wx=(width) -wy=(height)]"
    DATA "   [-F(font ID) [--fw]] [{-v | -vv | -vvv | -s | -ss}] --"
    DATA "   {(path to file) | (program code)}"
    DATA ""
    DATA ""
    DATA "-h   Displays this message then exits"
    DATA ""
    DATA "-f   Specifies to open a file"
    DATA ""
    DATA "-c   Specifies to use data after '--' as the program"
    DATA ""
    DATA "-wx, Specifies the program window size on startup"
    DATA "-wy"
    DATA ""
    DATA "-F   Sets the font to use for the program window"
    DATA ""
    DATA "--fw Sets the font to double width"
    DATA ""
    DATA "-v,  Sets the verbosity level. You can use -vv, -vvv, -s and"
    DATA "-s      -ss."
    DATA ""
    DATA "          For more information, consult README.md"
    DATA "."
END SUB

SUB IntpA1 (a$)
    DIM I AS _UNSIGNED _INTEGER64, Vars(255) AS STRING, Subs(255) AS _UNSIGNED _INTEGER64, VarAr(255, 255) AS STRING
    ON ERROR GOTO e
    FOR I = 1 TO LEN(a$)
        ON ERROR GOTO e
        c~%% = ASC(a$, I)
        SELECT CASE c~%%
            CASE 0 'Prints to log {ARG1}
                I = I + 1
                PrintLog 1, "Notice: Line" + STR$(I - 1) + ": ID:" + STR$(ASC(a$, I)), I - 1
            CASE 1 'Set [ARG1] to {ARG2} characters following it
                Vars(ASC(a$, I + 1)) = MID$(a$, I + 3, ASC(a$, I + 2))
                I = I + 2 + LEN(Vars(ASC(a$, I + 1)))
            CASE 2 'Print [ARG3] at {ARG1},{ARG2}
                LOCATE ASC(a$, I + 1), ASC(a$, I + 2): PRINT Vars(ASC(a$, I + 3))
                I = I + 3
            CASE 3 'Do math {ARG1}
                SELECT CASE ASC(a$, I + 1)
                    CASE 0: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) + VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]+[ARG4]
                    CASE 1: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) - VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]-[ARG4]
                    CASE 2: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) * VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]*[ARG4]
                    CASE 3: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) / VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]/[ARG4]
                    CASE 4: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) ^ VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]^[ARG4]
                    CASE 5: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) MOD VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3] MOD [ARG4]
                    CASE 6: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3)))))): I = I - 1 '[ARG2]=Value of [ARG3]
                    CASE 7: Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)): I = I - 1 '[ARG2]=[ARG3]
                    CASE 8: Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)) + Vars(ASC(a$, I + 4)) '[ARG2]=[ARG3] and [ARG4]
                    CASE 9: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(LEN(Vars(ASC(a$, I + 3)))))): I = I - 1 '[ARG2]=Length of [ARG3]
                    CASE 10: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(_ROUND(VAL(Vars(ASC(a$, I + 3))))))): I = I - 1 '[ARG2]=Round [ARG3]
                    CASE 11: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(RND(1)))): I = I - 2 '[ARG2]=Random number between 0-1
                    CASE 12: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(NOT VAL(Vars(ASC(a$, I + 3)))))): I = I - 1 '[ARG2]=Not [ARG3]
                    CASE 13: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 4))) AND VAL(Vars(ASC(a$, I + 3)))))) '[ARG2]=[ARG3] and [ARG4]
                    CASE 14: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 4))) OR VAL(Vars(ASC(a$, I + 3)))))) '[ARG2]=[ARG3] or [ARG4]
                    CASE 15: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 4))) XOR VAL(Vars(ASC(a$, I + 3)))))) '[ARG2]=[ARG3] xor [ARG4]
                    CASE ELSE: PrintLog 3, "invalid math eq", I
                END SELECT
                I = I + 4
            CASE 4 'Input keypress into [ARG1]
                Vars(ASC(a$, I + 1)) = Vars(ASC(a$, I + 1)) + INKEY$
                I = I + 1
            CASE 5 'goto [ARG1]
                I = VAL(Vars(ASC(a$, I + 1)))
            CASE 6 'If [ARG1] then goto line [ARG2]
                IF VAL(Vars(ASC(a$, I + 1))) THEN I = VAL(Vars(ASC(a$, I + 2))) ELSE I = I + 1
            CASE 7 'Subroutine
                Subs(ASC(a$, I + 1)) = VAL(Vars(ASC(a$, I + 2)))
                I = I + 2
            CASE 8 'Call subroutine
                IntpA1 MID$(a$, Subs(ASC(a$, I + 1)))
                I = I + 1
            CASE 9 'Sets var slot to {ARG1}
                i3~%% = ASC(a$, I + 1)
                FOR i2~%% = 0 TO 255
                    VarAr(i2~%%, varslot~%%) = Vars(i2~%%)
                    Vars(i2~%%) = VarAr(i2~%%, i3~%%)
                    IntpVarsShared(i2~%%) = VarAr(i2~%%, 255)
                NEXT
                varslot~%% = i3~%%
                I = I + 1
            CASE 10 'Sets [ARG1] to system variable {ARG2}
                SELECT CASE ASC(a$, I + 2)
                    CASE 0: i$ = STR$(varslot~%%)
                    CASE 1: i$ = STR$(I)
                    CASE 2: i$ = STR$(TIMER)
                    CASE 3: i$ = TIME$
                    CASE 4: i$ = DATE$
                    CASE 5: i$ = STR$(_WIDTH)
                    CASE 6: i$ = STR$(_HEIGHT)
                    CASE 7:
                    CASE 8: i$ = _CLIPBOARD$
                    CASE 9: i$ = _TITLE$
                    CASE 255: i$ = a$
                    CASE ELSE: PrintLog 3, "Invalid system variable ID", I: i$ = ""
                END SELECT
                Vars(ASC(a$, I + 1)) = LTRIM$(RTRIM$(i$))
                I = I + 2
            CASE 11 'Sets [ARG1] in slot [ARG2] to [ARG3] in current slot
                Vars(ASC(a$, I + 3)) = VarAr(ASC(a$, I + 1), ASC(a$, I + 2))
                I = I + 3
            CASE 12 'conditionals
                SELECT CASE ASC(a$, I + 1)
                    CASE 0: IF Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2]=[ARG3] then [ARG4]=1
                    CASE 1: IF VAL(Vars(ASC(a$, I + 2))) AND VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2] AND [ARG3] then [ARG4]=1
                    CASE 2: IF VAL(Vars(ASC(a$, I + 2))) OR VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2] OR [ARG3] then [ARG4]=1
                    CASE 3: IF VAL(Vars(ASC(a$, I + 2))) XOR VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2] XOR [ARG3] then [ARG4]=1
                    CASE 4: IF VAL(Vars(ASC(a$, I + 2))) > VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2]>[ARG3] then [ARG4]=1
                    CASE ELSE: PrintLog 3, "invalid conditional", I
                END SELECT
                I = I + 4
            CASE 13
            CASE 255: EXIT SUB
            CASE ELSE
                PrintLog 4, "syntax", I
        END SELECT
        ON ERROR GOTO e
    NEXT
END SUB

SUB PrintLog (level~%%, s$, i~&&)
    IF Verbose <= level~%% THEN
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
        IF i~&& THEN PRINT s$; " @ Pos"; i~&& ELSE PRINT s$
        _DEST a&
    END IF
END SUB
