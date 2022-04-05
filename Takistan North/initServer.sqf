// Setup vehicle respawns and restrictions
[] spawn clash_fnc_respawnVehicles;

// Vehicle service
[] spawn clash_fnc_serviceVehicles;

hillTrigger enableSimulationGlobal false;
bluforHQ enableSimulationGlobal false;
opforHQ enableSimulationGlobal false;
milbaseTrigger enableSimulationGlobal true;
commTrigger enableSimulationGlobal true;

// Bleed settings
[[WEST,EAST], 0.6, 1, 15] call BIS_fnc_bleedTickets;

// Frontline visualization
[] execVM "modules\JST_Frontline\JST_FL_init.sqf";