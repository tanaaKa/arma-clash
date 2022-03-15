// find spline curve that intersects all points of given poly by breaking poly into a series of cubic bezier curves
// uses resolution _t; _t = 0.1 means function will return 10 times the number of input points, 0.2 = 5 times, etc.

params ["_poly"];

// find bezier curve control points for the poly points
private _polyCPs = [];
{
	private _pnt = _x;
	// if not first or last point (most points)
	if ((_forEachIndex > 0) and (_forEachIndex < ((count _poly) - 1))) then
	{
		private _pntL = _poly select (_forEachIndex - 1);
		private _pntR = _poly select (_forEachIndex + 1);
		// calculate left control point
		private _cpDisL = (_pntR distance2D _pntL)/3;
		private _cpDirL = _pntR getDir _pntL;
		private _cpL = _pnt getPos [_cpDisL, _cpDirL];
		// calculate right control point
		private _cpDisR = (_pntL distance2D _pntR)/3;
		private _cpDirR = _pntL getDir _pntR;
		private _cpR = _pnt getPos [_cpDisR, _cpDirR];
		// add control points into new poly array
		_polyCPs pushBack [_pnt, _cpL, _cpR];
	}
	else
	{
		// if first point
		if (_forEachIndex isEqualTo 0) then
		{
			private _pntR = _poly select 1;
			private _cpDis = (_pnt distance2D _pntR)/3;
			private _cpDir = _pnt getDir _pntR;
			private _cp = _pnt getPos [_cpDis, _cpDir];
			_polyCPs pushBack [_pnt, nil, _cp];
		}
		// if last point
		else
		{
			private _pntL = _poly select (_forEachIndex - 1);
			private _cpDis = (_pnt distance2D _pntL)/3;
			private _cpDir = _pnt getDir _pntL;
			private _cp = _pnt getPos [_cpDis, _cpDir];
			_polyCPs pushBack [_pnt, _cp, nil];
		};
	};
} forEach _poly;

// build array of cubic bezier curves that make up the poly
private _cubicBeziers = [];
{
	// only if not first item in array
	if (_forEachIndex > 0) then
	{
		private _pnt = _x;
		_previousPnt = _polyCPs select (_forEachIndex - 1);
		_cubicBeziers pushBack [_previousPnt select 0, _previousPnt select 2, _pnt select 1, _pnt select 0];
	};
} forEach _polyCPs;

// create large array of points along spline describing the bezier curves for drawing
private _spline = [];
{
	_x params ["_pntA", "_pntB", "_pntC", "_pntD"];
	_pntA params ["_aX", "_aY"];
	_pntB params ["_bX", "_bY"];
	_pntC params ["_cX", "_cY"];
	_pntD params ["_dX", "_dY"];
	for "_t" from 0 to 1 step 0.1 do
	{
		private _tX = (1-_t)^3*_aX + 3*(1-_t)^2*_t*_bX + 3*(1-_t)*_t^2*_cX + _t^3*_dX;
		private _tY = (1-_t)^3*_aY + 3*(1-_t)^2*_t*_bY + 3*(1-_t)*_t^2*_cY + _t^3*_dY;
		_spline pushBack [_tX, _tY];
	};
} forEach _cubicBeziers;

// remove duplicate points
_spline = _spline arrayIntersect _spline;

// return spline
_spline

/* Backup code

// draw line between all spline points
{
	// quit after point before last
	if (_forEachIndex > ((count _spline) - 2)) exitWith {};
	// draw line from point to next point in array...
	// get points
	private _pnt1 = _x;
	private _pnt2 = _spline select (_forEachIndex + 1);
	// get marker length which is distance/2
	private _length = (_pnt1 distance2D _pnt2)/2;
	// get dir
	private _dir = _pnt1 getDir _pnt2;
	// get midpoint
	private _midPnt = _pnt1 getPos [_length, _dir];
	// draw marker
	private _markerStr = "mkr_" + str _pnt1;
	private _marker = createMarkerLocal [_markerStr, _midPnt];
	_markerStr setMarkerShapeLocal "RECTANGLE";
	_markerStr setMarkerDirLocal _dir;
	_markerStr setMarkerSizeLocal [2, _length];
	_markerStr setMarkerColor "ColorBLACK";
	JST_markers pushBack _markerStr;
} forEach _spline;

// automatically input points
JST_poly = [];
for "_i" from 0 to 100 do
{
	private _num = _i;
	private _mkr = ("curve_pnt_" + (str _num));
	private _mkrType = getMarkerType _mkr;
	if !(_mkrType isEqualTo "") then
	{
		private _pos = [markerPos _mkr select 0, markerPos _mkr select 1, 0];
		JST_poly pushBack _pos;
	};
};


// show all spline points
JST_markers = [];
{
	deleteMarker _x;
} forEach JST_markers;
{
	private _markerStr = "mkr_" + str _forEachIndex;
	private _marker = createMarker [_markerStr, [_x select 0, _x select 1]];
	_marker setMarkerType "hd_dot";
	_marker setMarkerText str _forEachIndex;
	JST_markers pushBack _marker;
} forEach _spline;