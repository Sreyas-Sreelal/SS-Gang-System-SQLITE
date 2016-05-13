/*
|-------------------------------------------------------------|
|       ==ADVANCED GANG SYSTEM SQLLITE==                      |
|	    ==AUTHOR:SREYAS==                                 |
|       ==Version:1.0(Beta)==                                 |
|                                                             |
|   =======Commands=========                                  |
|	/gcp - to enter gang control panel                    |
|	/creategang - to create new gang                      |
|	/gangtag - to add tag to your gang                    |
|	/gwar - to challenge other gang members for a gang war|
|	/gkick - to kick a member from gang                   |
|	/setleader - to set a member to leader                |
|	/gmembers - to see whole members of gang              |
|	/top - to see top 10 gangs                            |
|	/ginvite - to invite some to your gang                |
|	/accept - to accept an invitation                     |
|	/decline - to decline an invitation                   |
|	/gangcolor - to change your gang color                |
|	/lg - to leave the gang                               |
|                                                             |
|	 ======Other Features=====                            |
|	 Use '#' to gang chat                                 |
|	 Each kill give 1 score for gang                      |
|	 Gang Member's death will be notified                 |
|	 Gang will be destroyed if a leader leaves it         |
|	 Gang Members will get 100$ per each 10 minutes       |
|	                                                      |
|                                                             |
|-------------------------------------------------------------|
*/
#define FILTERSCRIPT

#include<a_samp> //SA-MP TEAM
#include<zcmd> //ZEEX
#include<sscanf2> //Y_LESS
#include<foreach> //Y_LESS

#define GANG_COLOR 78
#define GTOP 79
#define GMEMBERS 80
#define GCP 81
#define GKICK 82
#define GWAR 83
#define GLEADER 84
#define GTAG 85
#define MAX_GANGS 50

new Float:RandomSpawnsGW[][] =
{
	{1390.2234,-46.3298,1000.9236,5.7688},
	{1417.2269,-45.6457,1000.9274,53.0826},
	{1393.3025,-33.7530,1007.8823,89.6141},
	{1365.5669,2.3778,1000.9285,11.9068}
	
};
new bool:ActiveWar = false;
//-----GANG COLORS--------------------------
#define G_PURPLE                0xD526D9FF
#define G_GREEN        		0x00FF00FF
#define G_PINK			0xFFB6C1FF
#define G_CYAN		        0x33CCFFAA
#define G_GREY	                0xAFAFAFAA
#define G_WHITE                 0xFFFFFFFF
#define G_ORANGE                0xFF8000FF
#define G_YELLOW                0xFFFF00FF
#define G_BLUE                  0x0080FFC8
#define G_RED                   0xFF0000FF
//------------------------------------------


//------Colors-----------------------------
#define RED           "{FF0000}"
#define GREY          "{C0C4C4}"
#define ORANGE        "{F07F1D}"
#define CYAN          "{00FFFF}"
#define GREEN         "{00FF00}"
#define WHITE         "{FFFFFF}"
#define VIOLET        "{8000FF}"
#define YELLOW        "{FFFF00}"
#define BLUE          "{0000FF}"
#define PINK          "{F7B0D0}"
//---------------------------------------

enum G_USER_DATA
{
	gangmember,
	gangleader,
	gangname[56],
	gang_id,
	bool:ganginvite,
	username[MAX_PLAYER_NAME],
	ginvitedname[56],
	gangcolor,
	gangtag[4]
}
new bool:inwar[MAX_PLAYERS];


new GInfo[MAX_PLAYERS][G_USER_DATA];
new DB:Database;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("---Gang---system---by---Sreyas---Loaded---");
	print("--------------------------------------\n");
	
	Database = db_open("gang.db");
	
	db_query( Database, "PRAGMA synchronous = OFF" );
	
	return 1;
}
public OnFilterScriptExit()
{
	db_close( Database );
	return 1;
}


public OnPlayerConnect(playerid)
{
	for( new i; i < _: G_USER_DATA; ++i ) GInfo[ playerid ][ G_USER_DATA: i ] = 0;
	
	GetPlayerName( playerid, GInfo[playerid][username], MAX_PLAYER_NAME );
	new  Query[ 89 ],DBResult: Result;
	format( Query, sizeof( Query ), "SELECT * FROM Members WHERE UserName = '%s' LIMIT 0, 1", DB_Escape( GInfo[ playerid ][ username ] ) );
	Result = db_query( Database, Query );
	if( db_num_rows( Result ) )
	{
		
		db_get_field_assoc( Result, "GangMember", Query, 7 );
		GInfo[ playerid ][ gangmember ] = strval( Query );
		db_get_field_assoc( Result, "GangLeader", Query, 7 );
		GInfo[ playerid ][ gangleader] = strval( Query );
		db_get_field_assoc(Result, "GangName", GInfo[playerid][gangname], 56);
		
		if(GInfo[playerid][gangmember] == 1)
		{
			new str[128];
			SetTimerEx("GMoney",100000,true,"u",playerid);
			
			if(GInfo[playerid][gangleader] == 1)
			{
				
				format(str,sizeof(str),""RED"[GANG INFO]"ORANGE"Leader"GREEN" %s"ORANGE" has Logged in!!",GInfo[playerid][username]);
				SendGangMessage(playerid,str);
			}
			else if(GInfo[playerid][gangleader] == 0)
			{
				format(str,sizeof(str),""RED"[GANG INFO]"CYAN"Member"YELLOW" %s"ORANGE" has Logged in!!",GInfo[playerid][username]);
				SendGangMessage(playerid,str);
			}
			
			new query[880],DBResult:result;
			format(query,sizeof(query),"SELECT * FROM Gangs Where GangName = '%s' ",DB_Escape(GInfo[playerid][gangname]));
			result = db_query(Database,query);
			
			if(db_num_rows(result))
			{
				db_get_field_assoc(result,"GangColor",query,10);
				GInfo[playerid][gangcolor] = strval(query);
				SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
				db_get_field_assoc(result, "GangTag", GInfo[playerid][gangtag], 4);
				db_free_result( result );
			}
			
			db_free_result( Result );
			return 1;
		}
		return 1;
	}
	else
	{
		new GQuery[700];
		format( GQuery, sizeof( GQuery ), "INSERT INTO Members (UserName) VALUES ('%s')", DB_Escape( GInfo[ playerid ][ username ] ));
		db_query( Database, GQuery );
		return 1;
	}
}
public OnPlayerDisconnect(playerid,reason)
{
	
	SetPlayerName(playerid,GInfo[playerid][username]);//just to avoid some bugs
	
	if(GInfo[playerid][gangmember] == 1)
	{
		new str[128];
		format(str,sizeof(str),"Member %s has Logged Out ",GInfo[playerid][username]);
		SendGangMessage(playerid,str);
	}
	for( new i; i < _: G_USER_DATA; ++i ) GInfo[ playerid ][ G_USER_DATA: i ] = 0;
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(text[0] == '#' && GInfo[playerid][gangmember] == 1)
	{
		new str[128],name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		format(str,sizeof(str),""RED"[GANG CHAT]"ORANGE" %s: "WHITE"%s",name,text[1]);
		SendGangMessage(playerid,str);
		return 0;
	}
	else
	{
		new pText[144];
		format(pText, sizeof (pText), "(%d) %s", playerid, text);
		SetPlayerChatBubble(playerid, text, 0xFFFFFFFF, 100.0, 10000);
		SendPlayerMessageToAll(playerid, pText);
		return 0;
	}
	
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case GANG_COLOR:
		{
			if(response)
			{
			switch(listitem)
			{
				case 0:
				{
					GInfo[playerid][gangcolor] = G_BLUE;
					SetPlayerColor(playerid,G_BLUE);
					
				}
				case 1:
				{
					GInfo[playerid][gangcolor] = G_RED;
					SetPlayerColor(playerid,G_RED);
				}
				case 2:
				{
					GInfo[playerid][gangcolor] = G_WHITE;
					SetPlayerColor(playerid,G_WHITE);
				}
				case 3:
				{
					GInfo[playerid][gangcolor] = G_PINK;
					SetPlayerColor(playerid,G_PINK);
				}
				case 4:
				{
					GInfo[playerid][gangcolor] = G_CYAN;
					SetPlayerColor(playerid,G_CYAN);
				}
				case 5:
				{
					GInfo[playerid][gangcolor] = G_ORANGE;
					SetPlayerColor(playerid,G_ORANGE);
				}
				case 6:
				{
					GInfo[playerid][gangcolor] = G_GREEN;
					SetPlayerColor(playerid,G_GREEN);
				}
				case 7:
				{
					GInfo[playerid][gangcolor] = G_YELLOW;
					SetPlayerColor(playerid,G_YELLOW);
				}
				
			}
			new Query[789];
			format(Query,sizeof(Query),"UPDATE Gangs SET GangColor = %d Where GangName = '%s'",GInfo[playerid][gangcolor],DB_Escape(GInfo[playerid][gangname]));
			db_query(Database,Query);
			SendGangMessage(playerid,""RED"Leader"YELLOW"Has changed gang color");
			return 1;
		}
		}
		case GCP:
		{
 			if(response)
			{
			switch(listitem)
			{
				case 0:return cmd_gcp(playerid);
				case 1:return cmd_gcp(playerid);
				case 2:return cmd_gmembers(playerid);
				case 3:return cmd_top(playerid);
				case 4:return ShowPlayerDialog(playerid, GWAR, DIALOG_STYLE_INPUT, ""ORANGE"Input Enemy Gang Name", ""GREY"Please enter the  name of enemy gang", "Start", "Cancel");
				case 5:return ShowPlayerDialog(playerid, GKICK, DIALOG_STYLE_INPUT, ""ORANGE"Input Member Name", ""GREY"Please enter the  name or id Member to Kicked", "Kick", "Cancel");
				case 6:return ShowPlayerDialog(playerid, GTAG, DIALOG_STYLE_INPUT, ""ORANGE"Input Gang Tag", ""GREY"Please enter the new tag for your Gang", "Set", "Cancel");
				case 7:return cmd_gangcolor(playerid);
				case 8:return ShowPlayerDialog(playerid, GLEADER, DIALOG_STYLE_INPUT, ""ORANGE"Input Member Name or ID", ""GREY"Please enter the  name or id Member to Set as leader ", "Kick", "Cancel");
			}
			}
			return 1;
		}

		case GWAR :
			{
			if(response)
			{

			return cmd_gwar(playerid,inputtext);
			}
			}
		case GKICK:
        {
			if(response)
			{
		return cmd_gkick(playerid,inputtext);
		}
		}
		case GLEADER:
        {
			if(response)
			{
		return cmd_setleader(playerid,inputtext);
			}
			}
		case GTAG:
        {
			if(response)
			{
		return cmd_gangtag(playerid,inputtext);
		}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	SendDeathMessage(killerid, playerid, reason);
	if(inwar[playerid] == true)
	{
		inwar[playerid] = false;
		SpawnPlayer(playerid);
		CheckVict(GInfo[playerid][gangname],GInfo[killerid][gangname]);
	}
	
	if(GInfo[playerid][gangmember] == 1)
	{
		new rvg[128];
		if(GInfo[killerid][gangmember] == 1)
		{
			format(rvg,sizeof(rvg),""GREY"The member of your Gang "YELLOW"%s"GREY" has been killed by a Member "RED"(%s)"GREY" of Gang "RED"%s",GInfo[playerid][username],GInfo[killerid][username],GInfo[killerid][gangname]);
			new Query1[80],Query2[80],DBResult: Result,Score = 0;
			format(Query1,sizeof(Query1),"SELECT GangScore FROM Gangs WHERE GangName = '%s'",GInfo[killerid][gangname]);
			Result = db_query(Database,Query1);
			if(db_num_rows(Result))
			{
				db_get_field_assoc(Result,"GangScore",Query1,10);
				Score = strval(Query1);
			}
			
			Score++;
			format(Query2,sizeof(Query2),"UPDATE Gangs SET GangScore = %i WHERE GangName = '%s'",Score,GInfo[killerid][gangname]);
			db_query(Database,Query2);
		}
		else
		{
			format(rvg,sizeof(rvg),""GREY"The member of your Gang "RED"%s "GREY"has been killed by a Player Named "RED"%s ",GInfo[playerid][username],GInfo[killerid][username]);
		}
		SendGangMessage(playerid,rvg);
	}
	
	return 1;
}

//---COMMANDS---------------------------------------------------------------------------------------------------------------------------

CMD:creategang(playerid,params[])
{
	new gname[56],query[256],DBResult:result,string[128];
	GetPlayerName( playerid, GInfo[playerid][username], MAX_PLAYER_NAME );
	if(sscanf(params,"s[56]",gname))return SendClientMessage(playerid,-1,""RED"Error:"GREY"/creategang [GangName]");
	if(GInfo[playerid][gangmember] == 1)return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are already in a Gang /lg to leave it");
	format(query,sizeof(query),"SELECT GangName FROM Gangs WHERE GangName = '%s'",DB_Escape(gname));
	result = db_query( Database, query );
	if( db_num_rows( result ) )
	{
		db_free_result(result);
		return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"That name exits");
	}
	db_free_result(result);
	
	GInfo[playerid][gangmember] = 1;
	
	GInfo[playerid][gangname] = gname;
	GInfo[playerid][gangleader] = 1;
	ShowPlayerDialog(playerid,GANG_COLOR,DIALOG_STYLE_LIST,"Gang Color",""BLUE"Blue\n"RED"RED\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow","OK","CANCEL");
	
	new Query[128];
	format(Query,sizeof(query),"UPDATE Members SET GangName = '%s' ,GangMember = 1,GangLeader = 1 WHERE UserName = '%s' ",DB_Escape(gname),DB_Escape(GInfo[playerid][username]));
	db_query( Database, Query );
	
	new gquery[256];
	format( gquery, sizeof( gquery ), "INSERT INTO Gangs (GangName,GangColor) VALUES ('%s','%s')", DB_Escape( GInfo[ playerid ][ gangname ] ),DB_Escape(GInfo[playerid][gangcolor]));
	db_query(Database,gquery);
	SendClientMessage(playerid,-1,""RED"[GANG INFO]:"GREY"You have sucessfully create a gang");
	format(string,sizeof(string),""ORANGE"%s"GREY" has created a new gang named "YELLOW"%s",GInfo[playerid][username],GInfo[playerid][gangname]);
	SendClientMessageToAll(-1,string);
	return 1;
}

CMD:lg(playerid,params[])
{
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not in a gang ");
	new  gname [56],lquery[234] ;
	strcat(gname,GInfo[playerid][gangname],56) ;
	if(GInfo[playerid][gangleader] == 1)
	{
		foreach(new i : Player)
		{
			if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname],false))
			{
				GInfo[i][gangmember] = 0;
				GInfo[i][gangname] = '\0';
				if(GInfo[i][gangleader] == 1)
				{
					GInfo[playerid][gangleader] = 0;
				}
			}
		}
		new  Query[102];
		format(Query,sizeof(Query),"DELETE FROM Gangs WHERE GangName = '%s'",DB_Escape(gname));
		db_query(Database,Query);
		format(lquery,sizeof(lquery),"UPDATE Members SET GangMember = 0,GangLeader = 0,GangName = NULL WHERE GangName = '%s'",DB_Escape(gname));
		db_query(Database,lquery);
		new str[128];
		format(str,sizeof(str),""RED"Leader "YELLOW"%s"RED" Has Left Gang "CYAN"%s"RED" and Gang is Destroyed",GInfo[playerid][username],gname);
		return SendClientMessageToAll(-1,str);
	}
	GInfo[playerid][gangmember] = 0;
	GInfo[playerid][gangname] = ' ';
	new query[102];
	format(query,sizeof(query),"UPDATE Members SET GangMember = 0,GangLeader = 0,GangName = NULL WHERE UserName = '%s'",DB_Escape(GInfo[playerid][username]));
	db_query(Database,query);
	new ls[128];
	format(ls,sizeof(ls),""RED"%s "GREY"has left Gang "YELLOW"%s",GInfo[playerid][username],gname);
	SendClientMessageToAll(-1,ls);
	return 1;
}



CMD:setleader(playerid,params[])
{
	new giveid,str[128],Query[256];
	if(sscanf(params,"u",giveid))return SendClientMessage(playerid,-1,""RED"Error:"GREY"/setleader playerid");
	if(GInfo[playerid][gangname]!=GInfo[giveid][gangname]) return SendClientMessage(playerid,-1,""RED"He is not in your gang ");
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang ");
	if(GInfo[giveid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"That guy is not in a gang");
	if(GInfo[giveid][gangleader] == 1) return SendClientMessage(playerid,-1,""RED"That guy is already leader in you gang");
	if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"You are not authorised to do that");
	GInfo[giveid][gangleader] = 1;
	format(str,sizeof(str),"%s is promoted to Gang Leader of %s",GInfo[giveid][username],GInfo[giveid][gangname]);
	SendClientMessageToAll(-1,str);
	format(Query,sizeof(Query),"UPDATE Members SET GangLeader = 1 WHERE UserName = '%s' ",DB_Escape(GInfo[giveid][username]));
	db_query( Database, Query );
	return 1;
}

CMD:ginvite(playerid,params[])
{
	new giveid;
	if(sscanf(params,"u",giveid)) return SendClientMessage(playerid,-1,""RED"Error:"GREY"/ginvite playerid");
	if(GInfo[playerid][gangleader] == 0 ) return SendClientMessage(playerid,-1,""RED"You are not authorised to do that");
	if(GInfo[giveid][gangmember] == 1) return SendClientMessage(playerid,-1,""RED"He is already in a gang");
	GInfo[giveid][ganginvite] = true;
	SendClientMessage(playerid,-1,""GREEN"Invitation send successfully");
	SendClientMessage(giveid,-1,""GREEN"You have recieved a gang invitation /accept or /decline to accept or decline ");
	strdel(GInfo[giveid][ginvitedname],0,56);
	strcat(GInfo[giveid][ginvitedname], GInfo[playerid][gangname], 56);
	return 1;
}

CMD:top(playerid)
{
	new query[256];
	new	DBResult:result;
	format(query,sizeof(query),"SELECT GangName,GangScore FROM Gangs ORDER BY GangScore DESC limit 0,10");
	result = db_query( Database, query );
	new	scores,name[30],string[250];
	for (new a; a < db_num_rows(result); a++, db_next_row(result))
	{
		db_get_field_assoc(result, "GangName", name, sizeof(name));
		scores = db_get_field_assoc_int(result, "GangScore");
		format(string,sizeof(string),"%s\n"WHITE"%d.)"RED" %s "CYAN" scores:"ORANGE" %i", string, a + 1, name, scores);
	}
	ShowPlayerDialog(playerid, GTOP, DIALOG_STYLE_MSGBOX, ""RED"Top GANGS ", string, "Close", "");
	db_free_result(result);
	return 1;
}


CMD:gmembers(playerid)
{
	new Query[256],name[30],string[250];
	new DBResult:result;
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not a Gang Member");
	format(Query,sizeof(Query),"SELECT UserName FROM Members WHERE GangName = '%s'",GInfo[playerid][gangname]);
	result = db_query(Database,Query);
	for (new a; a < db_num_rows(result); a++, db_next_row(result))
	{
		db_get_field_assoc(result, "UserName", name, sizeof(name));
		format(string,sizeof(string),"%s\n"WHITE"%d.)"RED" %s ",string,a + 1,name);
	}
	ShowPlayerDialog(playerid, GMEMBERS, DIALOG_STYLE_MSGBOX, ""RED"GANG MEMBERS ", string, "Close", "");
	db_free_result(result);
	return 1;
}


CMD:decline(playerid)
{
	if(GInfo[playerid][ganginvite] == false) return SendClientMessage(playerid,-1,""RED"You didnt recieve any invitations");
	SendClientMessage(playerid,-1,"You declined the invitation");
	GInfo[playerid][ganginvite] = false;
	return 1;
}

CMD:accept(playerid)
{
	new Query[900];
	if(GInfo[playerid][ganginvite] == false) return SendClientMessage(playerid,-1,""RED"You didnt recieve any invitations");
	SendClientMessage(playerid,-1,""GREEN"You accepted invitation and you are now a gang member");
	GInfo[playerid][gangmember] = 1;
	strdel(GInfo[playerid][gangname],0,56);
	strcat(GInfo[playerid][gangname],GInfo[playerid][ginvitedname],55);
	GInfo[playerid][ganginvite] = false;
	format(Query,sizeof(Query),"UPDATE Members SET GangMember = 1,GangLeader = 0,GangName = '%s' WHERE UserName = '%s' ",DB_Escape(GInfo[playerid][gangname]),DB_Escape(GInfo[playerid][username]));
	db_query( Database, Query );
	new query[880],DBResult:result;
	format(query,sizeof(query),"SELECT * FROM Gangs Where GangName = '%s' ",DB_Escape(GInfo[playerid][gangname]));
	result = db_query(Database,query);
	if(db_num_rows(result))
	{
		db_get_field_assoc(result,"GangColor",query,10);
		GInfo[playerid][gangcolor] = strval(query);
		SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
		db_free_result( result );
	}
	return 1;
}

CMD:gkick(playerid,params[])
{
	new Query[300],giveid,str[128];
	if(sscanf(params,"u",giveid)) return SendClientMessage(playerid,-1,"ERROR:/gkick playerid");
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,"You are not a Gang Member");
	if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,"You are not authorised to do it");
	if(GInfo[giveid][gangleader] == 1) return SendClientMessage(playerid,-1,"You cant kick a group leader");
	GInfo[giveid][gangmember] = 0;
	format(Query,sizeof(Query),"UPDATE Members SET GangMember = 0,GangName = NULL WHERE UserName = '%s' ",DB_Escape(GInfo[giveid][username]));
	db_query( Database, Query );
	format(str,sizeof(str),""YELLOW"%s"GREY" has Kicked from Gang "RED"%s "GREY"by GangLeader "BLUE"%s",GInfo[giveid][username],GInfo[playerid][username],GInfo[playerid][username]);
	SendClientMessageToAll(-1,str);
	return 1;
}

CMD:gangtag(playerid,params[])
{
	new tag[4],newname[25],Query[245];
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not a Gang Member");
	if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"You are not authorised to do it");
	if(sscanf(params,"s[4]",tag)) return SendClientMessage(playerid,-1,""RED"Error:"GREY"/gangtag [new tag]");
	GetPlayerName(playerid,newname,25);
	
	strcat(newname,tag,sizeof(newname));
	
	format(Query,sizeof(Query),"UPDATE Gangs SET GangTag = '%s' WHERE GangName = '%s'",DB_Escape(tag),DB_Escape(GInfo[playerid][gangname]));
	db_query(Database,Query);
	
	foreach(new i : Player)
	{
		if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname],false))
		{
			
			SetPlayerName(i,newname);
			SendClientMessage(i,-1,""RED"Leader"WHITE"Has Set New Tag For Gang");
		}
	}
	
	return 1;
}

CMD:gangcolor(playerid)
{
	ShowPlayerDialog(playerid,GANG_COLOR,DIALOG_STYLE_LIST,"Gang Color",""BLUE"Blue\n"RED"RED\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow","OK","CANCEL");
	return 1;
}

CMD:gwar(playerid,params[])
{
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not a Gang Member!!");
	if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not Authorised to do that!!");
	if(ActiveWar == true) return SendClientMessage(playerid,-1,""RED"Error:"GREY"There is a War Going on now wait till it finishes");
	new gname[56],c1;
	if(sscanf(params,"s[56]",gname)) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY":/gwar gangname");
	
	foreach(new i : Player)
	{
		if(!strcmp(GInfo[i][gangname],gname,true))
		{
			printf("entered");
			c1++;
		}
		
	}
	
	if(c1 == 0)return SendClientMessage(playerid,-1,""RED"No members of that gang is online");
	
	foreach(new i : Player)
	{
		if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname]) || !strcmp(gname,GInfo[i][gangname]))
		{
			inwar[i] = true;
			new Random = random(sizeof(RandomSpawnsGW));
			SetPlayerPos(i,RandomSpawnsGW[Random][0], RandomSpawnsGW[Random][1], RandomSpawnsGW[Random][2]);
			SetPlayerInterior(i,1);
			ResetPlayerWeapons(i);
			TogglePlayerControllable( i, false );
		}
	}
	ActiveWar = true;
	
	SetTimerEx("GangWar",10000,false,"u",GInfo[playerid][gangname],gname);
	
	new str[128];
	format(str,sizeof(str),""GREEN"%s"WHITE" has started a war against "RED"%s "WHITE"and will start in "YELLOW"10 seconds",GInfo[playerid][gangname],gname);
	SendClientMessageToAll(-1,str);
	return 1;
}
CMD:gcp(playerid)
{
	if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not a Gang Member!!");
	new str[300],Query[80],DBResult:Result,GScore;
	format(Query,sizeof(Query),"SELECT GangScore FROM Gangs WHERE GangName = '%s'",DB_Escape(GInfo[playerid][gangname]));
	if( db_num_rows( Result ) )
	{
		db_get_field_assoc( Result, "GangScore", Query,10 );
		GScore = strval(Query);
		db_free_result( Result );
	}
	
	format(str,sizeof(str),"GangName : %s \n GangScore : %d \nGangMembers \nTop Gangs \nGang War\nKick Member \nChange Tag \nChange Color\nSet Leader",GInfo[playerid][gangname],GScore);
	ShowPlayerDialog(playerid,GCP,DIALOG_STYLE_LIST,""RED"Gang Control Panel",str,"Ok","Cancel");
	return 1;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//-Custom Functions--------------------------------------------------------------------------------------------------------------------------------------------------------

forward GangWar(gname1[],gname2[]);
public GangWar(gname1[],gname2[])
{
	new count1,count2;
	foreach(new i : Player)
	{
		if(!strcmp(gname1,GInfo[i][gangname]))
		{
			GivePlayerWeapon(i,34,100);
			SetPlayerHealth(i,100);
			SetPlayerArmour(i,100);
			TogglePlayerControllable( i, true );
			GameTextForPlayer(i, "~w~War ~g~ Has~r~ Started", 5000, 5);
			count1++;
		}
		if(!strcmp(gname2,GInfo[i][gangname]))
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
		foreach(new i : Player)
		{
			if(inwar[i] == true)
			{
				inwar[i] = false;
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




DB_Escape( text[ ] )
{
	new
	ret[ 80 * 2 ],
	ch,
	i,
	j
	;
	while( ( ch = text[ i++ ] ) && j < sizeof( ret ) )
	{
		if( ch == '\'' )
		{
			if( j < sizeof( ret ) - 2 )
			{
				ret[ j++ ] = '\'';
				ret[ j++ ] = '\'';
			}
		}
		else if( j < sizeof( ret ) )
		{
			ret[ j++ ] = ch;
		}
		else
		{
			j++;
		}
	}
	ret[ sizeof( ret ) - 1 ] = '\0';
	return ret;
}


SendGangMessage(playerid,Message[])
{
	foreach(new i : Player)
	{
		if(!strcmp(GInfo[playerid][gangname],GInfo[i][gangname],false)&& !isnull(GInfo[i][gangname]))
		{
			SendClientMessage(i,-1,Message);
		}
	}
	return 0;
}


CheckVict(gname1[],gname2[])
{
	new count1,count2;
	foreach(new i : Player)
	{
		if(inwar[i] == true)
		{
			if(!strcmp(gname1,GInfo[i][gangname]))
			{
				count1++;
			}
			if(!strcmp(gname2,GInfo[i][gangname]))
			{
				count2++;
			}
		}
	}
	if(count1 ==0 || count2 ==0)
	{
		foreach(new i : Player)
		{
			if(inwar[i] == true)
			{
				inwar[i] = false;
				SpawnPlayer(i);
			}
		}
		new str[128];
		if(count1 == 0)
		{
			format(str,sizeof(str),""RED"%s "WHITE"has won the war against "RED"%s",gname2,gname1);
			SendClientMessageToAll(-1,str);
			ActiveWar = false;
		}
		else if(count2 == 0)
		{
			format(str,sizeof(str),""RED"%s "WHITE"has won the war against "RED"%s",gname1,gname2);
			SendClientMessageToAll(-1,str);
			ActiveWar = false;
		}
	}
	return 1;
}
