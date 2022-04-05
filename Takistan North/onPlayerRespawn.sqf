// localEH respawn eventHandler seems to not work in certain situations, trying its stuff here again...

params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

if (_oldUnit isEqualTo objNull) exitWith {};

// if there was a valid last hit in the past life not yet rewarded, credit hitter with kill
private _lastHitter = _oldUnit getVariable ["clash_lastHitter", 0];
if !(_lastHitter isEqualTo 0) then
{
	[_oldUnit] spawn clash_fnc_killEvents;
};
// in any case, load money and loadout
_newUnit setUnitLoadout (profileNamespace getVariable ["clash_loadout", []]);
[_newUnit, (profileNamespace getVariable "clash_aas_money")] call grad_lbm_fnc_setFunds;
if (JST_debug) then {["Respawn handler fired."] remoteExec ["systemChat"]};