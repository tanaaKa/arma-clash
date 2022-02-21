// Adds supports to commanders when they JIP
// Thanks BI!
if !(typeOf (player) isEqualTo "O_officer_F" || typeOf (player) isEqualTo "B_officer_F") exitWith {};

if (side player isEqualTo WEST) then {
	player synchronizeObjectsAdd [BluSupportRequester];
	BluSupportRequester synchronizeObjectsAdd [player];
	BIS_supp_refresh = TRUE;
	publicVariable "BIS_supp_refresh";

	[player, BluSupportRequester, BluArty] call BIS_fnc_addSupportLink;
	
} else {
	player synchronizeObjectsAdd [OpfSupportRequester];
	OpfSupportRequester synchronizeObjectsAdd [player];
	BIS_supp_refresh = TRUE;
	publicVariable "BIS_supp_refresh";

	[player, OpfSupportRequester, OpfArty] call BIS_fnc_addSupportLink;
};