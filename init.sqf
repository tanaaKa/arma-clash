setviewdistance 2000;

// Buy locations
[bPC,"bluforWeapons",bPC,bHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == WEST}] call grad_lbm_fnc_addInteraction;
[oPC,"bluforWeapons",oPC,oHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == EAST}] call grad_lbm_fnc_addInteraction;