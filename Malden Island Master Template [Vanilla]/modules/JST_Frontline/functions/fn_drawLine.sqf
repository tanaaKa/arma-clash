// draw line between two points, color based on input side

params ["_pnt1", "_pnt2", "_side", "_i"]; // _i is forEachIndex
if (isNil "JST_highestMkrNum") then {JST_highestMkrNum = _i};
private _color = "ColorBLACK";
private _sideStr = "none";
// get distance
private _dis = (_pnt1 distance2D _pnt2)/2;
// get dir
private _dir = _pnt1 getDir _pnt2;
// find midpoint
private _midPnt = _pnt1 getPos [_dis, _dir];
// set side color
switch (_side) do
{
	case WEST: {_color = "ColorBLUFOR"; _sideStr = "blu"};
	case EAST: {_color = "ColorOPFOR"; _sideStr = "opf"};
	case INDEPENDENT: {_color = "ColorINDEPENDENT"; _sideStr = "ind"};
};
// init marker
private _mkrStr = _sideStr + "_bdr_" + str _i;
private _mkrType = markerShape _mkrStr;
// if marker already exists, change it
if (_mkrType isEqualTo "RECTANGLE") then
{
	_mkrStr setMarkerPosLocal _midPnt;
	_mkrStr setMarkerDirLocal _dir;
	_mkrStr setMarkerSizeLocal [5, _dis];
	_mkrStr setMarkerAlphaLocal 1;
	_mkrStr setMarkerColor _color;
}
// if marker doesn't exist, create it
else
{
	private _mkr = createMarkerLocal [_mkrStr, _midPnt];
	_mkrStr setMarkerShape "RECTANGLE";
	_mkrStr setMarkerDirLocal _dir;
	_mkrStr setMarkerSizeLocal [5, _dis];
	_mkrStr setMarkerAlphaLocal 1;
	_mkrStr setMarkerColor _color;	
};
// record highest number of markers created
if (_i > JST_highestMkrNum) then {JST_highestMkrNum = _i};