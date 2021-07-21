//Birocket.update.ks
PRINT("Birocket.update.ks v1229645").

//Delete all the things in the controller
SWITCH TO 1.
LIST.
LIST FILES IN filelist.
FOR f in filelist
{
    PRINT("Deleting " + f).
    DELETEPATH(f).
}
PRINT("Cleared drive").
WAIT 5.
DOWNLOAD("boot.ks").
//DOWNLOAD("hello.ks").

PRINT("Downloaded").
LIST.
WAIT 5.

MOVEPATH("hello.ks", "startup.ks").
run "startup.ks".
