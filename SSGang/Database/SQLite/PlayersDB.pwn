#include <YSI\y_hooks>

hook OnFilterScriptInit()
{
	db_query(Database,"CREATE TABLE IF NOT EXISTS Members (\
                                                            GangID  INT(3),\
                                                            UserName  VARCHAR(24) UNIQUE NOT NULL,\
                                                            GangLeader  TINYINT DEFAULT 0\
                                                          )");
	return 1;
}

hook OnPlayerConnect(playerid)
{
	new  
        Query[107],
        DBResult: Result;
    format(Query, sizeof(Query),"SELECT * FROM Members WHERE UserName = '%q' LIMIT 0, 1",GInfo[playerid][username]);
    Result = db_query(Database,Query);

    if(db_num_rows(Result))//if the connected player is in member table (ie he is a gang member)
    {

        GInfo[playerid][gangmember] = true;
        GInfo[playerid][gangleader] = db_get_field_assoc_int( Result, "GangLeader");
        GInfo[playerid][creatingzone] = false;
        GInfo[playerid][gangid] = db_get_field_assoc_int( Result, "GangID");
       
        new str[128];

        SetTimerEx("GMoney",600000,true,"i",playerid);

        if(GInfo[playerid][gangleader] == 1)
        {

            format(str,sizeof(str),""RED"[GANG INFO]"ORANGE"Leader"GREEN" %s "ORANGE"has Logged in!!",GInfo[playerid][username]);
            SendGangMessage(playerid,str);
        }

        else 
        {

            format(str,sizeof(str),""RED"[GANG INFO]"CYAN"Member"YELLOW" %s "ORANGE"has Logged in!!",GInfo[playerid][username]);
            SendGangMessage(playerid,str);
        }


        new DBResult:result;
        format(Query,sizeof(Query),"SELECT * FROM Gangs Where GangID = %d ",GInfo[playerid][gangid]);
        result = db_query(Database,Query);

        if(db_num_rows(result))
        {
            
            GInfo[playerid][gangcolor] = db_get_field_assoc_int(result,"GangColor");
            SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
            db_get_field_assoc(result, "GangTag", GInfo[playerid][gangtag], 4);
            db_get_field_assoc(result, "GangName", GInfo[playerid][gangname], 32);
            db_free_result( result );
        }

        db_free_result( Result );
        SetTimerEx("FullyConnected",3000,false,"i",playerid);
        
    }
	return 1;
}