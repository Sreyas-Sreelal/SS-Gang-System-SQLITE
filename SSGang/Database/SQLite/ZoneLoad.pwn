
#include <YSI\y_hooks>

hook OnFilterScriptInit()
{
	db_query(Database,"CREATE TABLE IF NOT EXISTS Zones (\
                                                          Name VARCHAR(32) COLLATE NOCASE,\
                                                          OwnerID  INT(3) DEFAULT 0,\
                                                          MinX FLOAT,\
                                                          MinY FLOAT,\
                                                          MaxX FLOAT,\
                                                          MaxY FLOAT\
                                                        )");
	new  
        DBResult:Result,
                 iter;
    Result = db_query(Database,"SELECT NAME,MinX,MinY,MaxX,MaxY,GangName,GangCOLOR \
                                FROM ZONES \
                                LEFT JOIN GANGS ON ZONES.OWNERID = GANGS.GANGID");

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
            db_get_field_assoc(Result, "GangName", ZInfo[iter][Owner], 32);
            
            ZInfo[iter][Color] = db_get_field_assoc_int(Result, "GangColor");
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
            #if DEBUG == true
                printf("Iter : %d Name : %s COLOR : %d min x : %d y :%d max x :%d y :%d ",
                        iter,ZInfo[iter][Name],
                        ZInfo[iter][Color],
                        ZInfo[iter][ZminX],
                        ZInfo[iter][ZminY],
                        ZInfo[iter][ZmaxX],
                        ZInfo[iter][ZmaxX]
                      );
            #endif


        } while(db_next_row(Result));
    }

    db_free_result( Result );
	return 1;
}