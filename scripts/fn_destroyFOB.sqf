params["_FOB"];

// play ticking sound
[_FOB] spawn {
	params["_FOB"];
	_spawnTodelete = _FOB getVariable "fobRespawn";
	
	//systemChat format ["_FOB: %1\n_spawn: %2",_FOB,_spawnTodelete];
	[_FOB, "bombtick", 100] call CBA_fnc_globalSay3d;

	uiSleep 30; // 30s countdown
	// TODO: Sleep here during countdown that allows the bomb to be "defused"

	// Big boom
	"Bo_GBU12_LGB" createVehicle (getpos _FOB);
	_FOB setDamage 1;
	
	// Remove action
	[_FOB, 0, ["ACE_MainActions", "destroyFOB"]] call ace_interact_menu_fnc_removeActionFromObject;

	// Delete spawn point
	_spawnTodelete call BIS_fnc_removeRespawnPosition;

	// Send noti
	"A FOB has been destroyed" remoteExec ["systemChat",0];
	
	// Delete the fob 60s later to allow for another FOB to be placed
	uiSleep 60;
	deleteVehicle _FOB;
};
