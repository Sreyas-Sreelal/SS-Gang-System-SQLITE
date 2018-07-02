

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
                                      |   /removezone - to remove a created zone(Rcon only)            |
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

//Script options 

#define DEBUG (true)  // for developers only
#define USE_STREAMER  (true)    //defining true uses streamer otherwise the script uses y_areas

/*
--------------------------------------------------------------------------------------------------
|					   ,___                        ___                                                      |
|					  /   /       _/_             ( / \    /)o                                              |
|					 /    , , (   /  __ _ _ _      /  /_  //,  _ _   _  (                                   |
|					(___/(_/_/_)_(__(_)/ / / /_  (/\_/(/_//_(_/ / /_(/_/_)_                                 | 
|					                                    /)                                                  |
|					                                   (/                                                   |
---------------------------------------------------------------------------------------------------
*/

#define MAX_GANGS                (50)
#define MAX_GZONES               (50)
#define MAX_GANG_WARS            (10) //Maximum number of gang wars at a time
#define ZONE_COLOR               (0xF3F0E596)
#define ZONE_LOCK_TIME           (10)                //NOTE:The time should be given in seconds
#define ZONE_CAPTURE_TIME        (5)                //Same as above note
#define MAX_SCORE                (0)                //Maximum score to create a gang
#define ZONE_COLOR_OPAQUE_VALUE  (100)		  //Don't un neccessarily put value use your brain!
#define CHAT_SYMBOL              '#'        //The prefix used for gang chat in game
#define INVALID_WAR_ID           (4808)

#if USE_STREAMER == true
  #include<streamer>
  #define Area_AddBox CreateDynamicRectangle
  #define Area_Delete DestroyDynamicArea
  #define OnPlayerEnterArea OnPlayerEnterDynamicArea
  #define OnPlayerLeaveArea OnPlayerLeaveDynamicArea

#else 
  #include <YSI\y_areas>

#endif

/*
---------------------------------------------------------------------------------------------------
|							   ,___    _                                                                        |
|							  /   /   //                                                                        |
|							 /    __ // __ , , _   (                                                            |
|							(___/(_)(/_(_)(_/_/ (_/_)_                                                          |
|																								                                                  |
---------------------------------------------------------------------------------------------------
*/

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

#define G_PURPLE   0xD526D9FF
#define G_GREEN    0x00FF00FF
#define G_PINK     0xFFB6C1FF
#define G_CYAN     0x33CCFFAA
#define G_GREY     0xAFAFAFAA
#define G_WHITE    0xFFFFFFFF
#define G_ORANGE   0xFF8000FF
#define G_YELLOW   0xFFFF00FF
#define G_BLUE     0x0080FFC8
#define G_RED      0xFF0000FF




new 
	Iterator:SS_Player<MAX_PLAYERS>,
	Iterator:Zones<MAX_GZONES>;

 
#include "SSGANG\Core\Gangs\GangData.pwn"
#include "SSGANG\Core\Dialogs\DialogHandles.pwn"
#include "SSGANG\Database\SQLite\DBHandle.pwn"
#include "SSGANG\Core\Players\PHandle.pwn"    
#include "SSGANG\Core\Gangs\GInit.pwn"
#include "SSGANG\Database\SQLite\PlayersDB.pwn"
#include "SSGANG\Core\TextDraws\TInit.pwn"
#include "SSGANG\Core\Zones\ZoneData.pwn"
#include "SSGANG\Core\Zones\Zhandle.pwn"
#include "SSGANG\Core\Zones\ZCmds.pwn"
#include "SSGANG\Database\SQLite\Commands\DBZonecmds.pwn"
#include "SSGANG\Database\SQLite\GangDB.pwn"
#include "SSGANG\Database\SQLite\ZoneLoad.pwn"
#include "SSGANG\Core\Gangs\Functions.pwn"
#include "SSGANG\Core\Gangs\GDestructor.pwn"
#include "SSGANG\Core\Zones\ZoneCreator.pwn"
#include "SSGANG\Database\SQLite\Commands\DBGangcmds.pwn"
#include "SSGANG\Core\Gangs\GCmds.pwn"
#include "SSGANG\Database\SQLite\DialogHooks.pwn"
#include "SSGANG\Core\Players\Others\AreaSync.pwn"
#include "SSGANG\Database\SQLite\CallBackHooks.pwn"

public OnFilterScriptInit()
{
  for(new i; i <= GetPlayerPoolSize();++i)
    if(IsPlayerConnected(i))
      CallRemoteFunction("OnPlayerConnect", "i", i);
    
  return 1;
}

public OnFilterScriptExit()
{
  for(new i; i <= GetPlayerPoolSize();++i)
    if(IsPlayerConnected(i))
      CallRemoteFunction("OnPlayerDisconnect", "ii", i,1);
  return 1;
}