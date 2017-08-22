---
layout: page
title: SICOMTRACE
subtitle: SPORTident COM port követő és TCP/IP szerver
version: 0.2.1
repo: "https://github.com/tajfutas/sicomtrace"
download: "https://github.com/tajfutas/sicomtrace/releases/download/v0.2.1/sicomtrace.zip"
---


Bevezetés
---------

The `SICOMTRACE.BAT` fájl segítségével naplózhatja a SPORTident RS232 kapcsolatot tájékozódási futó versenyek adatainak tárolása valamint elemzése céljából.

Számos más ingyenes megoldást kipróbáltunk (Eltima Serial Port Monitor, Free Device Monitoring Studio, Portmon, AccessPort, SerialMon, API Monitor v2), sikertelenül.
Ennek a megoldásnak a segítségével sikerült néhány verseny teljes RS232 adatsorait kinyerni ami alapját fogja képezni a későbbi fejlesztéseknek.
Az adatsorok a [GitHub oldalunk](https://github.com/tajfutas) _data_ kezdetű adattárokban vannak.

A rögzítéshez minden SPORTident eszközre jutnia kell egy SICOMTRACE-nek.
A nap végén a naplófájlokat egy helyre kell gyűjteni a verseny eredményeivel és a lebonyolítást végző szoftver mentéseivel együtt.
Érdemes legalább a verseny előtt és után menteni a szoftverben, de még jobb rendszeresen megtenni ezt különböző fájlokba és ezzel a verseny több állapotát rögzíteni.

Kérem, hogy amennyiben végez ilyen rögzítést, azt ossza meg velem, hogy felkerülhessen ide és segítse az én és más fejlesztők munkáját!
Ez a sportág érdekét is szolgálja.

Ezen felül a `SICOMTRACE.BAT` indít egy TCP/IP szervert is, amelynek segítségével hálózaton keresztüli kommunikáció is lehetséges a SPORTident eszközzel egy kliens számára.
A további kliensek várakoztatva vannak.

_Megjegyzés:_ A következő verzió nagyobb szabadságot fog biztosítani a portok beállításban, így akár több virtuális soros port vagy több TCP/IP szerver is beállítható lesz.


Általános tudnivalók
--------------------

A telepítés és használat során virtuális soros port párokat kell majd létrehozni a com0com driver segíségével.
Minden ilyen pár között egy virtuális [null modem] kábel is húzódik.
Ez azt jelenti, hogy ami adat bemegy az egyik virtuális portba, az a másikon kimenő adatként jelentkezik és fordítva.
Alapesetben ezek a virtuális portok a CNCAx és a CNCBx neveket kapják.
Az ilyen portokat a legtöbb szoftver vagy nem is látja, vagy nem képes használni.
Éppen ezért a com0com képes az ilyen virtuális portokat COM névvel és jellemzőkkel ellátni, amit követően semmilyen szoftver nem képes megkülönböztetni azokat számítógép fizikai COM portjaitól.
Érdemes takarékosan bánni viszont a COM portok használatávl, egyes szoftverek ugyanis csak egy számjegyű (COM1–COM9) vagy csak az első 16 COM portot képesek kezelni, amelyek közül egy vagy több már jó eséllyel foglalt.
Szélsőséges esetben az is megeshet, hogy erővel kell [felszabadítani a COM portokat][COM portok felszabadítása].

Virtuális null modem kábelt hoz létre a hub4com program is, amit a SICOMTRACE használ a háttérben.
Sőt, a hub4com működhet úgy, mint egy elosztó.
Ilyen esetben be lehet állítani, hogy az egyes végpontokon bejövő adatokat melyik másik pont kapja meg.
Ráadásul a hub4com végpontjai nem csupán virtuális vagy fizikai soros portok lehetnek (akár CNCxy nevű is), hanem hálózati portok is.
A hub4com képes TCP/IP szervert indítani és megadott számú kliensekt fogadni, de képes kliensként kapcsolódni is.
Ráadásul a hub4com ezenközben képes az adatforgalom megbízható naplózására is.

A SICOMTRACE nem más, mint egy un. [kötegelt állomány], ami annyit tud, hogy megnyitja a hub4com programot a megfelelő – egyébként igen bonyolult – paraméterekkel.
Ezek közé tartozik az is, hogy sosem engedi, hogy egy meglevő naplófájl felülíródjék.
Az hub4com indítási parancsot a SICOMTRACE minden esetben ki is írja a képernyőre.

Fontos tudni, hogy egy soros portot egyszerre csak egy szoftver ragadhat magához.
Számos szoftver a kapcsolódott eszköz portját időközben el sem ereszti, csak a munka végeztével.
A hub4com és így a SICOMTRACE is ilyen, azaz a működése teljes ideje alatt lefoglal minden soros végpontot.
Ezzel szemben a létrehozott com0com virtuális portok mindig szabadok.

Ha tehát adott egy SPORTident doboz a COM1 porton, akkor az adatforgalom naplózásához vagy hálózaton történő átadásához a SICOMTRACE által létrehozott virtuális null modem kábelen kell átvezetni azt.
Ennek a virtuális kábelnek azonban kell egy másik végpont.

Ha van egy com0com port párunk mondjuk COM2 és CNCB0 nevekkel, akkor a másik végpontnak CNCB0-t választva a doboz ugyanúgy elérhető a COM2 porton, mint annak előtte a COM1-en volt, viszont az adatforgalmat közben naplózásra is kerül.
Az eredeti COM1 port foglalt, azon theát az eszköz nem érhető el, amíg a SICOMTRACE fut.

Részletesebben leírva az történik, hogy a SICOMTRACE által indított hub4com összeköti COM1-et CNCB0-val, miközben lefoglalja magának ezeket a portokat.
Ami bejön a COM1-en, az kimegy CNCB0-n és fordítva.
CNCB0 viszont driver szinten át van vezetve a COM2-be (ez egy szabad port), azaz ami kijön CNCB0-n az bemegy a COM2-n és fordítva.
Látható, hogy CNCB0 csak egy átmeneti állomás.
COM2 port továbbra is szabadon használható bármilyen szoftver számára, hogy kapcsolódjon a SPORTident dobozhoz.


Telepítés és használat
----------------------

1. Töltse le és telepítse a [com0com virtuális null modem aláírt meghajtóját][com0com driver]!

2. Indítsa a com0com setup programot és biztosítson egy virtuális COM port párt a SPORTident eszköz számára!
   A két port valamelyikének állítsa be a _use Port class_ kapcsolót: ezzel a neve és a működése is olyan lesz, mint egy valódi COM portnak.

   ![com0com Setup](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/setup.png)

   További SPORTident hardverekhez újabb port párokat kell létrehozni.

3. [Töltse le][LETÖLTÉS] és csomagolja ki a SICOMTRACE-et egy könyvtárba!

4. Nyisson egy Parancssort (Start gomb > Keresés `cmd`-re)!

   Lépjen be a könyvtárba ahol a naplófájlok lesznek!
   Azt javaslom, hogy ha lehetséges, akkor egy gyors meghajtót válasszon erre a célra, mint például egy SSD tároló vagy egy USB 3.0 pendrive.
   Ellenkező esetben működtesse az eszközt 4800-as baudrátán, ami egyébként még mindig kellően gyors adatátvitelt biztosít a legtöbb tájékozódási fútóverseny esetében!

5. Indítsa a `SICOMTRACE.BAT`-ot!
   Első argumentumként a SPORTident eszköz COM portját, másodikként a baudrátát, harmadikként a virtuális port pár nevét (pl. `CNCB0`) kell megadni.
   A baudráta értéke 38400 vagy 4800 lehet és meg kell feleljen a SPORTident eszköz beállított értékének.
   Lehetséges a TCP szerver portjának megadása is negyedik argumentumként.
   Ennek hiányában a SICOMTRACE nem indít TCP/IP szervert.

   Amennyiben a fenti com0com beállítás él és COM10-en van a SPORTident doboz ami 38400-as baudrátára van állítva, akkor az alábbi paranccsal kötjük be a SICOMTRACE-et és nyitunk egy TCP/IP szervert a 7488-as porton:

   ```bat
   SICOMTRACE COM10 38400 CNCB0 7488
   ```

   ![SICOMTRACE a Parancssorban](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cmd.png)

   Előfordulhat, hogy engedélyezni kell a hub4com porthozzáférését.

   ![hub4com porthozzáférésének engedélyezése](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/alert.png)

   A példabeli SPORTident doboz most a COM8-on valamint a 7488-as porton is elérhető.
   A kommunikáció mindkét esetben naplózásra kerül.

6. Most csatlakozhat a SPORTident eszközhöz a virtuális COM porton keresztül.
   A kommunikáció úgy folytatható mint annak előtte, csupán a COM port változott.

   ![Config+ a virtuális COM porthoz kapcsolódva](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cpl2virt.png)

   Amennyiben nem látható a com0com virtuális COM portja, akkor a View menüben állítsa be a _Show all available devices_ opciót!

   Ha a SPORTident hardver és a megadott baudráták nem egyeznek meg akkor ezen a ponton _Communication Failed_ hibaüzenetet kell kapjon.
   Ennek orvoslására állítsa meg a SICOMTRACE-et kétszeri `Ctrl+C` leütésével, nyomja meg a felfelé mutató nyíl billentyűt (ez előkészíti az előző parancs szövegét a kurzor elé), írja át a baudrátát, majd üssön Entert!
   Ezt akkor is meg kell tenni, ha változik az eszköz baudrátája menet közben, ami mellesleg ritka dolog.
   Mindenesetre a leghelyesebb a SPORTident eszköz baudrátáját már korábban beálítani, a `SICOMTRACE.BAT`-nak azt az értéket megadni, és azt utána nem megváltoztatni.

   ![Communication Failed hibaüzenet](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/commfail.png)

   Ha a kapcsolat sikeres, akkor minden kommunikáció naplózásra kerül a háttérben.

   ![RS232 napló](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/tracelog.png)

   Látható, hogy a SPORTident Config+ 38400-as baudrátát mutat 4800 helyett.
   Ennek oka az, hogy a virtuális port hiba nélkül elfogadja a 38400-as baudrátával érkező adatokat annak ellenére, hogy 4800-ra van állítva.
   Ezek után már 4800-as baudrátával küldi tovább azokat a SPORTident eszköznek.
   Ez a com0com driver és a hub4com korlátozása vagy jellemzője amin a második pontban beállított _emulate baud rate_ opció kiválasztása sem segít.
   Remélhetőleg a baudráta megadható az SI szoftverben.
   Sajnos a Config+ okosabb akar lenni ennél, ezért nem lehetséges a 4800-as baudráta kézi beálltása.
   Ehelyett a mutatott érték újra és újra visszaugrik 38400-ra, hiába állítjuk át azt az F3 billentyű leütésével.
   Ennek ellenére én nem tapasztaltam ebből semmilyen problémát:  a szoftver hibátlanul kommunikált a 4800-as baudrátára állított mesterdobozzal.

   Amennyiben követi a bemutatót, akkor most klikkeljen a _View punch_ ikonra Config+-ban!

7. Most csatlakozhat a TCP/IP szerverhez.
   Én ezt a telepítést nem igénylő [Hercules SETUP utility](http://www.hw-group.com/products/hercules/index_en.html) programmal fogom bemutatni.
   Ha letöltötte és elindította, lépjen a _TCP Client_ fülre és kapcsolódjon a _Connect_ nyomógomb segítségével.

   Jobb klikk a _Received/Sent data_ területre és állítsa be a _HEX Enable_ opciót, hogy az adatokat hexadecimális formában láttassa a program.
   Ha most végzünk egy lyukasztást, akkor annak nyers RS232 adatai azonnal meg kell jelenjenek itt...

   ![Céllyukasztás bájtjai a kapcsolódott TCP kliensnél](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/hercconn.png)

   ... és a naplófájlban is.

   ![Céllyukasztás bájtjai a naplófájlban](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/punchlog.png)

   Látható, hogy ez a naplófájl nem azonos a korábban mutatottal.
   Ennek az oka az, hogy a bemutató készítése közben többször is újraindítottam a SICOMTRACE-et és az mindannyiszor egy új naplófájlba kezdett dolgozni.
   Sajnos a hub4com naplófájlokat nem lehet hozzáfűzéssel megnyitni, így a sorozatba állítás lett a megoldás arra, hogy a nem szándékos adatvesztést el lehessen kerülni.

   A lyukasztás adatai a Config+-ban a szokott módon kell megjelenjenek.

   ![Finish punch details in Config+](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cplpunch.png)

8. Most lekérdezhetjük az SI doboz idejét TCP/IP-n keresztül Herculessel.
   Másolja a _02 F7 00 F7 00 03_ szöveget az első _Send_ beviteli mezőbe, pipálja ki a _HEX_-et és klikkeljen a _Send_ nyomógombra!

   ![Get time command with Hercules](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/herctime.png)

   Látható, hogy a BSM7 válasza _02 F7 09 00 0C 11 07 0C 07 6A 88 23 40 E6 03_.

   A SPORTident protokol leírása a [SPORTident Developer Forum](https://www.sportident.com/support/developer-forum.html)-on található.


Eset: SPORTident Live (GSM rádiós pontok)
-----------------------------------------

A SPORTident GSM állomások elküldik a lyukasztásokat a SPORTident Live szerverre, ahonnan a SPORTident Reader nevű program segítségével behozzuk azokat a szervezői informatikus rendszerbe egy virtuális com0com porton keresztül, amit aztán átvezetünk és naplózunk a SICOMTRACE segítségével egy másik COM portba.
Ez utóbbi porthoz csatlakozik a versenyszervezői szoftver.

1. Szükségünk lesz két com0com port párra.

   ![com0com Setup két port párra](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/setup2.png)

2. Indítsuk a SPORTident Reader-t, és adjuk meg a SPORTident Live rendszerben létrehozott verseny hozzáférési adatait (API key, Event ID).
   Ezt követően válasszuk ki a SPORTident Serial port output plug-int mint kimenő oldali eszközt és kattintsunk a _Configure this plugin_ feliratra.

   ![SI Reader Live beállítások](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/siremain.png)

3. Állítsuk be az egyik COMx (a példában COM8) nevű virtuális COM portot.

   ![SI reader soros kimeneti eszköz beállítások](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/sirecoms.png)

   Ezzel a GSM dobozok úgy viselkednek, mint egy soros doboz, ami kizárólag autosend lyukasztások küldésére képes.

4. Most összekötjük CNCB0-t CNCB1-gyel a SICOMTRACE segítségével.
   A példában ez az alábbi paranccsal történik:

   ```bat
   SICOMTRACE CNCB1 38400 CNCB0
   ```

   ![SICOMTRACE két port pár kötötti kötéskor](https://raw.githubusercontent.com/tajfutas/sicomtrace/gh-pages-shared/screenshots/cmd2.png)

5. Indítsuk a SPORTident Readert az _Open/Close_ feliratra kattintva.

6. A szervezői szoftver a COMy (a példában COM9) porton fogja kapni a rádiós lyukasztásokat.
   Csatlakoztassuk ehhez a porthoz.


Engedély
--------

_Copyright © 2016–2017, Szieberth Ádám_

Minden engedély megadva.

Ez a munka szabadon felhasználható mindennemű célból nem kizárólagosan ideértve a használatot, másolást, módosítást, közlést, terjesztést, újraengedélyezést, és az eredeti vagy a derivatív példányok üzleti célú értékesítését.


[LETÖLTÉS]: {{ page.download }}
[com0com driver]: https://github.com/tajfutas/sicomtrace/releases/tag/com0com-signed
[COM portok felszabadítása]: https://superuser.com/questions/408976/how-do-i-clean-up-com-ports-in-use
[null modem]: https://pcforum.hu/szotar/Null+modem+k%C3%A1bel
[kötegelt állomány]: https://hu.wikipedia.org/wiki/K%C3%B6tegelt_%C3%A1llom%C3%A1ny
