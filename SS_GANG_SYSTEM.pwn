
/*

  _________ _________         ________                              _________               __
 /   _____//   _____/        /  _____/_____    ____    ____        /   _____/__.__. _______/  |_  ____   _____
 \_____  \ \_____  \        /   \  ___\__  \  /    \  / ___\       \_____  <   |  |/  ___/\   __\/ __ \ /     \
 /        \/        \       \    \_\  \/ __ \|   |  \/ /_/  >      /        \___  |\___ \  |  | \  ___/|  Y Y  \
/_______  /_______  /        \______  (____  /___|  /\___  /      /_______  / ____/____  > |__|  \___  >__|_|  /
        \/        \/                \/     \/     \//_____/               \/\/         \/            \/      \/
                                     __________
                                     \______   \___.__.
                                      |    |  _<   |  |
                                      |    |   \\___  |
                                      |______  // ____|
                                             \/ \/ _________
                                                  /   _____/______   ____ ___.__._____    ______
                                                  \_____  \\_  __ \_/ __ <   |  |\__  \  /  ___/
                                                  /        \|  | \/\  ___/\___  | / __ \_\___ \
                                                 /_______  /|__|    \___  > ____|(____  /____  >
                                                         \/             \/\/          \/     \/




                                      |----------------------------------------------------------------|
                                      |       ==ADVANCED GANG SYSTEM SQLLITE==                         |
                                      |       ==AUTHOR:SREYAS==                                        |
                                      |       ==Version:2.0==                                          |
                                      |                                                                |
                                      |   =======Commands=========                                     |
                                      |   /gcp        - to enter gang control panel                    |
                                      |   /creategang - to create new gang                             |
                                      |   /gangtag    - to add tag to your gang                        |
                                      |   /gwar       - to challenge other gang members for a gang war |
                                      |   /backup     - to request backup                              |
                                      |   /gkick      - to kick a member from gang                     |
                                      |   /setleader  - to set a member to leader                      |
                                      |   /gmembers   - to see whole members of gang                   |
                                      |   /top        - to see top 10 gangs                            |
                                      |   /ginvite    - to invite some to your gang                    |
                                      |   /accept     - to accept an invitation                        |
                                      |   /decline    - to decline an invitation                       |
                                      |   /gangcolor  - to change your gang color                      |
                                      |   /lg         - to leave the gang                              |
                                      |   /capture    - to capture a gangzone                          |
                                      |   /createzone - to create a gang zone(Rcon only)               |
                                      |   /zones      -  to show all gang zone and their details       |
                                      |   /ghelp      - to view all cmds                               |
                                      |                                                                |
                                      |    ======Other Features=====                                   |
                                      |    Use '#' to gang chat                                        |
                                      |    Each kill give 1 score for gang                             |
                                      |    Gang Member's death will be notified                        |
                                      |    Gang will be destroyed if a leader leaves it                |
                                      |    Gang Members will get 100$ per each 10 minutes              |
                                      |    Gang Zone will locked for certain time given by user        |
                                      |    Capturing gang zone gives 10 score to the gang              |
                                      |    In game dynamic gang zone creator                           |
                                      |    On entering the zone zone info will be displayed to player  |
                                      |                                                                |
                                      |                                                                |
                                      |----------------------------------------------------------------|
*/


#define FILTERSCRIPT

#include <a_samp> //SA - MP TEAM
#include <zcmd> //ZEEX
#include <sscanf2> //Y LESS
#include <YSI\y_iterate> //Y LESS
#include <YSI\y_areas> //Y LESS

//-----Dialogs--------------
enum 
{
    GANG_COLOR,
    GTOP,
    GMEMBERS,
    GCP,
    GKICK,
    GWAR,
    GLEADER,
    GTAG,
    ZONECREATE,
    ZONES,
    GHELP
};


//--------------Custom Defines-----------------------------------------------------------

#define MAX_GANGS           (50)
#define MAX_GZONES          (50)
#define ZONE_COLOR          (0xF3F0E596)
#define ZONE_LOCK_TIME      (120)                //NOTE:The time should be given in seconds
#define ZONE_CAPTURE_TIME   (30)                //Same as above note
#define MAX_SCORE           (0)              //Maximum score to create a gang

//----------------------------------------------------------------------------------------


static const Float:RandomSpawnsGW[][] =
{
    {1390.2234,-46.3298,1000.9236,5.7688},
    {1417.2269,-45.6457,1000.9274,53.0826},
    {1393.3025,-33.7530,1007.8823,89.6141},
    {1365.5669,2.3778,1000.9285,11.9068}
};


static 
      bool:ActiveWar = false,
      Iterator:Zones<MAX_GZONES>,
      Iterator:SS_Player<MAX_PLAYERS>;//custom player iterator to overcome a bug in foreach's default one

//-----GANG COLORS--------------------------

#define G_PURPLE                0xD526D9FF
#define G_GREEN                 0x00FF00FF
#define G_PINK                  0xFFB6C1FF
#define G_CYAN                  0x33CCFFAA
#define G_GREY                  0xAFAFAFAA
#define G_WHITE                 0xFFFFFFFF
#define G_ORANGE                0xFF8000FF
#define G_YELLOW                0xFFFF00FF
#define G_BLUE                  0x0080FFC8
#define G_RED                   0xFF0000FF

//------------------------------------------

//------Colors-----------------------------

#define RED     "{FF0000}"
#define GREY    "{C0C4C4}"
#define ORANGE  "{F07F1D}"
#define CYAN    "{00FFFF}"
#define GREEN   "{00FF00}"
#define WHITE   "{FFFFFF}"
#define VIOLET  "{8000FF}"
#define YELLOW  "{FFFF00}"
#define BLUE    "{0000FF}"
#define PINK    "{F7B0D0}"

//---------------------------------------


//----------------------------------------------------------------------------------------------

enum G_USER_DATA
{
    
    gangname[32],
    gangid,
    gangmember,
    gangleader,
    username[MAX_PLAYER_NAME],
    invitedid,
    bool:ganginvite,
    bool:Capturing,
    bool:inwar,
    bool:creatingzone,
    gangcolor,
    gangtag[4],
    tempzone,
    Float:minX, 
    Float:minY,
    Float:maxX,
    Float:maxY,
    PlayerText:TextDraw,
    PlayerText:TimerTD
};

static 
      GInfo[MAX_PLAYERS][G_USER_DATA],
      DB:Database;

static const Reset_Gang_Enum[G_USER_DATA];
enum Zone_Data
{
    Color,
    Owner[32],
    bool:Owned,
    bool:locked,
    bool:U_Attack,
    timer,
    timer_main,
    timercap_main,
    timercap,
    Name[32],
    Float:ZminX,
    Float:ZminY,
    Float:ZmaxX,
    Float:ZmaxY,
    Region,
    Zone_Wrapper
}

static ZInfo[MAX_GZONES][Zone_Data];

public OnFilterScriptInit()
{

    print("-------------------------------------------------------");
    print("---SS_Gang---SQLITE----system---by---Sreyas---Loaded---");
    print("-------------------------------------------------------");

    Database = db_open("gang.db");
    db_query( Database, "PRAGMA synchronous = OFF" );
    db_query(Database,"CREATE TABLE `Gangs` (\
                                              `GangID`  INT(3) PRIMARY KEY AUTOINCREMENT,\
                                              `GangName`  VARCHAR(24),\
                                              `GangColor` INTEGER,\
                                              `GangTag` VARCHAR(4),\
                                              `GangScore` INTEGER DEFAULT 0\
                                              )");
    db_query(Database,"CREATE TABLE IF NOT EXISTS Zones (\
                                                          Name VARCHAR(32) COLLATE NOCASE,\
                                                          MinX FLOAT,\
                                                          MinY FLOAT,\
                                                          MaxX FLOAT,\
                                                          MaxY FLOAT,\
                                                          Owner VARCHAR(32) COLLATE NOCASE,\
                                                          Color INTEGER\
                                                        )");
    db_query(Database,"CREATE TABLE `Members` (\
                                                `GangID`  INT(3),\
                                                `UserName`  VARCHAR(24) UNIQUE NOT NULL,\
                                                `GangLeader`  TINYINT DEFAULT 0\
                                              )");

    new  
        DBResult:Result,
                 iter;
    Result = db_query(Database,"SELECT * FROM Zones");

    if(db_num_rows(Result))
    {

        do
        {
            iter = Iter_Free(Zones);
            ZInfo[iter][ZminX] = db_get_field_assoc_float(Result, "MinX");
            ZInfo[iter][ZminY] = db_get_field_assoc_float(Result, "MinY");
            ZInfo[iter][ZmaxX] = db_get_field_assoc_float(Result, "MaxX");
            ZInfo[iter][ZmaxY] = db_get_field_assoc_float(Result, "MaxY");
            db_get_field_assoc(Result, "Name", ZInfo[iter][Name], 32);
            db_get_field_assoc(Result, "Owner", ZInfo[iter][Owner], 32);
            
            ZInfo[iter][Color] = db_get_field_assoc_int(Result, "Color");
            ZInfo[iter][locked] = false;
            ZInfo[iter][Owned] = false;
            ZInfo[iter][U_Attack] = false;
            
            ZInfo[iter][Region]  = Area_AddBox( 
                                                ZInfo[iter][ZminX],
                                                ZInfo[iter][ZminY],  
                                                ZInfo[iter][ZmaxX], 
                                                ZInfo[iter][ZmaxY]
                                              );
            
            ZInfo[iter][ Zone_Wrapper] = GangZoneCreate( 
                                                  ZInfo[iter][ZminX],
                                                  ZInfo[iter][ZminY],  
                                                  ZInfo[iter][ZmaxX],
                                                  ZInfo[iter][ZmaxY]
                                                );
            Iter_Add(Zones, iter);
        } while(db_next_row(Result));
    }

    db_free_result( Result );
    return 1;
}



public OnFilterScriptExit()
{
    foreach(new i : Zones)
    {
        GangZoneDestroy(ZInfo[i][ Zone_Wrapper]);
        Area_Delete(ZInfo[i][Region]);
    }

    Iter_Clear(Zones);
    Iter_Clear(SS_Player);
    db_close( Database );
    print("---------------------------------------------------------");
    print("---SS_Gang---SQLITE----system---by---Sreyas---UnLoaded---");
    print("-------------------------------------------------------\n");
    return 1;
}




public OnPlayerConnect(playerid)
{
    
    GInfo[playerid] = Reset_Gang_Enum; 

    Iter_Add(SS_Player,playerid);
    GetPlayerName( playerid, GInfo[playerid][username], MAX_PLAYER_NAME );
    GInfo[playerid][Capturing] = false;

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

    foreach(new i:Zones)
      GangZoneShowForPlayer(playerid,ZInfo[i][ Zone_Wrapper], (isnull(ZInfo[i][Owner])) ?(ZONE_COLOR): (ZInfo[i][Color])) ;

        
    

    new  
        Query[107],
        DBResult: Result;
    format( 
            Query, sizeof( Query ), 
            "SELECT * FROM Members WHERE UserName = '%q' LIMIT 0, 1", 
            GInfo[ playerid ][ username ]
          );
    Result = db_query( Database, Query );

    if( db_num_rows( Result ) )//if the connected player is in member table (ie he is a gang member)
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
    /*else
    {
        format( Query, sizeof( Query ), "INSERT INTO Members (UserName) VALUES ('%q')", GInfo[ playerid ][ username ] );
        db_query( Database, Query );
        return 1;
    }*/
}



public OnPlayerDisconnect(playerid,reason)
{
    SetPlayerName(playerid,GInfo[playerid][username]);//just to avoid some bugs

    if(GInfo[playerid][inwar])
    {
        GInfo[playerid][inwar] = false;
        CheckVict(GInfo[playerid][gangname],"INVALID");//NOTE: to work on

    }

    if(GInfo[playerid][gangmember] == 1)
    {
        new str[128];
        format(str,sizeof(str),""ORANGE"[GANGINFO]"RED" Member "CYAN"%s"RED" has Logged Out ",GInfo[playerid][username]);
        SendGangMessage(playerid,str);
    }

    GInfo[playerid] = Reset_Gang_Enum; 

    Iter_Remove(SS_Player,playerid);
    return 1;
}



public OnPlayerText(playerid, text[])
{
    static pText[144];
    if(text[0] == '#' && GInfo[playerid][gangmember] == 1)
    {
        
        format(pText,sizeof(pText),""RED"[GANG CHAT]"ORANGE" %s: "WHITE"%s",GInfo[playerid][username],text[1]);
        SendGangMessage(playerid,pText);
        return 0;
    }
    else
    {
        
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
            }

            else
            {
                GInfo[playerid][gangcolor] = random(15);
                SetPlayerColor(playerid,GInfo[playerid][gangcolor]);

            }

            new Query[116];
            format(Query,sizeof(Query),"UPDATE Gangs SET GangColor = %d Where GangID = %d",GInfo[playerid][gangcolor],GInfo[playerid][gangid]);
            db_query(Database,Query);
            SendGangMessage(playerid,""RED"Leader"YELLOW" Has changed gang color");
            return 1;

        }

        case GCP:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0: return cmd_gcp(playerid);
                    case 1: return cmd_gcp(playerid);
                    case 2: return cmd_gmembers(playerid);
                    case 3: return cmd_top(playerid);
                    case 4: return ShowPlayerDialog(playerid, GWAR, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Enemy Gang Name", ""GREY"Please enter the  name of enemy gang", "Start", "Cancel");
                    case 5: return ShowPlayerDialog(playerid, GKICK, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Member Name", ""GREY"Please enter the  name or id Member to Kicked", "Kick", "Cancel");
                    case 6: return ShowPlayerDialog(playerid, GTAG, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Gang Tag", ""GREY"Please enter the new tag for your Gang", "Set", "Cancel");
                    case 7: return cmd_gangcolor(playerid);
                    case 8: return ShowPlayerDialog(playerid, GLEADER, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Member Name or ID", ""GREY"Please enter the  name or id Member to Set as leader ", "Kick", "Cancel");
                }
            }
            return 1;
        }


        case GWAR :
        {
            if(response)
                return cmd_gwar(playerid,inputtext);
            
        }

        case GKICK:
        {
            if(response)
                return cmd_gkick(playerid,inputtext);
            
        }

        case GLEADER:
        {
            if(response)
                return cmd_setleader(playerid,inputtext);
            
        }

        case GTAG:
        {
            if(response)
                 return cmd_gangtag(playerid,inputtext);
            
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
        }

    }
    return 1;
}


public OnPlayerDeath(playerid,killerid,reason)
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


public OnPlayerUpdate(playerid) 
{
    if(GInfo[playerid][creatingzone])
    {
        static keys,ud,lr;
        GetPlayerKeys(playerid,keys,ud,lr);

        if(lr == KEY_LEFT)
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
        
        else if(lr == KEY_RIGHT)
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

        else if(ud == KEY_UP)
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

        else if(ud == KEY_DOWN)
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

        else if(keys & KEY_WALK)
        {
            GInfo[playerid][creatingzone] = false;
            TogglePlayerControllable(playerid,true);
            ShowPlayerDialog(playerid,ZONECREATE,DIALOG_STYLE_INPUT,"Input Zone Name ","Input the name of this gang zone","Create","");
            GangZoneDestroy(GInfo[playerid][tempzone]);
        }
    }
    return 1;

}

public OnPlayerEnterArea(playerid, areaid)
{
    static str[128];
    foreach(new i : Zones)
    {
        if(areaid == ZInfo[i][Region])
        {
            
            if(isnull(ZInfo[i][Owner]))
            {
                 format(str,sizeof str,"~y~Zone_Info~n~~b~Name:_~r~%s~n~~b~Status:_~r~Un_Owned",ZInfo[i][Name]);
                 PlayerTextDrawSetString(playerid, GInfo[playerid][TextDraw],str);
            }
            else
            {
                format(str,sizeof str,"~y~Zone_Info_~n~~b~Name:_~r~%s~n~~b~Status:_~r~Owned-by_~g~%s",ZInfo[i][Name],ZInfo[i][Owner]);
                PlayerTextDrawSetString(playerid, GInfo[playerid][TextDraw],str);
            }

            PlayerTextDrawShow(playerid,GInfo[playerid][TextDraw]);
            return 1;
        }
    }
    return 1;
}

public OnPlayerLeaveArea(playerid, areaid)
{
    static msg[200];
    foreach(new i : Zones)
    {
        if(areaid == ZInfo[i][Region])
        {
            if(GInfo[playerid][Capturing])
            {
                
                GInfo[playerid][Capturing] = false;
                format(msg,sizeof msg,"%s%s "ORANGE" gang has failed in capturing "GREEN" %s "ORANGE"zone.It will be locked for %d minute(s)",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[i][Name],((ZONE_LOCK_TIME)/60));
                KillTimer(ZInfo[i][timercap_main]);
                PlayerTextDrawHide(playerid,GInfo[playerid][TimerTD]);
                SendClientMessageToAll(-1,msg);
                ZInfo[i][timer] = ZONE_LOCK_TIME;
                ZInfo[i][locked] = true;
                ZInfo[i][timer_main] = SetTimerEx("UnlockZone",1000,true,"i",i);
            }
            ZInfo[i][U_Attack] = false;
            GangZoneStopFlashForAll(ZInfo[i][ Zone_Wrapper]);
            PlayerTextDrawHide(playerid, GInfo[playerid][TextDraw]);
        }
    }
    return 1;
}


//--------------------------------COMMANDS---------------------------------------------------------------------------------------------------------------------------


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
    //format(Query,sizeof(query),"UPDATE Members SET GangName = '%q' ,GangMember = 1,GangLeader = 1 WHERE UserName = '%q' ",params,GInfo[playerid][username]);
    
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
    strdel(GInfo[playerid][gangname],0,32) ;
    GInfo[playerid][gangname] = EOS;
    if(GInfo[playerid][gangleader] == 1)
    {
        foreach(new i : SS_Player)
        {
            if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname],false))
            {
                GInfo[i][gangmember] = 0;
                GInfo[i][gangname][0] = EOS;
                if(GInfo[i][gangleader] == 1)
                    GInfo[playerid][gangleader] = 0;
            }
        }
    
        
        format(Query,sizeof(Query),"DELETE FROM Gangs WHERE GangName = '%q'",gname);
        db_query(Database,Query);
        format(Query,sizeof(Query),"DELETE FROM Members WHERE GangID = %d ",GInfo[playerid][gangid]);
        db_query(Database,Query);
        
        format(str,sizeof(str),""RED"Leader "YELLOW"%s"RED" Has Left Gang %s%s"RED" and Gang is Destroyed",GInfo[playerid][username],IntToHex(GInfo[playerid][gangcolor]),gname);
        SetPlayerName(playerid,GInfo[playerid][username]);
        return SendClientMessageToAll(-1,str);
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

CMD:ginvite(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0 ) return SendClientMessage(playerid,-1,""RED"You are not authorised to do that");
  
    new giveid;
    
    if(sscanf(params,"u",giveid)) return SendClientMessage(playerid,-1,""RED"Error:"GREY"/ginvite playerid");
    if(giveid == INVALID_PLAYER_ID) return SendClientMessage(playerid,-1,""RED"Invalid player!");
    if(GInfo[giveid][gangmember] == 1) return SendClientMessage(playerid,-1,""RED"He is already in a gang");

    GInfo[giveid][ganginvite] = true;
    SendClientMessage(playerid,-1,""GREEN"Invitation send successfully");
    SendClientMessage(giveid,-1,""GREEN"You have recieved a gang invitation /accept or /decline to accept or decline ");
    GInfo[giveid][invitedid] = GInfo[playerid][gangid];
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


CMD:decline(playerid)
{
    if(GInfo[playerid][ganginvite] == false) return SendClientMessage(playerid,-1,""RED"You didnt recieve any invitations");

    SendClientMessage(playerid,-1,"You declined the invitation");
    GInfo[playerid][ganginvite] = false;
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
    if(GInfo[giveid][gangleader] == 1) 
        return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You cant kick a group leader");

    GInfo[giveid][gangmember] = 0;
    format(Query,sizeof(Query),"DELETE FROM Members UserName = '%q' ",GInfo[giveid][username]);
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

CMD:gangcolor(playerid)
{
    ShowPlayerDialog(playerid,GANG_COLOR,DIALOG_STYLE_LIST,"Gang Color",""BLUE"Blue\n"RED"RED\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow","OK","CANCEL");
    return 1;
}

CMD:gwar(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not Authorised to do that!!");
    if(ActiveWar == true) return SendClientMessage(playerid,-1,""RED"Error:"GREY"There is a War Going on now wait till it finishes");
    
    new 
        c1,
        tempid,
        p;
    
    if(isnull(params)) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY":/gwar gangname");
    if(!strcmp(params,"INVALID")) return SendClientMessage(playerid,-1,""RED"ERROR:"GREY"You are not allowed to use that name!!");
    foreach( p: SS_Player)
    {
        if(!strcmp(GInfo[p][gangname],params,true))
        {
            c1++;
            tempid = p;
        }
    }
    
    if(c1 == 0) return SendClientMessage(playerid,-1,""RED"No members of that gang is online");
    new Random;
    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[i][gangname],GInfo[playerid][gangname]) || !strcmp(params,GInfo[i][gangname]))
        {
            GInfo[i][inwar] = true;
            Random = random(sizeof(RandomSpawnsGW));
            SetPlayerPos(i,RandomSpawnsGW[Random][0], RandomSpawnsGW[Random][1], RandomSpawnsGW[Random][2]);
            SetPlayerInterior(i,1);
            ResetPlayerWeapons(i);
            TogglePlayerControllable( i, false );
        }
    }

    ActiveWar = true;
    SetTimerEx("GangWar",10000,false,"ii",playerid,tempid);

    new str[128];

    format(str,sizeof(str),"%s%s"WHITE" has started a war against %s%s "WHITE"and will start in "YELLOW"10 seconds",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],IntToHex(GInfo[tempid][gangcolor]),params);
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
        DBResult:Result,GScore;

    format(Query,sizeof(Query),"SELECT GangScore FROM Gangs WHERE GangName = '%q'",GInfo[playerid][gangname]);

    if( db_num_rows( Result ) )
    {
        GScore = db_get_field_assoc_int(Result,"GangScore");
        db_free_result( Result );
    }

    format(str,sizeof(str),""RED"GangName\t:\t%s%s\n"PINK"GangScore\t:\t"GREEN"%d"WHITE"\nGangMembers\nTop Gangs\nGang War\nKick Member \nChange Tag \nChange Color\nSet Leader",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],GScore);
    ShowPlayerDialog(playerid,GCP,DIALOG_STYLE_LIST,""RED"Gang Control Panel",str,"Ok","Cancel");
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

CMD:capture(playerid)
{

    if(GInfo[playerid][gangmember] == 0) 
      return SendClientMessage(playerid,-1,""RED"[ERROR]:"GREY"You are not in any gang!");
    new 
        bool:inzone = false,
        i;

    foreach( i : Zones)
    {
        if(IsPlayerInArea(playerid, ZInfo[i][ZminX] ,ZInfo[i][ZminY],ZInfo[i][ZmaxX],ZInfo[i][ZmaxY]))
        {
            inzone = true;
            break;
        }
    }

    if(!inzone)
      return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"You should be in a gang zone to use this CMD!");
    new string[150];
    if(ZInfo[i][locked])
    {
        format(string,sizeof string,""GREY"This Zone is Locked comeback in "YELLOW"%d "GREY"seconds ",ZInfo[i][timer]);
        return SendClientMessage(playerid,-1,string);
    }

    if(GInfo[playerid][Capturing]) 
        return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"You are capturing this zone! ");
    if(ZInfo[i][U_Attack]) 
        return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"Another gang is already set an atttack on  this zone!");
    if(!strcmp(ZInfo[i][Owner],GInfo[playerid][gangname],true)&&!isnull(ZInfo[i][Owner])) 
        return SendClientMessage(playerid,-1,""RED"[ERROR] "GREY"Your Gang Own this Zone");

    GangZoneFlashForAll(ZInfo[i][ Zone_Wrapper], 0xFF0000AA);
    GInfo[playerid][Capturing] = true;
    ZInfo[i][U_Attack] = true;

    format(string,sizeof string,"%s%s"ORANGE" gang has started to capture "GREEN"%s "ORANGE"zone",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[i][Name]);
    SendClientMessageToAll(-1,string);
    ZInfo[i][timercap] = ZONE_CAPTURE_TIME;
    ZInfo[i][timercap_main] = SetTimerEx("CaptureZone", 1000, true, "ii", playerid, i);

    return 1;
}

CMD:zones(playerid)
{
   new string[900];

   foreach(new i : Zones)
   {
        if(isnull(ZInfo[i][Owner]))
             format(string,sizeof string,"%s"GREEN"%d.)"RED"%s\n",string,(i+1),ZInfo[i][Name]);
        else
            format(string,sizeof string,"%s"GREEN"%d.)"RED"%s"YELLOW" %s(%s)\n",string,(i+1),ZInfo[i][Name],IntToHex(ZInfo[i][Color]),ZInfo[i][Owner]);
   }

   ShowPlayerDialog(playerid,ZONES,DIALOG_STYLE_MSGBOX,""ORANGE"Zones"PINK"           Owned By",string,"Cancel","");
   return 1;
}

CMD:ghelp(playerid)
{
    new string[1164];
    
    strcat(string,""GREEN"\t/creategang\t\t"WHITE"-\t"ORANGE"To create a gang\n");
    strcat(string,""GREEN"\t/gmembers\t"WHITE"-\t"ORANGE"To view all gangmembers\n");
    strcat(string,""GREEN"\t/lg\t\t\t"WHITE"-\t"ORANGE"To leave the gang\n");
    strcat(string,""GREEN"\t/accept\t\t\t"WHITE"-\t"ORANGE"To accept an invitation to a gang\n");
    strcat(string,""GREEN"\t/decline\t\t"WHITE"-\t"ORANGE"To decline an invitation to a gang\n");
    strcat(string,""GREEN"\t/top\t\t\t"WHITE"-\t"ORANGE"To view all top 10 gangs\n");
    strcat(string,""GREEN"\t/gangcolor\t\t"WHITE"-\t"ORANGE"To change gangcolor\n");
    strcat(string,""GREEN"\t/gkick\t\t\t"WHITE"-\t"ORANGE"To kick a gangmember\n");
    strcat(string,""GREEN"\t/gwar\t\t\t"WHITE"-\t"ORANGE"To challenge other  gang for a war\n");
    strcat(string,""GREEN"\t/gcp\t\t\t"WHITE"-\t"ORANGE"To view all gang control panel\n");
    strcat(string,""GREEN"\t/capture\t\t"WHITE"-\t"ORANGE"To capture a  gangzone\n");
    strcat(string,""GREEN"\t/zones\t\t\t"WHITE"-\t"ORANGE"To view all gangzones and their details\n");
    strcat(string,""GREEN"\t/createzone\t\t"WHITE"-\t"ORANGE"To create a gangzone\n");
    strcat(string,""GREEN"\t/gangtag\t\t"WHITE"-\t"ORANGE"To change gang tag\n");
    strcat(string,""GREEN"\t/ginvite\t\t"WHITE"-\t"ORANGE"To invite other players to the gang\n");
    strcat(string,""GREEN"\t/setleader\t\t"WHITE"-\t"ORANGE"To set a member as gangleader\n");
    strcat(string,""GREEN"\t/demote\t\t"WHITE"-\t"ORANGE"To demote a member from gang leader position\n");
    strcat(string,""GREEN"\t/ghelp\t\t\t"WHITE"-\t"ORANGE"To view this dialog");
    
    ShowPlayerDialog(playerid,GHELP,DIALOG_STYLE_MSGBOX,""RED"SS GANG SYSTEM BY SREYAS",string,"OK","");
    return 1;
}



//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//-------------------------------------------------Custom Functions---------------------------------------------------------------------------------------------------------



forward CaptureZone(playerid,zoneid);

public CaptureZone(playerid,zoneid)
{
    ZInfo[zoneid][timercap]--;
    new str[34];
    format(str,sizeof str,"%02d-%02d",(ZInfo[zoneid][timercap]/60),ZInfo[zoneid][timercap]);
    PlayerTextDrawSetString(playerid, GInfo[playerid][TimerTD],str);
    PlayerTextDrawShow(playerid,GInfo[playerid][TimerTD]);

    if(ZInfo[zoneid][timercap]==0)
    {
        new string[128];
        format(string,sizeof string,""RED"Your Gang zone is captured by"YELLOW" %s %sgang ",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname]);
        PlayerTextDrawHide(playerid,GInfo[playerid][TimerTD]);
        foreach(new i : SS_Player)
        {
            if(!strcmp(ZInfo[zoneid][Owner],GInfo[i][gangname]))
                SendClientMessage(i,-1,string);
        }

        if(ZInfo[zoneid][U_Attack])
        {
            GangZoneStopFlashForAll(ZInfo[zoneid][ Zone_Wrapper]);
            new color = (GInfo[playerid][gangcolor] & ~0xFF) | 80;
            GangZoneShowForAll(ZInfo[zoneid][ Zone_Wrapper], color);
            format(ZInfo[zoneid][Owner],24,"%s",GInfo[playerid][gangname]);
            ZInfo[zoneid][locked] = true;
            ZInfo[zoneid][Color] = color;
            new 
                Query[300],
                msg[150];
            format(Query,sizeof Query,"UPDATE Zones SET Owner = '%q',Color = %i WHERE Name = '%q'",ZInfo[zoneid][Owner],ZInfo[zoneid][Color],ZInfo[zoneid][Name]);
            db_query(Database,Query);
            format(msg,sizeof msg,"%s%s "ORANGE" gang has successfully captured"GREEN" %s "ORANGE"zone. It will be locked for "RED"%d "ORANGE"minute(s)",IntToHex(GInfo[playerid][gangcolor]),GInfo[playerid][gangname],ZInfo[zoneid][Name],((ZONE_LOCK_TIME)/60));
            SendClientMessageToAll(-1,msg);
            ZInfo[zoneid][timer] = ZONE_LOCK_TIME;
            ZInfo[zoneid][timer_main] = SetTimerEx("UnlockZone",1000,true,"i",zoneid);
            ZInfo[zoneid][U_Attack] = false;
            GInfo[playerid][Capturing] = false;
            
            format(Query,sizeof(Query),"UPDATE Gangs SET GangScore = GangScore+10 WHERE GangName = '%q'",GInfo[playerid][gangname]);
            db_query(Database,Query);
        }
 
        KillTimer(ZInfo[zoneid][timercap_main]);
     }
    return 1;
}

forward UnlockZone(zoneid);
public UnlockZone(zoneid)
{

    ZInfo[zoneid][timer]--;
    if(ZInfo[zoneid][timer] == 0)
    {
        KillTimer(ZInfo[zoneid][timer_main]);
        ZInfo[zoneid][locked] = false;
    }
    return 1;
}



forward GangWar(playerid,enemyid);
public GangWar(playerid,enemyid)
{
    new 
        count1,
        count2;
    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[playerid][gangname],GInfo[i][gangname]))
        {
            GivePlayerWeapon(i,34,100);
            SetPlayerHealth(i,100);
            SetPlayerArmour(i,100);
            TogglePlayerControllable( i, true );
            GameTextForPlayer(i, "~w~War ~g~ Has~r~ Started", 5000, 5);
            count1++;
        }

        if(!strcmp(GInfo[enemyid][gangname],GInfo[i][gangname]))
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
        foreach(new i : SS_Player)
        {
            if(GInfo[i][inwar] == true)
            {
                GInfo[i][inwar] = false;
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

forward FullyConnect(playerid);
public FullyConnect(playerid)
{
    if(!isnull(GInfo[playerid][gangtag]))
    {
        new newname[24];
        format(newname,sizeof newname,"%s[%s]",GInfo[playerid][username],GInfo[playerid][gangtag]);
        SetPlayerName(playerid,newname);
        SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
    }
    return 1;
}

SendGangMessage(playerid,Message[])
{
    foreach(new i : SS_Player)
    {
        if(!strcmp(GInfo[playerid][gangname],GInfo[i][gangname],false) && !isnull(GInfo[i][gangname]))
            SendClientMessage(i,-1,Message);
    }
    return 0;
}


IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) 
        return 1;
  
    return 0;
}

//NOTE: Need to rewrite
CheckVict(gname1[],gname2[])
{
    new count1,count2,pid,eid;
  
    foreach(new i : SS_Player)
    {
        if(GInfo[i][inwar] == true)
        {
            if(!strcmp(gname1,GInfo[i][gangname]) || !strcmp(gname1,"INVALID"))
            {
                pid = i;
                count1++;
            }

            if(!strcmp(gname2,GInfo[i][gangname]) || !strcmp(gname2,"INVALID"))
            {
                eid = i;
                count2++;
            }
        }
    }

    if(count1 ==0 || count2 ==0)
    {
        new winner[32];
        foreach(new i : SS_Player)
        {
            if(GInfo[i][inwar])
            {
                GInfo[i][inwar] = false;
                SetPlayerInterior(i,0);
                SpawnPlayer(i);
            }
        }

        new str[128];
  
        if(count1 == 0)
        {
            format(str,sizeof(str),"%s%s "WHITE"has won the war against %s%s",IntToHex(GInfo[eid][gangcolor]),GInfo[eid][gangname],IntToHex(GInfo[pid][gangcolor]),GInfo[pid][gangname]);
            SendClientMessageToAll(-1,str);
            ActiveWar = false;
            format(winner,sizeof winner,"%s",gname2);
        }

        else if(count2 == 0)
        {
             
            format(str,sizeof(str),"%s%s "WHITE"has won the war against %s%s",IntToHex(GInfo[pid][gangcolor]),GInfo[pid][gangname],IntToHex(GInfo[eid][gangcolor]),GInfo[eid][gangname]);
            SendClientMessageToAll(-1,str);
            ActiveWar = false;
            format(winner,sizeof winner,"%s",gname1);
        }

        new Query[180];
        format(Query,sizeof(Query),"UPDATE Gangs SET GangScore = GangScore+5 WHERE GangName = '%q'",winner);
        db_query(Database,Query);
    }
    return 1;
}

IntToHex(var)
{
    new hex[10];
    format(hex,sizeof hex,"{%06x}", var >>> 8);
    return hex;
}

