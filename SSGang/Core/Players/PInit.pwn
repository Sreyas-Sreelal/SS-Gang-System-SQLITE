#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	#if DEBUG == true
		printf("OnPlayerconnect of player init called ");
	#endif
	Iter_Add(SS_Player,playerid);
	return 1;
}

