// destroy fob, called by ace action, local to player with action

params ["_fob"];

// play ticking sound, blow up, delete fob, remove spawnpoint
[_fob] spawn
{
	params ["_fob"];
	
	private _name = name player;
	
	// pull vars from object
	_spawnPoint = _fob getVariable "clash_fobRespawn";
	_fobSide = _fob getVariable "clash_fobSide";
	_fobName = _fob getVariable "clash_fobName";
	_trig = _fob getVariable "clash_fobTrigger";
	_mkrIconStr =  _fob getVariable "clash_fobMkrIcon";
	_mkrCircleStr = _fob getVariable "clash_fobMkrCircle";
	
	// broadcast chat to all players
	[format ["A charge has been rigged on %1 by %2", _fobName, _name]] remoteExec ["systemChat"];
	
	// remove "place charge" action
	[_fob, 0, ["ACE_MainActions", "destroyFOB"]] remoteExec ["ace_interact_menu_fnc_removeActionFromObject"];
	
	// start 30 second ticking
	[_fob, "bombtick", 200] call CBA_fnc_globalSay3d;
	uiSleep 30;
	
	// to do: allow the bomb to be "defused"

	// big boom
	"Bo_GBU12_LGB" createVehicle (getpos _fob);
	_fob setDamage 1;
	
	// delete the warning trigger and markers
	deleteVehicle _trig;
	[_fob, _fobName, false] remoteExec ["clash_fnc_handleFOBMarker", _fobSide];

	// delete spawn point
	_spawnPoint call BIS_fnc_removeRespawnPosition;

	// broadcast notification
	[format ["%1 has been destroyed", _fobName]] remoteExec ["systemChat", _fobSide];
};