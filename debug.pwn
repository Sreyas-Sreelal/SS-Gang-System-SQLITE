#include<a_samp>

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    SetPlayerPos(playerid,fX,fY,fZ);
    return 1;
}
