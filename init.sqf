setviewdistance 2000;

JST_debug = false;

// safe zone triggers
CLASH_safeZones = [bsafezone, osafezone];

// Buy locations
[bPC,"bluforWeapons",bOF,bHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == WEST}] call grad_lbm_fnc_addInteraction;
[oPC,"bluforWeapons",oOF,oHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == EAST}] call grad_lbm_fnc_addInteraction;

// Active fob list
activeFOBs = [];
activeFOBMarkers = [];