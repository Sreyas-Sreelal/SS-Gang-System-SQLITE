# SS-Gang-System-SQLITE

Dynamic gang system for SA-MP.This filterscript allows user to create custom gang,fight gang wars with other gangs and take over gang zones.The script available in both SQLITE and MySQL versions.This script undergone many tests by various server owners and scripters.If you found any bug or if you have any suggestions or improvements open an issue or make a pull request.

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
*	Gang War logic has been re written now.Limit of on gangwar per time is removed.
*	Gang ownership logic has been modified.Now system checks for another leader if the one leader leaves the gang.
*	Added support for streamer.(See the custom settings)
*	Changed database schema.(Old db is no longer supported.Delete it before using upgraded one).
*	Minor bug fixed and optmisations.
```
## Custom Settings

```
#define MAX_GANGS                (50)
#define MAX_GZONES               (50)
#define MAX_GANG_WARS            (10) //Maximum number of gang wars at a time
#define ZONE_COLOR               (0xF3F0E596)
#define ZONE_LOCK_TIME           (10) //NOTE:The time should be given in seconds
#define ZONE_CAPTURE_TIME        (5)  //Same as above note
#define MAX_SCORE                (0)  //Maximum score to create a gang
#define ZONE_COLOR_OPAQUE_VALUE  (100)//Don't un neccessarily put value use your brain!
#define CHAT_SYMBOL              '#'  //The prefix used for gang chat in game

```
## Plugins and Libraries
```
*	sscanf by Yless - https://github.com/maddinat0r/sscanf/releases
*	YSI by Yless - https://github.com/Misiur/YSI-Includes/releases
*	Streamer(optional) by Incognito - https://github.com/Misiur/YSI-Includes/releases
```

## Building and Installing
```
*	Compile SS_GANG_MAIN.pwn
*	Copy SS_GANG_MAIN.amx to filterscripts folder
* 	Add SS_GANG_MAIN  to server.cfg
```

## Special Thanks
*	AndySedeyn 	 - Contributing
*	Konstantinos - Contributing
*	MonsterGamer - Testing
*	Oma37		 - Testing
*	Yaa			 - Testing	
*	UltraZ		 - Testing




