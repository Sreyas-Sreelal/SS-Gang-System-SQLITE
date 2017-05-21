/*

ZHandle.pwn - Contains hooked callbacks handling the zone setup and destruction

*/

#include <YSI\y_hooks>


hook OnPlayerConnect(playerid)
{
	#if DEBUG == true
	     printf("OnPlayerconnect of zones init called ");
	#endif
	
      foreach(new i:Zones)
        GangZoneShowForPlayer(
          				playerid,
          				ZInfo[i][ Zone_Wrapper], 
          				(isnull(ZInfo[i][Owner])) ?(ZONE_COLOR): (ZInfo[i][Color])
      			       );
      return 1;
}

hook OnFilterScriptExit()
{
    foreach(new i : Zones)
    {
        GangZoneDestroy(ZInfo[i][ Zone_Wrapper]);
        Area_Delete(ZInfo[i][Region]);
    }

    Iter_Clear(Zones);
       
    return 1;
}

forward CaptureZone(playerid,zoneid);
/*

Function calls on each second to check completion conquiring of a zone and related things.

params:
            playerid - id of the player started war 
            zoneid   - gang zone id 

returns: 1  

*/
public CaptureZone(playerid,zoneid)
{
    ZInfo[zoneid][timercap]--;
    new str[34];
    format(str,sizeof str,"%02d-%02d",(ZInfo[zoneid][timercap]/60),ZInfo[zoneid][timercap]);
    PlayerTextDrawSetString(playerid, GInfo[playerid][TimerTD],str);
    PlayerTextDrawShow(playerid,GInfo[playerid][TimerTD]);

    if(ZInfo[zoneid][timercap]==0)
    {
        new string[128];
        format(string,sizeof string,""RED"Your Gang zone is captured by"YELLOW" %s %sgang ",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname]);
        PlayerTextDrawHide(playerid,GInfo[playerid][TimerTD]);
        foreach(new i : SS_Player)
        {
            if(!strcmp(ZInfo[zoneid][Owner],GInfo[i][gangname]))
                SendClientMessage(i,-1,string);
        }

        if(ZInfo[zoneid][U_Attack])
        {
            GangZoneStopFlashForAll(ZInfo[zoneid][ Zone_Wrapper]);
            ZInfo[zoneid][Color] = (GInfo[playerid][gangcolor] & ~0xFF) | ZONE_COLOR_OPAQUE_VALUE;
            GangZoneShowForAll(ZInfo[zoneid][ Zone_Wrapper], ZInfo[zoneid][Color]);
            format(ZInfo[zoneid][Owner],24,"%s",GInfo[playerid][gangname]);
            ZInfo[zoneid][locked] = true;
            new 
                Query[300],
                msg[150];
            format(Query,sizeof Query,"UPDATE Zones SET OwnerID = '%d' WHERE Name = '%q'",GInfo[playerid][gangid],ZInfo[zoneid][Name]);
            db_query(Database,Query);
            format(msg,sizeof msg,"%s%s "ORANGE" gang has successfully captured"GREEN" %s "ORANGE"zone. It will be locked for "RED"%d "ORANGE"minute(s)",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[zoneid][Name],((ZONE_LOCK_TIME)/60));
            SendClientMessageToAll(-1,msg);
            ZInfo[zoneid][timer] = ZONE_LOCK_TIME;
            ZInfo[zoneid][timer_main] = SetTimerEx("UnlockZone",1000,true,"i",zoneid);
            ZInfo[zoneid][U_Attack] = false;
            foreach(new j : SS_Player)
            {
                if(GInfo[playerid][gangid] == GInfo[j][gangid] && IsPlayerInAreaEx(playerid,zoneid))
                    GInfo[j][Capturing] = false;
            }
            
            
            format(Query,sizeof(Query),"UPDATE Gangs SET GangScore = GangScore+10 WHERE GangID = '%d'",GInfo[playerid][gangid]);
            db_query(Database,Query);
        }
 
        KillTimer(ZInfo[zoneid][timercap_main]);
     }
    return 1;
}

forward UnlockZone(zoneid);
/*

Function to handle the unlocking of zone after expiration

parmas:
            zoneid - id of the gang zone

return: 1

*/
public UnlockZone(zoneid)
{

    ZInfo[zoneid][timer]--;
    if(ZInfo[zoneid][timer] == 0)
    {
        KillTimer(ZInfo[zoneid][timer_main]);
        ZInfo[zoneid][locked] = false;
    }
    return 1;
}

