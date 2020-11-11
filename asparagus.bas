'$INCLUDE:'/files/aspHead.bas'

ParseCMD

'$INCLUDE:'/files/aspCommon.bas'

FUNCTION IntpA1%% (a$)
    DIM I AS _UNSIGNED _INTEGER64, Vars(255) AS STRING, Subs(255) AS _UNSIGNED _INTEGER64, VarAr(255, 255) AS STRING', SndHandles(255) AS LONG
    ON ERROR GOTO IntpErr
    IF INSTR(_OS$, "[WINDOWS]") THEN os` = -1
    FOR I = 1 TO LEN(a$)
        ON ERROR GOTO IntpErr
        c~%% = ASC(a$, I)
        PrintLog 0, "executing " + STR$(c~%%), I
        SELECT CASE c~%%
            'CASE 0 'Prints to log {ARG1}
            '    I = I + 1
            '    PrintLog 1, "Notice: Line" + STR$(I - 1) + ": ID:" + STR$(ASC(a$, I)), I - 1

            REM Variables

            CASE &H00 'Set [ARG1] to {ARG2} characters following it
                Vars(ASC(a$, I + 1)) = MID$(a$, I + 3, ASC(a$, I + 2))
                I = I + 2 + LEN(Vars(ASC(a$, I + 1)))

            CASE &H01 'Sets [ARG1] in slot [ARG2] to [ARG3] in current slot
                Vars(ASC(a$, I + 3)) = VarAr(ASC(a$, I + 1), ASC(a$, I + 2))
                I = I + 3

            CASE &H02 'Sets var slot to {ARG1}
                i3~%% = ASC(a$, I + 1)
                FOR i2~%% = 0 TO 255
                    VarAr(i2~%%, varslot~%%) = Vars(i2~%%)
                    Vars(i2~%%) = VarAr(i2~%%, i3~%%)
                    Intp.Vars(i2~%%) = VarAr(i2~%%, 255)
                NEXT
                varslot~%% = i3~%%
                I = I + 1

            CASE &H03 'Sets [ARG1] to system variable {ARG2}
                SELECT CASE ASC(a$, I + 2)
                    CASE &H0: i$ = STR$(varslot~%%)
                    CASE &H1: i$ = STR$(I)
                    CASE &H2: i$ = STR$(TIMER)
                    CASE &H3: i$ = TIME$
                    CASE &H4: i$ = DATE$
                    CASE &H5: i$ = STR$(_WIDTH)
                    CASE &H6: i$ = STR$(_HEIGHT)
                    CASE &H7:
                    CASE &H8: IF os THEN i$ = _CLIPBOARD$ ELSE PrintLog 3, "clipboard only supported on windows :(", I
                    CASE &H9: i$ = _TITLE$
                    CASE &HA: i$ = STR$(Intp.VerNo)
                    CASE &HB: i$ = _OS$
                    CASE &HC: i$ = STR$(ex%%)
                    CASE &HFF: i$ = a$
                    CASE ELSE: PrintLog 3, "Invalid system variable ID", I: i$ = ""
                END SELECT
                Vars(ASC(a$, I + 1)) = LTRIM$(RTRIM$(i$))
                I = I + 2

            CASE &H04 'Set system variable
                i$ = Vars(ASC(a$, I + 1))
                SELECT CASE ASC(a$, I + 2)
                    CASE &H0: PrintLog 4, "setting varslot via env set is not supported, use varslot instead", I
                    CASE &H1: PrintLog 2, "setting location via env set is not recommended, consider using goto instead", I: I = VAL(i$)
                    CASE &H2: PrintLog 4, "timer env variable cannot be written to", I
                    CASE &H3: PrintLog 0, "setting date to " + i$, I: DATE$ = i$
                    CASE &H4: PrintLog 0, "setting time to " + i$, I: TIME$ = i$
                    CASE &H5: WIDTH VAL(i$)
                    CASE &H6: WIDTH , VAL(i$)
                    CASE &H7:
                    CASE &H8: IF os THEN _CLIPBOARD$ = i$ ELSE PrintLog 3, "clipboard only supported on windows :(", I
                    CASE &H9: _TITLE i$
                    CASE &HFF: PrintLog 4, "changing source code during execution is strongly unrecommended. remember, if the program breaks for no apparent reason after this point, it's you own goddamn fault for doing this", I: a$ = i$
                END SELECT

                REM Computations

            CASE &H10 'conditionals
                SELECT CASE ASC(a$, I + 1)
                    CASE &H0: IF Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2]=[ARG3] then [ARG4]=1
                    CASE &H1: IF VAL(Vars(ASC(a$, I + 2))) AND VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2] AND [ARG3] then [ARG4]=1
                    CASE &H2: IF VAL(Vars(ASC(a$, I + 2))) OR VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2] OR [ARG3] then [ARG4]=1
                    CASE &H3: IF VAL(Vars(ASC(a$, I + 2))) XOR VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2] XOR [ARG3] then [ARG4]=1
                    CASE &H4: IF VAL(Vars(ASC(a$, I + 2))) > VAL(Vars(ASC(a$, I + 3))) THEN Vars(ASC(a$, I + 4)) = "1" 'if [ARG2]>[ARG3] then [ARG4]=1
                    CASE ELSE: PrintLog 3, "invalid conditional", I
                END SELECT
                I = I + 4

            CASE &H11 'Do math {ARG1}
                SELECT CASE ASC(a$, I + 1)
                    CASE &H0: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) + VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]+[ARG4]
                    CASE &H1: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) - VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]-[ARG4]
                    CASE &H2: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) * VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]*[ARG4]
                    CASE &H3: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) / VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]/[ARG4]
                    CASE &H4: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) ^ VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3]^[ARG4]
                    CASE &H5: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3))) MOD VAL(Vars(ASC(a$, I + 4)))))) '[ARG2]=[ARG3] MOD [ARG4]
                    CASE &H6: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 3)))))): I = I - 1 '[ARG2]=Value of [ARG3]
                        'CASE &H7: Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)): I = I - 1 '[ARG2]=[ARG3]
                        'CASE &H7: Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)) + Vars(ASC(a$, I + 4)) '[ARG2]=[ARG3] and [ARG4]
                        'CASE &H9: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(LEN(Vars(ASC(a$, I + 3)))))): I = I - 1 '[ARG2]=Length of [ARG3]
                    CASE &H7: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(_ROUND(VAL(Vars(ASC(a$, I + 3))))))): I = I - 1 '[ARG2]=Round [ARG3]
                    CASE &H8: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(RND(1)))): I = I - 2 '[ARG2]=Random number between 0-1
                    CASE &H9: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(NOT VAL(Vars(ASC(a$, I + 3)))))): I = I - 1 '[ARG2]=Not [ARG3]
                    CASE &HA: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 4))) AND VAL(Vars(ASC(a$, I + 3)))))) '[ARG2]=[ARG3] and [ARG4]
                    CASE &HB: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 4))) OR VAL(Vars(ASC(a$, I + 3)))))) '[ARG2]=[ARG3] or [ARG4]
                    CASE &HC: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(VAL(Vars(ASC(a$, I + 4))) XOR VAL(Vars(ASC(a$, I + 3)))))) '[ARG2]=[ARG3] xor [ARG4]
                    CASE ELSE: PrintLog 3, "invalid math eq", I
                END SELECT
                I = I + 4

            CASE &H12 'conversion
                SELECT CASE ASC(a$, I + 1)
                    CASE &H0: Vars(ASC(a$, I + 2)) = HEX$(VAL(Vars(ASC(a$, I + 3))))
                    CASE &H1: Vars(ASC(a$, I + 2)) = OCT$(VAL(Vars(ASC(a$, I + 3))))
                    CASE &H2
                        i$ = OCT$(VAL(Vars(ASC(a$, I + 3))))
                        FOR a = 1 TO LEN(i$)
                            SELECT CASE ASC(i$, a)
                                CASE ASC("0"): b$ = b$ + "000"
                                CASE ASC("1"): b$ = b$ + "001"
                                CASE ASC("2"): b$ = b$ + "010"
                                CASE ASC("3"): b$ = b$ + "011"
                                CASE ASC("4"): b$ = b$ + "100"
                                CASE ASC("5"): b$ = b$ + "101"
                                CASE ASC("6"): b$ = b$ + "110"
                                CASE ASC("7"): b$ = b$ + "111"
                                CASE ELSE: PrintLog 6, "how does this even happen? (non-octal value on val->bin)", I
                            END SELECT
                            Vars(ASC(a$, I + 2)) = b$
                        NEXT
                END SELECT
                I = I + 3

            CASE &H13 'strings
                SELECT CASE ASC(a$, I + 1)
                    CASE &H0: Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3))
                    CASE &H1: Vars(ASC(a$, I + 2)) = LEFT$(Vars(ASC(a$, I + 3)), ASC(a$, I + 4))
                    CASE &H2: Vars(ASC(a$, I + 2)) = RIGHT$(Vars(ASC(a$, I + 3)), ASC(a$, I + 4))
                    CASE &H3: Vars(ASC(a$, I + 2)) = MID$(Vars(ASC(a$, I + 3)), ASC(a$, I + 4))
                    CASE &H4: Vars(ASC(a$, I + 2)) = MID$(Vars(ASC(a$, I + 3)), ASC(a$, I + 4), ASC(a$, I + 5))
                    CASE &H5: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(INSTR(Vars(ASC(a$, I + 3)), Vars(ASC(a$, I + 4))))))
                    CASE &H6: Vars(ASC(a$, I + 2)) = LTRIM$(RTRIM$(STR$(LEN(Vars(ASC(a$, I + 3))))))
                    CASE &H7: Vars(ASC(a$, I + 2)) = Vars(ASC(a$, I + 3)) + Vars(ASC(a$, I + 4))
                END SELECT

                REM I/O

            CASE &H20 'Print [ARG3] at {ARG1},{ARG2}    'haha h20
                LOCATE ASC(a$, I + 1) - 1, ASC(a$, I + 2) - 1: PRINT Vars(ASC(a$, I + 3))
                I = I + 3

            CASE &H21 'Input keypress into [ARG1]
                Vars(ASC(a$, I + 1)) = Vars(ASC(a$, I + 1)) + INKEY$
                I = I + 1

            CASE &H22
                INPUT "", Vars(ASC(a$, I + 1))
                I = I + 1

                REM Control

            CASE &H30 'goto [ARG1]
                I = VAL(Vars(ASC(a$, I + 1)))

            CASE &H31 'If [ARG1] then goto line [ARG2]
                IF VAL(Vars(ASC(a$, I + 1))) THEN I = VAL(Vars(ASC(a$, I + 2))) ELSE I = I + 1

            CASE &H32 'Subroutine
                Subs(ASC(a$, I + 1)) = VAL(Vars(ASC(a$, I + 2)))
                I = I + 2

            CASE &H33 'Call subroutine
                ex%% = IntpA1(MID$(a$, Subs(ASC(a$, I + 1))))
                I = I + 1

            CASE &H34: IntpA1 = ASC(a$, I + 1) - 127: EXIT SUB

                REM Graphics

            CASE &H40

                REM Sound

            CASE &H50 'play ml
                PLAY Vars(ASC(a$, I + 1))
                I = I + 1

            CASE &H51 'play str raw
                i$ = Vars(ASC(a$, I + 1))
                FOR i2~&& = 0 TO LEN(i$)
                    _SNDRAW ASC(i$, i2~&&) / 255
                NEXT
                I = I + 1

                REM Misc

            CASE ELSE: PrintLog 4, "syntax", I
        END SELECT
        ON ERROR GOTO IntpErr
    NEXT
    IntpA1 = -127
END SUB
