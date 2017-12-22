# SS-Gang-System-SQLITE

Dynamic gang system for SA-MP.This filterscript allows user to create custom gang,fight gang wars with other gangs and take over gang zones.The script available in both SQLITE and MySQL versions.This script undergone many tests by various server owners and scripters.If you found any bug or if you have any suggestions or improvements open an issue or make a pull request.

!["pic"](https://s24.postimg.org/nbh74vcb5/gta_sa_2016_04_27_11_22_08_998.jpg) !["pic"](https://s24.postimg.org/4x6o0w00h/gta_sa_2016_04_27_11_22_11_851.jpg) !["pic"](https://s24.postimg.org/raeenp0y9/gta_sa_2016_04_27_11_22_15_285.jpg)
!["pic"](https://s24.postimg.org/ekerocidt/gta_sa_2016_04_27_11_22_30_476.jpg) !["pic"](https://s24.postimg.org/y3jcxph5d/gta_sa_2016_04_27_11_22_34_748.jpg) !["pic"](https://s24.postimg.org/r1lfbidjl/gta_sa_2016_04_27_11_22_44_777.jpg)
!["pic"](https://s24.postimg.org/hibqi1q1d/gta_sa_2016_04_27_11_23_08_195.jpg) !["pic"](https://s24.postimg.org/l37m19ukx/gta_sa_2016_04_27_11_23_24_947.jpg) !["pic"](https://s24.postimg.org/bjxx7t72p/gta_sa_2016_04_27_11_23_50_649.jpg)
!["pic"](https://s24.postimg.org/nzun1k0ep/DA6_Iwj_U.jpg) !["pic"](https://s24.postimg.org/6b2w9xonl/5pz9_J6_A.jpg) !["pic"](https://s24.postimg.org/qjq9vnnyp/bi1s_ZLy.jpg)
!["pic"](https://s24.postimg.org/aa03srdap/WDTZY4_P.jpg) !["pic"](https://s24.postimg.org/xod51t1jl/sbh_Rgd_U.jpg)

## Commands

```
*   /gcp        - to enter gang control panel
*   /creategang - to create new gang
*   /gangtag    - to add tag to your gang
*   /gwar       - to challenge other gang members for a gang war
*   /backup     - to request backup
*   /gkick      - to kick a member from gang
*   /setleader  - to set a member to leader
*   /gmembers   - to see whole members of gang
*   /top        - to see top 10 gangs
*   /ginvite    - to invite some to your gang
*   /accept     - to accept an invitation
*   /decline    - to decline an invitation
*   /gangcolor  - to change your gang color
*   /lg         - to leave the gang
*   /capture    - to capture a gangzone
*   /createzone - to create a gang zone(Rcon only)
*   /zones      - to show all gang zone and their details
*   /ghelp      - to view all cmds
```
## Latest Bug fixes
```
* Gang War logic has been re written now.Limit of on gangwar per time is removed.
* Gang ownership logic has been modified.Now system checks for another leader if the one leader leaves the gang.
* Added support for streamer.(See the custom settings)
* Changed database schema.(Old db is no longer supported.Delete it before using upgraded one).
* Minor bug fixed and optmisations.
```
## Custom Settings

```
#define DEBUG (true)  // for debuging 
#define USE_STREAMER  (true)    //defining true uses streamer otherwise the script uses y_areas

#define MAX_GANGS                (50)
#define MAX_GZONES               (50)
#define MAX_GANG_WARS            (10) //Maximum number of gang wars at a time
#define ZONE_COLOR               (0xF3F0E596)
#define ZONE_LOCK_TIME           (10) //NOTE:The time should be given in seconds
#define ZONE_CAPTURE_TIME        (5)  //Same as above note
#define MAX_SCORE                (0)  //Maximum score to create a gang
#define ZONE_COLOR_OPAQUE_VALUE  (100)//Opaque value
#define CHAT_SYMBOL              '#'  //The prefix used for gang chat in game

```
## Plugins and Libraries

* sscanf by [Yless](http://forum.sa-mp.com/member.php?u=29176) - https://github.com/maddinat0r/sscanf/releases
* YSI by [Yless](http://forum.sa-mp.com/member.php?u=29176) - https://github.com/Misiur/YSI-Includes/releases
* Streamer(optional) by [Incognito](http://forum.sa-mp.com/member.php?u=925) - https://github.com/Misiur/YSI-Includes/releases


## Building and Installing
```
* Compile SS_GANG_MAIN.pwn
* Copy SS_GANG_MAIN.amx to filterscripts folder
* Add SS_GANG_MAIN  to server.cfg
```

## Special Thanks
* [AndySedeyn](http://forum.sa-mp.com/member.php?u=225999)   - Contributing
* [Konstantinos](http://forum.sa-mp.com/member.php?u=149753) - Contributing
* [MonsterGamer](http://forum.sa-mp.com/member.php?u=229155) - Testing
* [Oma37](http://forum.sa-mp.com/member.php?u=274689)		 - Testing
* [Yaa](http://forum.sa-mp.com/member.php?u=279315)		     - Testing	
* [UltraZ](http://forum.sa-mp.com/member.php?u=284129)	     - Testing




