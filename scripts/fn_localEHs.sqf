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
	
	if (_isEngineer && typeOf _object isEqualTo FOBOBJECT && _fobBuildable && !_inSpawn) then {
		_build = true; // make it placeable
		
		// Rest of the FOB code is down below in the FOB EH
	};
	
	if (typeOf _object isEqualTo FOBOBJECT && !_fobBuildable) then {
		_build = false;
		hint "Cannot build. There is already a FOB within 600m of here.";
	};
	
	if (_isEngineer && _inSpawn) then {	// Disable building in spawns
		_build = false; 
		hint "Building is disabled in the spawn.";
	};
	
	if !(_isEngineer) then {
		_build = false; 
		hint "You can only build if you're an engineer.";
	};
	
	if (_isEngineer && !_nearFOB) then {
		_build = false; 
		hint "You must be within 100m of the FOB to build.";
	};
	
	if (_isEngineer && typeOf _object != FOBOBJECT && _nearFOB && !_inSpawn) then {
		_build = true;
	};
	
	_build	// always returns true/false. T - can be built / F - cannot be built
}] call ace_fortify_fnc_addDeployHandler;

// Economy system for kills + kill messages
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	
	// do nothing if self-kill
	if ((_killer isEqualTo _unit) or (_instigator isEqualTo _unit)) exitWith {};
	
	// check for teamkill, if so remove money from killer
	if (side (group _unit) isEqualTo side (group _instigator)) then
	{
		[_instigator, -100] call grad_lbm_fnc_addFunds;
		_killerText = 
		[ 
			format  
			[ 
				"<t color='#B71900' font='PuristaBold' size = '0.6' shadow='1'>You teamkilled %1 (-100CR)</t>", 
				name _unit
			],-0.8,1.1,4,1,0.25,789
		];
		_killerText remoteExec ["BIS_fnc_dynamicText", _instigator];
	}
	// else award money + msg to killer
	else
	{
		[_killer, 100] call grad_lbm_fnc_addFunds;
		_killerText =
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>You killed %1 (+100CR)</t>", 
				name _unit 
			],-0.8,1.1,4,1,0.25,789
		];
		_killerText remoteExec ["BIS_fnc_dynamicText", _killer];
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
	
	// Locality Check
	if (isServer) exitWith {};
	if (player isNotEqualTo _unit) exitWith {};
	
	_moneyToPay = 0;
	_fortName = "";
	//systemChat format ["Object: %1", typeOf _object];
	
	// Pay these motherfuckers based on object placed
	// We can set an entire table of payouts here based on object type
	switch (typeOf _object) do {
		case FOBOBJECT: // FOBs
		{
			_fortName = "FOB";
			_moneyToPay = 200;
		};
		default 		// Everything else basically
		{
			_fortName = "Fortification";
			_moneyToPay = 20;
		};
	};
	
	// Create a FOB if it's the fob object
	if (typeOf _object isEqualTo FOBOBJECT) then {
		_spawnPoint = [(side _unit), getPos _object] call BIS_fnc_addRespawnPosition;
		_object setVariable ["fobRespawn", _spawnPoint]; // respawn to delete
		_object allowDamage false;
		
		// Create fob marker
		{
			if (side _x isEqualTo side _unit) then {
				_fobMarker = createMarkerLocal ["FOB", _object];
				_fobMarker setMarkerShapeLocal "ICON";
				_fobMarker setmarkerTypeLocal "loc_CivilDefense";
				_fobMarker setMarkerTextLocal format ["FOB %1",name _unit];
			};
		} forEach allPlayers;
		
		// Hint
		systemChat format ["A FOB has been built at %1 by %2", mapGridPosition _object, name _unit];
		
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
}] call CBA_fnc_addEventHandler;