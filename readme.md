SportIdent COM Port Tracer
==========================

v0.1
by Szieberth Ádám



Installation
------------

### Windows 7

1. Install the signed _com0com_ driver from [powersdr-iq/downloads][1].
   After that, the virtual COM port configuration executables should be in the
   `C:\Program Files (x86)\com0com\` directory.

2. Add `C:\Program Files (x86)\com0com\` directory to the system PATH
   environment variable. I assume you know how to do this. If not, Google it.

3. Download [`hub4com-2.1.0.0-386.zip`][2], unpack it, rename `readme.txt` to
   `readme.hub4com.txt` and move all files to the
   `C:\Program Files (x86)\com0com\` directory.

4. Download [`sicomtrace.bat`][3] to the `C:\Program Files (x86)\com0com\`
   directory as well.

5. Open a Command Prompt as Administrator: Start > Type `cmd` to the search
   field > Right click on _cmd_ -> Run As Administrator

6. Go to the directory where you want to log the traffic of a SportIdent Master
   Station.

7. Assuming the physical port of the Master station is COM4, type
   `sicomtrace 0 com4 com14` to the Command Prompt. The script will redirect all
   traffic to a virtual COM port on COM14.
   It will also log the data in a file.
   Softwares like SportIdent ConfigPlus should connect to the virtual COM port.

8. Repeat steps 5-7 for additional Master Stations with increasing identifier
   (first argument), eg. the next command could be like
   `sicomtrace 1 comP comV`.


[1]: https://code.google.com/archive/p/powersdr-iq/downloads
[2]: https://sourceforge.net/projects/com0com/files/hub4com/2.1.0.0/
[3]: https://raw.githubusercontent.com/tajfutas/sicomtrace/master/sicomtrace.bat
