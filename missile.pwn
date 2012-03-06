//-------------------------------------------------
//
// Script to launch missile object to vehicle
// Requires zcmd include.
//
// Scott Reed (h02) 2011
//
//-------------------------------------------------

#include <a_samp>
#include <zcmd>

new tracer[20];
new missiles[20];

public OnFilterScriptInit()
{
	for(new x;x<sizeof(tracer);x++) tracer[x] = INVALID_VEHICLE_ID;
	return 1;
}

stock Float:isin(Float:opp,Float:hyp)
{
	new Float:tx = floatdiv(opp,hyp);
	if(tx < 1.0 && tx > -1.0)
	{
		return tx+(1.0/2.0)*(floatpower(tx,3)/3.0)+((1.0*3.0)/(2.0*4.0))*(floatpower(tx,5)/5.0)+((1.0*3.0*5.0)/(2.0*4.0*6.0))*(floatpower(tx,7)/7.0)+((1.0*3.0*5.0*7.0)/(2.0*4.0*6.0*8.0))*(floatpower(tx,9)/9.0)+((1.0*3.0*5.0*7.0*9.0)/(2.0*4.0*6.0*8.0*10.0))*(floatpower(tx,11)/11.0);
	}
	return -1.0;
}

Float:GetAngleBetweenPoints(Float:X1,Float:Y1,Float:Z1, Float:X2,Float:Y2, Float:Z2, &Float:RY, &Float:RZ)
{
	new Float:angle, Float:angle2;
	new Float:hyp = GetDistanceBetweenPoints(X1,Y1,Z1,X2,Y2,Z2);
	new Float:opp = floatsub(Z2,Z1);
	GetAngleToXY(X1,Y1,X2,Y2,angle);
	angle = floatsub(angle,90);
	angle2 = isin(opp,hyp);
	angle2 = floatmul(angle2,100);
	RY=angle2;
	RZ=angle;
}

GetAngleToXY(Float:X, Float:Y, Float:CurrentX, Float:CurrentY, &Float:Angle)
{
    Angle = atan2(Y-CurrentY, X-CurrentX);
    Angle = floatsub(Angle, 90.0);
    if(Angle < 0.0) Angle = floatadd(Angle, 360.0);
}

GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 )
{
    return floatround(floatsqroot((( x1 - x2 ) * ( x1 - x2 ) ) + ( ( y1 - y2 ) * ( y1 - y2 ) ) + ( ( z1 - z2 ) * ( z1 - z2 ))));
}

stock Float:GetDistance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    x1 -= x2;
    y1 -= y2;
    z1 -= z2;
    return floatsqroot((x1 * x1) + (y1 * y1) + (z1 * z1));
}

CMD:tracera(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new target = strval(params);
		for(new x;x<sizeof(tracer);x++)
		{
			if(tracer[x] == INVALID_VEHICLE_ID)
			{
			    new string[64];
			    tracer[x] = target;
			    format(string, sizeof(string), "Tracer attached to car %d with ID %d", target, x);
			    SendClientMessage(playerid, 0xFFFFFFF, string);
			    break;
			}
		}
	}
	return 1;
}

CMD:missilel(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    for(new x;x<sizeof(missiles);x++)
	    {
	        if(!IsValidObject(missiles[x]))
	        {
			    SendClientMessage(playerid, 0xFFFFFFF, "Missile launched!");
		     	new Float:X, Float:Y, Float:Z, Float:RZ, Float:vx, Float:vy, Float:vz;

		     	GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
		     	GetVehicleZAngle(GetPlayerVehicleID(playerid), RZ);
				missiles[x] = CreateObject(3790, X, Y, Z-2.0, 0.0, 0.0, RZ-90);
				MoveObject(missiles[x], X+vx, Y+vy, (Z+vz)-10.0, 5.0, 0.0, 0.0, RZ-90);
				break;
			}
		}
	}
	return 1;
}

CMD:destroyt(playerid, params[])
{
    for(new i;i<sizeof(missiles);i++)
	{
	    if(IsValidObject(missiles[i]))
	    {
	        DestroyObject(missiles[i]);
	    }
	}
	return 1;
}

public OnObjectMoved(objectid)
{
    for(new I;I<sizeof(missiles);I++)
    {
        if(objectid == missiles[I])
        {
	        new i=-1, Float:distance=99999.9;
			for(new x;x<sizeof(tracer);x++)
			{
			    if(tracer[x] != INVALID_VEHICLE_ID)
			    {
	       			new Float:vx, Float:vy, Float:vz, Float:X, Float:Y, Float:Z;
	       			GetVehiclePos(tracer[x], vx, vy, vz);
		        	GetObjectPos(missiles[I], X, Y, Z);
			        new Float:tmpdis;
					tmpdis = GetDistance(vx, vy, vz, X, Y, Z);
					if(tmpdis < 10.0)
					{
		   				DestroyObject(missiles[I]);
				   		CreateExplosion(X, Y, Z, 6, 10.0);

						tracer[i] = INVALID_VEHICLE_ID;
	    				return 1;
					}
	    			if(tmpdis < 5000.0 && (tmpdis<distance))
	      			{
			 			distance=tmpdis;
				 		i=x;
	      			}
		        	if(distance == 0.0) i=-2;
	   			}
			}
			if(i == -2)
			{
				new Float:X, Float:Y, Float:Z;
			    GetObjectPos(missiles[I], X, Y, Z);
			    DestroyObject(missiles[I]);
 				CreateExplosion(X, Y, Z, 6, 10.0);

				tracer[i] = INVALID_VEHICLE_ID;
			}
			else if(i != -1)
			{
   				new Float:ox, Float:oy, Float:oz, Float:x, Float:y, Float:z, Float:RY, Float:RZ, Float:rx, Float:ry, Float:rz;
			    GetVehiclePos(tracer[i], x, y, z);
			    GetObjectPos(missiles[I], ox, oy, oz);
				GetObjectRot(missiles[I], rx, ry, rz);
				
			    GetAngleBetweenPoints(ox, oy, oz, x, y, z, RY, RZ);
                
				x -= (10 * floatcos(-rz, degrees));
				y -= (10 * floatcos(-rz, degrees));
				z -= (10 * floattan(-ry, degrees));
				
				new string[64];
				format(string, sizeof(string), "MoveObject(missile, %f, %f, %f, 250.0, 0.0, %f, %f)", x, y, z, RY, RZ+180);
				SendClientMessage(69, 0xFFFFFFFF, string);
				
				MoveObject(missiles[I], x,y,z, 250.0, 0.0 , RY, RZ+180.0);
			}
			break;
		}
	}
	return 1;
}
