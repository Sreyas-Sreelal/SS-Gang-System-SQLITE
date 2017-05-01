
/*
Functions.pwn - Contains the defintions of custom made functions handling gangs and other hooked callbacks
*/

/*

Calls  after some time of connection so as to avoid corrupted writing of data on connection

Params: 
        playerid - connected player's id 

returns: 1

*/

forward FullyConnect(playerid);
public FullyConnect(playerid)
{
    if(!isnull(GInfo[playerid][gangtag]))
    {
        new newname[24];
        format(newname,sizeof newname,"%s[%s]",GInfo[playerid][username],GInfo[playerid][gangtag]);
        SetPlayerName(playerid,newname);
        SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
    }
    return 1;
}







forward GangWar(playerid,enemyid);

/*

Fucntion to handle gangwar for gangs

Params: 
        playerid - connected player's id
        enemyid  - enemy's id    

returns: 1

*/

/*

NOTE: Need to rewrite

*/

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

/*

This function calls on a certain intervals (provided by user) to give players money as reward for
being a gang member

*/

public GMoney(playerid)
{
    GivePlayerMoney(playerid,100);
    GameTextForPlayer(playerid,"~w~RECIEVED ~g~100$ ~w~FROM GANG HQ FOR YOUR SERVICE",5000,5);
    return 1;
}

/*

Function to check whether a gang won in the war.

params:
        gname1[] - naem of participant 1 
        gname2[] - name of participant 2 


returns: nothing

*/
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
    
}
/*

Function to convert integer hex values to string one 

parmas:
        var - variable holding hexadecimal value

returns: converted hex value (string)

*/
IntToHex(var)
{
    new hex[10];
    format(hex,sizeof hex,"{%06x}", var >>> 8);
    return hex;
}
/*

Function sending message to specified gang or group

params:
        ID - id of the of  gang
        Message[] - Message to be send

returns: 1 

*/
SendGangMessage(ID,Message[])
{
    foreach(new i : SS_Player)
    {
        if(GInfo[i][gangid] == ID)
            SendClientMessage(i,-1,Message);
    }
    return 1;
}

/*Hooked callback to handle clan chat*/

hook OnPlayerText(playerid, text[])
{
    static str[128];
   
    if( GInfo[playerid][gangmember] == 1 && text[0] == CHAT_SYMBOL )
    {
        format(str,sizeof(str),""RED"[GANG CHAT]"ORANGE" %s: "WHITE"%s",GInfo[playerid][username],text[1]);
        SendGangMessage(GInfo[playerid][gangid],str);
        return 0;
    }
    
    else
    {
        format(str, sizeof (str), "(%d) %s", playerid, text);
        SetPlayerChatBubble(playerid, text, 0xFFFFFFFF, 100.0, 10000);
        SendPlayerMessageToAll(playerid, str);
        return 0;
    }

}
