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

// vehicle array moved to clash_map_configs.hpp

clash_respawnIdleVehs = true;

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
	// get in: only allow certain players to get in driver/gunner seats
	[
		_veh,
		[
			"GetIn",
			{
				params ["_vehicle", "_role", "_unit", "_turret"];
				// only run on local unit
				if !(local _unit) exitWith {};
				private _restricted = (_vehicle getVariable "Clash_vehArray") select 1;
				if (_restricted and (_vehicle isKindOf "AIR")) then
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
				if (_restricted and ((_vehicle isKindOf "CAR") or (_vehicle isKindOf "TANK"))) then
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
				private _restricted = (_vehicle getVariable "Clash_vehArray") select 1;
				if (_restricted and (_vehicle isKindOf "AIR")) then
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
				if (_restricted and ((_vehicle isKindOf "CAR") or (_vehicle isKindOf "TANK"))) then
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
	_vehArray params ["_unitVar", "_restricted", "_time", "_pos", "_vDirAndUp", "_class", "_config", "_name", "_attObjs", "_fnc", "_sideLocInfo"];
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
	// add to zeuses
	{
		_x addCuratorEditableObjects [[_unitVar], true]
	} forEach allCurators;
	// add handlers
	[_unitVar] call JST_fnc_addVehRespawnHandlers;
	// save respawn data onto vehicle
	_unitVar setVariable ["Clash_vehArray", _vehArray, true];
	// safety check
	UIsleep 1;
	_unitVar setDamage 0;
	UIsleep 1;
	_unitVar setDamage 0;
	// Remove banned magazines
	{
		_unitVar removeMagazinesTurret [_x, [0]];
	} forEach VehBannedMagazines;
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
	// recreate setVariable'd sideLocInfo, if any
	_unitVar setVariable ["sideLocInfo", _sideLocInfo, true];
	// run any functions assigned to this vehicle
	[_unitVar] call _fnc;
	// Broadcast respawn notification
	{
		[
			"RespawnVehicle",
			[
				getText (configfile >> "CfgVehicles" >> typeOf _unitVar >> "displayName"),
				(_sideLocInfo select 1),
				getText (configfile >> "CfgVehicles" >> typeOf _unitVar >> "picture")
			]
		] remoteExec ["BIS_fnc_showNotification", _x];
	} forEach (_sideLocInfo select 0);
};

// wait for mission start
waitUntil {time > 3};
waitUntil {!(isNil "Clash_vehs")};

// handle vehicles at start: save data, remove banned magazines, add handlers
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
	private _configSide = (getNumber (configfile >> "CfgVehicles" >> typeOf _unitVar >> "side"));
	// custom mission maker input for respawn notification [array of sides to notify, location name]
	// defaults to generic stuff if no input
	private _sideLocInfo = _unitVar getVariable ["sideLocInfo", [[_configSide],"MAIN"]];
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
	private _vehArray = [_unitVar, _restricted, _time, _pos, [_vDir, _vUp], _class, _config, _name, _attObjs, _fnc, _sideLocInfo];
	_unitVar setVariable ["Clash_vehArray", _vehArray, true];
	// Remove banned magazines
	{
		_unitVar removeMagazinesTurret [_x, [0]];
	} forEach VehBannedMagazines;
	// run any functions assigned to this vehicle
	[_unitVar] spawn _fnc;
	// add handlers
	[_unitVar] spawn JST_fnc_addVehRespawnHandlers;
	// short sleep to avoid overload
	UIsleep 0.25;
} forEach Clash_vehs;

// start idle check loop if enabled
// maxTick is 30 = 5 minute idle allowance / 10 second script loop
clash_maxTick = 30;
if (clash_respawnIdleVehs) then
{
	[] spawn
	{
		while {UIsleep 10; true} do
		{
			{
				private _veh = _x;
				// if crewed, skip and reset var
				private _cnt = 0;
				{
					if (alive _x) then {_cnt = _cnt + 1};
				} forEach (crew _veh);
				if (_cnt > 0) then
				{
					_veh setVariable ["clash_idleChecker", 0];
					continue
				};
				// if not a respawn vehicle, skip
				private _vehArray = _veh getVariable ["clash_vehArray", 0];
				if (_vehArray isEqualTo 0) then {continue};
				// if near original spawn point, skip
				private _pos = getPos _veh;
				private _spawnPos = _vehArray select 3;
				if ((_pos distance2D _spawnPos) < 20) then {continue};
				// handle empty respawn vehicles not near their spawn point
				private _idleChecker = _veh getVariable ["clash_idleChecker", 0];
				switch true do
				{
					// if no pos/tick stored, store it
					case (_idleChecker isEqualTo 0):
					{
						_veh setVariable ["clash_idleChecker", [_pos, 1]];
						systemChat "Creating variable.";
					};
					// if pos/tick stored, pos not changed, and not max tick, increment tick
					case (((_idleChecker select 1) < clash_maxTick) and (((_idleChecker select 0) distance2D _pos) < 1)):
					{
						_veh setVariable ["clash_idleChecker", [_pos, ((_idleChecker select 1) + 1)]];
						systemChat "Incrementing tick.";
					};
					// if pos/tick stored, pos not changed, and max tick hit, respawn
					case (((_idleChecker select 1) >= clash_maxTick) and (((_idleChecker select 0) distance2D _pos) < 1)):
					{
						/* apparently deleteVehicle fires the deleted eventHandler
						// remove all event handlers
						_veh removeAllMPEventHandlers "MPKilled";
						[_veh, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
						[_veh, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
						[_veh, "SeatSwitched"] remoteExec ["removeAllEventHandlers", 0];
						// delete all attached objects
						{
							deleteVehicle _x;
						} forEach (attachedObjects _veh);
						// respawn on server
						[_veh, _vehArray] remoteExec ["JST_fnc_vehRespawn", 2];
						// delete vehicle
						*/
						deleteVehicle _veh;
						systemChat "Respawning vehicle";
					};
				};
			} forEach vehicles;
		};
	};
};