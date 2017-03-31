
#include <YSI\y_hooks>

hook OnPlayerDisconnect(playerid,reason)
{
    SetPlayerName(playerid,GInfo[playerid][username]);//just to avoid some bugs

    if(GInfo[playerid][inwar])
    {
        GInfo[playerid][inwar] = false;
        CheckVict(GInfo[playerid][gangname],"INVALID");//NOTE: to work on

    }

    if(GInfo[playerid][gangmember] == 1)
    {
        new str[128];
        format(str,sizeof(str),""ORANGE"[GANGINFO]"RED" Member "CYAN"%s"RED" has Logged Out ",GInfo[playerid][username]);
        SendGangMessage(playerid,str);
    }

    GInfo[playerid] = Reset_Gang_Enum; 

    
    return 1;
}