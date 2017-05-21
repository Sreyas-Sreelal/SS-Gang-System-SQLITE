
/*

ZoneData.pwn - Conatains variable declaration handling zones

*/
enum Zone_Data
{
    Color,
    Owner[32],
    bool:Owned,
    bool:locked,
    bool:U_Attack,
    timer,
    timer_main,
    timercap_main,
    timercap,
    Name[32],
    Float:ZminX,
    Float:ZminY,
    Float:ZmaxX,
    Float:ZmaxY,
    Region,
    Zone_Wrapper,
    PlayerText:TimerTD
}

new ZInfo[MAX_GZONES][Zone_Data];

/*
Function to check whether Player is in a specified area

params:
        playerid  - id of player to be checked
        MinX      - The X coordinate for the west side of the area.
        MinY      - The Y coordinate for the south side of the area.
        MaxX      - The X coordinate for the east side of the area.
        MaxY      - The Y coordinate for the north side of the area.

returns: 1 on sucess or 0 otherwise        

*/

IsPlayerInArea(playerid,Float:MinX,Float:MinY,Float:MaxX,Float:MaxY)
{
    static Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    return (X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY); 
}

bool:IsPlayerInAreaEx(playerid,zoneid)
{
    #if USE_STREAMER == true
        printf("Streamer function returns %d",IsPlayerInDynamicArea(playerid,ZInfo[zoneid][Region]));
        return bool:!!IsPlayerInDynamicArea(playerid,ZInfo[zoneid][Region]);
    #else
        return Area_GetPlayerAreas(playerid,0) == ZInfo[zoneid][Region]; 
    #endif
    
   
}