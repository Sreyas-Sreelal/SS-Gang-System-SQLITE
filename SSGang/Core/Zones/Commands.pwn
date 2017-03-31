
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
    Zone_Wrapper
}

new ZInfo[MAX_GZONES][Zone_Data];



CMD:capture(playerid)
{

    if(GInfo[playerid][gangmember] == 0) 
      return SendClientMessage(playerid,-1,""RED"[ERROR]:"GREY"You are not in any gang!");
    new 
        bool:inzone = false,
        i;

    foreach( i : Zones)
    {
        if(IsPlayerInArea(playerid, ZInfo[i][ZminX] ,ZInfo[i][ZminY],ZInfo[i][ZmaxX],ZInfo[i][ZmaxY]))
        {
            inzone = true;
            break;
        }
    }

    if(!inzone)
      return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"You should be in a gang zone to use this CMD!");
    new string[150];
    if(ZInfo[i][locked])
    {
        format(string,sizeof string,""GREY"This Zone is Locked comeback in "YELLOW"%d "GREY"seconds ",ZInfo[i][timer]);
        return SendClientMessage(playerid,-1,string);
    }

    if(GInfo[playerid][Capturing]) 
        return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"You are capturing this zone! ");
    if(ZInfo[i][U_Attack]) 
        return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"Another gang is already set an atttack on  this zone!");
    
    if(!strcmp(ZInfo[i][Owner],GInfo[playerid][gangname],true) && !isnull(ZInfo[i][Owner])) 
        return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"Your Gang Own this Zone");

    GangZoneFlashForAll(ZInfo[i][ Zone_Wrapper], 0xFF0000AA);
    GInfo[playerid][Capturing] = true;
    ZInfo[i][U_Attack] = true;

    format(string,sizeof string,"%s%s"ORANGE" gang has started to capture "GREEN"%s "ORANGE"zone",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[i][Name]);
    SendClientMessageToAll(-1,string);
    ZInfo[i][timercap] = ZONE_CAPTURE_TIME;
    ZInfo[i][timercap_main] = SetTimerEx("CaptureZone", 1000, true, "ii", playerid, i);

    return 1;
}

CMD:zones(playerid)
{
   new string[900];

   foreach(new i : Zones)
   {
        if(isnull(ZInfo[i][Owner]))
             format(string,sizeof string,"%s"GREEN"%d.)"RED"%s\n",string,(i+1),ZInfo[i][Name]);
        else
            format(string,sizeof string,"%s"GREEN"%d.)"RED"%s"YELLOW" %s(%s)\n",string,(i+1),ZInfo[i][Name],IntToHex(ZInfo[i][Color]),ZInfo[i][Owner]);
   }

   ShowPlayerDialog(playerid,ZONES,DIALOG_STYLE_MSGBOX,""ORANGE"Zones"PINK"           Owned By",string,"Cancel","");
   return 1;
}

forward CaptureZone(playerid,zoneid);

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
            new color = (GInfo[playerid][gangcolor] & ~0xFF) | 80;
            GangZoneShowForAll(ZInfo[zoneid][ Zone_Wrapper], color);
            format(ZInfo[zoneid][Owner],24,"%s",GInfo[playerid][gangname]);
            ZInfo[zoneid][locked] = true;
            ZInfo[zoneid][Color] = color;
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
            GInfo[playerid][Capturing] = false;
            
            format(Query,sizeof(Query),"UPDATE Gangs SET GangScore = GangScore+10 WHERE GangID = '%d'",GInfo[playerid][gangid]);
            db_query(Database,Query);
        }
 
        KillTimer(ZInfo[zoneid][timercap_main]);
     }
    return 1;
}

forward UnlockZone(zoneid);
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

