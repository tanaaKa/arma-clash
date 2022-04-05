// take unordered list of points defining border edge and sort them into an actual spline
// if poly detected (closed loop) add to list of polys

params ["_masterBorders", "_polys", "_pntsUnsorted"];
// _pntsUnsorted is in format [ [ bordering midpoint, bordering corner 1, bordering corner 2, square centerpoint, squareStr ] , ...]
private _border = [_pntsUnsorted select 0];	
_pntsUnsorted deleteAt 0;
private _newPnt = _border select 0;
// start loop going one direction
private _go = true;
while {_go} do
{
	// find another point that shares a centerpoint AND a corner point with last new point
	private _cornerID = _pntsUnsorted findIf
	{
		(((_x select 3) isEqualTo (_newPnt select 3)) and (((_x select 1) in _newPnt) or ((_x select 2) in _newPnt)));
	};
	// if above not found, then find another point that shares only a corner point with last new point
	if !(_cornerID > -1) then
	{
		_cornerID = _pntsUnsorted findIf
		{
			(((_x select 1) in _newPnt) or ((_x select 2) in _newPnt))
		};
	};
	// if found, use that point as next point
	if (_cornerID > -1) then
	{
		_newPnt = _pntsUnsorted select _cornerID;
		private _previousPnt = _border select ((count _border) - 1);
		// blank-out connecting corner point from lastPnt array to avoid potential backtracking (don't delete to avoid select errors later)
		if ((_newPnt select 1) in _previousPnt) then {_newPnt set [1, (_newPnt select 3)]};
		if ((_newPnt select 2) in _previousPnt) then {_newPnt set [2, (_newPnt select 3)]};
		// add lastPnt to border and remove from unsorted list
		_border pushBack _newPnt;
		_pntsUnsorted deleteAt _cornerID;
	}
	// if not found
	else
	{
		_go = false;
	};
};
// repeat loop going in the other direction (invert array, start over) because first loop could have started in the middle of a border
reverse _border;
_go = true;
private _newPnt = _border select ((count _border) - 1);
while {_go} do
{
	// find another point that shares a centerpoint AND a corner point with last point
	private _cornerID = _pntsUnsorted findIf
	{
		(((_x select 3) isEqualTo (_newPnt select 3)) and (((_x select 1) in _newPnt) or ((_x select 2) in _newPnt)))
	};
	// if above not found, then find another point that shares only a corner point with last point
	if !(_cornerID > -1) then
	{
		_cornerID = _pntsUnsorted findIf
		{
			(((_x select 1) in _newPnt) or ((_x select 2) in _newPnt))
		};
	};
	// if found, use that point as next point
	if (_cornerID > -1) then
	{
		_newPnt = _pntsUnsorted select _cornerID;
		private _previousPnt = _border select ((count _border) - 1);
		// blank-out connecting corner point from lastPnt array to avoid potential backtracking (don't delete to avoid select errors later)
		if ((_newPnt select 1) in _previousPnt) then {_newPnt set [1, (_newPnt select 3)]};
		if ((_newPnt select 2) in _previousPnt) then {_newPnt set [2, (_newPnt select 3)]};
		// add lastPnt to border and remove from unsorted list
		_border pushBack _newPnt;
		_pntsUnsorted deleteAt _cornerID;
	}
	// if not found
	else
	{
		_go = false;
	};
};
// detect if poly by checking if first and last pnt share their remaining unconnected corner point
private _lastPnt = _border select ((count _border) - 1);
private _firstPnt = _border select 0;
if (((_lastPnt select 1) in _firstPnt) or ((_lastPnt select 2) in _firstPnt)) then
{
	// if poly, add first point to end to close poly
	_border pushBack (_border select 0);
};
// create border array of JUST points
_borderPnts = [];
{
	_borderPnts pushBack (_x select 0);
} forEach _border;
// if poly (first and last point are the same), add to list of polys
if ((_borderPnts select 0) isEqualTo (_borderPnts select ((count _borderPnts) - 1))) then
{
	_polys pushBack _borderPnts;
};
// add border to master list of borders
_masterborders pushBack _borderPnts;