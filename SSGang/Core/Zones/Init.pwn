#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	#if DEBUG == true
		printf("OnPlayerconnect of zones init called ");
	#endif
	foreach(new i:Zones)
      GangZoneShowForPlayer(
      							playerid,
      							ZInfo[i][ Zone_Wrapper], 
      							(isnull(ZInfo[i][Owner])) ?(ZONE_COLOR): (ZInfo[i][Color])
      						);
      return 1;
}
