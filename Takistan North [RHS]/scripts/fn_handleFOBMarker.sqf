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
	_mkrIconStr setMarkerTextLocal ("FOB" + _fobName);
	_fob setVariable ["clash_fobMkrIcon", _mkrIconStr, true];
	// circle
	private _mkrCircleVar = createMarkerLocal [_mkrCircleStr, _fob];
	_mkrCircleStr setMarkerShapeLocal "ELLIPSE";
	_mkrCircleStr setMarkerTypeLocal "ELLIPSE";
	_mkrCircleStr setMarkerSizeLocal [100,100];
	_mkrCircleStr setMarkerBrushLocal "Border";
	_mkrCircleStr setMarkerTextLocal ("FOB" + _fobName);
	_fob setVariable ["clash_fobMkrCircle", _mkrCircleStr, true];
}
else
{
	deleteMarkerLocal _mkrIconStr;
	deleteMarkerLocal _mkrCircleStr;
};