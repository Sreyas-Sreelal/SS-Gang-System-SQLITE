
CMD:removezone(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) 
      return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not authorised to use that Command!!");
  
	if(isnull(params)) return SendClientMessage(playerid,-1,""RED"Error:"GREY" /removezone [ZoneName]");
	new Query[60],bool:found=false,i;

	foreach(i : Zones)
		if(!strcmp(ZInfo[i][Name],params))
		{
			found = true;
			break;
		}

	if(!found) return SendClientMessage(playerid,-1,""RED"Error:"GREY" No such zone!");
	format(Query, sizeof(Query),"DELETE FROM ZONES WHERE NAME='%q';",params);
	db_query(Database,Query);

	GangZoneHideForAll(ZInfo[i][Zone_Wrapper]);
	GangZoneDestroy(ZInfo[i][Zone_Wrapper]);
	
	Iter_Remove(Zones, i);
	
	new string[128];
	format(string,sizeof(string),""ORANGE"%s"GREY" has deleted the zone named %s",GInfo[playerid][username],params);
    SendClientMessageToAll(-1,string);

	return 1;
}