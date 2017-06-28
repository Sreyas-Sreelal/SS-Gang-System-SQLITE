
/*
GangData.pwn - Contains defintions of constants and variables that are relevant to the gang member's part
*/
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
    PlayerText:TimerTD,
    warid = INVALID_WAR_ID
};

new 
	GInfo[MAX_PLAYERS][G_USER_DATA],
	Iterator:WarArenas<MAX_GANG_WARS>,
    bool:ActiveWar[MAX_GANG_WARS];
    

new const 
    		Reset_Gang_Enum[G_USER_DATA],
    		Float:RandomSpawnsGW [ ][ ][ ] =
    		{
    		    
                { //Driving school ground
                    {-2063.4272,-268.0447,35.3274,353.6908},
        		    {-2092.9961,-243.0618,35.3203,263.6907},
        		    {-2093.1350,-143.5839,35.3203,263.6907},
        		    {-2094.5271,-107.3827,35.3203,198.9026},
                    {-2016.7467,-117.4055,35.1909,200.4927}
                    
                    
                },
    		    
                { //Field
                    {-1007.0177,-1061.6558,129.2188,67.8079},
                    {-1012.4520,-1012.1425,129.2126,95.0681},
                    {-1013.7773,-987.6338,129.2188,117.9417},
                    {-1059.6803,-913.7853,129.2119,177.4756},
                    {-1115.9939,-948.7264,129.2188,254.2430}
                },
                
                { //Dam
                    {-846.8908,2019.5038,60.1875,298.4453},
                    {-812.1741,2016.5128,60.3906,38.3996},
                    {-806.6881,2050.6653,60.1875,182.8242},
                    {-776.8618,2035.6453,60.3906,31.5062},
                    {-781.8876,2104.6047,60.3828,200.6846}
                    
                }
            
            
            
            };



