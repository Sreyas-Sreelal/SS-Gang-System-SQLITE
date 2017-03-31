#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	#if DEBUG == true
        printf("OnPlayerconnect of textdraw init called ");
    #endif
    GInfo[playerid][TextDraw] = CreatePlayerTextDraw(playerid,468.500823, 333.937500, " ");

    PlayerTextDrawLetterSize(playerid, GInfo[playerid][TextDraw],0.201999, 0.789999);
    PlayerTextDrawTextSize(playerid, GInfo[playerid][TextDraw],572.496704, -2714.384277);
    PlayerTextDrawAlignment(playerid, GInfo[playerid][TextDraw],1);
    PlayerTextDrawColor(playerid, GInfo[playerid][TextDraw],-100663297);
    PlayerTextDrawUseBox(playerid, GInfo[playerid][TextDraw],2);
    PlayerTextDrawBoxColor(playerid, GInfo[playerid][TextDraw], 255);
    PlayerTextDrawSetShadow(playerid, GInfo[playerid][TextDraw], 0);
    PlayerTextDrawSetOutline(playerid, GInfo[playerid][TextDraw], 0);
    PlayerTextDrawBackgroundColor(playerid, GInfo[playerid][TextDraw], 255);
    PlayerTextDrawFont(playerid, GInfo[playerid][TextDraw], 1);
    PlayerTextDrawSetProportional(playerid, GInfo[playerid][TextDraw], 1);
    PlayerTextDrawSetShadow(playerid, GInfo[playerid][TextDraw], 0);

    GInfo[playerid][TimerTD] = CreatePlayerTextDraw(playerid, 590.000000, 392.125000, "00-00");
    
    PlayerTextDrawLetterSize(playerid, GInfo[playerid][TimerTD], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, GInfo[playerid][TimerTD], 1);
    PlayerTextDrawColor(playerid, GInfo[playerid][TimerTD], -10241);
    PlayerTextDrawSetShadow(playerid, GInfo[playerid][TimerTD], -1);
    PlayerTextDrawSetOutline(playerid, GInfo[playerid][TimerTD], 0);
    PlayerTextDrawBackgroundColor(playerid, GInfo[playerid][TimerTD], 255);
    PlayerTextDrawFont(playerid, GInfo[playerid][TimerTD], 2);
    PlayerTextDrawSetProportional(playerid, GInfo[playerid][TimerTD], 1);
    PlayerTextDrawSetShadow(playerid, GInfo[playerid][TimerTD], -1);
	
	return 1;
}