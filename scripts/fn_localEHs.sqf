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
	
	// Search for fob within 300 meters
	private _nearestFobs = nearestObjects [_unit, [FOBOBJECT], 600];
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

// Economy system for kills + kill messages
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	_crew = [_instigator];
	
	// do nothing if self-kill
	if ((_killer isEqualTo _unit) or (_instigator isEqualTo _unit)) exitWith {};
	
	// Check if vehicle, if so set instigator to the entire crew
	if !(isNull objectParent _instigator) then {_crew = crew vehicle _instigator};
	
	// check for teamkill, if so remove money from killer(s)
	if (side (group _unit) isEqualTo side (group _instigator)) then
	{
		{
			[_x, -100] call grad_lbm_fnc_addFunds;
			_killerText = 
			[ 
				format  
				[ 
					"<t color='#B71900' font='PuristaBold' size = '0.6' shadow='1'>You teamkilled %1 (-100CR)</t>", 
					name _unit
				],-0.8,1.1,4,1,0.25,789
			];
			_killerText remoteExec ["BIS_fnc_dynamicText", _x];
			"FD_CP_Clear_F" remoteExec ["playSound",_x];
		} forEach _crew;
	}
	// else award money + msg to killer(s)
	else
	{
		{
			[_x, 100] call grad_lbm_fnc_addFunds;
			_killerText =
			[
				format  
				[ 
					"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>You killed %1 (+100CR)</t>", 
					name _unit 
				],-0.8,1.1,4,1,0.25,789
			];
			_killerText remoteExec ["BIS_fnc_dynamicText", _x];
			"FD_CP_Clear_F" remoteExec ["playSound",_x];
		} forEach _crew;
	};
	
	// msg to self
	_unitText = 
	[ 
		format  
		[ 
			"<t color='#FFD500' font='PuristaBold' size = '1' shadow='1'>You were killed by %1 from %2m</t>", 
			name _instigator, _unit distance _instigator 
		],-1,-1,4,1,0,790
	];
	_unitText remoteExec ["BIS_fnc_dynamicText", _unit];
	
	// Set money the player had on death
	_currentMoney = [_unit] call grad_lbm_fnc_getFunds;
	profileNamespace setVariable ["tnk_aas_money",_currentMoney];
}];

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
	params["_unit","_side","_object"];
	_fortName = "Fortification";
	_moneyToPay = 20;
	_soundToPlay = "FD_CP_Clear_F";
	
	// Locality Check
	if (player isNotEqualTo _unit) exitWith {};
	
	// Pay these motherfuckers based on object placed
	// We can set an entire table of payouts here based on object type
	switch (typeOf _object) do {
		case FOBOBJECT: // FOBs
		{
			_fortName = "FOB";
			_moneyToPay = 200;
			_soundToPlay = "FD_Finish_F";
		};
		default 		// Everything else basically
		{
			
		};
	};
	
	// Create a FOB if it's the fob object
	if (typeOf _object isEqualTo FOBOBJECT) then {
		_spawnPoint = [(side _unit), getPos _object] call BIS_fnc_addRespawnPosition;
		_object setVariable ["fobRespawn", _spawnPoint]; 	// respawn to delete
		_object setVariable ["fobSide", side _unit];		// makes FOBs side-based
		_object allowDamage false;
		
		// Create fob markers + sound
		{
			if (side _x isEqualTo side _unit) then {
				_fobMarker = createMarkerLocal ["FOB", _object];
				_fobMarker setMarkerShapeLocal "ICON";
				_fobMarker setmarkerTypeLocal "loc_CivilDefense";
				_fobMarker setMarkerTextLocal format ["FOB %1",name _unit];
				
				_100m = createMarkerLocal ["10mm", _object];
				_100m setMarkerShapeLocal "ELLIPSE";
				_100m setMarkerTypeLocal "ellipse";
				_100m setMarkerSizeLocal [100,100];
				_100m setMarkerBrushLocal "Border";
			};
		} forEach allPlayers;
		
		// Hint + sound
		// Might be better to move this into the loop above
		format ["A FOB has been built at %1 by %2", mapGridPosition _object, name _unit] remoteExec ["systemChat", side _unit];
		"FD_Finish_F" remoteExec ["playSound", side _unit];
		
		// Create a destroy action for said FOB
		// Only engis and demolitions can destroy the FOB with a satchel in their inventory
		_condition = 
		{
			(typeOf _player isEqualTo "B_soldier_repair_F" || typeOf _player isEqualTo "O_soldier_repair_F" || typeOf _player isEqualTo "B_soldier_exp_F" || typeOf _player isEqualTo "O_soldier_exp_F") && ("SatchelCharge_Remote_Mag" in items _player);
		};
		_dfAction = ["destroyFOB","Place Charge on FOB","",{_player removeItem "SatchelCharge_Remote_Mag"; call TNK_fnc_destroyFOB},_condition,{},[_object], {[0,0,0]}, 5] call ace_interact_menu_fnc_createAction;
		[_object, 0, ["ACE_MainActions"], _dfAction] call ace_interact_menu_fnc_addActionToObject;
	};
	
	// Finally
	[_unit,_moneyToPay] call grad_lbm_fnc_addFunds;
	_unitText = 
	[
		format
		[ 
			"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>%1 Built (+%2CR)</t>"
			,_fortName,_moneyToPay
		],-0.8,1.1,4,1,0.25,789
		
	];
	_unitText remoteExec ["BIS_fnc_dynamicText", _unit];
	
	// Play sound
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