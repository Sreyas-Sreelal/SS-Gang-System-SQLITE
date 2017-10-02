
/*

GangCmds.pwn - Contains commands that has handle to both gangs as well as database

*/
CMD:creategang(playerid,params[])
{
    
    if(GInfo[playerid][gangmember] == 1) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY" You are already in a Gang /lg to leave it");
    new 
        query[115],
        DBResult: result,
        string[128];
    if(GetPlayerScore(playerid) < MAX_SCORE )
    {
        
        format(string,sizeof string,""RED"ERROR:"GREY"You need atleast "GREEN"%d "GREY" score to create a gang!",MAX_SCORE);
        return SendClientMessage(playerid,-1,string);
    }
    
    if(isnull(params)) return SendClientMessage(playerid,-1,""RED"Error:"GREY" /creategang [GangName]");
    if(!strcmp(params,"INVALID",true)) return SendClientMessage(playerid,-1,""RED"Error:"GREY" Please choose another name for your gang");
    format(query,sizeof(query),"SELECT GangName FROM Gangs WHERE GangName = '%q'",params);
    result = db_query( Database, query );
    if( db_num_rows( result ) )
    {
        db_free_result(result);
        return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"That name exits");
    }
    db_free_result(result);
    GInfo[playerid][gangmember] = 1;
    format(GInfo[playerid][gangname], 32, params);
    GInfo[playerid][gangleader] = 1;
    ShowPlayerDialog(playerid,GANG_COLOR,DIALOG_STYLE_LIST,"Gang Color",""BLUE"Blue\n"RED"RED\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow","OK","CANCEL");
    new Query[217];
    format( Query, sizeof(Query), "INSERT INTO Gangs (GangName,GangColor) VALUES ('%q','%q')", GInfo[playerid][gangname],GInfo[playerid][gangcolor]);
    db_query(Database,Query);
    result = db_query(Database, "SELECT last_insert_rowid()");
    GInfo[playerid][gangid] = db_get_field_int(result);
    db_free_result(result);
    format( Query,sizeof(Query), "INSERT INTO Members (GangID,UserName,GangLeader) VALUES (%d,'%q',1)",GInfo[playerid][gangid],GInfo[playerid][username]);
    db_query(Database,Query);
    
    SendClientMessage(playerid,-1,""RED"[GANG INFO]:"GREY"You have sucessfully create a gang");
    format(string,sizeof(string),""ORANGE"%s"GREY" has created a new gang named %s%s",GInfo[playerid][username],IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname]);
    SendClientMessageToAll(-1,string);
    return 1;
}

CMD:lg(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not in a gang ");
    new  
        gname [32],
        Query[155],
        str[128];
    strcpy(gname,GInfo[playerid][gangname]);
    
    if(GInfo[playerid][gangleader] == 1)
    {
        GInfo[playerid][gangleader] = 0;
        new count_leader,DBResult:count_result;
        format(Query,sizeof(Query),"SELECT COUNT(*) FROM Members WHERE GANGID = %d AND GANGLEADER = 1",GInfo[playerid][gangid]);
        
        count_result = db_query(Database, Query);
        count_leader = db_get_field_assoc_int(count_result,"COUNT(*)");
        #if DEBUG == true
            printf("leader count = %d ",count_leader);
        #endif
        db_free_result(count_result);
        if(count_leader<=1)
        {
		    format(Query,sizeof(Query),"DELETE FROM Gangs WHERE GangName = '%q'",gname);
		    db_query(Database,Query);

	        foreach(new i : SS_Player)
	        {
	            if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname],false))
	            {
	                GInfo[i][gangmember] = 0;
	                GInfo[i][gangname][0] = EOS;
	                /*if(GInfo[i][gangleader] == 1)
	                    GInfo[playerid][gangleader] = 0;*/
	            }
	        }
	    
	             
	        format(Query,sizeof(Query),"DELETE FROM Members WHERE GangID = %d ",GInfo[playerid][gangid]);
	        db_query(Database,Query);
	        
	        format(str,sizeof(str),""RED"Leader "YELLOW"%s"RED" Has Left Gang %s%s"RED" and Gang is Destroyed",GInfo[playerid][username],IntToHex(GInfo[playerid][gangcolor]),gname);
	        SetPlayerName(playerid,GInfo[playerid][username]);
	        return SendClientMessageToAll(-1,str);
	    }
    }

    GInfo[playerid][gangmember] = 0;
    GInfo[playerid][gangname][0] = EOS;

    format(Query,sizeof(Query),"DELETE FROM Members WHERE UserName = '%q'",GInfo[playerid][username]);
    db_query(Database,Query);
    
    format(str,sizeof(str),""RED"%s "GREY"has left Gang %s%s",GInfo[playerid][username],IntToHex(GInfo[playerid][gangcolor]),gname);
    SetPlayerName(playerid,GInfo[playerid][username]);
    SendClientMessageToAll(-1,str);
    return 1;
}



CMD:setleader(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"You are not authorised to do that!");
   
    new 
        giveid,
        str[128],
        Query[256];
    
    if(sscanf(params,"u",giveid)) return SendClientMessage(playerid,-1,""RED"Error:"GREY"/setleader playerid");
    if(giveid == INVALID_PLAYER_ID) return SendClientMessage(playerid,-1,""RED"Invalid player!");
    if(strcmp(GInfo[playerid][gangname],GInfo[giveid][gangname])) return SendClientMessage(playerid,-1,""RED"He is not in your gang!");
    if(GInfo[giveid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"That guy is not in a gang!");
    if(GInfo[giveid][gangleader] == 1) return SendClientMessage(playerid,-1,""RED"That guy is already leader in you gang!");
       
    GInfo[giveid][gangleader] = 1;
    format(str,sizeof(str),""YELLOW"%s"GREY" is promoted to Gang Leader of %s%s",GInfo[giveid][username],IntToHex(GInfo[playerid][gangcolor]),GInfo[giveid][gangname]);
    SendClientMessageToAll(-1,str);
    format(Query,sizeof(Query),"UPDATE Members SET GangLeader = 1 WHERE UserName = '%q' ",GInfo[giveid][username]);
    db_query( Database, Query );
    return 1;
}

CMD:demote(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"You are not authorised to do that!");
   
    new 
        giveid,
        str[128],
        Query[256];

    if(sscanf(params,"u",giveid))return SendClientMessage(playerid,-1,""RED"Error:"GREY"/demote playerid");
    if(giveid == INVALID_PLAYER_ID) return SendClientMessage(playerid,-1,""RED"Invalid player!");
    if(strcmp(GInfo[playerid][gangname],GInfo[giveid][gangname])) return SendClientMessage(playerid,-1,""RED"He is not in your gang!");
    if(GInfo[giveid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"That guy is not in a gang!");
    if(GInfo[giveid][gangleader] != 1) return SendClientMessage(playerid,-1,""RED"That guy is not the head of your gang!");

    GInfo[giveid][gangleader] = 0;
    format(str,sizeof(str),""YELLOW"%s"GREY" is demoted from Gang Leader postion of %s%s",GInfo[giveid][username],IntToHex(GInfo[playerid][gangcolor]),GInfo[giveid][gangname]);
    SendClientMessageToAll(-1,str);

    format(Query,sizeof(Query),"UPDATE Members SET GangLeader = 0 WHERE UserName = '%q' ",GInfo[giveid][username]);
    db_query( Database, Query );

    return 1;

}


CMD:top(playerid)
{
    new 
        query[256],
        DBResult:result,
        scores,
        name[30],
        string[512],
        color;

    format(query,sizeof(query),"SELECT GangName,GangScore,GangColor FROM Gangs ORDER BY GangScore DESC limit 0,10");
    result = db_query( Database, query );
     
    
    for (new a,b = db_num_rows(result); a != b; a++, db_next_row(result))
    {
        db_get_field_assoc(result, "GangName", name, sizeof(name));
        scores = db_get_field_assoc_int(result, "GangScore");
        color = db_get_field_assoc_int(result, "GangColor");
        format(string,sizeof(string),"%s\n"WHITE"%d.)%s %s "CYAN" scores:"ORANGE" %i", string, a + 1, IntToHex(color),name, scores);
    }

    ShowPlayerDialog(playerid, GTOP, DIALOG_STYLE_MSGBOX, ""RED"Top GANGS ", string, "Close", "");
    db_free_result(result);
    return 1;
}


CMD:gmembers(playerid)
{
    
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    
    new 
        Query[256],
        name[30],
        string[250],
        DBResult:result;

    format(Query,sizeof(Query),"SELECT UserName FROM Members WHERE GangID = %d",GInfo[playerid][gangid]);
    result = db_query(Database,Query);

    for (new a,b= db_num_rows(result); a !=b; a++, db_next_row(result))
    {
        db_get_field_assoc(result, "UserName", name, sizeof(name));
        format(string,sizeof(string),"%s\n"WHITE"%d.)"RED" %s ",string,a + 1,name);
    }

    ShowPlayerDialog(playerid, GMEMBERS, DIALOG_STYLE_MSGBOX, ""RED"GANG MEMBERS ", string, "Close", "");
    db_free_result(result);
    return 1;
}



CMD:accept(playerid)
{

    if(GInfo[playerid][ganginvite] == false) 
        return SendClientMessage(playerid,-1,""RED"You didnt recieve any invitations");
    new 
        Query[216],
        DBResult:result;
    
    SendClientMessage(playerid,-1,""GREEN"You accepted invitation and you are now a gang member");
    GInfo[playerid][gangmember] = 1;
    GInfo[playerid][gangname][0] = EOS;
    GInfo[playerid][gangid] = GInfo[playerid][invitedid];
    GInfo[playerid][ganginvite] = false;
    
    
    format( Query,sizeof(Query), "INSERT INTO Members (GangID,UserName) VALUES (%d,'%q')",GInfo[playerid][gangid],GInfo[playerid][username]);
    db_query( Database, Query);
    
    format(Query,sizeof(Query),"SELECT GangColor,GangName FROM Gangs Where GangID = %d ",GInfo[playerid][gangid]);
    result = db_query(Database,Query);

    if(db_num_rows(result))
    {
        GInfo[playerid][gangcolor] = db_get_field_assoc_int(result,"GangColor");
        SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
        db_get_field_assoc(result, "GangName", GInfo[playerid][gangname], 32);
        db_free_result(result);
    }
 
    return 1;
}

CMD:gkick(playerid,params[])
{
    
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not authorised to do it");
    new 
        Query[300],
        giveid,
        str[128];
    if(sscanf(params,"u",giveid)) 
        return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"/gkick playerid");
    if(giveid == INVALID_PLAYER_ID) 
        return SendClientMessage(playerid,-1,""RED"Invalid player!");
    if(GInfo[giveid][gangid] != GInfo[playerid][gangid])
        return SendClientMessage(playerid, -1 , ""RED"He is not in your gang ");
    if(GInfo[giveid][gangleader] == 1) 
        return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You cant kick a group leader");

    GInfo[giveid][gangmember] = 0;
    format(Query,sizeof(Query),"DELETE FROM Members WHERE UserName = '%q' ",GInfo[giveid][username]);
    db_query( Database, Query );
    format(str,sizeof(str),""YELLOW"%s"GREY" has Kicked from Gang %s%s "GREY"by GangLeader "BLUE"%s",GInfo[giveid][username],IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],GInfo[playerid][username]);
    SendClientMessageToAll(-1,str);
    return 1;
}

CMD:gangtag(playerid,params[])
{
    new 
        newname[24],
        Query[245];

    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"You are not authorised to do it");
    if(isnull(params)) return SendClientMessage(playerid,-1,""RED"Error:"GREY"/gangtag [new tag]");
    if(strlen(params)>2) return SendClientMessage(playerid,-1,""RED"Error:"GREY"tag should between 1-2 size");
    
    format(Query,sizeof(Query),"UPDATE Gangs SET GangTag = '%q' WHERE GangID = %d",params,GInfo[playerid][gangid]);
    db_query(Database,Query);

    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname],false))
        {
            format(newname, sizeof(newname), "%s[%s]", GInfo[i][username], params);
            SetPlayerName(i,newname);
            SendClientMessage(i,-1,""RED"Leader "WHITE"Has Set New Tag For Gang");
        }
    }
    return 1;
}





CMD:gwar(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not Authorised to do that!!");
    new tempwarid;
    if((tempwarid = Iter_Free(WarArenas)) == -1) return SendClientMessage(playerid,-1,""RED"Error:"GREY"There is a War arenas are full please wait for sometime.");
    
    new 
        c1,
        tempid,
        p;
    
    if(isnull(params)) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY" /gwar gangname");
    if(!strcmp(params,"INVALID")) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not allowed to use that name!!");
    if(!strcmp(params,GInfo[playerid][gangname],true)) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You can't challenge your own gang!");
    foreach( p: SS_Player)
    {
        if(!strcmp(GInfo[p][gangname],params,true))
        {
            c1++;
            tempid = p;
        }
    }
    
    if(c1 == 0) return SendClientMessage(playerid,-1,""RED"No members of that gang is online");
    new RandomSpawn,RandomArena;
    RandomArena = random(sizeof(RandomSpawnsGW));
    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname]) || !strcmp(params,GInfo[i][gangname]))
        {
            GInfo[i][inwar] = true;
            GInfo[i][warid] = tempwarid;
            RandomSpawn = random(sizeof(RandomSpawnsGW[]));
            SetPlayerPos(i,RandomSpawnsGW[RandomArena][RandomSpawn][0], RandomSpawnsGW[RandomArena][RandomSpawn][1], RandomSpawnsGW[RandomArena][RandomSpawn][2]);
            ResetPlayerWeapons(i);
            SetPlayerVirtualWorld(i, tempwarid+25);
            TogglePlayerControllable( i, false );
        }
    }

    ActiveWar[tempwarid] = true;
    Iter_Add(WarArenas, tempwarid);
    SetTimerEx("GangWar",10000,false,"iii",playerid,tempid,tempwarid);

    new str[128];

    format(
            str,sizeof(str),
            "%s%s"WHITE" has started a war against %s%s "WHITE"and will start in "YELLOW"10 seconds",
            IntToHex(GInfo[playerid][gangcolor]),
            GInfo[playerid][gangname],
            IntToHex(GInfo[tempid][gangcolor]),
            params
          );
    SendClientMessageToAll(-1,str);
    return 1;
}

//NOTE:Need to work on
CMD:gcp(playerid)
{

    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    
    new 
        str[300],
        Query[80],
        DBResult:Result,
        GScore;
    
    format(Query,sizeof(Query),"SELECT GangScore FROM Gangs WHERE GangName = '%q'",GInfo[playerid][gangname]);
    Result = db_query(Database, Query);
    
    if( db_num_rows( Result ) )
        GScore = db_get_field_assoc_int(Result,"GangScore");
       
    db_free_result( Result );
    
    format(
            str,sizeof(str),
            ""RED"GangName\t:\t%s%s\n"PINK"GangScore\t:\t"GREEN"%d"WHITE"\nGangMembers\nTop Gangs\nGang War\n\
            Kick Member \nChange Tag \nChange Color\nSet Leader",
            IntToHex(GInfo[playerid][gangcolor]),
            GInfo[playerid][gangname],
            GScore
         );
    ShowPlayerDialog(playerid,GCP,DIALOG_STYLE_LIST,""RED"Gang Control Panel",str,"Ok","Cancel");
    return 1;
}
