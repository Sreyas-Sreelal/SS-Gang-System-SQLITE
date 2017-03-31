
#include <YSI\y_hooks>

hook OnPlayerEnterArea(playerid, areaid)
{
    static str[128];
    foreach(new i : Zones)
    {
        if(areaid == ZInfo[i][Region])
        {
            
            if(isnull(ZInfo[i][Owner]))
            {
                 format(str,sizeof str,"~y~Zone_Info~n~~b~Name:_~r~%s~n~~b~Status:_~r~Un_Owned",ZInfo[i][Name]);
                 PlayerTextDrawSetString(playerid, GInfo[playerid][TextDraw],str);
            }
            else
            {
                format(str,sizeof str,"~y~Zone_Info_~n~~b~Name:_~r~%s~n~~b~Status:_~r~Owned-by_~g~%s",ZInfo[i][Name],ZInfo[i][Owner]);
                PlayerTextDrawSetString(playerid, GInfo[playerid][TextDraw],str);
            }

            PlayerTextDrawShow(playerid,GInfo[playerid][TextDraw]);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerLeaveArea(playerid, areaid)
{
    static msg[200];
    foreach(new i : Zones)
    {
        if(areaid == ZInfo[i][Region])
        {
            if(GInfo[playerid][Capturing])
            {
                
                GInfo[playerid][Capturing] = false;
                format(msg,sizeof msg,"%s%s "ORANGE" gang has failed in capturing "GREEN" %s "ORANGE"zone.It will be locked for %d minute(s)",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[i][Name],((ZONE_LOCK_TIME)/60));
                KillTimer(ZInfo[i][timercap_main]);
                PlayerTextDrawHide(playerid,GInfo[playerid][TimerTD]);
                SendClientMessageToAll(-1,msg);
                ZInfo[i][timer] = ZONE_LOCK_TIME;
                ZInfo[i][locked] = true;
                ZInfo[i][timer_main] = SetTimerEx("UnlockZone",1000,true,"i",i);
            }
            ZInfo[i][U_Attack] = false;
            GangZoneStopFlashForAll(ZInfo[i][ Zone_Wrapper]);
            PlayerTextDrawHide(playerid, GInfo[playerid][TextDraw]);
        }
    }
    return 1;
}