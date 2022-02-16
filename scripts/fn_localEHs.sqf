// EH for placing objects - Engineers only!
[{
	params ["_unit", "_object", "_cost"];
	
	/* TODO - Deny building if player is not engineer
	if !(typeOf _unit isEqualTo "B_soldier_repair_F" || typeOf _unit isEqualTo "O_soldier_repair_F") exitWith {};
	*/
	
	// Exit if not trying to place a fob
	if !(typeOf _object isEqualTo "Land_Cargo_House_V1_F") exitWith {[player,20] call grad_lbm_fnc_addFunds;};
	// Search for fob within 300 meters
	private _nearestFob = nearestObjects [_unit, ["Land_Cargo_House_V1_F"], 300];
	// Check if FOB is placeable
	// True - no fob within 300m - therefore placeable
	// False - 1 or more fobs within 300m - therefore not placeable
	// We have to subtract 1 because it counts the current object we're trying to place (lmao)
	private _return = (count _nearestFob - 1) isEqualTo 0;
	if !(_return) then { // Send error if fob exists within 300m
		hint "Cannot place. There is already a FOB within 300 meters of this position.";
	} else {
		// Add money for engineers building FOB
		[player,100] call grad_lbm_fnc_addFunds;
		_fobName = [(side _unit), getPos _object] call BIS_fnc_addRespawnPosition;
		_object setVariable ["fobName", _fobName];
		_object allowDamage false;
		hint "FOB placed. Players may now respawn here";
		
		// Send hint and create marker for friendly players
		_string = format ["A FOB has been built at %1 by %2", mapGridPosition _object, name player];
		_string remoteExec ["systemChat", side player]; 
		tnk_createSideMarker =
		{
			{
				_fobMarker = createMarkerLocal ["FOB", _object];
				_fobMarker setMarkerShapeLocal "ICON";
				_fobMarker setmarkerTypeLocal "loc_CivilDefense";
				_fobMarker setMarkerTextLocal format ["FOB %1",name player];	
			} forEach allPlayers select {side _x isEqualTo side player};
		};
		remoteExec ["tnk_createSideMarker", side player];
		
		// Destruction event if the fob is destroyed
		// TODO: Add ace interaction action to FOB here to destroy it
		
		/* 	
		_object addMPEventHandler ["MPKilled", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			
			systemChat "A FOB has been destroyed";
			
			// Get respawn and marker variable to remove them
			_respawnToDelete = ((_this select 0) getVariable "fobName");
			_markerToDelete = ((_this select 0) getVariable "fobMarker");
			_respawnToDelete call BIS_fnc_removeRespawnPosition;
			deleteMarkerLocal _markerToDelete;
		}]; */
	};
	
	_return
}] call ace_fortify_fnc_addDeployHandler;

// Economy system for kills + kill messages
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	
	// do nothing if self-kill
	if ((_killer isEqualTo _unit) or (_instigator isEqualTo _unit)) exitWith {};
	
	// check for teamkill, if so remove money from killer
	if (side (group _unit) isEqualTo side (group _instigator)) then
	{
		[_killer, -100] call grad_lbm_fnc_addFunds;
		_killerText = 
		[ 
			format  
			[ 
				"<t color='#B71900' font='PuristaBold' size = '0.6' shadow='1'>You teamkilled %1 (-100CR)</t>", 
				name _unit
			],-0.8,1.1,4,1,0.5,789
		];
		_killerText remoteExec ["BIS_fnc_dynamicText", _killer];
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
			],-0.8,1.1,4,1,0.5,789
		];
		_killerText remoteExec ["BIS_fnc_dynamicText", _killer];
	};
	
	// msg to self
	_unitText = 
	[ 
		format  
		[ 
			"<t color='#FFD500' font='PuristaBold' size = '1' shadow='1'>You were killed by %1 from %2m</t>", 
			name _instigator, _unit distance _killer 
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
	if (typeOf _unit isEqualTo "B_soldier_repair_F" || typeOf _unit isEqualTo "O_soldier_repair_F") then {
		_unit removeItem "ACE_Fortify";
	};
	
	_unit removeItem "ACRE_PRC148";
}, true, [], true] call CBA_fnc_addClassEventHandler;