'iniman - command line utility to edit/view .ini files
'based on INI Manager - Fellippe Heitor, 2017
'fellippe@qb64.org - @FellippeHeitor
OPTION _EXPLICIT

$CONSOLE:ONLY
_DEST _CONSOLE

'$include:'ini.bi'

IF _COMMANDCOUNT = 0 OR COMMAND$(1) = "/?" OR COMMAND$(1) = "-?" OR LCASE$(COMMAND$(1)) = "-help" OR LCASE$(COMMAND$(1)) = "/help" THEN
    Usage
END IF

IF NOT _FILEEXISTS(COMMAND$(1)) THEN
    PRINT "File not found."
    SYSTEM
END IF

DIM file$, a$
file$ = COMMAND$(1)

SELECT CASE LCASE$(COMMAND$(2))
    CASE "", "-read", "read", "-r", "r"
        IF _COMMANDCOUNT = 4 THEN
            PRINT ReadSetting(file$, COMMAND$(3), COMMAND$(4))
        ELSE
            DO
                a$ = ReadSetting$(file$, COMMAND$(3), "")

                IF IniCODE > 0 AND IniCODE <> 2 THEN EXIT DO 'IniCODE > 0 --> error/unexpected result

                PRINT IniLastSection$; " "; IniLastKey$; "="; a$
            LOOP
        END IF
    CASE "-write", "write", "-w", "w"
        IF _COMMANDCOUNT >= 4 THEN
            WriteSetting file$, COMMAND$(3), COMMAND$(4), COMMAND$(5)
            PRINT ReadSetting(file$, COMMAND$(3), COMMAND$(4))
        ELSE
            Usage
        END IF
    CASE "-delete", "delete", "-d", "d"
        IF _COMMANDCOUNT = 3 THEN
            IniDeleteSection file$, COMMAND$(3)
        ELSEIF _COMMANDCOUNT = 4 THEN
            IniDeleteKey file$, COMMAND$(3), COMMAND$(4)
        ELSE
            Usage
        END IF
    CASE "-move", "move", "-m", "m"
        IF _COMMANDCOUNT = 5 THEN
            IniMoveKey file$, COMMAND$(3), COMMAND$(4), COMMAND$(5)
        ELSE
            Usage
        END IF
    CASE ELSE
        Usage
END SELECT

IF IniCODE > 0 THEN PRINT IniINFO$
SYSTEM IniCODE

SUB Usage
    PRINT "iniman - INI manager"
    PRINT "by Fellippe Heitor, 2017"
    PRINT
    PRINT "Usage:"
    PRINT
    PRINT "    iniman file.ini -read|-r    [section [key]]"
    PRINT "                    -write|-w   section key value"
    PRINT "                    -move|-m    section key newsection"
    PRINT "                    -delete|-d  section [key]"
    PRINT
    PRINT "If a section or key name contains spaces, enclose them in quotation marks."
    SYSTEM
END SUB

'$include:'ini.bm'
