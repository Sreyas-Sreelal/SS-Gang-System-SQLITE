

/*

  _________ _________         ________                              _________               __
 /   _____//   _____/        /  _____/_____    ____    ____        /   _____/__.__. _______/  |_  ____   _____
 \_____  \ \_____  \        /   \  ___\__  \  /    \  / ___\       \_____  <   |  |/  ___/\   __\/ __ \ /     \
 /        \/        \       \    \_\  \/ __ \|   |  \/ /_/  >      /        \___  |\___ \  |  | \  ___/|  Y Y  \
/_______  /_______  /        \______  (____  /___|  /\___  /      /_______  / ____/____  > |__|  \___  >__|_|  /
        \/        \/                \/     \/     \//_____/               \/\/         \/            \/      \/
                                     __________
                                     \______   \___.__.
                                      |    |  _<   |  |
                                      |    |   \\___  |
                                      |______  // ____|
                                             \/ \/ _________
                                                  /   _____/______   ____ ___.__._____    ______
                                                  \_____  \\_  __ \_/ __ <   |  |\__  \  /  ___/
                                                  /        \|  | \/\  ___/\___  | / __ \_\___ \
                                                 /_______  /|__|    \___  > ____|(____  /____  >
                                                         \/             \/\/          \/     \/




                                      |----------------------------------------------------------------|
                                      |            ==ADVANCED GANG SYSTEM SQLLITE==                    |
                                      |            ==AUTHOR:SREYAS==                                   |
                                      |            ==COLLABRATORS: AndySedeyn,Konstantinos==           |
                                      |            ==Version:1.0==                                     |
                                      |                                                                |
                                      |        =======Commands=========                                |
                                      |   /gcp        - to enter gang control panel                    |
                                      |   /creategang - to create new gang                             |
                                      |   /gangtag    - to add tag to your gang                        |
                                      |   /gwar       - to challenge other gang members for a gang war |
                                      |   /backup     - to request backup                              |
                                      |   /gkick      - to kick a member from gang                     |
                                      |   /setleader  - to set a member to leader                      |
                                      |   /gmembers   - to see whole members of gang                   |
                                      |   /top        - to see top 10 gangs                            |
                                      |   /ginvite    - to invite some to your gang                    |
                                      |   /accept     - to accept an invitation                        |
                                      |   /decline    - to decline an invitation                       |
                                      |   /gangcolor  - to change your gang color                      |
                                      |   /lg         - to leave the gang                              |
                                      |   /capture    - to capture a gangzone                          |
                                      |   /createzone - to create a gang zone(Rcon only)               |
                                      |   /zones      -  to show all gang zone and their details       |
                                      |   /ghelp      - to view all cmds                               |
                                      |                                                                |
                                      |          ======Other Features=====                             |
                                      |    Use '#' to gang chat                                        |
                                      |    Each kill give 1 score for gang                             |
                                      |    Gang Member's death will be notified                        |
                                      |    Gang will be destroyed if a leader leaves it                |
                                      |    Gang Members will get 100$ per each 10 minutes              |
                                      |    Gang Zone will locked for certain time given by user        |
                                      |    Capturing gang zone gives 10 score to the gang              |
                                      |    In game dynamic gang zone creator                           |
                                      |    On entering the zone zone info will be displayed to player  |
                                      |                                                                |
                                      |                                                                |
                                      |----------------------------------------------------------------|
*/


#define FILTERSCRIPT

#include <a_samp> //SA - MP TEAM
#include <sscanf2> //YLESS
#include <zcmd>   //ZEEX 
#include <YSI\y_iterate> //Y LESS
#include <YSI\y_areas> //Y LESS

#define DEBUG (true)  // for developers only

//--------------Custom Defines-----------------------------------------------------------

#define MAX_GANGS           (50)
#define MAX_GZONES          (50)
#define ZONE_COLOR          (0xF3F0E596)
#define ZONE_LOCK_TIME      (120)                //NOTE:The time should be given in seconds
#define ZONE_CAPTURE_TIME   (30)                //Same as above note
#define MAX_SCORE           (0)                //Maximum score to create a gang
#define ZONE_COLOR_OPAQUE_VALUE (100)		  //Don't un neccessarily put value use your brain!

//---------------------------------------------------------------------------------------

//------Colors-----------------------------

#define RED     "{FF0000}"
#define GREY    "{C0C4C4}"
#define ORANGE  "{F07F1D}"
#define CYAN    "{00FFFF}"
#define GREEN   "{00FF00}"
#define WHITE   "{FFFFFF}"
#define VIOLET  "{8000FF}"
#define YELLOW  "{FFFF00}"
#define BLUE    "{0000FF}"
#define PINK    "{F7B0D0}"

IsPlayerInArea(playerid,Float:MinX,Float:MinY,Float:MaxX,Float:MaxY)
{
    static Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) 
        return 1;
  
    return 0;
}

new 
	Iterator:SS_Player<MAX_PLAYERS>,
    Iterator:Zones<MAX_GZONES>;

#include "SSGANG\Core\Dialogs\_Def_.pwn"
#include "SSGANG\Database\SQLite\DBHandle.pwn"
#include "SSGANG\Core\Gangs\Data.pwn"
#include "SSGANG\Core\Players\PInit.pwn"    
#include "SSGANG\Core\Gangs\GInit.pwn"
#include "SSGANG\Database\SQLite\PlayersDB.pwn"
#include "SSGANG\Core\TextDraws\TInit.pwn"
#include "SSGANG\Core\Zones\Commands.pwn"
#include "SSGANG\Core\Zones\ZInit.pwn"
#include "SSGANG\Database\SQLite\GangDB.pwn"
#include "SSGANG\Database\SQLite\ZoneLoad.pwn"
#include "SSGANG\Core\Gangs\Functions.pwn"
#include "SSGANG\Core\Players\Functions.pwn"
#include "SSGANG\Core\Dialogs\Response.pwn"
#include "SSGANG\Core\Gangs\Colors.pwn"
#include "SSGANG\Core\Gangs\GDestructor.pwn"
#include "SSGANG\Core\Players\PDestructor.pwn"
#include "SSGANG\Core\Zones\ZDestructor.pwn"
#include "SSGANG\Core\Zones\ZoneCreator.pwn"
#include "SSGANG\Database\SQLite\Commands\Gangcmds.pwn"
#include "SSGANG\Database\SQLite\CallBackHooks.pwn"
#include "SSGANG\Database\SQLite\DialogHooks.pwn"
#include "SSGANG\Core\Players\Others\AreaSync.pwn"





