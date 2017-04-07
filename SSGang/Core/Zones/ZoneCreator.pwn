
/*

ZoneCreator.pwn - Contains script handling dynamic zone creation.


*/
#include <YSI\y_hooks>

hook OnPlayerUpdate(playerid)
{
	if(GInfo[playerid][creatingzone])
    {
        static keys,ud,lr;
        GetPlayerKeys(playerid,keys,ud,lr);

        if(lr == KEY_LEFT)//if Left arrow key pressed
        {
            GInfo[playerid][minX] -= 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] =  GangZoneCreate(
                                                          GInfo[playerid][minX],
                                                          GInfo[playerid][minY],
                                                          GInfo[playerid][maxX],
                                                          GInfo[playerid][maxY]
                                                        );
            
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);
        }
        
        else if(lr == KEY_RIGHT)//if Right arrow key pressed
        {
            GInfo[playerid][maxX] += 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] =  GangZoneCreate(
                                                          GInfo[playerid][minX],
                                                          GInfo[playerid][minY],
                                                          GInfo[playerid][maxX],
                                                          GInfo[playerid][maxY]
                                                        );
            
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone],ZONE_COLOR);
        }

        else if(ud == KEY_UP)//if Upward arrow key pressed
        {
            GInfo[playerid][maxY] += 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] =  GangZoneCreate(
                                                          GInfo[playerid][minX],
                                                          GInfo[playerid][minY],
                                                          GInfo[playerid][maxX],
                                                          GInfo[playerid][maxY]
                                                          );
            
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);
        }

        else if(ud == KEY_DOWN)//if Downward arrow key pressed
        {
            GInfo[playerid][minY] -= 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] =  GangZoneCreate(
                                                          GInfo[playerid][minX],
                                                          GInfo[playerid][minY],
                                                          GInfo[playerid][maxX],
                                                          GInfo[playerid][maxY]
                                                        );

            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);

        }

        else if(keys & KEY_WALK)//if WALK key pressed arrow key pressed (stops creation process)
        {
            GInfo[playerid][creatingzone] = false;
            TogglePlayerControllable(playerid,true);
            ShowPlayerDialog(playerid,ZONECREATE,DIALOG_STYLE_INPUT,"Input Zone Name ","Input the name of this gang zone","Create","");
            GangZoneDestroy(GInfo[playerid][tempzone]);
        }
    }
	return 1;
}

CMD:createzone(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) 
      return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not authorised to use that Command!!");
    if(GInfo[playerid][creatingzone]) 
      return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are already creating one zone complete it using left alt key!!");

    if(!GInfo[playerid][creatingzone])
    {
        new Float:tempz;
        GetPlayerPos(playerid, GInfo[playerid][minX], GInfo[playerid][minY], tempz);
        GetPlayerPos(playerid, GInfo[playerid][maxX], GInfo[playerid][maxY], tempz);
        SendClientMessage(playerid,-1,"Use "YELLOW" Left,Right Forward and Backward "RED"keys to change size of zone");
        SendClientMessage(playerid,-1,"Use "YELLOW"walk "RED"key to stop the process");
        GInfo[playerid][creatingzone] = true;
        GInfo[playerid][tempzone] = -1;
        TogglePlayerControllable(playerid,false);
        return 1;
    }
    
    return 1;
}