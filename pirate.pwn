//-------------------------------------------------
//
// Script to control flying pirate ship with arrow keys
// Requires zcmd include.
//
// Scott Reed (h02) 2011
//
//-------------------------------------------------

#include <a_samp>
#include <zcmd>

#define SHIP_OBJECT_ID          8493
#define SHIP_SKULL_ATTACH       3524
#define SHIP_RAILS_ATTACH       9159
#define SHIP_LINES_ATTACH       8981

new PirateShip[7];
new Float:carrierrot[3];
new Float:carrierspeed;
new carriercontrol;
new piratecam;

public OnFilterScriptInit()
{
	PirateShip[0] = CreateObject(8493, 0.0, 0.0, 0.0,   0.00, 0.00, 270.00);
	PirateShip[1] = CreateAttachment(PirateShip[0], SHIP_SKULL_ATTACH, 4.11, -5.53, -9.78, 0.0, 0.0, 90.0);
	PirateShip[2] = CreateAttachment(PirateShip[0], SHIP_SKULL_ATTACH, -4.11, -5.53, -9.78, 0.0, 0.0, -90.0);
	PirateShip[3] = CreateAttachment(PirateShip[0], SHIP_SKULL_ATTACH, -4.3378, -15.2887, -9.7863, 0.0, 0.0, -90.0);
	PirateShip[4] = CreateAttachment(PirateShip[0], SHIP_SKULL_ATTACH, 4.3378, -15.2887, -9.7863, 0.0, 0.0, 90.0);
	PirateShip[5] = CreateAttachment(PirateShip[0], SHIP_RAILS_ATTACH, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	PirateShip[6] = CreateAttachment(PirateShip[0], SHIP_LINES_ATTACH, -0.5468, -6.1875, -0.4375, 0.0, 0.0, 0.0);
	SetObjectPos(PirateShip[0], 2250.0, -1656.0, 15.0);
	EditObject(0, PirateShip[1]);
}

stock CreateAttachment(attach, modelid, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ)
{
	new obj = CreateObject(modelid, X, Y, Z, RX, RY, RZ);
	AttachObjectToObject(obj, attach, X, Y, Z, RX, RY, RZ);
	return obj;
}

public OnFilterScriptExit()
{
	for(new x;x<sizeof(PirateShip);x++)
	{
	    if(IsValidObject(PirateShip[x])) DestroyObject(PirateShip[x]);
	}
}
/*
public OnObjectMoved(objectid)
{
	if(objectid == PirateShip[0])
	{
	    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
		GetObjectPos(PirateShip[0],x,y,z);
		GetObjectRot(PirateShip[0], rx, ry, rz);

		rz += 180;
		x -= (60 * floatsin(-rz, degrees));
		y -= (60 * floatcos(-rz, degrees));
		z -= (60 * floattan(-rx, degrees));

		MoveObject(PirateShip[0],x,y,z,carrierspeed, carrierrot[0] , carrierrot[1], carrierrot[2]);
	}
	return 1;
}
*/


public OnPlayerUpdate(playerid)
{
    if(carriercontrol == playerid)
    {
		new Keys,ud,lr;
	    GetPlayerKeys(playerid,Keys,ud,lr);

	    if(ud > 0)
		{
		    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetObjectPos(PirateShip[0], x, y, z);
			GetObjectRot(PirateShip[0], rx, ry, rz);

			rz += 180;
			x -= (60 * floatsin(-rz, degrees));
			y -= (60 * floatcos(-rz, degrees));
			z -= (60 * floattan(-rx, degrees));
			MoveObject(PirateShip[0],x,y,z,carrierspeed, carrierrot[0] , carrierrot[1], carrierrot[2]);

			if(carrierrot[0] > 360.0) carrierrot[0] = 0.0;
			else carrierrot[0] = carrierrot[0] + 1.0;
		}
	    else if(ud < 0)
		{
		    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetObjectPos(PirateShip[0], x, y, z);
			GetObjectRot(PirateShip[0], rx, ry, rz);

			rz += 180;
			x -= (60 * floatsin(-rz, degrees));
			y -= (60 * floatcos(-rz, degrees));
			z -= (60 * floattan(-rx, degrees));
			MoveObject(PirateShip[0],x,y,z,carrierspeed, carrierrot[0] , carrierrot[1], carrierrot[2]);

			if(carrierrot[0] < 0.0) carrierrot[0] = 360.0;
			else carrierrot[0] = carrierrot[0] - 1.0;
		}
	    if(lr > 0)
		{
			new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetObjectPos(PirateShip[0], x, y, z);
			GetObjectRot(PirateShip[0], rx, ry, rz);

			rz += 180;
			x -= (60 * floatsin(-rz, degrees));
			y -= (60 * floatcos(-rz, degrees));
			z -= (60 * floattan(-rx, degrees));
			MoveObject(PirateShip[0],x,y,z,carrierspeed, carrierrot[0] , carrierrot[1], carrierrot[2]);

			if(carrierrot[2] <= 0.0) carrierrot[2] = 359.0;
			else carrierrot[2] = carrierrot[2] - 1.0;
			
			//if(carrierrot[1] < 90.0) carrierrot[1] += 1.0;
		}
	    else if(lr < 0)
		{
		    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetObjectPos(PirateShip[0], x, y, z);
			GetObjectRot(PirateShip[0], rx, ry, rz);

			rz += 180;
			x -= (60 * floatsin(-rz, degrees));
			y -= (60 * floatcos(-rz, degrees));
			z -= (60 * floattan(-rx, degrees));
			MoveObject(PirateShip[0],x,y,z,carrierspeed, carrierrot[0] , carrierrot[1], carrierrot[2]);

			if(carrierrot[2] >= 360.0) carrierrot[2] = 1.0;
			else carrierrot[2] = carrierrot[2] + 1.0;
			
			//if(carrierrot[1] > -90.0) carrierrot[1] -= 1.0;
		}
	}
    return 1;
}

CMD:tpship321(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	SetObjectPos(PirateShip[0], X, Y, Z);
	return 1;
}

CMD:control321(playerid, params[])
{
	if(carriercontrol == playerid)
 	{
  		carriercontrol = INVALID_PLAYER_ID;
  		KillTimer(piratecam);
  		//SetCameraBehindPlayer(playerid);
    	SendClientMessage(playerid, 0xFFFFFF, "Stopped Controlling");
   	}
    else
    {
   		carriercontrol = playerid;
   		//piratecam = SetTimerEx("CameraUpdate", 10, true, "i", playerid);
    	SendClientMessage(playerid, 0xFFFFFF, "Controlling");
	}
 	return 1;
}

CMD:setcspeed(playerid, params[])
{
	new string[64];
	carrierspeed = floatstr(params);
	if(carrierspeed == 0.0)
	{
	    if(IsObjectMoving(PirateShip[0])) StopObject(PirateShip[0]);
	}

	format(string, sizeof(string), "Carrier speed set to %f", carrierspeed);
	SendClientMessage(playerid, 0xFFFFFF, string);
	return 1;
}

forward CameraUpdate(playerid);
public CameraUpdate(playerid)
{
    new Float:x, Float:y, Float:z, Float:X, Float:Y, Float:Z, Float:rx, Float:ry, Float:rz;
	GetObjectPos(PirateShip[0],x,y,z);
	X=x; Y=y; Z=z;
	GetObjectRot(PirateShip[0], rx, ry, rz);
	
	rz += 180;
	x -= (-60 * floatsin(-rz, degrees));
	y -= (-60 * floatcos(-rz, degrees));
	
	SetPlayerCameraPos(playerid, x, y, Z+10.0);
	SetPlayerCameraLookAt(playerid, X, Y, Z);
}
