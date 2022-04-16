// per map settings
// Tanoa Docks

// minimum distance between FOBs
clash_fobDistance = 500;

// vehicles that respawn
Clash_vehs =
[
	[bifv1,		true,		(15*60),	{}],
	[bifv2,		true,		(15*60),	{}],
	[oifv1,		true,		(15*60),	{}],
	[oifv2,		true,		(15*60),	{}],
	[b_ah,		true,		(15*60),	{}],
	[o_ah,		true,		(15*60),	{}],
	[b_th,		true,		(5*60),		{}],
	[o_th,		true,		(5*60),		{}],
	[btruck1,	false,		(5*60),		{}],
	[btruck2,	false,		(5*60),		{}],
	[btruck3,	false,		(5*60),		{}],
	[otruck1,	false,		(5*60),		{}],
	[otruck2,	false,		(5*60),		{}],
	[otruck3,	false,		(5*60),		{}]
];

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

// banned magazines
VehBannedMagazines =
[
	"2Rnd_GAT_missiles_O"
];