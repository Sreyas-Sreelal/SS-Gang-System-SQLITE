
#include <YSI\y_hooks>

hook OnPlayerDeath(playerid, killerid, reason)
{
	
	SendDeathMessage(killerid, playerid, reason);

    if(killerid != INVALID_PLAYER_ID)
    {
        if(GInfo[playerid][inwar])
        {
            GInfo[playerid][inwar] = false;
            SetPlayerInterior(playerid,0);
            CheckVict(GInfo[playerid][gangname],GInfo[killerid][gangname]);
        }

        if(GInfo[playerid][gangmember] == 1)
        {
            new rvg[300];
            if(GInfo[killerid][gangmember] == 1)
            {
                format(rvg,sizeof(rvg),""GREY"The member of your Gang "YELLOW"%s"GREY" has been killed by a Member "RED"(%s)"GREY" of Gang %s%s",GInfo[playerid][username],GInfo[killerid][username],IntToHex(GInfo[killerid][gangcolor]),GInfo[killerid][gangname]);
                new Query[120];
                format(Query,sizeof(Query),"UPDATE Gangs SET GangScore = GangScore+1  WHERE GangID = %d",GInfo[killerid][gangid]);
                db_query(Database,Query);
            }
            else
            {
                format(rvg,sizeof(rvg),""GREY"The member of your Gang "RED"%s "GREY"has been killed by a Player Named "RED"%s ",GInfo[playerid][username],GInfo[killerid][username]);
            }
            SendGangMessage(playerid,rvg);
        }
    }

    else
    {
        if(GInfo[playerid][inwar])
        {
            GInfo[playerid][inwar] = false;
            CheckVict(GInfo[playerid][gangname],"INVALID");
        }

    }
    return 1;
}