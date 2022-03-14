// create or delete a fob's marker, local

params ["_fob", "_fobName", "_create"];

private _mkrIconStr = "mkrIcon_" + str _fob;
private _mkrCircleStr = "mkrCircle_" + str _fob;

// if _create true, create marker (actually two markers: an icon and a circle around it)
if ((_create) and (alive _fob)) then
{
	// icon
	private _mkrIconVar = createMarkerLocal [_mkrIconStr, _fob];
	_mkrIconStr setMarkerShapeLocal "ICON";
	_mkrIconStr setMarkerTypeLocal "loc_CivilDefense";
	_mkrIconStr setMarkerTextLocal _fobName;
	_fob setVariable ["clash_fobMkrIcon", _mkrIconStr, true];
	// circle
	private _mkrCircleVar = createMarkerLocal [_mkrCircleStr, _fob];
	_mkrCircleStr setMarkerShapeLocal "ELLIPSE";
	_mkrCircleStr setMarkerTypeLocal "ELLIPSE";
	_mkrCircleStr setMarkerSizeLocal [100,100];
	_mkrCircleStr setMarkerBrushLocal "Border";
	_mkrCircleStr setMarkerTextLocal _fobName;
	_fob setVariable ["clash_fobMkrCircle", _mkrCircleStr, true];
}
else
{
	deleteMarkerLocal _mkrIconStr;
	deleteMarkerLocal _mkrCircleStr;
};

/*

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

_tempName = format ["FOB%1", count activeFOBs];
_fobMarker = createMarkerLocal [_tempName, _object];
_fobMarker setMarkerShapeLocal "ICON";
_fobMarker setmarkerTypeLocal "loc_CivilDefense";
_fobMarker setMarkerText format ["%1",_fobName];
_object setVariable ["fobMarker",_fobMarker, true];
if (side player isEqualTo West) then
{
	B_activeFOBs pushBackUnique _tempName;
	publicVariable "B_activeFOBS";
}
else
{
	O_activeFOBs pushBackUnique _tempName;
	publicVariable "O_activeFOBS";
};

_tempMarker = format ["100m%1", count activeFOBMarkers];
_100m = createMarkerLocal [_tempMarker, _object];
_100m setMarkerShapeLocal "ELLIPSE";
_100m setMarkerTypeLocal "ellipse";
_100m setMarkerSizeLocal [100,100];
_100m setMarkerBrush "Border";
_object setVariable ["fobRadius", _100m, true];
if (side player isEqualTo West) then
{
	B_activeFOBMarkers pushBackUnique _tempMarker;
	publicVariable "B_activeFOBMarkers";
}
else
{
	O_activeFOBMarkers pushBackUnique _tempMarker;
	publicVariable "O_activeFOBMarkers";
};

*/