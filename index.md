---
layout: page
title: SICOMTRACE
subtitle: SportIdent COM Port Tracer and TCP server
version: 0.2.1
repo: "https://github.com/tajfutas/sicomtrace"
download: "https://github.com/tajfutas/sicomtrace/releases/download/v0.2.1/sicomtrace.zip"
---


Introduction
------------

The `SICOMTRACE.BAT` batch file helps to log the SportIdent RS232 comminication in order to store and research data of orienteering events.

We tried other free solutions (Eltima Serial Port Monitor, Free Device Monitoring Studio, Portmon, AccessPort, SerialMon, API Monitor v2) for that and they all failed.
With this solution we managed to get the full RS232 data of some orienteering events which will serve as the basis of our future development.
Those data are stored in the _data_ prefixed repositories in our [GitHub page](https://github.com/tajfutas).

To record data, you should start a SICOMTRACE for every SportIdent hardware.
At the end of the event day, the logfiles should be collected to a single directory along with the results of the event and the saved files of the organizer software.
It is advised to save in your software at least before and after the event but even better would be to save regularly to separate files and store multiple snapshots of the event.

If you record event data this way, I ask you to share it with me to get shown here to help my and other developers' work.
This also serves the sake of the sport.

In addition the `SICOMTRACE.BAT` starts a TCP server as well which allows communication with the SportIdent hardware over the network for a single client.
Additional clients are defered.

_Sidenote:_ The next version will provide more flexibility in adding virtual COM ports and TCP/IP servers, including the possibility of adding multiple of them.


General Information
-------------------

During tha Installation and Usage phase below you will have to create virtual serial port pairs with the com0com driver.
Between each of these pairs have a virtual [null modem] cable.
This means that bytes going in one virtual port comes out from the other one and reversed.
By default these virtual ports are named as CNCAx and CNCBx.
These ports are invisible or unusable by most softwares.
For this issue, com0com is capable to make any of these virtual ports to seem and behave like physical serial ports by allocating COMx type names to them, making softwares unable to distinguish such a port from a real one.
It is adviced to be sparing with the COM ports though, as many softwares are capable to handle only one digit (COM1–COM9) or only the first 16 of them, and some of these ports are most likely already taken on your PC.
In the extreme case, it may be necessary to [force clean up those ports][clean up COM ports].

The hub4com software —called by SICOMTRACE— also creates a virtual null modem cable.
Moreover, hub4com can work like a dispenser.
In these case a setup can be made for the nodes controlling which other node the incoming bytes should be send.
The nodes of hub4com can be virtual and physical serial ports (including those named as CNCxy) and also network ports.
The hub4com is capable to start a TCP/IP server handling a fixed number of clients, but it also able to connect to a server as a client.
In addition the hub4com can reliably log the communication.

SICOMTRACE is nothing but a [batch file] which do only call hub4com with the necessary (rather complicated) parameters.
Among these it does not allow any of the previous log files to get overwritten.
The hub4com call string gets printed on the screen at each successful start.

It is important to know that a serial port can be used by only one software at a single time.
Most programs does not free up the connected device's port before the end of its process.
The hub4com and thus SICOMTRACE are such programs, locking all serial nodes until exit.
In contrast, com0com virtual ports are always made free.

So if you have a SportIdent master station connected to COM1 then to log the communication or to pass it on the network, you have to transit the data over the virtual null modem cable made by SICOMTRACE.
This cable needs another endpoint though.

If you have a com0com port pair named as COM2 and CNCB0, then making CNCB0 as the other endpoint, the SportIdent station will be available on COM2 as before it was on COM1, but the communication can be logged as well.
The original COM1 port is locked as long as SICOMTRACE runs making it impossible to conect to the station on that port.

More specifically, hub4com (started by SICOMTRACE) connects COM1 with CNCB0 locking both of these ports.
What comes in COM1 goes out in CNCB0 and reversed.
However, CNCB0 is connected with a driver level null modem cable to COM2 (which is unlocked), so what goes out from CNCB0 comes in COM2 and reversed.
Note that CNCB0 is a temporary node here.
The COM2 port is free to get used by any software to conect to the SportIdent station.


Installation and Usage
----------------------

1. Download and install the [signed version of the com0com virtual null modem driver][com0com driver].

2. Start the com0com setup program and ensure a virtual COM port pair for the SportIdent hardware.
   Set any of the two ports to _use Port class_: this should change its name an behavior to mimic a real COM port.

   ![com0com Setup](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/setup.png)

   More SportIdent hardware requires additional port pairs.

3. [Download][DOWNLOAD] and unpack SICOMTRACE to a directory you prefer.

4. Open a Command Prompt (Start button > Search for `cmd`).

   Go to the directory where you want to store the log files.
   I advice you to choose a fast storage for this, like an SSD drive or an USB 3.0 pendrive.
   Otherwise, set the communication to 4800 baudrate which should be still fast enough for the majority of orienteering events.

5. Start the `SICOMTRACE.BAT`.
   Pass the SportIdent hardware COM port as the first, baudrate as the second, and the virtual com port pair name (eg. `CNCB0`) as the third argument.
   Baudrate can be 38400 or 4800 and must match with the SportIdent hardware's own setting.
   The TCP server port can be explicitly set with the optional fourt argument.
   Without it, no TCP/IP server will be started.

   If the above com0come setup lives and the SportIdent Station is connected on COM10 and is set to baudrate 38400 then the following command connects SICOMTRACE and opens a TCP/IP server on port 7488:

   ```bat
   SICOMTRACE COM10 38400 CNCB0 7488
   ```

   ![Command Prompt session for SICOMTRACE](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cmd.png)

   You might have to allow access for hub4com.

   ![Allow access for hub4com](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/alert.png)

   The SportIdent station in the example can be reached on COM8 and also on port 7488.
   The communication will get logged in either case.

6. Now you can connect to your SI station via the _Port class_ virtual COM port.
   Only the port changes but communication should work like it used to.

   ![Config+ connected to virtual COM port](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cpl2virt.png)

   If you are unable to find the com0com virtual COM port in the list then set the _Show all available devices_ option in the View menu.

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


[DOWNLOAD]: {{ page.download }}
[com0com driver]: https://github.com/tajfutas/sicomtrace/releases/tag/com0com-signed
[clean up COM ports]: https://superuser.com/questions/408976/how-do-i-clean-up-com-ports-in-use
[null modem]: https://en.wikipedia.org/wiki/Null_modem
[batch file]: https://en.wikipedia.org/wiki/Batch_file
