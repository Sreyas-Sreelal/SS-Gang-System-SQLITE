
/*
GInit.pwn - Contains hooked callback to intialise gang variables for player on connection
*/

#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	#if DEBUG == true
		printf("OnPlayerconnect of gang init called ");
	#endif
	GInfo[playerid] = Reset_Gang_Enum; 
	GetPlayerName( playerid, GInfo[playerid][username], MAX_PLAYER_NAME );
    GInfo[playerid][Capturing] = false;
    return 1;
}

