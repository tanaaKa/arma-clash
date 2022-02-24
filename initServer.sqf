// Setup vehicle respawns and restrictions
[] spawn TNK_fnc_respawnVehicles;

// Vehicle service
[] spawn TNK_fnc_serviceVehicles;

hillTrigger enableSimulationGlobal false;
bluforHQ enableSimulationGlobal false;
opforHQ enableSimulationGlobal false;
milbaseTrigger enableSimulationGlobal true;
commTrigger enableSimulationGlobal true;

// Bleed settings
[[WEST,EAST], 0.6, 1, 15] call BIS_fnc_bleedTickets;