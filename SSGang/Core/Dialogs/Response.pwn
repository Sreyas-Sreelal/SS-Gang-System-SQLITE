
#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        
        case GCP:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0: return cmd_gcp(playerid);
                    case 1: return cmd_gcp(playerid);
                    case 2: return cmd_gmembers(playerid);
                    case 3: return cmd_top(playerid);
                    case 4: return ShowPlayerDialog(playerid, GWAR, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Enemy Gang Name", ""GREY"Please enter the  name of enemy gang", "Start", "Cancel");
                    case 5: return ShowPlayerDialog(playerid, GKICK, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Member Name", ""GREY"Please enter the  name or id Member to Kicked", "Kick", "Cancel");
                    case 6: return ShowPlayerDialog(playerid, GTAG, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Gang Tag", ""GREY"Please enter the new tag for your Gang", "Set", "Cancel");
                    case 7: return cmd_gangcolor(playerid);
                    case 8: return ShowPlayerDialog(playerid, GLEADER, DIALOG_STYLE_INPUT, ""ORANGE"SS Gang - Input Member Name or ID", ""GREY"Please enter the  name or id Member to Set as leader ", "Kick", "Cancel");
                }
            }
            return 1;
        }


        case GWAR :
        {
            if(response)
                return cmd_gwar(playerid,inputtext);
            
        }

        case GKICK:
        {
            if(response)
                return cmd_gkick(playerid,inputtext);
            
        }

        case GLEADER:
        {
            if(response)
                return cmd_setleader(playerid,inputtext);
            
        }

        case GTAG:
        {
            if(response)
                 return cmd_gangtag(playerid,inputtext);
            
        }

        

    }
    return 1;
}
