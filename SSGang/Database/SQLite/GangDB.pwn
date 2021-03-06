/*

GangDB.pwn - Contains DB handling to Gangs table

*/

#include <YSI\y_hooks>

hook OnFilterScriptInit()
{
	db_query(Database,"CREATE TABLE IF NOT EXISTS Gangs (\
                                                          GangID  INTEGER PRIMARY KEY AUTOINCREMENT,\
                                                          GangName  VARCHAR(24) UNIQUE NOT NULL COLLATE NOCASE,\
                                                          GangColor INTEGER,\
                                                          GangTag VARCHAR(4),\
                                                          GangScore INTEGER DEFAULT 0\
                                                        )");
	return 1;
}