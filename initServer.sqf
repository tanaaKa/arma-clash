// Setup vehicle respawns and restrictions
call TNK_fnc_respawnVehicles;

hillTrigger enableSimulationGlobal false;
bluforHQ enableSimulationGlobal false;
opforHQ enableSimulationGlobal false;

// Buy locations
[bPC,"bluforWeapons",bPC,bHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == WEST}] call grad_lbm_fnc_addInteraction;
[oPC,"bluforWeapons",oPC,oHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == EAST}] call grad_lbm_fnc_addInteraction;