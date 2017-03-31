#include <YSI\y_hooks>

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