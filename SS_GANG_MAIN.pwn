
#define FILTERSCRIPT

#include <a_samp> //SA - MP TEAM



//#include <YSI\y_hooks>
#include <sscanf2> 
#include <zcmd>    //ZEEX

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



/*public OnPlayerConnect(playerid)
{	
	printf("MAIN CONNECT CALLED");
	return 1;

}*/


#include <YSI\y_iterate> //Y LESS
#include <YSI\y_areas> 

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





