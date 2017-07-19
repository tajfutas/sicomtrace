---
layout: page
title: SICOMTRACE
subtitle: SportIdent COM Port Tracer and TCP server
---

version 0.2.0  
_[DOWNLOAD]_


Introduction
------------

The `SICOMTRACE.BAT` batch file helps to log the SportIdent RS232 comminication in order to store and research data of orienteering events.

We tried other free solutions (Eltima Serial Port Monitor, Free Device Monitoring Studio, Portmon, AccessPort, SerialMon, API Monitor v2) for that and they all failed.
With this solution we managed to get the full RS232 data of some orienteering events which will serve as the basis of our future development.
Those data are stored in the _data_ prefixed repositories in our [GitHub page](https://github.com/tajfutas).

To record data, you should start a SICOMTRACE for every SportIdent hardware.
Finally, the logfiles should be collected to a single directory along with the results of the event and the saved files of the organizer software.
It is advised to save in your software at least before and after the event but even better would be to save regularly to separate files and store multiple snapshots of the event.

If you record event data this way, I ask you to share it with me to get shown here to help my and other developers' work.
This also serves the sake of the sport.

In addition the `SICOMTRACE.BAT` starts a TCP server as well which allows communication with the SportIdent hardware over the network for a single client.
Additional clients are defered.

_Sidenote:_ The next version will provide more flexibility in adding virtual COM ports and TCP/IP servers, including the possibility of adding multiple of them.


Installation and Usage
----------------------

1. Download and install the [signed version of the com0com virtual null modem driver][com0com driver].

2. Start the com0com setup program and ensure a virtual COM port pair for the SportIdent hardware.
   Set any of the two ports to _use Port class_: this should change its name an behavior to mimic a real COM port.

   ![com0com Setup](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/setup.png)

3. [Download][DOWNLOAD] and unpack SICOMTRACE to a directory you prefer.

4. Open a Command Prompt (Start button > Search for `cmd`).

   Go to the directory where you want to store the log files.
   I advice you to choose a fast storage for this, like an SSD drive or an USB 3.0 pendrive.
   Otherwise, set the communication to 4800 baudrate which should be still fast enough for the majority of orienteering events.

5. Start the `SICOMTRACE.BAT`.
   Pass the SportIdent hardware COM port as the first, the _non-Port class_ virtual port as the second, and the baudrate as the third argument.
   Baudrate can be 38400 or 4800 and must match with the SportIdent hardware's own setting.
   The TCP server port can be explicitly set with the optional fourt argument.
   Without it, TCP server serves on port 7487.

   ![Command Prompt session for SICOMTRACE](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cmd.png)

   You might have to allow access for hub4com.

   ![Allow access for hub4com](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/alert.png)

6. Now you can connect to your SI station via the _Port class_ virtual COM port.
   Only the port changes but communication should work like it used to.

   ![Config+ connected to virtual COM port](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cpl2virt.png)

   If the SportIdent hardware have different baudrate setting than the given argument then here you should get a Communication Failed alert.
   To solve it, stop SICOMTRACE by hitting Ctrl+C twice, press the upward arrow key to get the last command before the cursor, edit the baudrate, and press the Enter key.
   This should be also done if the physical device's baudrate changes during the SICOMTRACE session which is a rare event.
   By all means the best practice is to set the SportIdent hardware baudrate previously, pass that value to `SICOMTRACE.BAT` and avoid changing that thereafter.

   ![Communication Failed alert](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/commfail.png)

   If the connection was successful then all communication gets logged in the background.

   ![RS232 communication log](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/tracelog.png)

   Note that SportIdent Config+ shows baudrate 38400 instead of 4800.
   This is because the virtual port accepts the incoming data with 38400 baudrate without errors despite it is set to 4800.
   It then passes the data to the SportIdent hardware with 4800 baudrate.
   This is a limitation/feature of the com0com driver and hub4com and even _emulate baud rate_ option in step 2 can not help it.
   Hopefully you can set baudrate explicitely in your software.
   Unfortunately, SportIdent Config+ tries to be smarter than that and prevents the manual setting of 4800 baudrate.
   Instead the shown value get back to 38400 over and over despite the attempts to change it by hitting the F3 key.
   Still, I experienced no problem because of this limitation: the software communicated properly with a 4800 baud SI station.

   If you follow the demonstration then click on _View punch_ in Config+ now.

7. It is time to connect to the TCP server if wanted.
   I demonstrate this with the standalone [Hercules SETUP utility](http://www.hw-group.com/products/hercules/index_en.html).
   Once downloaded and started, then go to the TCP Client tab and connect.

   Right click into the _Received/Sent data_ area and set _HEX Enable_ to make it show date in hexadecimal numbers.
   Now if you make a punch, its raw serial data should be shown there...

   ![Finish punch bytes sended to a connected TCP client](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/hercconn.png)

   ... and also in the logfile.

   ![Finish punch bytes in the tracelog](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/punchlog.png)

   Note that this one is a different log file than before.
   This is because during this demonstration I restarted SICOMTRACE several times and it always started a new log file.
   Unfortunately log files can not be written in append mode so serializing them was necessary to prevent accidental data loss.

   The details of the punch should appear in Config+ as expected.

   ![Finish punch details in Config+](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cplpunch.png)

8. Now we can query the SI station time via TCP with Hercules.
   Copypaste _02 F7 00 F7 00 03_ to the first send entry, set _HEX_ and click on the _Send_ button.

   ![Get time command with Hercules](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/herctime.png)

   You can see that the BSM7 response was _02 F7 09 00 0C 11 07 0C 07 6A 88 23 40 E6 03_.

   The SportIdent protocol is documented in the [SportIdent Developer Forum](https://www.sportident.com/support/developer-forum.html).


Licence
-------

_Copyright © 2016–2017, Szieberth Ádám_

All permissions are granted.

This work is free for any kind of usage, including but not limited to copy, modify, publish, distribute, sublicense, and to sell original or derivative copies of it.


[DOWNLOAD]: https://github.com/tajfutas/sicomtrace/releases/download/v0.2.0/sicomtrace.zip
[com0com driver]: https://github.com/tajfutas/sicomtrace/releases/tag/com0com-signed
