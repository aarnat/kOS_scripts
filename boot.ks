// Display a message
SET v TO 12301525.


FUNCTION NOTIFY
{
    PARAMETER message.
    HUDTEXT("kOS: " + message, 5, 2, 50, YELLOW, false).
}


FUNCTION CLEAR_DRIVE
{
    SWITCH TO 1.
    //LIST.
    LIST FILES IN filelist.
    FOR f in filelist
    {
        IF NOT (f = boot.ks)
        {
            DELETEPATH(f).
        }
    }
    //PRINT("Cleared drive").
}


// First-pass at introducing artificial delay. ADDONS:RT:DELAY(SHIP) represents
// the line-of-site latency to KSC, as per RemoteTech
FUNCTION DELAY
{
    SET dTime TO ADDONS:RT:DELAY(SHIP) * 3. // Total delay time
    SET accTime TO 0.                       // Accumulated time

    UNTIL accTime >= dTime
    {
        SET start TO TIME:SECONDS.
        WAIT UNTIL (TIME:SECONDS - start) > (dTime - accTime) OR NOT ADDONS:RT:HASCONNECTION(SHIP).
        SET accTime TO accTime + TIME:SECONDS - start.
    }
}


// Get a file from KSC
FUNCTION DOWNLOAD
{
    PARAMETER name.

    DELAY().
    IF EXISTS("1:" + name)
    {
        DELETEPATH("1:" + name).
    }

    IF EXISTS("0:" + name)
    {
        COPYPATH("0:" + name , "1:").
    }
}


// Put a file on KSC
FUNCTION UPLOAD
{
    PARAMETER name.

    DELAY().
    IF EXISTS("0:/data/" + name)
    {
        DELETEPATH("0:/data/" + name).
    }

    IF EXISTS("1:" + name)
    {
        COPYPATH("1:" + name , "0:/data/" + name).
    }

    IF EXISTS("1:" + name)
    {
        DELETEPATH("1:" + name).
    }
    ELSE
    {
        PRINT("UPLOAD FAILED").
    }
}



// THE ACTUAL BOOTUP PROCESS
SET updateScript TO SHIP:NAME + ".update.ks".

// If we have a connection, see if there are new instructions.
//If so, download and run them.
IF ADDONS:RT:HASCONNECTION(SHIP)
{
    IF EXISTS("0:" + updateScript)
    {
        DOWNLOAD(updateScript).

        //remove the update from archive
        DELETEPATH("0:" + updateScript).

        //run the update script
        SWITCH TO 1.
        IF EXISTS("update.ks")
        {
            DELETEPATH("update.ks").
        }
        MOVEPATH(updateScript, "update.ks").
        RUNPATH("update.ks").
        DELETEPATH("update.ks").
    }
}

PRINT("RUNNING Boot.ks v" + v).

// If a startup.ks file exists on the disk, run that.
IF EXISTS("startup.ks")
{
    RUNPATH("startup.ks").
}
ELSE
{
    WAIT UNTIL ADDONS:RT:HASCONNECTION(SHIP).
    SET msg to SHIP:NAME + " REBOOTING".
    NOTIFY(msg).
    WAIT 10. // Avoid thrashing the CPU (when no startup.ks, but we have a
    // persistent connection, it will continually reboot).
    REBOOT.
}
