// Set loadout
player setUnitLoadout (player getVariable ["tnk_loadout", []]);

// Ensure funds are carried over on death
_funds = profileNamespace getVariable "tnk_aas_money";
[player,_funds] call grad_lbm_fnc_setFunds;