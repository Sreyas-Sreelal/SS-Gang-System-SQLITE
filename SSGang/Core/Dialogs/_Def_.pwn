#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
    printf("TEST CALL BACK");
    return 1;
}

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