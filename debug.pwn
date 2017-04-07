
#include<a_samp>
#include <zcmd>


#define FILTERSCRIPT

public OnFilterScriptInit()
{
	printf("DEBUG SCRIPT LOADED");
	return 1;
}

public OnFilterScriptExit()
{
	printf("DEBUG SCRIPT UNLOADED");
	UsePlayerPedAnims();
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	SetPlayerPos(playerid, fX, fY, fZ);
	return 1;
}
