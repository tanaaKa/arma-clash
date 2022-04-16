params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

// Set money the player had on death (in this file to cover for deaths other than killed EH)
profileNamespace setVariable ["clash_aas_money", ([_oldUnit] call grad_lbm_fnc_getFunds)];