// find and update teleport network on local client's side

params ["_side"];

// don't run where local client isn't on a side (pointless)
if !((side player isEqualTo WEST) or (side player IsEqualTo EAST)) exitWith {};

// find all fobs
clash_teleporters = allMissionObjects "Land_Cargo_House_V1_F";
// remove those not on correct side or dead
for "_i" from ((count clash_teleporters) - 1) to 0 step -1 do
{
	private _obj = clash_teleporters select _i;
	if (_side isEqualTo WEST) then
	{
		if ((_obj getVariable ["clash_fobSide", "NONE"]) isEqualTo EAST) then
		{
			clash_teleporters deleteAt _i;
		};
	};
	if (_side isEqualTo EAST) then
	{
		if ((_obj getVariable ["clash_fobSide", "NONE"]) isEqualTo WEST) then
		{
			clash_teleporters deleteAt _i;
		};
	};
	//if !(alive _obj) then {clash_teleporters deleteAt _i};
};

// add pc of correct side
if (_side isEqualTo WEST) then {clash_teleporters pushBack bPC} else {clash_teleporters pushBack oPC};

// remove all teleport actions from entire network
{
	private _teleporterFrom = _x;
	{
		private _teleporterTo = _x;
		if !(_teleporterFrom isEqualTo _teleporterTo) then
		{
			private _actionVarFrom = (str _teleporterFrom) + "_" + (str _teleporterTo);
			private _actionIDFrom = _teleporterFrom getVariable [_actionVarFrom, nil];
			if (!isNil "_actionIDFrom") then {_teleporterFrom removeAction _actionIDFrom};
			private _actionVarTo = (str _teleporterTo) + "_" + (str _teleporterFrom);
			private _actionIDTo = _teleporterTo getVariable [_actionVarTo, nil];
			if (!isNil "_actionIDTo") then {_teleporterTo removeAction _actionIDTo};
		};
	} forEach clash_teleporters;
} forEach clash_teleporters;

// add teleport actions to each object to go to each other object (unless teleporterTO is dead)
{
	private _teleporterFrom = _x;
	{
		private _teleporterTo = _x;
		if !(alive _teleporterTo) then {continue};
		if !(_teleporterFrom isEqualTo _teleporterTo) then
		{
			private _actionVar = (str _teleporterFrom) + "_" + (str _teleporterTo);
			private _toStr = _teleporterTo getVariable ["clash_fobName", "MAIN"];
			_teleporterFrom setVariable
			[
				_actionVar,
				[
					_teleporterFrom,
					format ["Teleport to %1", _toStr],
					"",
					"",
					"_this distance _target < 5",
					"_this distance _target < 5",
					{},
					{},
					{
						player setVehiclePosition [(getPos (_this select 3 select 1)), [], 5, "NONE"];
						player setDir (player getDir (_this select 3 select 1));
					},
					{},
					[_toStr, _teleporterTo],
					2,
					0,
					false,
					false
				] call BIS_fnc_holdActionAdd,
				false
			];
		};
	} forEach clash_teleporters;
} forEach clash_teleporters;