//-------------------------------------------------
//
// Script to FUS RO DAH other players in SA-MP
// Requires zcmd include.
//
// Scott Reed (h02) 2012
//
//-------------------------------------------------

#include <a_samp>
#include <zcmd>

CMD:fus(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new giveplayerid=strval(params);
		if(IsPlayerConnected(giveplayerid))
		{
		    new Float:X, Float:Y, Float:Z;
		    GetPlayerPos(giveplayerid, X, Y, Z);
		    for(new i;i<MAX_PLAYERS;i++)
		    {
				if(IsPlayerConnected(i) && IsPlayerStreamedIn(giveplayerid, i) && IsPlayerInRangeOfPoint(i, 30.0, X, Y, Z))
				{
		    		PlayAudioStreamForPlayer(i, "http://dl.dropbox.com/u/44207623/fus.mp3", X, Y, Z, 30.0, 1);
		        }
		   	}
		   	SetTimerEx("fusani", 2000, false, "i", playerid);
	    	SetTimerEx("fusvel", 5500, false, "i", giveplayerid);
		}
	}
	return 1;
}

forward fusani(playerid);
public fusani(playerid)
{
    ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

forward fusvel(playerid);
public fusvel(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) SetVehicleVelocity(GetPlayerVehicleID(playerid), 1.0,0.0,1.0);
	else SetPlayerVelocity(playerid,1.0,0.0,1.0);
    return 1;
}
