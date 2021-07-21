//Birocket.update.ks
PRINT("Birocket.update.ks v12301220").

//Delete all the things in the controller
CLEARSCREEN.
CLEAR_DRIVE().
LIST.
DOWNLOAD("/lib/idle.ks").
DOWNLOAD("data.txt").
LIST.
MOVEPATH("idle.ks","startup.ks").
LIST.
UPLOAD("data.txt").
LIST.
RUN "startup.ks".
