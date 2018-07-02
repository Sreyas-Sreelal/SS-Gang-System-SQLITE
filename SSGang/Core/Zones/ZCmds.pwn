
/*

Commands.pwn - Contains commands related to zones 

NOTE: this doesn't include comamnds that have handle to Database.

*/

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
    foreach (new j:SS_Player)
    {
        if(GInfo[j][gangid] == GInfo[playerid][gangid] && IsPlayerInArea(j, ZInfo[i][ZminX] ,ZInfo[i][ZminY],ZInfo[i][ZmaxX],ZInfo[i][ZmaxY]))
            GInfo[j][Capturing] = true;
    }
    
    ZInfo[i][U_Attack] = true;

    format(string,sizeof string,"%s%s"ORANGE" gang has started to capture "GREEN"%s "ORANGE"zone",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[i][Name]);
    SendClientMessageToAll(-1,string);
    ZInfo[i][timercap] = ZONE_CAPTURE_TIME;
    ZInfo[i][timercap_main] = SetTimerEx("CaptureZone", 1000, true, "ii", playerid, i);

    return 1;
}

CMD:zones(playerid)
{
   new string[900],count = 1;//work around to fix the numbering bug caused if iter_remove is called

   foreach(new i : Zones)
   {
        if(isnull(ZInfo[i][Owner]))
             format(string,sizeof string,"%s"GREEN"%d.)"RED"%s\n",string,count++,ZInfo[i][Name]);
        else
            format(string,sizeof string,"%s"GREEN"%d.)"RED"%s"YELLOW" %s(%s)\n",string,count++,ZInfo[i][Name],IntToHex(ZInfo[i][Color]),ZInfo[i][Owner]);
   }

   ShowPlayerDialog(playerid,ZONES,DIALOG_STYLE_MSGBOX,""ORANGE"Zones"PINK"           Owned By",string,"Cancel","");
   return 1;
}

