setviewdistance 2000;

JST_debug = false;

#include "fobNames.hpp"

// safe zone triggers
CLASH_safeZones = [bsafezone, osafezone];

// Buy locations

/* OLD ACE INTERACTION METHOD
[bPC,"bluforWeapons",bOF,bHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == WEST}] call grad_lbm_fnc_addInteraction;
[oPC,"opforWeapons",oOF,oHelipad,"BUY MENU (No Refunds!)","Buy Items",{side player == EAST}] call grad_lbm_fnc_addInteraction;
*/

if (hasInterface) then
{
	bPC addAction
	[
		"Open Store",	// title
		{
			(_this select 3) call grad_lbm_fnc_loadBuymenu;
		},
		[
			bPC,
			bOF,
			bHelipad,
			"bluforWeapons",
			"BUY MENU (NO REFUNDS)"
		],		// arguments
		0,		// priority
		true,		// showWindow
		false,		// hideOnUse
		"",			// shortcut
		"((side player) isEqualTo WEST)", 	// condition
		4,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];
	oPC addAction
	[
		"Open Store",	// title
		{
			(_this select 3) call grad_lbm_fnc_loadBuymenu;
		},
		[
			oPC,
			oOF,
			oHelipad,
			"opforWeapons",
			"BUY MENU (NO REFUNDS)"
		],		// arguments
		0,		// priority
		true,		// showWindow
		false,		// hideOnUse
		"",			// shortcut
		"((side player) isEqualTo EAST)", 	// condition
		4,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];
};