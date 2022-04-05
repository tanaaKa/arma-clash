// find a starting polygon per marker string input

params ["_mkrStr"];
if (_mkrStr isEqualTo "") exitWith {};
private _poly = [];
// find up to 1000 markers and add positions into array
for "_i" from 0 to 1000 do
{
	private _num = _i;
	private _mkr = (_mkrStr + (str _num));
	private _mkrType = getMarkerType _mkr;
	if !(_mkrType isEqualTo "") then
	{
		private _pos = [markerPos _mkr select 0, markerPos _mkr select 1, 0];
		_poly pushBack _pos;
	};
};
// close polygon
_poly pushBack (_poly select 0);
// return polygon
_poly