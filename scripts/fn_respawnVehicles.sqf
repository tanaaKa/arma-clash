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
CCO_vehs =
[
	[logi1,		false,		(5*60)],
	[logi2,		false,		(5*60)],
	[slick1,	true,		(20*60)],
	[slick2,	true,		(20*60)],
	[slick3,	true,		(20*60)],
	[slick4,	true,		(20*60)],
	[cobra1,	true,		(20*60)],
	[cobra2,	true,		(20*60)],
	[otruck1,	false,		(5*60)],
	[otruck2,	false,		(5*60)],
	[otruck3,	false,		(5*60)],
	[otruck4,	false,		(5*60)],
	[otruck5,	false,		(5*60)],
	[otruck6,	false,		(5*60)],
	[otruck7,	false,		(5*60)],
	[otruck8,	false,		(5*60)],
	[zpu1,		true,		(25*60)],
	[zpu2,		true,		(25*60)],
	[zpu3,		true,		(25*60)],
	[tank1,		true,		(25*60)],
	[tank1_1,	true,		(25*60)],
	[oh6,		true,		(20*60)],
	[psyops_truck,	false,	(5*60)]
];

// input allowed crew classes for GROUND vehicles
AllowedGroundCrew =
[
	"potato_e_vicl",
	"potato_e_vicc",
	"potato_e_vicd"
];
// input allowed crew classes for AIR vehicles
AllowedAirCrew =
[
	"potato_w_helicrew",
	"potato_w_cc",
	"potato_w_pilot"
];

/*
END USER CONFIG
*/

// temp workaround until I find a smarter, server-only way of handling crew restrictions
publicVariable "CCO_vehs";
publicVariable "AllowedGroundCrew";
publicVariable "AllowedAirCrew";

// Add actions to tow ZPUs and MSPs
tnk_detach = {
	_gun = _this select 3;
	detach _gun;
	hint "Detached!";
	
	_gun removeAction gundetach;
	_gun enableSimulation true;
	gunattach = _gun addaction ["<t color='#1279d1'>Tow Vehicle</t>", "call tnk_attach",_gun,6,false,true,"","(_target distance _this) < 8"];
};

tnk_attach = {
	_gun = _this select 3;
	_vehList = nearestObjects [_gun, ["Car", "Tank"], 10];
	if (_vehList select 0 isEqualTo _gun) then {_vehList deleteAt 0};
	if (count _vehList isEqualTo 0) exitWith {hint "There's no vehicle that can tow within 5 meters!"};
	_veh = _vehList select 0;
	
	[_gun, _veh] call BIS_fnc_attachToRelative;
	_gun enableSimulation false; 
	hint "Attached!";
	
	_gun removeAction gunattach;
	gundetach = _gun addaction ["<t color='#1279d1'>Detach Vehicle</t>", "call tnk_detach",_gun,6,false,true,"","(_target distance _this) < 8"];
};

tnk_towAction = 
{
	params["_veh"];
		
	gunattach = _veh addaction ["<t color='#1279d1'>Tow Vehicle</t>", "call tnk_attach",_veh,6,false,true,"","(_target distance _this) < 8"];
};

// temporary workaround for the tow actions needing to be local but functions being defined server-side, if used past CCO15 must do better
publicVariable "tnk_detach";
publicVariable "tnk_attach";
publicVariable "tnk_towAction";

// adds WP-extending function to server
JST_fnc_WPextend =
{
	params ["_pos"];
	private _smoke = createVehicle ["SmokeShell", _pos, [], 0, "NONE"];
	private _light = createVehicle ["ACE_F_Hand_Yellow", _pos, [], 0, "NONE"];
	_light attachTo [_smoke, [0,0,0]];
};

// adds handlers to vehicles that start respawn process and remove themselves
JST_fnc_addVehRespawnHandlers =
{
	params ["_veh"];
	// killed: remove all handlers, start respawn loop
	_veh addMPEventHandler
	[
		"MPKilled",
		{
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			// do not run if not server
			if !(isServer) exitWith {};
			// pull data
			private _vehArray = _unit getVariable "CCO_vehArray";
			// remove all event handlers
			_unit removeAllMPEventHandlers "MPKilled";
			[_unit, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "Fired"] remoteExec ["removeAllEventHandlers", 0];
			// delete all attached objects
			{
				deleteVehicle _x;
			} forEach (attachedObjects _unit);
			// respawn on server
			[_unit, _vehArray] remoteExec ["JST_fnc_vehRespawn", 2];
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
			private _vehArray = _unit getVariable "CCO_vehArray";
			// remove all event handlers
			_unit removeAllMPEventHandlers "MPKilled";
			[_unit, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "Fired"] remoteExec ["removeAllEventHandlers", 0];
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
				private _restricted = (_vehicle getVariable "CCO_vehArray") select 1;
				if (_restricted and (_vehicle isKindOf "AIR")) then
				{
					if !((typeOf _unit) in AllowedAirCrew) then
					{
						private _time = time;
						waitUntil {((vehicle _unit) isEqualTo _vehicle) or (time >= (_time + 5))};
						if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
						{
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
							[_unit] remoteExec ["moveOut", _unit];
							["You are not authorized crew."] remoteExec ["systemChat", _unit];
						};
					};
				};
			}
		]
	] remoteExec ["addEventHandler", 0, true];
	// adds WP life extending magic
	if ((typeOf _veh) isEqualTo "vn_b_air_oh6a_07") then
	{
		[_veh, "Fired"] remoteExec ["removeAllEventhandlers", 0];
		UIsleep 2;
		[
			_veh,
			[ 
				"Fired", 
				{  
					params ["_unit", "_weapon", "_muzzle", "_mode",  "_ammo", "_magazine", "_projectile"];
					if (!(local _projectile) or !(_ammo isEqualTo "vn_rocket_ffar_m156_wp_ammo")) exitWith {};
					[_projectile, _ammo] spawn
					{ 
						params ["_projectile", "_ammo"]; 
						private _finalPos = [1,1,1]; 
						while {alive _projectile} do 
						{
							UIsleep 0.03;
							if ((speed _projectile) > 1) then
							{
								_finalPos = (getPos _projectile);
							}; 
						};
						[_finalPos] remoteExec ["JST_fnc_WPextend", 2];
					}; 
				} 
			]
		] remoteExec ["addEventHandler", 0, true];
	};
};

// process that handles the actual respawn wait and spawn
JST_fnc_vehRespawn =
{
	params ["_unit", "_vehArray"];
	if (!isServer) exitWith {};
	// pull respawn data from dead unit
	_vehArray params ["_unitVar", "_restricted", "_time", "_pos", "_vDirAndUp", "_class", "_config", "_name", "_attObjs"];
	// wait respawn time
	UIsleep _time;
	// respawn vehicle
	_unitVar = createVehicle [_class, [(_pos select 0), (_pos select 1), ((_pos select 2) + 10000)], [], 0, "NONE"];
	_unitVar setVehicleVarName _name;
	_unitVar setVectorDirAndUp _vDirAndUp;
	_unitVar setPos [(_pos select 0), (_pos select 1), ((_pos select 2) + 1.5)];
	_unitVar setVectorDirAndUp _vDirAndUp;
	[_unitVar, _config select 0, _config select 1] call BIS_fnc_initVehicle;
	// save respawn data onto vehicle
	_unitVar setVariable ["CCO_vehArray", _vehArray, true];
	// add handlers
	[_unitVar] spawn JST_fnc_addVehRespawnHandlers;
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
	// CCO15 remove Cobra 40mm
	_unitVar removeMagazinesTurret ["vn_m129_v_300_mag", [0]];
	// CCO15 limit tank to 0.5 ammo by loop
	if (_class isEqualTo "vn_o_armor_type63_01_nva65") then
	{
		[_unitVar] spawn
		{
			params ["_unit"];
			while {alive _unit} do
			{
				private _ammoArray = magazinesAmmo _unit;
				private _heArray = _ammoArray select {_x select 0 isEqualTo "vn_t62_v_20_he_mag"};
				private _heCount = _heArray select 0 select 1;
				if (_heCount > 10) then {_unit setVehicleAmmo 0.5};
				UIsleep 10;
			};
		};
	};
	// CCO15 add tow action to ZPUs
	if (_class isEqualTo "vn_o_nva_65_static_zpu4") then
	{
		[_unitVar] remoteExec ["tnk_towAction", 0, true];
	};
	// CCO15 add psyops actions if loudspeaker attached
	if ((_attObjs findIf {(_x select 0) isEqualTo "Land_Loudspeakers_F"}) > -1) then
	{
		[_unitVar, EAST] remoteExec ["JST_fnc_psy_addMenuAction", 0, true];
	};
};

// wait for mission start
waitUntil {time > 3};

// handle vehicles at start: save data, add handlers
{
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
	private _vehArray = [_unitVar, _restricted, _time, _pos, [_vDir, _vUp], _class, _config, _name, _attObjs];
	_unitVar setVariable ["CCO_vehArray", _vehArray, true];
	// CCO15 remove Cobra 40mm
	_unitVar removeMagazinesTurret ["vn_m129_v_300_mag", [0]];
	// CCO15 limit tank to 0.5 ammo by loop
	if (_class isEqualTo "vn_o_armor_type63_01_nva65") then
	{
		[_unitVar] spawn
		{
			params ["_unit"];
			while {alive _unit} do
			{
				private _ammoArray = magazinesAmmo _unit;
				private _heArray = _ammoArray select {_x select 0 isEqualTo "vn_t62_v_20_he_mag"};
				private _heCount = _heArray select 0 select 1;
				if (_heCount > 10) then {_unit setVehicleAmmo 0.5};
				UIsleep 10;
			};
		};
	};
	// CCO15 add tow action to ZPUs
	if (_class isEqualTo "vn_o_nva_65_static_zpu4") then
	{
		[_unitVar] remoteExec ["tnk_towAction", 0, true];
	};
	// CCO15 add psyops actions if loudspeaker attached
	if ((_attObjs findIf {(_x select 0) isEqualTo "Land_Loudspeakers_F"}) > -1) then
	{
		[_unitVar, EAST] remoteExec ["JST_fnc_psy_addMenuAction", 0, true];
	};
	// add handlers
	[_unitVar] call JST_fnc_addVehRespawnHandlers;
	// short sleep to avoid overload
	UIsleep 0.25;
} forEach CCO_vehs;

// CCO15 - Add tow actions to MSPs
// Add tow actions to msps for quicker transport
{
	[_x] remoteExec ["tnk_towAction", 0, true];
} forEach [msp1, msp2, msp3];