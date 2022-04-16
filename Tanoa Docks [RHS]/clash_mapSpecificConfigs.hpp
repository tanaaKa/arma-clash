// per map settings
// Tanoa Docks

// minimum distance between FOBs
clash_fobDistance = 200;

// vehicles that respawn
Clash_vehs =
[
	//[veh, crew restricted, respawn time, function to run on spawn (server only, vehicle passed as param)]
	[bifv1,		true,		(10*60), 		{}],
	[bifv2,		true,		(10*60), 		{}],
	[oifv1,		true,		(10*60), 		{}],
	[oifv2,		true,		(10*60), 		{}],
	[btruck1,	false,		(5*60), 		{}],
	[btruck2,	false,		(5*60), 		{}],
	[btruck3,	false,		(5*60), 		{}],
	[btruck4,	false,		(5*60), 		{}],
	[otruck1,	false,		(5*60), 		{}],
	[otruck2,	false,		(5*60), 		{}],
	[otruck3,	false,		(5*60), 		{}],
	[otruck4,	false,		(5*60), 		{}],
	[cheli1,	false,		(10*60), 		{}],
	[cheli2,	false,		(10*60), 		{}],
	[cifv1,		false,		(10*60), 		{}],
	[carty1,	false,		(10*60), 		{}]
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

// banned vehicle magazines
VehBannedMagazines =
[

];