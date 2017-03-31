forward FullyConnect(playerid);
public FullyConnect(playerid)
{
    printf("FULLY CONNCTED ");
    if(!isnull(GInfo[playerid][gangtag]))
    {
        new newname[24];
        format(newname,sizeof newname,"%s[%s]",GInfo[playerid][username],GInfo[playerid][gangtag]);
        SetPlayerName(playerid,newname);
        SetPlayerColor(playerid,GInfo[playerid][gangcolor]);
    }
    return 1;
}




