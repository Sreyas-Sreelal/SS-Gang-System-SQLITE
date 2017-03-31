
forward GangWar(playerid,enemyid);
public GangWar(playerid,enemyid)
{
    new 
        count1,
        count2;
    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[playerid][gangname],GInfo[i][gangname]))
        {
            GivePlayerWeapon(i,34,100);
            SetPlayerHealth(i,100);
            SetPlayerArmour(i,100);
            TogglePlayerControllable( i, true );
            GameTextForPlayer(i, "~w~War ~g~ Has~r~ Started", 5000, 5);
            count1++;
        }

        if(!strcmp(GInfo[enemyid][gangname],GInfo[i][gangname]))
        {
            GivePlayerWeapon(i,34,100);
            SetPlayerHealth(i,100);
            SetPlayerArmour(i,100);
            TogglePlayerControllable( i, true );
            GameTextForPlayer(i, "~w~War ~g~ Has~r~ Started", 5000, 5);
            count2++;
        }
    }

    if(count1 ==0 || count2 ==0)
    {
        foreach(new i : SS_Player)
        {
            if(GInfo[i][inwar] == true)
            {
                GInfo[i][inwar] = false;
                SpawnPlayer(i);
            }
        }

        ActiveWar = false;
        return SendClientMessageToAll(-1,""RED "Gang war ended due to low participants");
    }
    return 1;
}


forward GMoney(playerid);
public GMoney(playerid)
{
    GivePlayerMoney(playerid,100);
    GameTextForPlayer(playerid,"~w~RECIEVED ~g~100$ ~w~FROM GANG HQ FOR YOUR SERVICE",5000,5);
    return 1;
}


CheckVict(gname1[],gname2[])
{
    new count1,count2,pid,eid;
  
    foreach(new i : SS_Player)
    {
        if(GInfo[i][inwar] == true)
        {
            if(!strcmp(gname1,GInfo[i][gangname]) || !strcmp(gname1,"INVALID"))
            {
                pid = i;
                count1++;
            }

            if(!strcmp(gname2,GInfo[i][gangname]) || !strcmp(gname2,"INVALID"))
            {
                eid = i;
                count2++;
            }
        }
    }

    if(count1 ==0 || count2 ==0)
    {
        new winner[32];
        foreach(new i : SS_Player)
        {
            if(GInfo[i][inwar])
            {
                GInfo[i][inwar] = false;
                SetPlayerInterior(i,0);
                SpawnPlayer(i);
            }
        }

        new str[128];
  
        if(count1 == 0)
        {
            format(str,sizeof(str),"%s%s "WHITE"has won the war against %s%s",IntToHex(GInfo[eid][gangcolor]),GInfo[eid][gangname],IntToHex(GInfo[pid][gangcolor]),GInfo[pid][gangname]);
            SendClientMessageToAll(-1,str);
            ActiveWar = false;
            format(winner,sizeof winner,"%s",gname2);
        }

        else if(count2 == 0)
        {
             
            format(str,sizeof(str),"%s%s "WHITE"has won the war against %s%s",IntToHex(GInfo[pid][gangcolor]),GInfo[pid][gangname],IntToHex(GInfo[eid][gangcolor]),GInfo[eid][gangname]);
            SendClientMessageToAll(-1,str);
            ActiveWar = false;
            format(winner,sizeof winner,"%s",gname1);
        }

        new Query[180];
        format(Query,sizeof(Query),"UPDATE Gangs SET GangScore = GangScore+5 WHERE GangName = '%q'",winner);
        db_query(Database,Query);
    }
    return 1;
}

IntToHex(var)
{
    new hex[10];
    format(hex,sizeof hex,"{%06x}", var >>> 8);
    return hex;
}

SendGangMessage(playerid,Message[])
{
    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[playerid][gangname],GInfo[i][gangname],false) && !isnull(GInfo[i][gangname]))
            SendClientMessage(i,-1,Message);
    }
    return 0;
}