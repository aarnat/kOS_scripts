CLEARSCREEN.

PRINT "Counting dowm:".
FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 1.
}
CLEARSCREEN.

run "boot.ks".

