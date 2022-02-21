// Adds supports to commanders when they JIP
// Thanks BI!
if !(typeOf (_this select 0) isEqualTo "O_officer_F" || typeOf (_this select 0) isEqualTo "B_officer_F") exitWith {};

if (side player isEqualTo WEST) then {
	_this select 0 synchronizeObjectsAdd [BluSupportRequester];
	BluSupportRequester synchronizeObjectsAdd [_this select 0];
	BIS_supp_refresh = TRUE;
	publicVariable "BIS_supp_refresh";

	[_this select 0, SupportRequester, ArtilleryProvider] call BIS_fnc_addSupportLink;
	[_this select 0, SupportRequester, CasProvider] call BIS_fnc_addSupportLink;
} else {
	_this select 0 synchronizeObjectsAdd [OpfSupportRequester];
	OpfSupportRequester synchronizeObjectsAdd [_this select 0];
	BIS_supp_refresh = TRUE;
	publicVariable "BIS_supp_refresh";

	[_this select 0, SupportRequester, ArtilleryProvider] call BIS_fnc_addSupportLink;
	[_this select 0, SupportRequester, CasProvider] call BIS_fnc_addSupportLink;
};