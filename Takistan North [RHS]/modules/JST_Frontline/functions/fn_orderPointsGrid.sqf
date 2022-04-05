// take unordered list of points defining border edge and sort as many as possible into an actual spline, add to provided master list

params ["_masterList", "_pntsUnsorted"];

// _pntsUnsorted is in format [ [ bordering midpoint, bordering corner 1, bordering corner 2, square centerpoint, squareStr ] , ...]
private _spline = [_pntsUnsorted select 0];	
_pntsUnsorted deleteAt 0;
private _newPnt = _spline select 0;
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
		private _previousPnt = _spline select ((count _spline) - 1);
		// blank-out connecting corner point from lastPnt array to avoid potential backtracking (don't delete to avoid select errors later)
		if ((_newPnt select 1) in _previousPnt) then {_newPnt set [1, (_newPnt select 3)]};
		if ((_newPnt select 2) in _previousPnt) then {_newPnt set [2, (_newPnt select 3)]};
		// add lastPnt to border and remove from unsorted list
		_spline pushBack _newPnt;
		_pntsUnsorted deleteAt _cornerID;
	}
	// if not found
	else
	{
		_go = false;
	};
};
// repeat loop going in the other direction (invert array, start over) because first loop could have started in the middle of a border
reverse _spline;
_go = true;
private _newPnt = _spline select ((count _spline) - 1);
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
		private _previousPnt = _spline select ((count _spline) - 1);
		// blank-out connecting corner point from lastPnt array to avoid potential backtracking (don't delete to avoid select errors later)
		if ((_newPnt select 1) in _previousPnt) then {_newPnt set [1, (_newPnt select 3)]};
		if ((_newPnt select 2) in _previousPnt) then {_newPnt set [2, (_newPnt select 3)]};
		// add lastPnt to border and remove from unsorted list
		_spline pushBack _newPnt;
		_pntsUnsorted deleteAt _cornerID;
	}
	// if not found
	else
	{
		_go = false;
	};
};
// detect if poly by checking if first and last pnt share their remaining unconnected corner point
private _lastPnt = _spline select ((count _spline) - 1);
private _firstPnt = _spline select 0;
if (((_lastPnt select 1) in _firstPnt) or ((_lastPnt select 2) in _firstPnt)) then
{
	// if poly, add first point to end to close poly
	_spline pushBack (_spline select 0);
};
// create border array of JUST points, no extra data / sub arrays
_splinePnts = [];
{
	_splinePnts pushBack (_x select 0);
} forEach _spline;
// add to provided master list
_masterList pushBack _splinePnts;