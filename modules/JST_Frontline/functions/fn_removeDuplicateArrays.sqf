// remove an array from a list of arrays if another two lists of arrays shares a point with it, or if empty

params ["_arrays1", "_arrays2", "_arrays3", "_uniqueArrays"];

for "_i" from ((count _arrays1) - 1) to 0 step -1 do
{
	private _array = _arrays1 select _i;
	if ((count _array) isEqualTo 0) then
	{
		_arrays1 deleteAt _i
	}
	else
	{
		// pick first point as arbitrary test point
		private _pnt = _array select 0;
		private _shared = false;
		// iterate through arrays2 arrays
		{
			if (_pnt in _x) exitWith {_shared = true};
		} forEach _arrays2;
		// iterate through arrays3 arrays
		{
			if (_pnt in _x) exitWith {_shared = true};
		} forEach _arrays3;
		// if point shared, delete array from arrays1, else add array to unique arrays
		if (_shared) then {_arrays1 deleteAt _i} else {_uniqueArrays pushBack _array};
	};
};