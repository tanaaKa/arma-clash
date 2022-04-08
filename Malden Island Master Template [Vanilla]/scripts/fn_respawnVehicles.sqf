/*

Simple vehicle respawn script by Jester

 -Detects vehicle death or deletion, waits specified time, and respawns the vehicle at starting position
 -Vehicle is respawned with original Garage configuration
 -Run on server only, scheduled
 
 -Additionally, can restrict driver/gunner/commander roles to specified classes
 
*/

if (!isServer) exitWith {};

/*
BEGIN USER CONFIG
*/

// input all vehicles to respawn in format [vehName, crew restricted boolean, timer]
#include "vehicles_island.hpp"

// input allowed crew classes for GROUND vehicles
AllowedGroundCrew =
[
	"B_crew_F",
	"O_crew_F"
];
// input allowed crew classes for AIR vehicles
AllowedAirCrew =
[
	"B_Pilot_F",
	"O_Pilot_F"
];

/*
END USER CONFIG
*/

// temp workaround until I find a smarter, server-only way of handling crew restrictions
publicVariable "Clash_vehs";
publicVariable "AllowedGroundCrew";
publicVariable "AllowedAirCrew";

// adds handlers to vehicles that start respawn process and remove themselves
JST_fnc_addVehRespawnHandlers =
{
	params ["_veh"];
	if (JST_debug) then {systemChat "Adding eventHandlers to respawned vehicle."};
	// hit: record hitter
	_veh addMPEventHandler
	[
		"MPHit",
		{
			params ["_unit", "_causedBy", "_damage", "_instigator"];
			// do not run if not server
			if !(isServer) exitWith {};
			// record last hitter
			if (!(_instigator isEqualTo _unit) and (_instigator isKindOf "CAManBase")) then
			{
				_unit setVariable ["clash_lastHitter", _instigator];
				if (JST_debug) then {[format ["%1 was hit by %2", _unit, _instigator]] remoteExec ["systemChat"]};
			};
		}
	];
	// killed: remove all handlers, start respawn loop
	_veh addMPEventHandler
	[
		"MPKilled",
		{
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			// do not run if not server
			if !(isServer) exitWith {};
			// pull data
			private _vehArray = _unit getVariable "Clash_vehArray";
			// remove all event handlers
			_unit removeAllMPEventHandlers "MPKilled";
			[_unit, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "SeatSwitched"] remoteExec ["removeAllEventHandlers", 0];
			// delete all attached objects
			{
				deleteVehicle _x;
			} forEach (attachedObjects _unit);
			// respawn on server
			[_unit, _vehArray] remoteExec ["JST_fnc_vehRespawn", 2];

			// award points to the vehicle killer
			
			// if kill was from real unit, record unit
			if (!(_instigator isEqualTo _unit) and (_instigator isKindOf "CAManBase")) then
			{
				_unit setVariable ["clash_lastHitter", _instigator];
			};
			// perform kill events
			[_unit] spawn clash_fnc_killEvents;
			if (JST_debug) then {[format ["%1 was killed by %2", _unit, _instigator]] remoteExec ["systemChat"]};
		}
	];
	// deleted: remove all handlers, start respawn loop
	_veh addEventHandler
	[
		"Deleted",
		{
			params ["_unit"];
			// do not run if not server
			if !(isServer) exitWith {};
			// pull data
			private _vehArray = _unit getVariable "Clash_vehArray";
			// remove all event handlers
			_unit removeAllMPEventHandlers "MPKilled";
			[_unit, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "SeatSwitched"] remoteExec ["removeAllEventHandlers", 0];
			// delete all attached objects
			{
				deleteVehicle _x;
			} forEach (attachedObjects _unit);
			// respawn on server
			[_unit, _vehArray] remoteExec ["JST_fnc_vehRespawn", 2];
		}
	];
	// get in: only allow certain players to get in driver/gunner seats aka bane of my existence
	[
		_veh,
		[
			"GetIn",
			{
				params ["_vehicle", "_role", "_unit", "_turret"];
				// only run on local unit
				if !(local _unit) exitWith {};
				if (_vehicle isKindOf "AIR") then
				{
					if !((typeOf _unit) in AllowedAirCrew) then
					{
						private _time = time;
						waitUntil {((vehicle _unit) isEqualTo _vehicle) or (time >= (_time + 5))};
						if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
						{
							"Hint3" remoteExec ["playsound", _unit1];
							[_unit] remoteExec ["moveOut", _unit];
							["You are not authorized air crew."] remoteExec ["systemChat", _unit];
						};
					};
				};
				if (_vehicle isKindOf "APC_Tracked_02_base_F" || _vehicle isKindOf "Wheeled_APC_F") then
				{
					if !((typeOf _unit) in AllowedGroundCrew) then
					{
						private _time = time;
						waitUntil {((vehicle _unit) isEqualTo _vehicle) or (time >= (_time + 5))};
						if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
						{
							"Hint3" remoteExec ["playsound", _unit1];
							[_unit] remoteExec ["moveOut", _unit];
							["You are not authorized crew."] remoteExec ["systemChat", _unit];
						};
					};
				};
			}
		]
	] remoteExec ["addEventHandler", 0, true];
	// switch seats: prevents cheesing the seat system
	[
		_veh,
		[
			"SeatSwitched",
			{
				params ["_vehicle", "_unit1", "_unit2"];
				// only run on local unit
				if !(local _unit1) exitWith {};
				if (_vehicle isKindOf "AIR") then
				{
					if !((typeOf _unit1) in AllowedAirCrew) then
					{
						if (((assignedVehicleRole _unit1) isEqualTo ["driver"]) or ((assignedVehicleRole _unit1) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit1) isEqualTo ["turret",[0]])) then
						{
							[_unit1] remoteExec ["moveOut", _unit1];
							[_unit1,_vehicle] remoteExec ["moveInCargo", _unit1];
							["You are not authorized air crew."] remoteExec ["systemChat", _unit1];
						};
					};
				};
				if (_vehicle isKindOf "APC_Tracked_02_base_F" || _vehicle isKindOf "Wheeled_APC_F") then
				{
					if !((typeOf _unit1) in AllowedGroundCrew) then
					{
						if (((assignedVehicleRole _unit1) isEqualTo ["driver"]) or ((assignedVehicleRole _unit1) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit1) isEqualTo ["turret",[0]])) then
						{
							[_unit1] remoteExec ["moveOut", _unit1];
							[_unit1,_vehicle] remoteExec ["moveInCargo", _unit1];
							["You are not authorized crew."] remoteExec ["systemChat", _unit1];
						};
					};
				};
			}
		]
	] remoteExec ["addEventHandler", 0, true];
};

// process that handles the actual respawn wait and spawn
JST_fnc_vehRespawn =
{
	params ["_unit", "_vehArray"];
	if (!isServer) exitWith {};
	if (JST_debug) then {systemChat "Respawning a vehicle."};
	// pull respawn data from dead unit
	_vehArray params ["_unitVar", "_restricted", "_time", "_pos", "_vDirAndUp", "_class", "_config", "_name", "_attObjs", "_fnc"];
	// wait respawn time
	UIsleep _time;
	// find nearest safe position to respawn point
	private _safePos = _pos findEmptyPosition [0, 30, _class];
	// respawn vehicle
	_unitVar = createVehicle [_class, [(_safePos select 0), (_safePos select 1), ((_safePos select 2) + 10000)], [], 0, "NONE"];
	_unitVar setVehicleVarName _name;
	_unitVar setVectorDirAndUp _vDirAndUp;
	_unitVar setPos [(_safePos select 0), (_safePos select 1), ((_safePos select 2) + 1.5)];
	_unitVar setVectorDirAndUp _vDirAndUp;
	[_unitVar, _config select 0, _config select 1] call BIS_fnc_initVehicle;
	// Remove minispikes from stalker
	if (_class isEqualTo "O_APC_Tracked_02_cannon_F") then {
		_unitVar removeMagazinesTurret ["2Rnd_GAT_missiles_O", [0]];
	};
	// Send notification
	_side = "";
	switch (getNumber (configfile >> "CfgVehicles" >> typeOf _unitVar >> "side")) do {
		case 0:
		{
			_side = EAST;
		};
		case 1:
		{
			_side = WEST;
		};
	};
	["RespawnVehicle",[getText (configfile >> "CfgVehicles" >> typeOf _unitVar >> "displayName"),"MAIN",getText (configfile >> "CfgVehicles" >> typeOf _unitVar >> "picture")]] remoteExec ["BIS_fnc_showNotification",_side];
	// save respawn data onto vehicle
	_unitVar setVariable ["Clash_vehArray", _vehArray, true];
	// add handlers
	[_unitVar] call JST_fnc_addVehRespawnHandlers;
	// add to zeuses
	{
		_x addCuratorEditableObjects [[_unitVar], true]
	} forEach allCurators;
	// safety check
	UIsleep 1;
	_unitVar setDamage 0;
	UIsleep 1;
	_unitVar setDamage 0;
	// recreate attached objects, if any
	if ((count _attObjs) > 0) then
	{
		{
			_x params ["_type", "_relPos", "_vDirAndUp"];
			private _posSafe = [(_pos select 0), (_pos select 1), 100];
			private _obj = createVehicle [_type, _posSafe, [], 0, "CAN_COLLIDE"];
			_obj enableSimulationGlobal false;
			_obj setPos (_unitVar modelToWorld _relPos);
			_obj setVectorDirAndUp _vDirAndUp;
			[_obj, _unitVar] call BIS_fnc_attachToRelative;
		} forEach _attObjs;
	};
	// run any functions assigned to this vehicle
	[_unitVar] call _fnc;
};

// wait for mission start
waitUntil {time > 3};

// handle vehicles at start: save data, add handlers
{
	if (JST_debug) then {systemChat "Handling vehicle respawn setup."};
	// find data
	private _unitVar = _x select 0;
	private _restricted = _x select 1;
	private _time = _x select 2;
	private _pos = getPos _unitVar;
	private _vDir = vectorDir _unitVar;
	private _vUp = vectorUp _unitVar;
	private _class = typeOf _unitVar;
	private _config = [_unitVar] call BIS_fnc_getVehicleCustomization;
	private _name = vehicleVarName _unitVar;
	private _fnc = _x select 3;
	// find attached objects, if any
	private _attObjs = [];
	{ 
		private _type = typeOf _x;
		private _relPos = _unitVar worldToModel (getPos _x);
		private _vDir = vectorDir _x;
		private _vUp = vectorUp _x;
		_attObjs pushBack [_type, _relPos, [_vDir, _vUp]];
	} forEach (attachedObjects _unitVar);
	// store data on vehicle
	private _vehArray = [_unitVar, _restricted, _time, _pos, [_vDir, _vUp], _class, _config, _name, _attObjs, _fnc];
	_unitVar setVariable ["Clash_vehArray", _vehArray, true];
	// run any functions assigned to this vehicle
	[_unitVar] call _fnc;
	// add handlers
	[_unitVar] call JST_fnc_addVehRespawnHandlers;
	// short sleep to avoid overload
	UIsleep 0.25;
} forEach Clash_vehs;