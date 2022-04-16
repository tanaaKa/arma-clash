// draw border segments between all spline points

params ["_spline", "_leftSide", "_rightSide"];

// error check: if left and right side are the same, do nothing (must be a glitch!)
if (_leftSide isEqualTo _rightSide) exitWith {};

// left means + 270, right means + 90

// set left/right side colors
private _leftSideColor = switch (_leftSide) do
{
	case 0: {"ColorBLUFOR"};
	case 1: {"ColorOPFOR"};
	case 2: {"ColorINDEPENDENT"};
	default {"ColorBLACK"}
};
private _rightSideColor = switch (_rightSide) do
{
	case 0: {"ColorBLUFOR"};
	case 1: {"ColorOPFOR"};
	case 2: {"ColorINDEPENDENT"};
	default {"ColorBLACK"}
};

// draw markers
{
	// quit after point before last
	if (_forEachIndex > ((count _spline) - 2)) exitWith {};
	// get points
	private _pnt1 = _x;
	private _pnt2 = _spline select (_forEachIndex + 1);
	// get marker length which is distance/2
	private _length = (_pnt1 distance2D _pnt2)/2;
	// get dir
	private _dir = _pnt1 getDir _pnt2;
	// get midpoint
	private _midPnt = _pnt1 getPos [_length, _dir];
	// get left midpoint
	private _midPntL = _midPnt getPos [5, (_dir + 270)];
	// get right midpoint
	private _midPntR = _midPnt getPos [5, (_dir + 90)];
	
	// draw left marker:
	// if marker var already used, change marker
	JST_markerCount = JST_markerCount + 1;
	private _markerStr = "splineMkr_" + str JST_markerCount;
	if (JST_markerCount <= JST_markerCountHighest) then
	{
		_markerStr setMarkerPosLocal _midPntL;
		_markerStr setMarkerDirLocal _dir;
		_markerStr setMarkerSizeLocal [5, _length + 2];
		_markerStr setMarkerAlphaLocal 0.4;
		_markerStr setMarkerColor _leftSideColor;
	}
	// if not used: create it
	else
	{
		private _marker = createMarkerLocal [_markerStr, _midPntL];
		_markerStr setMarkerShapeLocal "RECTANGLE";
		_markerStr setMarkerDirLocal _dir;
		_markerStr setMarkerSizeLocal [5, _length + 2];
		_markerStr setMarkerAlphaLocal 0.4;
		_markerStr setMarkerColor _leftSideColor;
	};
	
	// draw right marker:
	// if marker var already used, change marker
	JST_markerCount = JST_markerCount + 1;
	private _markerStr = "splineMkr_" + str JST_markerCount;
	if (JST_markerCount <= JST_markerCountHighest) then
	{
		_markerStr setMarkerPosLocal _midPntR;
		_markerStr setMarkerDirLocal _dir;
		_markerStr setMarkerSizeLocal [5, _length + 2];
		_markerStr setMarkerAlphaLocal 0.4;
		_markerStr setMarkerColor _rightSideColor;
	}
	// if not used: create it
	else
	{
		private _marker = createMarkerLocal [_markerStr, _midPntR];
		_markerStr setMarkerShapeLocal "RECTANGLE";
		_markerStr setMarkerDirLocal _dir;
		_markerStr setMarkerSizeLocal [5, _length + 2];
		_markerStr setMarkerAlphaLocal 0.4;
		_markerStr setMarkerColor _rightSideColor;
	};
	
} forEach _spline;