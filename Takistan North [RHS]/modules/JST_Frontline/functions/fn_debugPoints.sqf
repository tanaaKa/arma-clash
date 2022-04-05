// show points in an array of points

params ["_arrs", "_color"];

// draw numbered markers along points in an array
{
	private _arr = _x;
	{
		private _pnt = _x;
		private _mkrVar = createMarkerLocal [(_color + (str _pnt)), _pnt];
		_mkrVar setMarkerTypeLocal "hd_dot";
		_mkrVar setMarkerColorLocal _color;
		_mkrVar setMarkerText (str _forEachIndex);
		JST_debugPoints pushBack _mkrVar;
	} forEach _arr;
} forEach _arrs;