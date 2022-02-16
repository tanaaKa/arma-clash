// EH for placing objects - Engineers only!
[{
	params ["_unit", "_object", "_cost"];
	
	/* TODO - Deny building if player is not engineer
	if !(typeOf _unit isEqualTo "B_soldier_repair_F" || typeOf _unit isEqualTo "O_soldier_repair_F") exitWith {};
	*/
	
	// Exit if not trying to place a fob
	if !(typeOf _object isEqualTo "Land_Cargo_House_V1_F") exitWith {};
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
		_fobName = [(side _unit), getPos _object] call BIS_fnc_addRespawnPosition;
		_object setVariable ["fobName", _fobName];
		hint "FOB placed. Players may now respawn here";
		
		// Send hint and create marker for friendly players
		_string = format ["A FOB has been built at %1 by %2", mapGridPosition _object, name player];
		_string remoteExec ["systemChat", side player]; 
		{
			_fobMarker = createMarkerLocal ["FOB", _object];
			_fobMarker setMarkerShapeLocal "ICON";
			_fobMarker setmarkerTypeLocal "loc_CivilDefense";
			_fobMarker setMarkerTextLocal format ["FOB %1",name player];	
		} forEach allPlayers select {side _x isEqualTo side player};
		_object setVariable ["fobMarker", _fobMarker];
		
		// Destruction event if the fob is destroyed
		tnk_objDestroyed = 
		{
			if !(isServer) exitWith {};
			
			_object addMPEventHandler ["MPKilled", {
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				
				systemChat "A FOB has been destroyed";
				
				// Get respawn and marker variable to remove them
				_respawnToDelete = ((_this select 0) getVariable "fobName");
				_markerToDelete = ((_this select 0) getVariable "fobMarker");
				_respawnToDelete call BIS_fnc_removeRespawnPosition;
				deleteMarkerLocal _markerToDelete;
			}];
		};
		_object remoteExec ["tnk_objDestroyed",0];
	};

	_return
}] call ace_fortify_fnc_addDeployHandler;

// Basic code to lock vehicles to crew for now
// Needs optimized
player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	
	if (_vehicle isKindOf "Wheeled_APC_F" || _vehicle isKindOf "APC_Tracked_02_base_F") then {
		if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
		{
			if !(typeOf _unit in AllowedGroundCrew) then {
				moveOut _unit;
				systemChat "You are not authorized ground crew.";
			} else {
				systemChat "Vehicle authorized as crew.";
			};
		};
	};
	if (_vehicle isKindOf "AIR") then {
		if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
		{
			if !(typeOf _unit in AllowedAirCrew) then {
				moveOut _unit;
				systemChat "You are not authorized air crew.";
			} else {
				systemChat "Vehicle authorized as pilot.";
			};
		};
	};
}];

// Economy system for kills + kill messages
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	
	if (_killer isEqualTo _unit) exitWith {};
	
	if (side _unit isEqualTo side _killer) then { // Check for teamkill
		[_killer,-100] call grad_lbm_fnc_addFunds;
		_killerText = 
		[ 
			format  
			[ 
				"<t color='#B71900' font='PuristaBold' size = '0.6'>You teamkilled %1 (-100CR)</t>", 
				name _unit
			],-0.8,1.1,4,1,0,789
		];
		_killerText remoteExec ["BIS_fnc_dynamicText", _killer];
	} else { // else award money
		[_killer,100] call grad_lbm_fnc_addFunds;
		_killerText = 
		[ 
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6'>You killed %1 (+100CR)</t>", 
				name _unit 
			],-0.8,1.1,4,1,0,789
		];
		_killerText remoteExec ["BIS_fnc_dynamicText", _killer];
	};
	
	_unitText = 
	[ 
		format  
		[ 
			"<t color='#FFD500' font='PuristaBold' size = '1'>You were killed by %1 from %2m</t>", 
			name _killer, _unit distance _killer 
		],-1,-1,4,1,0,790
	];
	_unitText remoteExec ["BIS_fnc_dynamicText", _unit];
}];

// Basic markers systems
[] execVM "scripts\player_markers.sqf";

// Basic safezone system
[] execVM "scripts\safezone.sqf";

// Add starting money or add former amount of money
_formerMoney = profileNamespace getVariable "tnk_aas_money";
if (isNil "_formerMoney") then {
	[player,200] call grad_lbm_fnc_setFunds;
	profileNamespace setVariable ["tnk_aas_money",200];
} else {
	[player,_formerMoney] call grad_lbm_fnc_setFunds;
};

// Save loadout for respawn
player setVariable ["tnk_loadout", getUnitLoadout player];