params["_FOB","_spawn"];

// play ticking sound
[_FOB,_spawn] spawn {
	params["_FOB","_spawn"];
	
	systemChat format ["_FOB: %1\n_spawn: %2",_FOB,_spawn];
	[_FOB, "bombtick", 100] call CBA_fnc_globalSay3d;

	uiSleep 30; // 30s countdown

	// Big boom
	"Bo_GBU12_LGB" createVehicle (getpos _FOB);

	// Delete spawn point
	[_spawn] call BIS_fnc_removeRespawnPosition;

	// Send noti
	"A FOB has been destroyed" remoteExec ["systemChat",0];
};
