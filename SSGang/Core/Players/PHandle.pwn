/*

PHandle.pwn - Contains normal connection hanlding

*/

#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	#if DEBUG == true
		printf("OnPlayerconnect of player init called ");
	#endif
	Iter_Add(SS_Player,playerid);
	return 1;
}


hook OnPlayerDisConnect(playerid)
{
	Iter_Remove(SS_Player,playerid);
	return 1;
}

hook OnFilterScriptExit()
{
	Iter_Clear(SS_Player);
	return 1;
}