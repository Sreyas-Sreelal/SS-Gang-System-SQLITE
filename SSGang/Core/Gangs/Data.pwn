


enum G_USER_DATA
{
    
    gangname[32],
    gangid,
    gangmember,
    gangleader,
    username[MAX_PLAYER_NAME],
    invitedid,
    gangcolor,
    gangtag[4],
    tempzone,
    bool:ganginvite,
    bool:Capturing,
    bool:inwar,
    bool:creatingzone,
    Float:minX, 
    Float:minY,
    Float:maxX,
    Float:maxY,
    PlayerText:TextDraw,
    PlayerText:TimerTD
};

new 
	GInfo[MAX_PLAYERS][G_USER_DATA],
	bool:ActiveWar = false;
    

new const 
    		Reset_Gang_Enum[G_USER_DATA],
    		Float:RandomSpawnsGW[ ][ ] =
    		{
    		    {1390.2234,-46.3298,1000.9236,5.7688},
    		    {1417.2269,-45.6457,1000.9274,53.0826},
    		    {1393.3025,-33.7530,1007.8823,89.6141},
    		    {1365.5669,2.3778,1000.9285,11.9068}
    		};



