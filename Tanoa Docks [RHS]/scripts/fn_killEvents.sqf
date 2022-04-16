// handles and queues kill events, runs locally on death of client or vehicle

params ["_unit"];

// random sleep time to decrease chance of next code block running simultaneously with a duplicate and therefore not working
UIsleep (random 0.5);

// do not run if already running
private _running = _unit getVariable ["clash_killEventsRunning", false];
if (_running) exitWith
{
	if JST_debug then {["killEvents called, but already running. Quitting..."] remoteExec ["systemChat", 0]};
};
_unit setVariable ["clash_killEventsRunning", true];

// load last hitter
private _lastHitter = _unit getVariable ["clash_lastHitter", 0];

// check if dead unit is man or vehicle
private _wasVehicle = if (_unit isKindOf "CAManBase") then {false} else {true};
private _reward = if (_wasVehicle) then {350} else {100};

// if no recorded last hit and is a man, save current money and quit
if (_lastHitter isEqualTo 0) exitWith
{
	// if dead object was vehicle, simply do nothing
	// if was man, save money
	if (!_wasVehicle) then
	{
		private _currentMoney = [_unit] call grad_lbm_fnc_getFunds;
		profileNamespace setVariable ["clash_aas_money",_currentMoney];
		// debug
		if JST_debug then {["Man killed event with no lastHitter, quitting..."] remoteExec ["systemChat", 0]};
	};
};

// if there was a recorded last hit, execute kill events...

// record side of killer
private _killerSide = side group _lastHitter;

// record name of killer
private _killerName = name _lastHitter;

// make killer an array in case of vehicle crew
private _killers = [];
{
	_killers pushBack _x;
} forEach crew (vehicle _lastHitter);

// record side of dead unit/vehicle
private _deadSide = 0;
if (_wasVehicle) then
{
	// use side of crew if any present
	if (count (crew _unit) > 0) then
	{
		_deadSide = side (group ((crew _unit) select 0));
	}
	else
	{
		// check if there's one user saved side, if one, use it, if many, treat as non-owned, if none, use config side
		private _configSide = (getNumber (configfile >> "CfgVehicles" >> typeOf _unit >> "side"));
		private _sideLocInfo = _unit getVariable ["sideLocInfo", [[_configSide],"MAIN"]];
		private _sideArr = _sideLocInfo select 0;
		if (count _sideArr isEqualTo 1) then
		{
			_deadSide = _sideArr select 0;
			switch (_deadSide) do
			{
				case 0: {_deadSide = EAST};
				case 1: {_deadSide = WEST};
				case 2: {_deadSide = INDEPENDENT};
				default {_deadSide = CIVILIAN};
			};
		}
		else
		{
			_deadSide = "NONE";
		}
	};
}
else
{
	_deadSide = side (group _unit);
};

// record name of dead unit/vehicle
private _deadName =
if (_wasVehicle) then
{
	"a " + getText (configFile >> "CfgVehicles" >> (typeOf _unit) >> "displayName")
}
else
{
	name _unit
};

// init kill type string ("killed" vs "teamkilled")
private _killType = "killed";

switch true do
{
	// teamkill
	case (_killerSide isEqualTo _deadSide):
	{
		{
			// remove money
			[_x, _reward * -1] call grad_lbm_fnc_addFunds;
			// send message
			[ 
				format  
				[ 
					"<t color='#B71900' font='PuristaBold' size = '0.6' shadow='1'>Credits deducted for teamkill!</t>"
				],-0.8,1.1,4,1,0.25,789
			] remoteExec ["BIS_fnc_dynamicText", _x];
			[ 
				format  
				[ 
					"You teamkilled %1 (-%2CR)!",
					_deadName,
					_reward
				]
			] remoteExec ["systemChat", _x];
			// send sound
			"FD_CP_Clear_F" remoteExec ["playSound", _x];
		} forEach _killers;
		// change kill type string
		_killType = "teamkilled";
		// debug
		if JST_debug then {["Teamkill event!"] remoteExec ["systemChat", 0]};
	};
	// kill of non-owned object
	case (_deadSide isEqualTo "NONE"):
	{
		// nothing, nobody cares
	};
	// valid kill on enemy
	default
	{
		{
			// send money
			[_x, _reward] call grad_lbm_fnc_addFunds;
			// send message
			[
				format  
				[ 
					"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>Credits awarded for kill!</t>"
				],-0.8,1.1,4,1,0.25,789
			] remoteExec ["BIS_fnc_dynamicText", _x];
			[
				format  
				[ 
					"You killed %1 (+%2CR)", 
					_deadName,
					_reward
				]
			] remoteExec ["systemChat", _x];
			// send sound
			"FD_CP_Clear_F" remoteExec ["playSound",_x];
		} forEach _killers;
		// debug
		if JST_debug then {["Enemy kill event!"] remoteExec ["systemChat", 0]};
	};
};
/*
// if teamkill, remove money from killers and send messages to them
if (_killerSide isEqualTo _deadSide) then
{
	{
		// remove money
		[_x, _reward * -1] call grad_lbm_fnc_addFunds;
		// send message
		[ 
			format  
			[ 
				"<t color='#B71900' font='PuristaBold' size = '0.6' shadow='1'>Credits deducted for teamkill!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
		[ 
			format  
			[ 
				"You teamkilled %1 (-%2CR)!",
				_deadName,
				_reward
			]
		] remoteExec ["systemChat", _x];
		// send sound
		"FD_CP_Clear_F" remoteExec ["playSound", _x];
	} forEach _killers;
	// change kill type string
	_killType = "teamkilled";
	// debug
	if JST_debug then {["Teamkill event!"] remoteExec ["systemChat", 0]};
}
// if enemy kill, add money and send messages to killers
else
{
	{
		// send money
		[_x, _reward] call grad_lbm_fnc_addFunds;
		// send message
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>Credits awarded for kill!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
		[
			format  
			[ 
				"You killed %1 (+%2CR)", 
				_deadName,
				_reward
			]
		] remoteExec ["systemChat", _x];
		// send sound
		"FD_CP_Clear_F" remoteExec ["playSound",_x];
	} forEach _killers;
	// debug
	if JST_debug then {["Enemy kill event!"] remoteExec ["systemChat", 0]};
};
*/
// message to self if was man
if (!_wasVehicle) then
{
	[
		format  
		[ 
			"<t color='#FFD500' font='PuristaBold' size = '1' shadow='1'>You were killed!</t>"
		],-1,-1,4,1,0,790
	] remoteExec ["BIS_fnc_dynamicText", _unit];
	[
		format  
		[ 
			"You were %1 by %2 from %3m", 
			_killType,
			_killerName,
			_unit distance _lastHitter 
		]
	] remoteExec ["systemChat", _unit];
};

// allow future kill events and reset last hitter (probably not necessary but I'm paranoid)
_unit setVariable ["clash_lastHitter", 0];
_unit setVariable ["clash_killEventsRunning", false];
player setVariable ["clash_lastHitter", 0];
player setVariable ["clash_killEventsRunning", false];