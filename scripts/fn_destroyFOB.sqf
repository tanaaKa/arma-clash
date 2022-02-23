params["_FOB","_playerName"];

// play ticking sound
[_FOB,_playerName] spawn {
	params["_FOB","_playerName"];
	
	_fobName = _FOB getVariable "fobName";
	_fobRadius = _FOB getVariable "fobRadius";
	_fobMarker =  _FOB getVariable "fobMarker";
	_fobTrigger = _FOB getVariable "fobTrigger";
	_spawnTodelete = _FOB getVariable "fobRespawn";
	
	_bNoti = format ["A charge has been rigged on %1 by %2",_fobName,_playerName];
	_bNoti remoteExec ["systemChat"];
	
	// Remove action
	[_FOB, 0, ["ACE_MainActions", "destroyFOB"]] call ace_interact_menu_fnc_removeActionFromObject;
	
	
	//systemChat format ["_FOB: %1\n_spawn: %2",_FOB,_spawnTodelete];
	[_FOB, "bombtick", 100] call CBA_fnc_globalSay3d;

	uiSleep 30; // 30s countdown
	// TODO: Sleep here during countdown that allows the bomb to be "defused"

	// Big boom
	"Bo_GBU12_LGB" createVehicle (getpos _FOB);
	_FOB setDamage 1;
	
	// Delete the warning trigger and markers
	deleteVehicle _fobTrigger;
	deleteMarker _fobMarker;
	deleteMarker _fobRadius;

	// Delete spawn point
	_spawnTodelete call BIS_fnc_removeRespawnPosition;

	// Send noti
	_sString = format ["%1 has been destroyed",_FOB getVariable "fobName"];
	_sString remoteExec ["systemChat",0];
	
	//Update arrays
	activeFOBs deleteAt (activeFOBs find _fobMarker);
	activeFOBMarkers deleteAt (activeFOBMarkers find _fobRadius);
	
	// Delete the fob 3 mins later to allow for another FOB to be placed
	uiSleep 180;
	deleteVehicle _FOB;
};
