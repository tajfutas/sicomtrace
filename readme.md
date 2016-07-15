SportIdent COM Port Tracer
==========================

v0.1
by Szieberth Ádám



Installation
------------

### Windows 7

1. Install the signed _com0com_ driver from [powersdr-iq/downloads][1].
   After that, the virtual COM port cunfiguration executables should be in the
   `C:\Program Files (x86)\com0com\` directory.

2. Add `C:\Program Files (x86)\com0com\` directory to the system PATH
   environment variable. I assume you know how to do this. If not, Google it.

3. Download [`hub4com-2.1.0.0-386.zip`][2], unpack it, rename `readme.txt` to
   `readme.hub4com.txt` and move all files to the
   `C:\Program Files (x86)\com0com\` directory.

4. Also copy _sicomtrace.bat_ to the _com0com_ install directory.

5. Open a Command Prompt as Administrator: Start > Type `cmd` to the search
   field > Right click on _cmd_ -> Run As Administrator

6. Go to the directory where you want to log the traffic of a SportIdent Master
   Station.

7. Assuming the physical port of the Master station is COM4, type
   `sicomtrace 0 com4 com14` to the Command Prompt. The script will redirect all
   trafic to a virtual COM port on COM14. It will also log the data in a file.

8. Repeat steps 5-7 for additional Master Stations with increasing identifier
   (first argument), eg. the next command could be like
   `sicomtrace 1 com3 com13`.


[1]: https://code.google.com/archive/p/powersdr-iq/downloads
[2]: https://sourceforge.net/projects/com0com/files/hub4com/2.1.0.0/
