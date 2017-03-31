#include <YSI\y_hooks>

hook OnFilterScriptExit()
{
    foreach(new i : Zones)
    {
        GangZoneDestroy(ZInfo[i][ Zone_Wrapper]);
        Area_Delete(ZInfo[i][Region]);
    }

    Iter_Clear(Zones);
       
    return 1;
}