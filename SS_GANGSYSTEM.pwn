
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
                                      |       ==ADVANCED GANG SYSTEM MySQL==                           |
                                      |       ==AUTHOR:SREYAS==                                        |
                                      |       ==Converted By: AndySedeyn==                             |
                                      |        ==Version:1.1==                                         |
                                      |                                                                |
                                      |   =======Commands=========                                     |
                                      |   /gcp        - to enter gang control panel                    |
                                      |   /creategang - to create new gang                             |
                                      |   /gangtag    - to add tag to your gang                        |
                                      |   /gwar       - to challenge other gang members for a gang war |
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

#undef MAX_PLAYERS
#define MAX_PLAYERS 50 // change to server slots

#define FOREACH_VEHICLE_ITERATOR 0
#define FOREACH_ACTOR_ITERATOR 0
#include <foreach> //Y LESS

#include <a_mysql> // BlueG
#include <sscanf2> //Y LESS
#include <streamer> //INCOGNITO
#include <zcmd> //ZEEX

//-----Dialogs--------------
enum {

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

#define CONNECT_ID          handle_id       // This is the name of your connection variable for the database

#define MYSQL_HOST          "host_unknown"  // Database IP
#define MYSQL_USER          "user_unknown"  // Database user
#define MYSQL_PASS          ""  // Database password
#define MYSQL_DATA          "db_unknown" // Database name

#define MAX_GANGS           50

#define MAX_GZONES          50

#define ZONE_COLOR          0xF3F0E596

#define ZONE_LOCK_TIME      120                //NOTE:The time should be given in seconds

#define ZONE_CAPTURE_TIME   30                //Same as above note

#define MAX_SCORE           0              //Maximum score to create a gang

//----------------------------------------------------------------------------------------


new Float:RandomSpawnsGW[][] =
{
    {1390.2234,-46.3298,1000.9236,5.7688},

    {1417.2269,-45.6457,1000.9274,53.0826},

    {1393.3025,-33.7530,1007.8823,89.6141},

    {1365.5669,2.3778,1000.9285,11.9068}

};


static bool:ActiveWar = false, GWar_Gang1, GWar_Gang2;

static Iterator:Zones<MAX_GZONES>, Iterator:Gangs<MAX_GANGS>;

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

#if !defined strcpy
    #define strcpy(%0,%1) strcat((%0[0] = EOS, %0), %1)
#endif

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

enum G_GANG_DATA
{
    gangid,
    gangname[32],
    gangcolor,
    gangtag[4]
}
static Gang[MAX_GANGS][G_GANG_DATA];

enum G_USER_DATA
{
    bool:gangleader,

    gang_index,

    ganginvited,

    username[MAX_PLAYER_NAME],

    gangtag[4],

    bool:Capturing,

    bool:inwar,

    bool:creatingzone,

    tempzone,

    Float:minX,

    Float:minY,

    Float:maxX,

    Float:maxY,

    PlayerText:TextDraw,

    PlayerText:TimerTD,
    
    in_zone
};
static GInfo[MAX_PLAYERS][G_USER_DATA];

enum Zone_Data
{
    Color,

    Owner,

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

    _Zone
}
static ZInfo[MAX_GZONES][Zone_Data];

static MySQL:CONNECT_ID;
public OnFilterScriptInit()
{
    print("-------------------------------------------------------");
    print("---SS_Gang---SQLITE----system---by---Sreyas---Loaded---");
    print("------Converted---to---MySQL---by---Andy---Sedeyn------");
    print("-------------------------------------------------------");

    CONNECT_ID = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);

    if(mysql_errno() != 0)
    {
        print("[SS_Gang]: Failed to connect to the database!");
        return 1;
    }
    else
    {
        print("[SS_Gang]: Connection to the database successful!");
    }
    
    GWar_Gang1 = GWar_Gang2 = -1;
    
    mysql_tquery(CONNECT_ID, "SELECT * FROM gangs", "OnGangsLoad");
    mysql_tquery(CONNECT_ID, "SELECT * FROM zones", "OnZonesLoad");

    foreach(new i : Player) OnPlayerConnect(i);
    return true;
}

forward OnGangsLoad();
public OnGangsLoad()
{
    new rowCount = cache_num_rows(), i;
    for(i = 0; i < rowCount; i++)
    {
        cache_get_value_name_int(i, "GangID", Gang[i][gangid]);
        cache_get_value_name(i, "GangName", Gang[i][gangname], 32);
        cache_get_value_name_int(i, "GangColor", Gang[i][gangcolor]);
        cache_get_value_name(i, "GangTag", Gang[i][gangtag]);
        
        Iter_Add(Gangs, i);
    }
}

forward OnZonesLoad();
public OnZonesLoad()
{
    new rowCount = cache_num_rows(), i, j, gang_id;
    for(i = 0; i < rowCount; i++)
    {
        cache_get_value_name_float(i, "MinX", ZInfo[i][ZminX]);
        cache_get_value_name_float(i, "MinY", ZInfo[i][ZminY]);
        cache_get_value_name_float(i, "MaxX", ZInfo[i][ZmaxX]);
        cache_get_value_name_float(i, "MaxY", ZInfo[i][ZmaxY]);

        cache_get_value_name(i, "Name", ZInfo[i][Name], 56);
        cache_get_value_name_int(i, "Owner", gang_id);
        ZInfo[i][Owner] = -1;
        
        if (gang_id)
        {
            foreach(j : Gangs)
            {
                if (gang_id == Gang[j][gangid])
                {
                    ZInfo[i][Owner] = j;
                    break;
                }
            }
        }
		
        cache_get_value_name_int(i, "Color", ZInfo[i][Color]);

        ZInfo[i][locked] = false;
        ZInfo[i][Owned] = false;
        ZInfo[i][U_Attack] = false;

        ZInfo[i][Region] = CreateDynamicRectangle(ZInfo[i][ZminX], ZInfo[i][ZminY], ZInfo[i][ZmaxX], ZInfo[i][ZmaxY]);
        Streamer_SetIntData(STREAMER_TYPE_AREA, ZInfo[i][Region], E_STREAMER_EXTRA_ID, MAX_GZONES + i);
        
        ZInfo[i][_Zone] = GangZoneCreate(ZInfo[i][ZminX], ZInfo[i][ZminY], ZInfo[i][ZmaxX], ZInfo[i][ZmaxY]);

        Iter_Add(Zones, i);
    }
    return true;
}

public OnFilterScriptExit()
{
    foreach(new i : Zones)
    {
        GangZoneDestroy(ZInfo[i][_Zone]);
    }
    Streamer_DestroyAllItems(STREAMER_TYPE_AREA, 0);
    Iter_Clear(Zones);
    Iter_Clear(Gangs);

    print("---------------------------------------------------------");
    print("---SS_Gang---SQLITE----system---by---Sreyas---UnLoaded---");
    print("-------------------------------------------------------\n");
    return true;
}

public OnPlayerConnect(playerid)
{
    static const empty_player[G_USER_DATA];
    GInfo[playerid] = empty_player;

    GetPlayerName(playerid, GInfo[playerid][username], MAX_PLAYER_NAME);

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

    foreach(new i : Zones)
    {
        if(ZInfo[i][Owner] == -1) GangZoneShowForPlayer(playerid, ZInfo[i][_Zone], ZONE_COLOR);
        else GangZoneShowForPlayer(playerid, ZInfo[i][_Zone], ZInfo[i][Color]);
    }

    new query[120];
    mysql_format(CONNECT_ID, query, sizeof(query), "SELECT GangLeader,GangID FROM Members WHERE UserName = '%e' LIMIT 0, 1", GInfo[playerid][username]);
    mysql_tquery(CONNECT_ID, query, "OnMemberLoad", "i", playerid);
    
    GInfo[playerid][gang_index] = -1;
    GInfo[playerid][in_zone] = -1;
    GInfo[playerid][ganginvited] = -1;
    return true;
}

forward OnMemberLoad(playerid);
public OnMemberLoad(playerid)
{
    new str[128];
    if(cache_num_rows())
    {
        new gang_id;
        
        cache_get_value_name_int(0, "GangLeader", GInfo[playerid][gangleader]);
        cache_get_value_name_int(0, "GangID", gang_id);
        
        if (gang_id)
        {
            foreach(new i : Gangs)
            {
                if (Gang[i][gangid] == gang_id)
                {
                    GInfo[playerid][gang_index] = i;
                    break;
                }
            }

            if(IsGangMember(playerid))
            {
                SetTimerEx("GMoney", 600000, true, "i", playerid);

                if(GInfo[playerid][gangleader])
                {
                    format(str, sizeof(str), ""RED"[GANG INFO]"ORANGE"Leader"GREEN" %s "ORANGE"has Logged in!!", GInfo[playerid][username]);
                    SendGangMessage(playerid, str);
                }
                else
                {
                    format(str, sizeof(str), ""RED"[GANG INFO]"CYAN"Member"YELLOW" %s "ORANGE"has Logged in!!", GInfo[playerid][username]);
                    SendGangMessage(playerid, str);
                }
	            
                SetPlayerColor(playerid, Gang[GInfo[playerid][gang_index]][gangcolor]);
                SetTimerEx("FullyConnected", 3000, false, "i", playerid);
            }
        }
    }
    else
    {
        mysql_format(CONNECT_ID, str, sizeof(str), "INSERT INTO Members (UserName) VALUES ('%e')", GInfo[playerid][username]);
        mysql_tquery(CONNECT_ID, str, "", "");
    }
    return true;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(GInfo[playerid][inwar])
    {
        GInfo[playerid][inwar] = false;
        CheckVict(GInfo[playerid][gang_index], GInfo[playerid][gang_index] == GWar_Gang1 ? GWar_Gang2 : GWar_Gang1);
    }
    if(IsGangMember(playerid))
    {
        new str[128];
        format(str, sizeof(str), ""ORANGE"[GANGINFO]"RED" Member "CYAN"%s"RED" has Logged Out ", GInfo[playerid][username]);
        SendGangMessage(playerid, str);
    }
    return true;
}

public OnPlayerText(playerid, text[])
{
    new str[144];
    if(text[0] == '#' && IsGangMember(playerid))
    {
        format(str, sizeof(str), ""RED"[GANG CHAT]"ORANGE" %s: "WHITE"%s", GInfo[playerid][username],text[1]);
        SendGangMessage(playerid, str);
    }
    else
    {
        format(str, sizeof(str), "(%d) %s", playerid, text);
        SetPlayerChatBubble(playerid, text, 0xFFFFFFFF, 100.0, 10000);
        SendPlayerMessageToAll(playerid, str);
    }
    return false;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case GANG_COLOR:
        {
            new gang_id = GInfo[playerid][gang_index];
            if(response)
            {
                switch(listitem)
                {
                    case 0:
                    {
                        Gang[gang_id][gangcolor] = G_BLUE;
                        SetPlayerColor(playerid, G_BLUE);
                    }
                    case 1:
                    {
                        Gang[gang_id][gangcolor] = G_RED;
                        SetPlayerColor(playerid, G_RED);
                    }
                    case 2:
                    {
                        Gang[gang_id][gangcolor] = G_WHITE;
                        SetPlayerColor(playerid, G_WHITE);
                    }
                    case 3:
                    {
                        Gang[gang_id][gangcolor] = G_PINK;
                        SetPlayerColor(playerid, G_PINK);
                    }
                    case 4:
                    {
                        Gang[gang_id][gangcolor] = G_CYAN;
                        SetPlayerColor(playerid, G_CYAN);
                    }
                    case 5:
                    {
                        Gang[gang_id][gangcolor] = G_ORANGE;
                        SetPlayerColor(playerid, G_ORANGE);
                    }
                    case 6:
                    {
                        Gang[gang_id][gangcolor] = G_GREEN;
                        SetPlayerColor(playerid, G_GREEN);
                    }
                    case 7:
                    {
                        Gang[gang_id][gangcolor] = G_YELLOW;
                        SetPlayerColor(playerid, G_YELLOW);
                    }
                }
            }
            else
            {
                Gang[gang_id][gangcolor] = -1;
                SetPlayerColor(playerid, -1);
            }
            new query[144];
            mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Gangs SET GangColor = %d WHERE GangID = %d", Gang[gang_id][gangcolor], Gang[gang_id][gangid]);
            mysql_tquery(CONNECT_ID, query, "", "");
            SendGangMessage(playerid, ""RED"Leader"YELLOW" has changed gang color");
        }
        case GCP:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0: return cmd_gcp(playerid);
                    case 1: return cmd_gcp(playerid);
                    case 2: cmd_gmembers(playerid);
                    case 3: cmd_top(playerid);
                    case 4: return ShowPlayerDialog(playerid, GWAR, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Enemy Gang Name", ""GREY"Please enter the  name of enemy gang", "Start", "Cancel");
                    case 5: return ShowPlayerDialog(playerid, GKICK, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Member Name", ""GREY"Please enter the  name or id Member to Kicked", "Kick", "Cancel");
                    case 6: return ShowPlayerDialog(playerid, GTAG, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Gang Tag", ""GREY"Please enter the new tag for your Gang", "Set", "Cancel");
                    case 7: return cmd_gangcolor(playerid);
                    case 8: return ShowPlayerDialog(playerid, GLEADER, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Member Name or ID", ""GREY"Please enter the  name or id Member to Set as leader ", "Kick", "Cancel");
                }
            }
        }
        case GWAR:
        {
            if(response)
            {
                return cmd_gwar(playerid, inputtext);
            }
        }
        case GKICK:
        {
            if(response)
            {
                return cmd_gkick(playerid, inputtext);
            }
        }
        case GLEADER:
        {
            if(response)
            {
                return cmd_setleader(playerid, inputtext);
            }
        }
        case GTAG:
        {
            if(response)
            {
                return cmd_gangtag(playerid, inputtext);
            }
        }
        case ZONECREATE:
        {
            if(response)
            {
                new query[144];
                mysql_format(CONNECT_ID, query, sizeof(query), "INSERT INTO Zones (Name, MinX, minY, MaxX, MaxY) VALUES ('%e', %f, %f, %f, %f)",
                    inputtext, GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);
                mysql_tquery(CONNECT_ID, query, "", "");

                new index = Iter_Free(Zones);
                ZInfo[index][ZminX] = GInfo[playerid][minX];
                ZInfo[index][ZminY] = GInfo[playerid][minY];
                ZInfo[index][ZmaxX] = GInfo[playerid][maxX];
                ZInfo[index][ZmaxY] = GInfo[playerid][maxY];

                strcpy(ZInfo[index][Name], inputtext, 32);
                ZInfo[index][Owner] = -1;

                ZInfo[index][locked] = false;
                ZInfo[index][Owned] = false;
                
                ZInfo[index][Region] = CreateDynamicRectangle(GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);
        		Streamer_SetIntData(STREAMER_TYPE_AREA, ZInfo[index][Region], E_STREAMER_EXTRA_ID, MAX_GZONES + index);

                ZInfo[index][_Zone] = GangZoneCreate(GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);

                Iter_Add(Zones, index);
                GangZoneShowForAll(ZInfo[index][_Zone], ZONE_COLOR);
            }
        }
        default: return false;
    }
    return true;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid, playerid, reason);

    if(killerid != INVALID_PLAYER_ID)
    {
        if(GInfo[playerid][inwar])
        {
            GInfo[playerid][inwar] = false;
            SetPlayerInterior(playerid, 0);
            CheckVict(GInfo[playerid][gang_index], GInfo[killerid][gang_index]);
        }
        
        
        if(IsGangMember(playerid))
        {
            new rvg[256];
            if(IsGangMember(killerid))
            {
                new gang_id = GInfo[killerid][gang_index];
	            
                mysql_format(CONNECT_ID, rvg, sizeof(rvg), "UPDATE Gangs SET GangScore = GangScore + 1 WHERE GangID = %d", Gang[gang_id][gangid]);
                mysql_tquery(CONNECT_ID, rvg, "", "");
	            
                format(rvg, sizeof(rvg), ""GREY"The member of your gang "YELLOW"%s"GREY" has been killed by a member "RED"(%s)"GREY" of gang %s%s", GInfo[playerid][username], GInfo[killerid][username], IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname]);
            }
            else
            {
                format(rvg,sizeof(rvg), ""GREY"The member of your Gang "RED"%s "GREY"has been killed by a Player Named "RED"%s ", GInfo[playerid][username], GInfo[killerid][username]);
            }
            SendGangMessage(playerid, rvg);
        }
    }
    else
    {
        if(GInfo[playerid][inwar])
        {
            GInfo[playerid][inwar] = false;
            CheckVict(GInfo[playerid][gang_index], GInfo[playerid][gang_index] == GWar_Gang1 ? GWar_Gang2 : GWar_Gang1);
        }
    }
    return true;
}

public OnPlayerUpdate(playerid) // By Ryder
{
    if(GInfo[playerid][creatingzone])
    {
        new keys, ud, lr;
        GetPlayerKeys(playerid, keys, ud, lr);

        if(lr == KEY_LEFT)
        {
            GInfo[playerid][minX] -= 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] = GangZoneCreate(GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);
        }
        else if(lr == KEY_RIGHT)
        {
            GInfo[playerid][maxX] += 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] = GangZoneCreate(GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);
        }
        else if(ud == KEY_UP)
        {
            GInfo[playerid][maxY] += 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] = GangZoneCreate(GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);
        }
        else if(ud == KEY_DOWN)
        {
            GInfo[playerid][minY] -= 6.0;
            GangZoneDestroy(GInfo[playerid][tempzone]);
            GInfo[playerid][tempzone] = GangZoneCreate(GInfo[playerid][minX], GInfo[playerid][minY], GInfo[playerid][maxX], GInfo[playerid][maxY]);
            GangZoneShowForPlayer(playerid, GInfo[playerid][tempzone], ZONE_COLOR);
        }
        else if(keys & KEY_WALK)
        {
            GInfo[playerid][creatingzone] = false;
            TogglePlayerControllable(playerid, true);
            ShowPlayerDialog(playerid, ZONECREATE, DIALOG_STYLE_INPUT, "Input zone name", "Input the name of this gang zone", "Create", "");
            GangZoneDestroy(GInfo[playerid][tempzone]);
        }
    }
    return true;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    new zone_id = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID) - MAX_GZONES;
	
    if (zone_id >= 0)
    {
        GInfo[playerid][in_zone] = zone_id;
	    
        new str[128];
        if(ZInfo[zone_id][Owner] == -1)
        {
            format(str, sizeof(str), "~y~Zone_Info~n~~b~Name:_~r~%s~n~~b~Status:_~r~Un_Owned", ZInfo[zone_id][Name]);
            PlayerTextDrawSetString(playerid, GInfo[playerid][TextDraw], str);
        }
        else
        {
            format(str, sizeof(str), "~y~Zone_Info_~n~~b~Name:_~r~%s~n~~b~Status:_~r~Owned-by_~g~%s", ZInfo[zone_id][Name], Gang[ZInfo[zone_id][Owner]][gangname]);
            PlayerTextDrawSetString(playerid, GInfo[playerid][TextDraw], str);
        }
        PlayerTextDrawShow(playerid, GInfo[playerid][TextDraw]);
    }
    return true;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    new zone_id = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID) - MAX_GZONES;

    if (zone_id >= 0)
    {
        GInfo[playerid][in_zone] = -1;
	    
        if(GInfo[playerid][Capturing])
        {
            new msg[200], gang_id = GInfo[playerid][gang_index];
            GInfo[playerid][Capturing] = false;
            format(msg, sizeof(msg), "%s%s "ORANGE" gang has failed in capturing "GREEN" %s "ORANGE"zone.It will be locked for %d minute(s)", IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname], ZInfo[zone_id][Name], ((ZONE_LOCK_TIME) / 60));
            KillTimer(ZInfo[zone_id][timercap_main]);
            PlayerTextDrawHide(playerid, GInfo[playerid][TimerTD]);
            SendClientMessageToAll(-1, msg);

            ZInfo[zone_id][timer] = ZONE_LOCK_TIME;
            ZInfo[zone_id][locked] = true;
            ZInfo[zone_id][timer_main] = SetTimerEx("UnlockZone", 1000, true, "i", zone_id);
        }
        ZInfo[zone_id][U_Attack] = false;
        GangZoneStopFlashForAll(ZInfo[zone_id][_Zone]);
        PlayerTextDrawHide(playerid, GInfo[playerid][TextDraw]);
    }
    return true;
}

//--------------------------------COMMANDS---------------------------------------------------------------------------------------------------------------------------

CMD:creategang(playerid, params[])
{
    if (Iter_Count(Gangs) == MAX_GANGS)
	    return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY"You are unable to create a gang, the limit was reached.");
	    
    if(IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are already in a gang. Use /lg to leave it.");

    if(GetPlayerScore(playerid) < MAX_SCORE)
    {
        new str_[85];
        format(str_, sizeof(str_), ""RED"ERROR:"GREY" You need at least "GREEN"%d "GREY" score to create a gang.", MAX_SCORE);
        return SendClientMessage(playerid, -1, str_);
    }
    if(isnull(params))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" /creategang [gangname]");

    new query[100];
    mysql_format(CONNECT_ID, query, sizeof(query), "INSERT IGNORE INTO Gangs (GangName) VALUES ('%e')", params);
    mysql_tquery(CONNECT_ID, query, "OnGangCreate", "is", playerid, params);
    return true;
}

forward OnGangCreate(playerid, params[]);
public OnGangCreate(playerid, params[])
{
    if(!cache_affected_rows()) SendClientMessage(playerid, -1, ""RED"ERROR:"GREY"That name exists");
    else
    {
        new gang_id = Iter_Free(Gangs);
        
        Gang[gang_id][gangid] = cache_insert_id();
        
        GInfo[playerid][gang_index] = gang_id;
        GInfo[playerid][gangleader] = true;
        strcpy(Gang[gang_id][gangname], params, 32);
        
        new query[150];
        mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Members SET GangID = %d, GangLeader = 1 WHERE UserName = '%e'", Gang[gang_id][gangid], GInfo[playerid][username]);
        mysql_tquery(CONNECT_ID, query, "", "");

        SendClientMessage(playerid, -1, ""RED"[GANG INFO]:"GREY" You have successfully created a gang.");
        format(query, sizeof(query), ""ORANGE"%s"GREY" has created a new gang named {FFFFFF}%s", GInfo[playerid][username], params);
        SendClientMessageToAll(-1, query);

        ShowPlayerDialog(playerid, GANG_COLOR, DIALOG_STYLE_LIST, "Gang Color", ""BLUE"Blue\n"RED"Red\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow", "OK", "CANCEL");
    }
}

CMD:lg(playerid, params[])
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not in a gang");

    new gname[32], query[144], gang_id = GInfo[playerid][gang_index];
    strcpy(gname, Gang[gang_id][gangname]);
	
    if(GInfo[playerid][gangleader])
    {
        foreach(new i : Player)
        {
            if(gang_id == GInfo[i][gang_index])
            {
                GInfo[playerid][gang_index] = -1;

                if(GInfo[i][gangleader])
                {
                    GInfo[playerid][gangleader] = false;
                }
            }
        }
        mysql_format(CONNECT_ID, query, sizeof(query), "DELETE FROM Gangs WHERE GangName = '%e'", gname);
        mysql_tquery(CONNECT_ID, query, "", "");

        mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Members SET GangMember = 0, GangLeader = 0, GangName = NULL WHERE GangName = '%e'", gname);
        mysql_tquery(CONNECT_ID, query, "", "");

        format(query, sizeof(query), ""RED"Leader "YELLOW"%s"RED" Has Left Gang %s%s"RED" and Gang is Destroyed", GInfo[playerid][username], IntToHex(Gang[gang_id][gangcolor]), gname);
        SetPlayerName(playerid, GInfo[playerid][username]);
        return SendClientMessageToAll(-1, query);
    }
    GInfo[playerid][gang_index] = -1;
	
    mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Members SET GangMember = 0, GangLeader = 0, GangName = NULL WHERE UserName = '%e'", GInfo[playerid][username]);
    mysql_tquery(CONNECT_ID, query, "", "");

    format(query, sizeof(query), ""RED"%s "GREY"has left Gang %s%s", GInfo[playerid][username], IntToHex(Gang[GInfo[playerid][gang_index]][gangcolor]), gname);
    SetPlayerName(playerid, GInfo[playerid][username]);
    SendClientMessageToAll(-1, query);
    return true;
}

CMD:setleader(playerid, params[])
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"You are not in a gang.");
        
    if(!GInfo[playerid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"You are not authorized to do that.");
        
    new giveid;
    if(sscanf(params, "u", giveid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" /setleader [playerid]");

    if(giveid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, ""RED"Invalid player.");
        
    if(!IsGangMember(giveid))
        return SendClientMessage(playerid, -1, "That guy is not in a gang.");
        
    if(GInfo[playerid][gang_index] != GInfo[giveid][gang_index])
        return SendClientMessage(playerid, -1, ""RED"He is not in your gang.");

    if(GInfo[giveid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"That guy is already a leader in your gang.");

    GInfo[giveid][gangleader] = true;

    new str[128], gang_id = GInfo[playerid][gang_index];
    format(str, sizeof(str), ""YELLOW"%s"GREY" is promoted to Gang Leader of %s%s", GInfo[giveid][username], IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname]);
    SendClientMessageToAll(-1, str);

    mysql_format(CONNECT_ID, str, sizeof(str), "UPDATE Members SET GangLeader = 1 WHERE UserName = '%e'", GInfo[giveid][username]);
    mysql_tquery(CONNECT_ID, str, "", "");
    return true;
}

CMD:demote(playerid, params[])
{
	if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"You are not in a gang.");

    if(!GInfo[playerid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"You are not authorized to do that.");

    new giveid;
    if(sscanf(params, "u", giveid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" /demote [playerid]");

    if(giveid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, ""RED"Invalid player.");
        
    if(!IsGangMember(giveid))
        return SendClientMessage(playerid, -1, ""RED"That guy is not in a gang.");

    if(GInfo[playerid][gang_index] != GInfo[giveid][gang_index])
        return SendClientMessage(playerid, -1, ""RED"He is not in your gang.");
        
    if(!GInfo[giveid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"That guy is not head of your gang.");

    GInfo[giveid][gangleader] = false;

    new str[144], gang_id = GInfo[playerid][gang_index];
    format(str, sizeof(str), ""YELLOW"%s"GREY" is demoted from Gang Leader postion of %s%s", GInfo[giveid][username], IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname]);
    SendClientMessageToAll(-1, str);

    mysql_format(CONNECT_ID, str, sizeof(str), "UPDATE Members SET GangLeader = 0 WHERE UserName = '%e'", GInfo[giveid][username]);
    mysql_tquery(CONNECT_ID, str, "", "");
    return true;
}

CMD:ginvite(playerid, params[])
{
    if(!GInfo[playerid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"You are not authorized to do that.");

    new giveid;
    if(sscanf(params, "u", giveid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" /ginvite [playerid]");
        
    if(giveid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, ""RED"Invalid player.");
        
    if(IsGangMember(giveid))
        return SendClientMessage(playerid, -1, ""RED"He is already in a gang.");

    GInfo[giveid][ganginvited] = GInfo[playerid][gang_index];

    SendClientMessage(playerid, -1, ""GREEN"Invitation successfully sent.");
    SendClientMessage(giveid, -1, ""GREEN"You have received a gang invitation /accept or /decline to accept or decline.");
    return true;
}

CMD:top(playerid)
{
    mysql_tquery(CONNECT_ID, "SELECT GangName, GangScore, GangColor FROM Gangs ORDER BY GangScore DESC limit 0, 10", "OnGangRankBoardLoad", "i", playerid);
    return true;
}

forward OnGangRankBoardLoad(playerid);
public OnGangRankBoardLoad(playerid)
{
    new rowCount = cache_num_rows(), i, db_Score, db_Name[30], db_Color, string[512];
    for(i = 0; i < rowCount; ++i)
    {
        cache_get_value_name(i, "GangName", db_Name);
        cache_get_value_name_int(i, "GangScore", db_Score);
        cache_get_value_name_int(i, "GangColor", db_Color);
        format(string, sizeof(string), "%s\n"WHITE"%d.)%s %s"CYAN "scores:"ORANGE" %i", string, i + 1, IntToHex(db_Color), db_Name, db_Score);
    }
    ShowPlayerDialog(playerid, GTOP, DIALOG_STYLE_MSGBOX, ""RED"Top Gangs", string, "Close", "");
    return true;
}

CMD:gmembers(playerid)
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not a gang member.");

    new query[150];
    mysql_format(CONNECT_ID, query, sizeof(query), "SELECT UserName FROM Members WHERE GangID = %d", Gang[GInfo[playerid][gang_index]][gangid]);
    mysql_tquery(CONNECT_ID, query, "OnGangMembersLoad", "i", playerid);
    return true;
}

forward OnGangMembersLoad(playerid);
public OnGangMembersLoad(playerid)
{
    new rowCount = cache_num_rows(), i, name[30], string[512];
    for(i = 0; i < rowCount; ++i)
    {
        cache_get_value_name(i, "UserName", name);
        format(string, sizeof(string), "%s\n"WHITE"%d.)"RED"%s", string, i + 1, name);
    }
    ShowPlayerDialog(playerid, GMEMBERS, DIALOG_STYLE_MSGBOX, ""RED"GANG MEMBERS", string, "Close", "");
    return true;
}

CMD:decline(playerid)
{
    if(GInfo[playerid][ganginvited] == -1)
        return SendClientMessage(playerid, -1, ""RED"You didn't receive any invitations.");

    SendClientMessage(playerid, -1, "You declined the invitation.");
    GInfo[playerid][ganginvited] = -1;
    return true;
}

CMD:accept(playerid)
{
    if(GInfo[playerid][ganginvited] == -1)
        return SendClientMessage(playerid, -1, ""RED"You didn't receive any invitations.");

    SendClientMessage(playerid, -1, ""GREEN"You accepted invitation and you are now a gang member.");
    
    new gang_id;
    gang_id = GInfo[playerid][gang_index] = GInfo[playerid][ganginvited];
    GInfo[playerid][ganginvited] = -1;

    new query[200];
    mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Members SET GangID = %d WHERE UserName = '%e'", Gang[gang_id][gangid], GInfo[playerid][username]);
    mysql_tquery(CONNECT_ID, query, "", "");
    
    SetPlayerColor(playerid, Gang[gang_id][gangcolor]);
    return true;
}

CMD:gkick(playerid, params[])
{
	if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not a gang member.");

    if(!GInfo[playerid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not authorized to do it.");
        
    new giveid;
    if(sscanf(params, "u", giveid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" /gkick [playerid]");

    if(giveid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, ""RED"Invalid player.");
        
    if(GInfo[giveid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You can't kick a group leader.");

    new query[144], gang_id = GInfo[giveid][gang_index];
    mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Members SET GangID = 0 WHERE UserName = '%e'", GInfo[giveid][username]);
    mysql_tquery(CONNECT_ID, query, "", "");

    format(query,sizeof(query), ""YELLOW"%s"GREY" has Kicked from Gang %s%s "GREY"by GangLeader "BLUE"%s", GInfo[giveid][username], IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname], GInfo[playerid][username]);
    SendClientMessageToAll(-1, query);
    
    GInfo[giveid][gang_index] = -1;
    return true;
}

CMD:gangtag(playerid, params[])
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"You are not a gang member.");

    if(!GInfo[playerid][gangleader])
        return SendClientMessage(playerid, -1, ""RED" You are not authorized to do this.");

    if(isnull(params))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY"/gangtag [newtag]");

    if(strlen(params) > 3)
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" tag can only be up to 3 characters long.");

    new query[120], gang_id = GInfo[playerid][gang_index];
    mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Gangs SET GangTag = '%e' WHERE GangID = %d", params, Gang[gang_id][gangid]);
    mysql_tquery(CONNECT_ID, query, "", "");

    new newname[MAX_PLAYER_NAME + 1], i;
    foreach(i : Player)
    {
        if(GInfo[i][gang_index] == gang_id)
        {
            format(newname, sizeof(newname), "%s[%s]", GInfo[i][username], params);
            SetPlayerName(i, newname);
            SendClientMessage(i, -1, ""RED"Leader "WHITE"has set new tag for gang.");
        }
    }
    return true;
}

CMD:gangcolor(playerid)
{
    if(!GInfo[playerid][gangleader])
	    return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not authorized to do this.");
	    
    ShowPlayerDialog(playerid, GANG_COLOR, DIALOG_STYLE_LIST, "Gang Color", ""BLUE"Blue\n"RED"Red\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow", "OK", "CANCEL");
    return true;
}

CMD:gwar(playerid, params[])
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not a gang member.");

    if(!GInfo[playerid][gangleader])
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not authorized to do this.");

    if(ActiveWar)
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" There is a war going on right now. Wait till it's finished.");

    if(isnull(params))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" /gwar gangname");

    new EnemiesOnline;
    
    foreach(new i : Gangs)
    {
        if (!strcmp(Gang[i][gangname], params, true))
        {
            GWar_Gang1 = i;
            break;
        }
    }
    
    if (GWar_Gang1 == -1)
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" There isn't any gang with this name.");
        
    foreach(new i : Player)
    {
        if(GWar_Gang1 == GInfo[i][gang_index])
        {
            EnemiesOnline++;
        }
    }
    if(EnemiesOnline == 0)
        return SendClientMessage(playerid, -1, ""RED"There are no members of that gang online.");

    GWar_Gang1 = -1;
    GWar_Gang2 = GInfo[playerid][gang_index];
    foreach(new i : Player)
    {
        if(GInfo[i][gang_index] == GWar_Gang1 || GInfo[i][gang_index] == GWar_Gang2)
        {
            GInfo[i][inwar] = true;
            new ranIndex = random(sizeof(RandomSpawnsGW));
            SetPlayerPos(i, RandomSpawnsGW[ranIndex][0], RandomSpawnsGW[ranIndex][1], RandomSpawnsGW[ranIndex][2]);
            SetPlayerInterior(i, 1);
            ResetPlayerWeapons(i);
            TogglePlayerControllable(i, false);
        }
    }
    ActiveWar = true;
    SetTimerEx("GangWar", 10000, false, "ii", GWar_Gang1, GWar_Gang2);

    new str[144];
    format(str, sizeof(str), "%s%s"WHITE" has started a war against %s%s "WHITE" and will start in "YELLOW"10 seconds.", IntToHex(Gang[GWar_Gang2][gangcolor]), Gang[GWar_Gang2][gangname], IntToHex(Gang[GWar_Gang1][gangcolor]), params);
    SendClientMessageToAll(-1, str);
    return true;
}

CMD:gcp(playerid)
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not a gang member.");

    new query[100], gang_id = GInfo[playerid][gang_index];
    mysql_format(CONNECT_ID, query, sizeof(query), "SELECT GangScore FROM Gangs WHERE GangID = %d", Gang[gang_id][gangid]);
    mysql_tquery(CONNECT_ID, query, "OnGangScoreLoad", "ii", playerid, gang_id);
    return true;
}

forward OnGangScoreLoad(playerid, gang_id);
public OnGangScoreLoad(playerid, gang_id)
{
    new rowCount = cache_num_rows(), gangScore;
    if(rowCount)
    {
        cache_get_value_name_int(0, "GangScore", gangScore);
    }

    new str[300];
    format(str, sizeof(str), ""RED"GangName\t:\t%s%s\n"PINK"GangScore\t:\t"GREEN"%d"WHITE"\nGangMembers\nTop Gangs\nGang War\nKick Member \nChange Tag \nChange Color\nSet Leader", IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname], gangScore);
    ShowPlayerDialog(playerid, GCP, DIALOG_STYLE_LIST, ""RED"Gang control panel", str, "Ok", "Cancel");
    return true;
}

CMD:createzone(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY "You are not authorized to use this command.");

    if(GInfo[playerid][creatingzone])
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are already creating a zone. Complite it using the LEFT ALT key.");

    new Float:tempZ;
    GetPlayerPos(playerid, GInfo[playerid][minX], GInfo[playerid][minY], tempZ);
    GetPlayerPos(playerid, GInfo[playerid][maxX], GInfo[playerid][maxY], tempZ);

    SendClientMessage(playerid, -1, "Use "YELLOW" the left, right, forward and backward "RED"keys to change the size of this zone.");
    SendClientMessage(playerid, -1, "Use "YELLOW" the walk "RED"key to stop the process.");
    GInfo[playerid][creatingzone] = true;
    GInfo[playerid][tempzone] = -1;
    TogglePlayerControllable(playerid, false);
    return true;
}

CMD:capture(playerid)
{
    if(!IsGangMember(playerid))
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You are not in any gang.");

    new i = GInfo[playerid][in_zone];
    if(i == -1)
        return SendClientMessage(playerid, -1, ""RED"ERROR:"GREY" You should be in a gang zone to use this command.");

    new str[150];

    if(ZInfo[i][locked])
    {
        format(str, sizeof(str), ""GREY"This zone is locked. Come back in "YELLOW"%d "GREY"seconds.", ZInfo[i][timer]);
        return SendClientMessage(playerid, -1, str);
    }
    if(GInfo[playerid][Capturing])
        return SendClientMessage(playerid, -1, ""RED"ERROR: "GREY"You are capturing this zone!");

    if(ZInfo[i][U_Attack])
        return SendClientMessage(playerid, -1, ""RED"ERROR: "GREY"Another gang is already set an attack on this zone.");

    new gang_id = GInfo[playerid][gang_index];
    if(gang_id == ZInfo[i][Owner])
        return SendClientMessage(playerid, -1, ""RED"ERROR: "GREY"Your gang owns this zone already.");

    GangZoneFlashForAll(ZInfo[i][_Zone], 0xFF0000AA);
    GInfo[playerid][Capturing] = true;
    ZInfo[i][U_Attack] = true;

    format(str, sizeof(str), "%s%s"ORANGE" gang has started to capture"GREEN" %s"ORANGE" zone.", IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname], ZInfo[i][Name]);
    SendClientMessageToAll(-1, str);
    ZInfo[i][timercap] = ZONE_CAPTURE_TIME;
    ZInfo[i][timercap_main] = SetTimerEx("CaptureZone", 1000, true, "ii", playerid, i);
    return true;
}

CMD:zones(playerid)
{
    new string[900], i;
    foreach(i : Zones)
    {
        if(ZInfo[i][Owner] == -1)
            format(string, sizeof(string), "%s"GREEN"%d.)"RED"%s\n", string, (i + 1), ZInfo[i][Name]);
        else
            format(string, sizeof(string), "%s"GREEN"%d.)"RED"%s"YELLOW" %s(%s)\n", string, (i + 1), ZInfo[i][Name], IntToHex(ZInfo[i][Color]), Gang[ZInfo[i][Owner]][gangname]);
    }
    ShowPlayerDialog(playerid, ZONES, DIALOG_STYLE_MSGBOX, ""ORANGE"Zones"PINK"           Owned By", string, "Cancel", "");
    return true;
}

CMD:ghelp(playerid)
{
    new string[1164];
    strcat(string, ""GREEN"\t/creategang\t\t"WHITE"-\t"ORANGE"To create a gang\n");
    strcat(string, ""GREEN"\t/gangmembers\t"WHITE"-\t"ORANGE"To view all gangmembers\n");
    strcat(string, ""GREEN"\t/lg\t\t\t"WHITE"-\t"ORANGE"To leave the gang\n");
    strcat(string, ""GREEN"\t/accept\t\t\t"WHITE"-\t"ORANGE"To accept an invitation to a gang\n");
    strcat(string, ""GREEN"\t/decline\t\t"WHITE"-\t"ORANGE"To decline an invitation to a gang\n");
    strcat(string, ""GREEN"\t/top\t\t\t"WHITE"-\t"ORANGE"To view all top 10 gangs\n");
    strcat(string, ""GREEN"\t/gangcolor\t\t"WHITE"-\t"ORANGE"To change gangcolor\n");
    strcat(string, ""GREEN"\t/gkick\t\t\t"WHITE"-\t"ORANGE"To kick a gangmember\n");
    strcat(string, ""GREEN"\t/gwar\t\t\t"WHITE"-\t"ORANGE"To challenge other  gang for a war\n");
    strcat(string, ""GREEN"\t/gcp\t\t\t"WHITE"-\t"ORANGE"To view all gang control panel\n");
    strcat(string, ""GREEN"\t/capture\t\t"WHITE"-\t"ORANGE"To capture a  gangzone\n");
    strcat(string, ""GREEN"\t/zones\t\t\t"WHITE"-\t"ORANGE"To view all gangzones and their details\n");
    strcat(string, ""GREEN"\t/createzone\t\t"WHITE"-\t"ORANGE"To create a gangzone\n");
    strcat(string, ""GREEN"\t/gangtag\t\t"WHITE"-\t"ORANGE"To change gang tag\n");
    strcat(string, ""GREEN"\t/ginvite\t\t"WHITE"-\t"ORANGE"To invite other players to the gang\n");
    strcat(string, ""GREEN"\t/setleader\t\t"WHITE"-\t"ORANGE"To set a member as gangleader\n");
    strcat(string, ""GREEN"\t/demote\t\t"WHITE"-\t"ORANGE"To demote a member from gang leader position\n");
    strcat(string, ""GREEN"\t/ghelp\t\t\t"WHITE"-\t"ORANGE"To view this dialog");
    ShowPlayerDialog(playerid, GHELP, DIALOG_STYLE_MSGBOX, ""RED"SS GANG SYSTEM BY SREYAS", string, "OK", "");
    return true;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//-Custom Functions--------------------------------------------------------------------------------------------------------------------------------------------------------

forward CaptureZone(playerid, zoneid);
public CaptureZone(playerid, zoneid)
{
    ZInfo[zoneid][timercap]--;
    new str[34];
    format(str, sizeof(str), "%02d-%02d", (ZInfo[zoneid][timercap] / 60), ZInfo[zoneid][timercap]);
    PlayerTextDrawSetString(playerid, GInfo[playerid][TimerTD], str);
    PlayerTextDrawShow(playerid, GInfo[playerid][TimerTD]);

    if(ZInfo[zoneid][timercap] == 0)
    {
        new string[128], gang_id = GInfo[playerid][gang_index];
        format(string, sizeof(string), ""RED"your gang zone is captured by"YELLOW" %s %sgang.", IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname]);
        PlayerTextDrawHide(playerid, GInfo[playerid][TimerTD]);

        foreach(new i : Player)
        {
            if(ZInfo[zoneid][Owner] == gang_id)
            {
                SendClientMessage(i, -1, string);
            }
        }
        if(ZInfo[zoneid][U_Attack])
        {
            new color = (Gang[gang_id][gangcolor] & ~0xFF) | 50;
            
            GangZoneStopFlashForAll(ZInfo[zoneid][_Zone]);
            GangZoneShowForAll(ZInfo[zoneid][_Zone], color);

            ZInfo[zoneid][Owner] = gang_id;
            ZInfo[zoneid][locked] = true;
            ZInfo[zoneid][Color] = color;

            new query[200];
            mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Zones SET Owner = %i, Color = %i, WHERE Name = '%e'", Gang[gang_id][gangid], ZInfo[zoneid][Color], ZInfo[zoneid][Name]);
            mysql_tquery(CONNECT_ID, query, "", "");

            format(query, sizeof(query), "%s%s "ORANGE" gang has successsfully captured"GREEN" %s "ORANGE"zone. It will be locked for "RED"%d "ORANGE"minute(s)", IntToHex(Gang[gang_id][gangcolor]), Gang[gang_id][gangname], ZInfo[zoneid][Name], ((ZONE_LOCK_TIME) / 60));
            SendClientMessageToAll(-1, query);

            ZInfo[zoneid][timer] = ZONE_LOCK_TIME;
            ZInfo[zoneid][timer_main] = SetTimerEx("UnlockZone", 1000, true, "i", zoneid);
            ZInfo[zoneid][U_Attack] = false;
            GInfo[playerid][Capturing] = false;

            mysql_format(CONNECT_ID, query, sizeof(query), "UPDATE Gangs SET GangScore = GangScore + 10 WHERE GangID = '%e'", Gang[gang_id][gangid]);
            mysql_tquery(CONNECT_ID, query, "", "");
        }
        KillTimer(ZInfo[zoneid][timercap_main]);
    }
    return true;
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
    return true;
}

forward GangWar(gang1, gang2);
public GangWar(gang1, gang2)
{
    new count1, count2;
    foreach(new i : Player)
    {
        if(gang1 == GInfo[i][gang_index]) count1++;
        else if (gang2 == GInfo[i][gang_index]) count2++;
        else continue;

        GivePlayerWeapon(i, 34, 100);
        SetPlayerHealth(i, 100);
        SetPlayerArmour(i, 100);
        TogglePlayerControllable(i, true);
        GameTextForPlayer(i, "~w~War ~g~has ~r~started", 5000, 5);
    }
    if(count1 == 0 || count2 == 0)
    {
        foreach(new i : Player)
        {
            if(GInfo[i][inwar] == true)
            {
                GInfo[i][inwar] = false;
                SpawnPlayer(i);
            }
        }
        ActiveWar = false;
        GWar_Gang1 = -1;
        GWar_Gang2 = -1;
        SendClientMessageToAll(-1, ""RED"Gang war ended due to low participants.");
    }
    return true;
}

forward GMoney(playerid);
public GMoney(playerid)
{
    GivePlayerMoney(playerid, 100);
    GameTextForPlayer(playerid, "~w~RECEIVED ~g~$100 ~w~FROM GANG HQ FOR YOUR SERVICE!", 5000, 5);
    return true;
}

forward FullyConnect(playerid);
public FullyConnect(playerid)
{
    new newname[MAX_PLAYER_NAME];
    format(newname, sizeof(newname), "%s[%s]", GInfo[playerid][username], Gang[GInfo[playerid][gang_index]][gangtag]);
    SetPlayerName(playerid, newname);
    return true;
}

SendGangMessage(playerid, message[])
{
    foreach(new i : Player)
    {
        if(GInfo[playerid][gang_index] == GInfo[i][gang_index])
        {
            SendClientMessage(i, -1, message);
        }
    }
    return false;
}

CheckVict(gang1, gang2)
{
    new count1, count2;
    foreach(new i : Player)
    {
        if(GInfo[i][inwar])
        {
            if(gang1 == GInfo[i][gang_index])
            {
                count1++;
            }
            else if(gang2 == GInfo[i][gang_index])
            {
                count2++;
            }
        }
    }
    if(count1 == 0 || count2 == 0)
    {
        foreach(new i : Player)
        {
            if(GInfo[i][inwar])
            {
                GInfo[i][inwar] = false;
                SetPlayerInterior(i, 0);
                SpawnPlayer(i);
            }
        }
        new str[128], winner = !count1 ? gang2 : gang1, looser = !count2 ? gang2 : gang1;
        
        format(str, sizeof(str), "%s%s "WHITE"has won the war against %s%s", IntToHex(Gang[winner][gangcolor]), Gang[winner][gangname], IntToHex(Gang[looser][gangcolor]), Gang[looser][gangname]);
        SendClientMessageToAll(-1, str);
        ActiveWar = false;
        GWar_Gang1 = -1;
        GWar_Gang1 = -2;

        mysql_format(CONNECT_ID, str, sizeof(str), "UPDATE Gangs SET GangScore = GangScore + 5 WHERE GangID = %d", Gang[winner][gangid]);
        mysql_tquery(CONNECT_ID, str, "", "");
    }
    return true;
}

IntToHex(var)
{
    new hex[9];
    format(hex, sizeof(hex), "{%06x}", var >>> 8);
    return hex;
}

IsGangMember(playerid)
{
	return GInfo[playerid][gang_index] != -1;
}
