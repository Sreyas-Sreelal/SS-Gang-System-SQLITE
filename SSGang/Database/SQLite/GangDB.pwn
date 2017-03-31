#include <YSI\y_hooks>

hook OnFilterScriptInit()
{
	db_query(Database,"CREATE TABLE IF NOT EXISTS Gangs (\
                                                          GangID  INTEGER PRIMARY KEY AUTOINCREMENT,\
                                                          GangName  VARCHAR(24),\
                                                          GangColor INTEGER,\
                                                          GangTag VARCHAR(4),\
                                                          GangScore INTEGER DEFAULT 0\
                                                        )");
	return 1;
}