if (typeOf player in Engineers) then {
	player additem "ACE_Fortify";
};

player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	
	// Basic code to lock vehicles to crew for now
	// Needs optimized
	if (_vehicle isKindOf "TANK") then {
		if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
		{
			moveOut _unit;
			systemChat "You are not authorized ground crew.";
		};
	};
	if (_vehicle isKindOf "AIR") then {
		if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]])) then
		{
			moveOut _unit;
			systemChat "You are not authorized air crew.";
		};
	};
}];