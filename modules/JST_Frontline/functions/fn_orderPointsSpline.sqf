// takes input list of points defining a frontline, tests for it starting/ending in its geographic middle, and reorders it properly to start/end on the ends of the frontline

// hard to describe what this does... needs picture comments

params ["_frontline"];

private _count = count _frontline;

private _start = _frontline select 0;
private _startID = 0;
private _end = _frontline select (_count - 1);
private _endID = _count - 1;

private _copy = [];

for "_i" from 0 to (_count - 1) step 1 do
{
	// iterate through points
	private _thisPnt = _frontline select _i;
	// if last point in array, stop (prevent out-of-bounds errors)
	if ((_count - 1) isEqualTo _i) exitWith {};
	// get next point in array
	private _nextPnt = _frontline select (_i + 1);
	// if distance between these two is > 150m, we'll call the current point the end and the next point the start of the actual frontline
	// and then make a copy of frontline, delete the last point, delete everything up to but not inc. start front frontline, delete everything after but not inc. end from copy, and then append copy to frontline
	if ((_thisPnt distance2D _nextPnt) > 150) exitWith
	{
		_start = _nextPnt;
		_startID = _i + 1;
		_end = _thisPnt;
		_endID = _i;
		// copy current array
		_copy = + _frontline;
		// delete last point of frontline
		_frontline deleteAt (_count - 1);
		// delete first half of points from frontline
		_frontline deleteRange [0, _startID - 1];
		// delete second half of points from copy
		_copy deleteRange [_startID, _count - 1];
		// append copy to frontline
		_frontline append _copy;
	};
};