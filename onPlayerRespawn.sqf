// Set loadout
player setUnitLoadout (player getVariable ["clash_loadout", []]);

// Ensure funds are carried over on death
_funds = profileNamespace getVariable "clash_aas_money";
[player,_funds] call grad_lbm_fnc_setFunds;