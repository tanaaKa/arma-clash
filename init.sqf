setviewdistance 2000;

// input allowed crew classes for GROUND vehicles
AllowedGroundCrew =
[
	"B_crew_F",
	"O_crew_F"
];

// input allowed crew classes for AIR vehicles
AllowedAirCrew =
[
	"B_Pilot_F",
	"O_Pilot_F"
];

// Buy locations
[bPC,"bluforWeapons",bPC,bHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == WEST}] call grad_lbm_fnc_addInteraction;
[oPC,"bluforWeapons",oPC,oHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == EAST}] call grad_lbm_fnc_addInteraction;