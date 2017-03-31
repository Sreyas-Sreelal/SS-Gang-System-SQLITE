#include <YSI\y_hooks>

new DB:Database;
hook OnFilterScriptInit()
{
	Database = db_open("gang.db");
    db_query( Database, "PRAGMA synchronous = OFF" );
	return 1;
}

hook OnFilterScriptExit()
{
	db_close(Database);
	return 1;
}