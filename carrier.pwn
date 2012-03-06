//-------------------------------------------------
//
// Script to control aircraft carrier with KEY_YES, KEY_NO
// Requires zcmd include.
//
// Scott Reed (h02) 2011
//
//-------------------------------------------------

#include <a_samp>
#include <zcmd>

new Carrier[26];
new Float:carrierrot[3];
new Float:carrierspeed;
new carriercontrol;
new liftstate[3];

public OnPlayerConnect(playerid)
{
    RemoveCarrier(playerid);
	return 1;
}

public OnFilterScriptInit()
{
	for(new x;x<MAX_PLAYERS;x++)
	{
	    if(IsPlayerConnected(x)) RemoveCarrier(x);
	}
	
	Carrier[0] = CreateObject(10771, 288.665771, 3600.003418, 6.032381, 0.0000, 0.0000, 90.0000);
	Carrier[1] = CreateAttachment(Carrier[0],11145, 225.782196, 3600.015137, 4.754915, 0.0000, 0.0000, 0.0000);
	Carrier[2] = CreateAttachment(Carrier[0],11149, 282.526093, 3594.805176, 12.487646, 0.0000, 0.0000, 0.0000);
	Carrier[3] = CreateAttachment(Carrier[0],11146, 279.620544, 3600.541016, 12.893089, 0.0000, 0.0000, 0.0000);
	Carrier[4] = CreateAttachment(Carrier[0],10770, 291.858917, 3592.397949, 39.171509, 0.0000, 0.0000, 0.0000);
	Carrier[5] = CreateAttachment(Carrier[0],10772, 290.014313, 3599.787598, 17.833616, 0.0000, 0.0000, 0.0000);
	Carrier[6] = CreateAttachment(Carrier[0],1671, 354.860748, 3589.442383, 11.234554, 0.0000, 0.0000, 175.3254);
	Carrier[7] = CreateAttachment(Carrier[0],925, 304.330383, 3589.067383, 11.735489, 0.0000, 0.0000, 0.0000);
	Carrier[8] = CreateAttachment(Carrier[0],930, 301.851654, 3588.497070, 11.131838, 0.0000, 0.0000, 0.0000);
	Carrier[9] = CreateAttachment(Carrier[0],930, 301.856079, 3589.598145, 11.181837, 0.0000, 0.0000, 0.0000);
	Carrier[10] = CreateAttachment(Carrier[0],964, 300.513062, 3589.303711, 10.705961, 0.0000, 0.0000, 177.4217);
	Carrier[11] = CreateAttachment(Carrier[0],964, 299.024902, 3589.362793, 10.698584, 0.0000, 0.0000, 177.4217);
	Carrier[12] = CreateAttachment(Carrier[0],1271, 305.058319, 3591.442871, 11.048584, 0.0000, 0.0000, 359.1406);
	Carrier[13] = CreateAttachment(Carrier[0],1431, 303.009491, 3591.383789, 11.253574, 0.0000, 0.0000, 0.0000);
	Carrier[14] = CreateAttachment(Carrier[0],2567, 297.100800, 3591.239746, 12.558563, 0.0000, 0.0000, 91.1003);
	Carrier[15] = CreateAttachment(Carrier[0],3576, 301.050110, 3593.777344, 12.198634, 0.0000, 0.0000, 0.0000);
	Carrier[16] = CreateAttachment(Carrier[0],3633, 304.567841, 3593.262207, 11.173386, 0.0000, 0.0000, 0.0000);
	Carrier[17] = CreateAttachment(Carrier[0],3267, 320.358582, 3592.519043, 21.567169, 0.0000, 0.0000, 0.0000);
	Carrier[18] = CreateAttachment(Carrier[0],11237, 291.557526, 3592.407715, 39.065594, 0.0000, 0.0000, 0.0000);
	Carrier[19] = CreateAttachment(Carrier[0],3395, 354.861725, 3590.989746, 10.797120, 0.0000, 0.0000, 88.0403);
	Carrier[20] = CreateAttachment(Carrier[0],1671, 356.571838, 3588.612793, 11.234554, 0.0000, 0.0000, 134.9316);
	Carrier[21] = CreateAttachment(Carrier[0],3393, 358.360016, 3588.834961, 10.797121, 0.0000, 0.0000, 0.0000);
	Carrier[22] = CreateAttachment(Carrier[0],3277, 320.391876, 3592.538086, 21.514416, 0.0000, 0.0000, 164.0483);
	Carrier[23] = CreateAttachment(Carrier[0],3114, 231.916656, 3615.134277, 17.269205, 0.0000, 0.0000, 0.0000); // Side Lift Up
	Carrier[24] = CreateAttachment(Carrier[0],3113, 180.344864, 3600.390137, 2.516232, 0.0000, 0.0000, 0.0000); // Back Hatch Closed
	Carrier[25] = CreateAttachment(Carrier[0],3115, 189.694626, 3599.983398, 17.483730, 0.0000, 0.0000, 0.0000); // Back Lift Up
}

public OnFilterScriptExit()
{
	for(new x;x<sizeof(Carrier);x++)
	{
	    if(IsValidObject(Carrier[x])) DestroyObject(Carrier[x]);
	}
}

stock CreateAttachment(attach, modelid, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ)
{
	new obj = CreateObject(modelid, X, Y, Z, RX, RY, RZ);
	
	new Float:x, Float:y, Float:z;
	x = X-288.665771;
	y = Y-3600.003418;
	z = Z-6.032381;
	
	AttachObjectToObject(obj, attach, x, y, z, RX, RY, RZ);
	return obj;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(carriercontrol == playerid)
	{
  		if(newkeys & KEY_YES)
		{
		    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetObjectPos(Carrier[0], x, y, z);
			GetObjectRot(Carrier[0], rx, ry, rz);
			
			rz += 90;
			x -= (60 * floatsin(-rz, degrees));
			y -= (60 * floatcos(-rz, degrees));

			MoveObject(Carrier[0],x,y,z,carrierspeed, carrierrot[0], 0, carrierrot[2]);

			if(carrierrot[2] >= 360.0) carrierrot[2] = 1.0;
			else carrierrot[2] = carrierrot[2] + 1.0;

            if(carrierrot[0] > -5.0) carrierrot[0] -= 1.0;
            
		    new string[128];
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~w~~n~~w~Rotation: %f", carrierrot[2]);
			GameTextForPlayer(playerid, string, 1000, 3);
		}
		else if(newkeys & KEY_NO)
		{
			new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetObjectPos(Carrier[0], x, y, z);
			GetObjectRot(Carrier[0], rx, ry, rz);

			rz += 90;
			x -= (60 * floatsin(-rz, degrees));
			y -= (60 * floatcos(-rz, degrees));
			MoveObject(Carrier[0],x,y,z,carrierspeed, carrierrot[0] , 0, carrierrot[2]);

			if(carrierrot[2] <= 0.0) carrierrot[2] = 359.0;
			else carrierrot[2] = carrierrot[2] - 1.0;

            if(carrierrot[0] < 5.0) carrierrot[0] += 1.0;
            
		    new string[128];
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~w~~n~~w~Rotation: %f", carrierrot[2]);
			GameTextForPlayer(playerid, string, 1000, 3);
		}
	}
	return 1;
}

CMD:carriertp(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
	GetObjectPos(Carrier[0], X, Y, Z);
	SetPlayerPos(playerid, X, Y, Z+20.0);
	return 1;
}

CMD:control321(playerid, params[])
{
	if(carriercontrol == playerid)
 	{
  		carriercontrol = INVALID_PLAYER_ID;
    	SendClientMessage(playerid, 0xFFFFFF, "Stopped Controlling");
   	}
    else
    {
   		carriercontrol = playerid;
    	SendClientMessage(playerid, 0xFFFFFF, "Controlling");
	}
 	return 1;
}

CMD:setcspeed(playerid, params[])
{
	new string[64];
	carrierspeed = floatstr(params);
	
	format(string, sizeof(string), "Carrier speed set to %f", carrierspeed);
	SendClientMessage(playerid, 0xFFFFFF, string);
	return 1;
}

public OnObjectMoved(objectid)
{
	if(objectid == Carrier[0])
	{
	    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
		GetObjectPos(Carrier[0],x,y,z);
		GetObjectRot(Carrier[0], rx, ry, rz);

		rz += 90;
		x -= (60 * floatsin(-rz, degrees));
		y -= (60 * floatcos(-rz, degrees));

		if(carrierrot[0] < 0) carrierrot[0] += 1.0;
		else if(carrierrot[0] > 0) carrierrot[0] -= 1.0;

		MoveObject(Carrier[0],x,y,z,carrierspeed, carrierrot[0], 0, carrierrot[2]);
	}
	else if(objectid == Carrier[25])
	{
	    if(liftstate[0] == 0)
	    {
	        AttachObjectToObject(Carrier[25], Carrier[0], -98.971145, -0.02002, 11.451349, 0.0, 0.0, 0.0);
	    }
	    else
	    {
	        AttachObjectToObject(Carrier[25], Carrier[0], -98.971145, -0.02002, 11.499285, 0.0, 0.0, 0.0);
	    }
	}
	return 1;
}

/*
CMD:bldown333(playerid, params[])
{
    if(liftstate[0] != 1)
    {
		new Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ;
	    GetObjectPos(Carrier[0], X, Y, Z);
	    GetObjectRot(Carrier[0], RX, RY, RZ);
	    DestroyObject(Carrier[25]);

		Carrier[25] = CreateObject(3115, X-98.971145, Y+0.02002, Z, RX, RY, RZ);
		MoveObject (Carrier[25],X-98.971145, Y+0.02002, Z-7.047936,1); // Back Lift (down position)
		liftstate[0] = 0;
	}
	return 1;
}

CMD:blup333(playerid, params[])
{
	if(liftstate[0] != 1)
	{
	    new Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ;
	    GetObjectPos(Carrier[0], X, Y, Z);
	    GetObjectRot(Carrier[0], RX, RY, RZ);
	    DestroyObject(Carrier[25]);

		Carrier[25] = CreateObject(3115, X-98.971145, Y+0.02002, Z, RX, RY, RZ);
		MoveObject (Carrier[25],X-98.971145, Y+0.02002, Z+7.047936,1); // Back Lift (down position)
		liftstate[0] = 1;
	}
	return 1;
}
CMD:sldown333(playerid, params[])
{
    new Float:X, Float:Y, Float:Z;
    GetObjectPos(Carrier[23], X, Y, Z);
    if(IsPlayerInRangeOfPoint(playerid, 50, X, Y, Z))
	{
		MoveObject (Carrier[23],X, Y, 10.271654,1); // Side Lift (down position)
	}
	return 1;
}

CMD:slup333(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
    GetObjectPos(Carrier[23], X, Y, Z);
    if(IsPlayerInRangeOfPoint(playerid, 50, X, Y, Z))
    {
		MoveObject (Carrier[23],X, Y, 17.269205,1); // Side Lift (down position)
	}
	return 1;
}

CMD:bhdown333(playerid, params[])
{
    new Float:X, Float:Y, Float:Z;
    GetObjectPos(Carrier[24], X, Y, Z);
   	if(IsPlayerInRangeOfPoint(playerid, 50, X, Y, Z))
    {
		MoveObject (Carrier[24], X, Y, 2.516232,1); // Back Hatch (down position)
	}
	return 1;
}

CMD:bhup333(playerid, params[])
{
    if(IsValidObject(Carrier[24]))
	{
		DestroyObject(Carrier[24]);
		new Float:X, Float:Y, Float:Z;
		GetObjectPos(Carrier[0], X, Y, Z);
		
	    Carrier[24] = CreateObject(3113, 180.344864, 3600.390137, 2.516232, 0.0000, 0.0000, 0.0000); // Back Hatch Closed
		
	    MoveObject (Carrier[24],X, Y, 17.280232,1); // Back Hatch (up position)
	    bhstate=1;
	 }
	return 1;
}
*/

stock RemoveCarrier(playerid)
{
    RemoveBuildingForPlayer(playerid, 10771, -1357.6953, 501.2969, 5.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 10872, -1824.3828, 541.3828, 150.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 10901, -1357.6953, 501.2969, 5.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 11145, -1420.5781, 501.2969, 4.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 11146, -1366.6875, 501.8516, 12.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 11148, -1366.6875, 501.2969, 12.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3884, -1394.8047, 493.3984, 18.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 3885, -1394.8047, 493.3984, 18.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3884, -1324.3281, 493.8125, 21.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 3885, -1324.3281, 493.8125, 21.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 11404, -1354.4688, 493.7500, 38.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1459.5703, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1459.5703, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1448.1172, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1448.1172, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 11401, -1449.2969, 507.8047, 4.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1436.6563, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1425.1953, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1435.8125, 488.6094, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1425.2500, 501.2891, 15.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1436.6563, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1435.8125, 513.9844, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1425.1953, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 11147, -1418.4141, 501.2969, 5.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1414.6719, 488.6094, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1414.5234, 504.9453, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1414.0625, 506.4844, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1413.1172, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1413.1250, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1411.2500, 489.1406, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1410.7969, 490.6797, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1412.7969, 488.6797, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1408.7969, 489.5938, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1405.8672, 489.5938, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1405.8672, 492.5234, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1408.7969, 492.5234, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1409.2578, 492.9844, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1404.4766, 492.9844, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1407.6250, 493.2813, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3794, -1404.8281, 499.8828, 10.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3793, -1403.8984, 500.0859, 10.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1408.4297, 506.4844, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1401.6641, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3795, -1401.8359, 494.9063, 10.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3792, -1401.0078, 494.6875, 10.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3793, -1398.1797, 494.7734, 10.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3788, -1399.0625, 494.4453, 10.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1400.0078, 489.5938, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1402.9375, 489.5938, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1397.0781, 489.5938, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1397.0781, 492.5234, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1400.0078, 492.5234, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1402.9375, 492.5234, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1402.4766, 492.9844, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1396.6172, 489.1250, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1396.6172, 491.1250, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1403.6641, 501.2891, 15.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1399.7578, 497.2891, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3796, -1398.1875, 502.7031, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1400.2109, 499.7422, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3792, -1401.2031, 502.2188, 11.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3789, -1403.6172, 504.0938, 10.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1400.0078, 495.4531, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1397.0781, 495.4531, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1396.6172, 495.9141, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1398.6172, 495.9141, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1400.2031, 496.4219, 4.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1396.6172, 497.9141, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1401.6641, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1400.2578, 512.8359, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1397.3281, 512.8359, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1390.2031, 488.2344, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1366.3750, 490.0625, 13.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1393.1172, 488.6094, 13.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1395.0781, 492.6016, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1395.0781, 493.6797, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1395.0781, 494.7578, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1381.6094, 500.7109, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1371.9688, 501.6016, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1370.7422, 501.1172, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 11149, -1363.7734, 496.0938, 11.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 11374, -1363.7734, 496.0938, 11.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1390.2031, 514.3516, 5.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1393.1016, 513.9844, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 11406, -1396.2656, 504.5078, 5.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1387.4609, 507.1875, 1.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1387.6094, 504.7188, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1387.6094, 509.6563, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1389.1484, 505.1797, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1386.0703, 509.1953, 2.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1388.0703, 509.3281, 4.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1371.9688, 513.9844, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1365.6016, 502.7891, 10.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1364.1172, 504.8359, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1362.5313, 505.7500, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1308.5781, 488.6094, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 11150, -1292.4844, 490.7656, 11.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1349.8203, 490.6563, 10.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1350.0000, 490.6563, 11.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1341.5547, 490.1875, 10.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1342.7422, 490.1875, 10.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1341.2344, 490.2031, 11.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 10770, -1354.4688, 493.7500, 38.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 3791, -1289.9766, 494.7734, 10.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 11237, -1354.4219, 493.7500, 38.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 955, -1350.1172, 492.2891, 10.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 11334, -1346.8984, 492.7969, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 956, -1350.1172, 493.8594, 10.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1341.2969, 493.7344, 12.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1341.7109, 493.9766, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1350.1094, 499.1797, 20.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1329.7031, 500.5391, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3796, -1335.9688, 499.9297, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3787, -1329.4297, 499.6016, 10.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3787, -1328.3906, 497.9375, 10.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3791, -1334.2891, 497.6094, 10.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3791, -1333.0547, 496.0000, 10.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1328.6016, 496.0469, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1349.9766, 495.8281, 10.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 3795, -1294.1172, 499.3359, 10.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3791, -1290.5000, 496.4375, 10.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3787, -1290.2656, 499.9609, 10.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3787, -1290.3125, 497.9609, 10.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3792, -1294.5938, 497.3750, 10.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 10772, -1356.3516, 501.1172, 17.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1350.8359, 501.6016, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1350.8438, 513.9844, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1359.8281, 501.1172, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1348.2813, 501.1172, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1342.6016, 502.8047, 10.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1329.7031, 501.6016, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1329.2734, 513.9844, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1340.5547, 504.0938, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1340.0859, 502.5469, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1328.2891, 503.1016, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3799, -1329.7891, 512.3984, 10.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1328.4844, 509.4766, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3785, -1308.6016, 513.9844, 13.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 3787, -1300.6406, 504.0391, 10.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3789, -1301.5859, 511.1094, 10.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3792, -1301.5859, 511.9688, 10.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3794, -1305.3359, 511.1953, 10.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3793, -1305.2891, 512.1484, 10.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3800, -1298.2109, 503.1641, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1297.7422, 501.6172, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3788, -1294.0156, 509.2188, 10.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3793, -1294.0156, 510.1563, 10.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3794, -1294.6172, 501.3281, 10.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3798, -1293.2344, 512.4531, 10.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3795, -1290.3984, 503.4688, 10.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3792, -1289.7031, 503.9922, 10.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3793, -1294.3750, 503.1094, 10.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 11400, -1288.8281, 504.5391, 13.0078, 0.25);
	return 1;
}
