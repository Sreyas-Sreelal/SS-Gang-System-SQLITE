

/*

DialogHooks.pwn - Contains dialog responses that have handle to databases 

*/


#include <YSI\y_hooks>


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
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
                }

                else
                {
                    GInfo[playerid][gangcolor] = random(15);
                    SetPlayerColor(playerid,GInfo[playerid][gangcolor]);

                }

                new Query[116];
                format(Query,sizeof(Query),"UPDATE Gangs SET GangColor = %d Where GangID = %d",GInfo[playerid][gangcolor],GInfo[playerid][gangid]);
                db_query(Database,Query);
                SendGangMessage(GInfo[playerid][gangid],""RED"Leader"YELLOW" Has changed gang color");
                return 1;

            }
        
        case ZONECREATE:
        {
            if(response)
            {
                new query[160];
                format(
                        query,sizeof query,
                        "INSERT INTO Zones (Name,MinX,MinY,MaxX,MaxY) VALUES('%q','%f','%f','%f','%f')",
                        inputtext,GInfo[playerid][minX],GInfo[playerid][minY],GInfo[playerid][maxX],GInfo[playerid][maxY]

                      );
                db_query(Database,query);
                new Iter = Iter_Free(Zones);
                ZInfo[Iter][ZminX] = GInfo[playerid][minX];
                ZInfo[Iter][ZminY] = GInfo[playerid][minY];
                ZInfo[Iter][ZmaxX] = GInfo[playerid][maxX];
                ZInfo[Iter][ZmaxY] = GInfo[playerid][maxY];
                format(ZInfo[Iter][Name],24,"%s",inputtext);
                strcpy(ZInfo[Iter][Owner],"");
                ZInfo[Iter][locked] = false;
                ZInfo[Iter][Owned] = false;
                ZInfo[Iter][Region]  = Area_AddBox(
                                                    GInfo[playerid][minX],
                                                    GInfo[playerid][minY], 
                                                    GInfo[playerid][maxX], 
                                                    GInfo[playerid][maxY]
                                                  );
                ZInfo[Iter][ Zone_Wrapper] = GangZoneCreate(
                                                              GInfo[playerid][minX],
                                                              GInfo[playerid][minY], 
                                                              GInfo[playerid][maxX],
                                                              GInfo[playerid][maxY]
                                                            );
                Iter_Add(Zones, Iter);
                GangZoneShowForAll(ZInfo[Iter][ Zone_Wrapper],ZONE_COLOR);
                
            }
            return 1;
        }
    }
    return 1;
}