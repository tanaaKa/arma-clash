// take unordered list of points defining border edges and sort them into an actual polygon

params ["_masterPolys", "_pntsUnsorted"];
// _pntsUnsorted is in format [ [ bordering midpoint, bordering corner 1, bordering corner 2, square centerpoint ] , ...]
private _poly = [_pntsUnsorted select 0];	
_pntsUnsorted deleteAt 0;
private _lastPnt = _poly select 0;
// start loop
private _go = true;
while {_go} do
{
	// find another point that shares a centerpoint AND a corner point with last point
	private _cornerID = _pntsUnsorted findIf
	{
		(((_x select 3) isEqualTo (_lastPnt select 3)) and (((_x select 1) in _lastPnt) or ((_x select 2) in _lastPnt)))
	};
	// if above not found, then find another point that shares only a corner point with last point
	if !(_cornerID > -1) then
	{
		_cornerID = _pntsUnsorted findIf
		{
			(((_x select 1) in _lastPnt) or ((_x select 2) in _lastPnt))
		};
	};
	// if found, use that point as next point
	if (_cornerID > -1) then
	{
		_lastPnt = _pntsUnsorted select _cornerID;
		_poly pushBack _lastPnt;
		_pntsUnsorted deleteAt _cornerID;
	}
	// if not found
	else
	{
		_go = false;
	};
};
// create poly array of JUST points
_polyPnts = [];
{
	_polyPnts pushBack (_x select 0);
} forEach _poly;
// close poly
_polyPnts pushBack (_polyPnts select 0);
// add to master list
_masterPolys pushBack _polyPnts;