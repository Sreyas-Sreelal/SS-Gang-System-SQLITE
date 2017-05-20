
CMD:ghelp(playerid)
{
    new string[1164];
    
    strcat(string,""GREEN"\t/creategang\t\t"WHITE"-\t"ORANGE"To create a gang\n");
    strcat(string,""GREEN"\t/gmembers\t"WHITE"-\t"ORANGE"To view all gangmembers\n");
    strcat(string,""GREEN"\t/lg\t\t\t"WHITE"-\t"ORANGE"To leave the gang\n");
    strcat(string,""GREEN"\t/accept\t\t\t"WHITE"-\t"ORANGE"To accept an invitation to a gang\n");
    strcat(string,""GREEN"\t/decline\t\t"WHITE"-\t"ORANGE"To decline an invitation to a gang\n");
    strcat(string,""GREEN"\t/top\t\t\t"WHITE"-\t"ORANGE"To view all top 10 gangs\n");
    strcat(string,""GREEN"\t/gangcolor\t\t"WHITE"-\t"ORANGE"To change gangcolor\n");
    strcat(string,""GREEN"\t/gkick\t\t\t"WHITE"-\t"ORANGE"To kick a gangmember\n");
    strcat(string,""GREEN"\t/gwar\t\t\t"WHITE"-\t"ORANGE"To challenge other  gang for a war\n");
    strcat(string,""GREEN"\t/gcp\t\t\t"WHITE"-\t"ORANGE"To view all gang control panel\n");
    strcat(string,""GREEN"\t/capture\t\t"WHITE"-\t"ORANGE"To capture a  gangzone\n");
    strcat(string,""GREEN"\t/zones\t\t\t"WHITE"-\t"ORANGE"To view all gangzones and their details\n");
    strcat(string,""GREEN"\t/createzone\t\t"WHITE"-\t"ORANGE"To create a gangzone\n");
    strcat(string,""GREEN"\t/gangtag\t\t"WHITE"-\t"ORANGE"To change gang tag\n");
    strcat(string,""GREEN"\t/ginvite\t\t"WHITE"-\t"ORANGE"To invite other players to the gang\n");
    strcat(string,""GREEN"\t/setleader\t\t"WHITE"-\t"ORANGE"To set a member as gangleader\n");
    strcat(string,""GREEN"\t/demote\t\t"WHITE"-\t"ORANGE"To demote a member from gang leader position\n");
    strcat(string,""GREEN"\t/ghelp\t\t\t"WHITE"-\t"ORANGE"To view this dialog");
    
    ShowPlayerDialog(playerid,GHELP,DIALOG_STYLE_MSGBOX,""RED"SS GANG SYSTEM BY SREYAS",string,"OK","");
    return 1;
}

CMD:decline(playerid)
{
    if(GInfo[playerid][ganginvite] == false) return SendClientMessage(playerid,-1,""RED"You didnt recieve any invitations");

    SendClientMessage(playerid,-1,"You declined the invitation");
    GInfo[playerid][ganginvite] = false;
    return 1;
}

CMD:gangcolor(playerid)
{
    ShowPlayerDialog(playerid,GANG_COLOR,DIALOG_STYLE_LIST,"Gang Color",""BLUE"Blue\n"RED"RED\n"WHITE"White\n"PINK"Pink\n"CYAN"Cyan\n"ORANGE"Orange\n"GREEN"Green\n"YELLOW"Yellow","OK","CANCEL");
    return 1;
}

CMD:ginvite(playerid,params[])
{
    if(GInfo[playerid][gangmember] == 0) return SendClientMessage(playerid,-1,""RED"You are not in a gang!");
    if(GInfo[playerid][gangleader] == 0 ) return SendClientMessage(playerid,-1,""RED"You are not authorised to do that");
  
    new giveid;
    
    if(sscanf(params,"u",giveid)) return SendClientMessage(playerid,-1,""RED"Error:"GREY"/ginvite playerid");
    if(giveid == INVALID_PLAYER_ID) return SendClientMessage(playerid,-1,""RED"Invalid player!");
    if(GInfo[giveid][gangmember] == 1) return SendClientMessage(playerid,-1,""RED"He is already in a gang");

    GInfo[giveid][ganginvite] = true;
    SendClientMessage(playerid,-1,""GREEN"Invitation send successfully");
    SendClientMessage(giveid,-1,""GREEN"You have recieved a gang invitation /accept or /decline to accept or decline ");
    GInfo[giveid][invitedid] = GInfo[playerid][gangid];
    return 1;
}
