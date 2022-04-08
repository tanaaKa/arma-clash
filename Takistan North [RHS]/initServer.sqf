// Setup vehicle respawns and restrictions
[] spawn clash_fnc_respawnVehicles;

// Vehicle service
[] spawn clash_fnc_serviceVehicles;

obj1Trigger enableSimulationGlobal true;
obj2Trigger enableSimulationGlobal false;
obj3Trigger enableSimulationGlobal true;
bluforHQ enableSimulationGlobal false;
opforHQ enableSimulationGlobal false;

// Bleed settings
[[WEST,EAST], 0.6, 1, 15] call BIS_fnc_bleedTickets;

// Frontline visualization
[] execVM "modules\JST_Frontline\JST_FL_init.sqf";