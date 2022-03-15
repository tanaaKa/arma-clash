// Some base constants
FOBOBJECT = "Land_Cargo_House_V1_F";

// EH for building objects and fobs
// Note: not very elegant lmao
[{
	params ["_unit", "_object", "_cost"];
	_isEngineer = true;
	_build = true;
	_nearFOB = false;
	_inSpawn = (_unit inArea osafezone) || (_unit inArea bsafezone);
	_heightCheck = (getPosATL _object) select 2 < 1;
	
	// Check if unit is engineer
	if !(typeOf _unit isEqualTo "B_soldier_repair_F" || typeOf _unit isEqualTo "O_soldier_repair_F") then {
		// Deny building
		_isEngineer = false;
		_build = false;
	};
	
	// Search for fob building within x meters
	private _nearestFobs = nearestObjects [_unit, [FOBOBJECT], 600];
	// remove from list if dead because nearestObjects finds dead objects for a while
	for "_i" from ((count _nearestFobs) - 1) to 0 step -1 do
	{
		if !(alive (_nearestFobs select _i)) then
		{
			_nearestFobs deleteAt _i;
		};
	};
	// Check if FOB is placeable
	// True - no fob within 300m - therefore placeable
	// False - 1 or more fobs within 300m - therefore not placeable
	// We have to subtract 1 because it counts the current object we're trying to place (lmao)
	private _fobBuildable = ((count _nearestFobs - 1) isEqualTo 0);
	private _nearFOB = (count (nearestObjects [_unit, [FOBOBJECT], 100])) > 0; // Build only around fobs
	private _fobSide = (_nearestFobs select 0 getVariable "fobSide");
	
	if (_isEngineer && typeOf _object isEqualTo FOBOBJECT && _fobBuildable && !_inSpawn) then {
		_build = true; // make it placeable
		
		// Rest of the FOB code is down below in the FOB EH
	};
	
	if (typeOf _object isEqualTo FOBOBJECT && !_fobBuildable) then {
		_build = false;
		playsound "Hint3";
		systemChat "Cannot build. There is already a FOB within 600m of here.";
	};
	
	if (_isEngineer && _inSpawn) then {	// Disable building in spawns
		_build = false; 
		playsound "Hint3";
		systemChat "Building is disabled in the spawn.";
	};
	
	if !(_isEngineer) then {
		_build = false; 
		playsound "Hint3";
		systemChat "You can only build if you're an engineer.";
	};
	
	if (_isEngineer && !_nearFOB) then {
		_build = false; 
		playsound "Hint3";
		systemChat "You must be within 100m of the FOB to build.";
	};
	
	if (_isEngineer && _fobSide isNotEqualTo side _unit) then {
		_build = false; 
		playsound "Hint3";
		systemChat "You cannot build at an enemy FOB";
	};
	
	if (_isEngineer && !_heightCheck) then {
		_build = false; 
		playsound "Hint3";
		systemChat "You cannot build floating objects";
	};
	
	// I really hate how I have to do this but there's so many fucking variables to check for
	// So much for object oriented in - out lmao
	if (_isEngineer && typeOf _object != FOBOBJECT && _nearFOB && !_inSpawn && _fobSide isEqualTo side _unit && _heightCheck) then {
		_build = true;
	};
	
	_build	// always returns true/false. T - can be built / F - cannot be built
}] call ace_fortify_fnc_addDeployHandler;

// saves instigator of last hit in case of kills on vehicles / target clicking respawn not recording real killer
player addEventHandler
[
	"Hit",
	{
		params ["_unit", "_source", "_damage", "_instigator"];
		// if hit was from real unit, record unit
		if (!(_instigator isEqualTo _unit) and (_instigator isKindOf "CAManBase")) then
		{
			_unit setVariable ["clash_lastHitter", _instigator];
		};
	}
];

// runs kills tracker on respawn (no gaming the system, Godonan... last hit will still get credited)
player addEventHandler
[
	"Respawn",
	{
		params ["_unit", "_corpse"];
		// if there was a valid last hit in the past life not yet rewarded, credit hitter with kill
		private _lastHitter = _unit getVariable ["clash_lastHitter", 0];
		if !(_lastHitter isEqualTo 0) then
		{
			[_unit] spawn clash_fnc_killEvents;
		};
		// in any case, load money and loadout
		player setUnitLoadout (profileNamespace getVariable ["clash_loadout", []]);
		[player, (profileNamespace getVariable "clash_aas_money")] call grad_lbm_fnc_setFunds;
	}
];

// kills tracker
player addEventHandler
[
	"Killed",
	{
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		// if kill was from real unit, record unit
		if (!(_instigator isEqualTo _unit) and (_instigator isKindOf "CAManBase")) then
		{
			_unit setVariable ["clash_lastHitter", _instigator];
		};
		// perform kill events
		[_unit] spawn clash_fnc_killEvents;
	}
];

// EH to remove radios and fortify on death
["CAManBase", "Killed", {
	params ["_unit"];
	// Delete fortify tool
	if (typeOf _unit isEqualTo "B_soldier_repair_F" || typeOf _unit isEqualTo "O_soldier_repair_F") then {
		_unit removeItem "ACE_Fortify";
	};
	
	// Delete commander uav terminal
	if (typeOf _unit isEqualTo "B_officer_F" || typeOf _unit isEqualTo "O_officer_F") then {
		_unit removeItem "O_UavTerminal";
		_unit removeItem "B_UavTerminal";
	};
	
	// Get all radios and remove those motherfuckers
	private _radios = [];
	{
		if ((getNumber (configFile >> "CfgWeapons" >> _x >> "acre_isUnique")) > 0) then {
			private _newBase = getText (configFile >> "CfgWeapons" >> _x >> "acre_baseClass");
			_radios pushBack [_x, _newBase];
		};
	} forEach (items _unit);
	
	_radios spawn {
		{
			_x params ["_oldRadio"];
			player removeItem _oldRadio;
			sleep 0.25;
		} forEach _this;
	};
}, true, [], true] call CBA_fnc_addClassEventHandler;

// Add object placed event handler to handle money
// WARNING: THIS IS GLOBAL, HENCE THE LOCALITY CHECK AT THE TOP
// TODO: Move to global EH file
["acex_fortify_objectPlaced", {
	params["_unit", "_side", "_object"];
	
	// only run on player placing the object
	if !(player isEqualTo _unit) exitWith {};
	
	// init reward vars into default values
	private _fortName = "Fortification";
	private _moneyToPay = 20;
	private _soundToPlay = "FD_CP_Clear_F";
		
	// switch through table of possible objects
	switch (typeOf _object) do
	{
		case FOBOBJECT: // FOB
		{
			// alter reward vars
			_fortName = "FOB";
			_moneyToPay = 200;
			_soundToPlay = "FD_Finish_F";
			
			// find needed side variables
			private _fobSide = side _unit;
			private _enemySide = switch (_fobSide) do
			{
				case EAST: {WEST};
				case WEST: {EAST};
			};
			
			// create spawnpoint
			private _spawnPoint = [_fobSide, getPos _object] call BIS_fnc_addRespawnPosition;
			
			// create name str based on who created it
			private _fobName = format ["FOB %1", name _unit];
			
			// set invincible, can only be destroyed by certain units
			_object allowDamage false;
			
			// create marker
			[_object, _fobName, true] remoteExec ["clash_fnc_handleFOBMarker", _fobSide, true];
			
			// create trigger that warns fob side when enemy nearby
			private _trg = createTrigger ["EmptyDetector", getPos _object];
			_trg setTriggerArea [100, 100, 0, false];
			_trg setTriggerActivation [str _enemySide, "PRESENT", true];
			_trg setTriggerInterval 3;
			private _onAct = format ["if (side player isEqualTo %1) then {systemChat 'Enemies near %2!'};", _fobSide, _fobName];
			_trg setTriggerStatements ["this", _onAct, ""];
			
			// save vars onto the fob for later use by other clients
			_object setVariable ["clash_fobRespawn", _spawnPoint];
			_object setVariable ["clash_fobSide", _fobSide];
			_object setVariable ["clash_fobName", _fobName];
			_object setVariable ["clash_fobTrigger", _trg];
			
			// broadcast hint and sound to fob side
			format ["A FOB has been built by %1", name _unit] remoteExec ["systemChat", _fobSide];
			"FD_Finish_F" remoteExec ["playSound", _fobSide];
			
			// add destroy action to engs
			[_object] remoteExec ["clash_fnc_createFOBAction", 0, true];
		};
		default // all other object types
		{
			
		};
	};
	
	// reward player for placing object
	[_unit, _moneyToPay] call grad_lbm_fnc_addFunds;
	_unitText = 
	[
		format
		[ 
			"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>%1 Built (+%2CR)</t>",
			_fortName,
			_moneyToPay
		],
		-0.8,1.1,4,1,0.25,789
		
	];
	_unitText remoteExec ["BIS_fnc_dynamicText", _unit];
	
	// play sound
	playSound _soundToPlay;
	
}] call CBA_fnc_addEventHandler;

// get in and get out eventhandlers to reward pilots and drivers for transporting pax
// reward is adjusted to 0-200 credits per player transported based on playable map size
player addEventHandler
[
	"GetInMan",
	{
		params ["_unit", "_role", "_vehicle", "_turret"];
		// only run on machine of player who got in a vehicle
		if !(player isEqualTo _unit) exitWith {};
		[_unit, _role, _vehicle, _turret] spawn 
		{
			params ["_unit", "_role", "_vehicle", "_turret"];
			// log starting pos of vehicle
			private _pos = position _vehicle;
			// wait for seat corrections for fat fingered bitches
			UIsleep 5;
			// if in pax seat, log data of vehicle, else set 0
			if (_role isEqualTo "cargo") then
			{
				CLASH_getInData = [_pos, _vehicle];
			}
			else
			{
				CLASH_getInData = 0;
			};
		};
	}
];
player addEventHandler
[
	"GetOutMan",
	{
		params ["_unit", "_role", "_vehicle", "_turret"];
		// only run on machine of player who got in a vehicle
		if !(player isEqualTo _unit) exitWith {};
		[_unit, _role, _vehicle, _turret] spawn 
		{
			params ["_unit", "_role", "_vehicle", "_turret"];
			// if error in data (e.g. player was the driver) do nothing
			if (CLASH_getInData isEqualTo 0) then
			{}
			else
			{
				// if unit was in pax seat, reward driver of vehicle based on distance driven compared to map size
				if ((_role isEqualTo "cargo") and (_vehicle isEqualTo (CLASH_getInData select 1))) then
				{
					// calculate reward
					private _disPax = round ((CLASH_getInData select 0) distance2D (position _vehicle));
					private _disMap = round ((markerPos "respawn_west") distance2D (markerPos "respawn_east"));
					private _reward = linearConversion [0, _disMap, _disPax, 0, 200, true];
					// reward driver
					[driver _vehicle, _reward] call grad_lbm_fnc_addFunds;
					_driverText =
					[
						format  
						[ 
							"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>You transported %1 %2m(+%3CR)</t>", 
							name _unit,
							_disPax,
							_reward
						],-0.8,1.1,4,1,0.25,789
					];
					_driverText remoteExec ["BIS_fnc_dynamicText", driver _vehicle];
					"FD_CP_Clear_F" remoteExec ["playSound", driver _vehicle];
					// reset data
					CLASH_getInData = 0;
				}
				// if things don't match up with this being a transport trip, reset data and do nothing
				else
				{
					CLASH_getInData = 0;
				};
			};
		};
	}
];