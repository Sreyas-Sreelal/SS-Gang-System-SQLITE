
/*

AreaSync.pwn - Contains script to handle player's interaction with Areas

*/

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
            if(ZInfo[i][U_Attack])
                PlayerTextDrawShow(playerid,GInfo[playerid][TextDraw]);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerLeaveArea(playerid, areaid)
{
    static  
            msg[200],
            bool:flag_invaders;

    flag_invaders = false;
    
        
    if(GInfo[playerid][Capturing])//Player left was capturing
    {
        new 
            i,//Zones Loop
            j;//Player loop
            
        GInfo[playerid][Capturing] = false;
        foreach(i : Zones)
        {
            if(areaid == ZInfo[i][Region])
            {
                
                foreach( j : SS_Player)//Check any other member was in the zone
                {
                    if(j == playerid || !GInfo[playerid][gangid]) continue;
                    
                    
                    if(GInfo[j][Capturing] && GInfo[j][gangid] == GInfo[playerid][gangid] && areaid == Area_GetPlayerAreas(j,0) )
                    {
                        #if DEBUG == true
                            printf("GInfo[j][Capturing] = %d GInfo[j][gangid] = %d   Area_GetPlayerAreas(j,0) = %d ",GInfo[j][Capturing],GInfo[j][gangid],Area_GetPlayerAreas(j,0));
                        #endif
                        flag_invaders = true;
                        break;
                    }
                }
                if(!flag_invaders)//No member found in the zone
                {

                    format(msg,sizeof msg,"%s%s "ORANGE" gang has failed in capturing "GREEN" %s "ORANGE"zone.It will be locked for %d minute(s)",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[i][Name],((ZONE_LOCK_TIME)/60));
                    KillTimer(ZInfo[i][timercap_main]);
                    PlayerTextDrawHide(playerid,GInfo[playerid][TimerTD]);
                    SendClientMessageToAll(-1,msg);
                    ZInfo[i][timer] = ZONE_LOCK_TIME;
                    ZInfo[i][locked] = true;
                    ZInfo[i][timer_main] = SetTimerEx("UnlockZone",1000,true,"i",i);
                    ZInfo[i][U_Attack] = false;
                    GangZoneStopFlashForAll(ZInfo[i][Zone_Wrapper]);

                                        
                }
                    
                break;
            }
        }
        PlayerTextDrawHide(playerid, ZInfo[playerid][TimerTD]);
    }
    
    PlayerTextDrawHide(playerid, GInfo[playerid][TextDraw]);
    return 1;
}