// hide markers above given index (e.g. hide if suffix > 100 blu_mkr_132)

params ["_side", "_n"];
if (isNil "JST_highestMkrNum") then {JST_highestMkrNum = _n + 1000};
// set side
private _sideStr = "";
switch (_side) do
{
	case WEST: {_sideStr = "blu"};
	case EAST: {_sideStr = "opf"};
	case INDEPENDENT: {_sideStr = "ind"};
};
// hide all markers above suffix num
for "_i" from _n to JST_highestMkrNum do
{
	private _mkrStr = _sideStr + "_bdr_" + str _i;
	_mkrStr setMarkerShape "RECTANGLE";
	_mkrStr setMarkerAlpha 0;
};