// per map settings
// Takistan North

// minimum distance between FOBs
clash_fobDistance = 500;

// Vehicle-specific functions defined up top, param is always the vehicle
clash_fnc_vbiedActions =
{
	params ["_veh"];
	// remove any existing actions
	[_veh] remoteExec ["removeAllActions", 0];
	UIsleep 3;
	// add new actions
	[
		_veh,
		"<t color='#ff0000'>VBIED: Activate Driver Deadman's Switch (1s)</t>",
		"",
		"",
		"(driver _target) isEqualTo player",
		"(driver _target) isEqualTo player",
		{},
		{},
		{
			[_this select 0, _this select 1] spawn
			{
				params ["_veh", "_caller"];
				systemChat "Deadman's switch activated on you. It will deactivate if you exit the driver's seat.";
				// while driver in-seat and ok and vehicle OK, just wait for change
				while {(((driver _veh) isEqualTo _caller) and (alive _veh) and (((lifeState _caller) isEqualTo "HEALTHY") or ((lifeState _caller) isEqualTo "INJURED")))} do
				{
					UIsleep 1;
				};
				// if vehicle dead or driver uncon/dead, explode
				if ((((driver _veh) isEqualTo _caller) and (((lifeState _caller) isEqualTo "DEAD") or ((lifeState _caller) isEqualTo "DEAD-RESPAWN") or ((lifeState _caller) isEqualTo "DEAD-SWITCHING") or ((lifeState _caller) isEqualTo "INCAPACITATED"))) or !(alive _veh)) then
				{
					systemChat "Deadman's switch activating!";
					private _nearbyUnits = _veh nearEntities ["MAN", 75];
					{
						[_x, ["clash_lastHitter", _caller]] remoteExec ["setVariable", _x];
					} forEach _nearbyUnits;
					_veh engineOn false;
					UIsleep 3;
					"Bo_Mk82" createVehicle (getpos _veh);
					_veh setDamage 1;
					_caller setDamage 1;
				};
				// if driver has exited the seat, deactivate
				if (!((driver _veh) isEqualTo _caller) and (alive _veh)) then
				{
					systemChat "Deadman's switch disabled.";
				};
			};
		},
		{},
		[],
		1,
		0,
		false,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, true];
	[
		_veh,
		"<t color='#ff0000'>VBIED: Manually Detonate Bomb (1s)</t>",
		"",
		"",
		"(driver _target) isEqualTo player",
		"(driver _target) isEqualTo player",
		{},
		{},
		{
			[_this select 0, _this select 1] spawn
			{
				params ["_veh", "_caller"];
				systemChat "Detonating bomb!";
				private _nearbyUnits = _veh nearEntities ["MAN", 75];
				{
					[_x, ["clash_lastHitter", _caller]] remoteExec ["setVariable", _x];
				} forEach _nearbyUnits;
				_veh engineOn false;
				UIsleep 3;
				"Bo_Mk82" createVehicle (getpos _veh);
				_veh setDamage 1;
				_caller setDamage 1;
			};
		},
		{},
		[],
		1,
		0,
		true,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, true];
};

// The actual list of vehicles
Clash_vehs =
[
	//[veh, crew restricted, respawn time, function to run on spawn (server only, vehicle passed as param)]
	// first letter is used as the side in some scripts
	[btank,		true,		(10*60), 		{}],
	[otank,		true,		(10*60), 		{}],
	[bifv1,		true,		(10*60), 		{}],
	[bifv2,		true,		(10*60), 		{}],
	[oifv1,		true,		(10*60), 		{}],
	[oifv2,		true,		(10*60), 		{}],
	[btruck1,	false,		(5*60), 		{}],
	[btruck2,	false,		(5*60), 		{}],
	[btruck3,	false,		(5*60), 		{}],
	[btruck4,	false,		(5*60), 		{}],
	[otruck1,	false,		(5*60), 		{}],
	[otruck2,	false,		(5*60), 		{}],
	[otruck3,	false,		(5*60), 		{}],
	[otruck4,	false,		(5*60), 		{}],
	[scud,		false,		(10*60), 		{}],
	[vbied1,	false,		(10*60), 		clash_fnc_vbiedActions],
	[vbied2,	false,		(10*60), 		clash_fnc_vbiedActions]
];

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

// banned vehicle magazines
VehBannedMagazines =
[
	"2Rnd_GAT_missiles_O"
];