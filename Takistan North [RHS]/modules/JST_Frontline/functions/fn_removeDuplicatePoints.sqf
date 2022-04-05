// removes points in bdrs 1 that are NOT also in bdrs 2 OR bdrs 3

params ["_bdrs1", "_bdrs2", "_bdrs3"];

// iterate through _bdrs1 borders and remove points that are NOT shared with enemy borders (not included in the frontline)
for "_i" from ((count _bdrs1) - 1) to 0 step -1 do
{
	private _bdr1 = _bdrs1 select _i;
	for "_k" from ((count _bdr1) - 1) to 0 step -1 do
	{
		private _bdr1Pnt = _bdr1 select _k;
		private _shared = false;
		// check against bdr2 borders
		{
			if (_shared) exitWith {};
			private _bdr2 = _x;
			{
				private _bdr2Pnt = _x;
				if (_bdr1Pnt isEqualTo _bdr2Pnt) exitWith {_shared = true};
			} forEach _bdr2;
		} forEach _bdrs2;
		// check against bdr3 borders
		{
			if (_shared) exitWith {};
			private _bdr3 = _x;
			{
				private _bdr3Pnt = _x;
				if (_bdr1Pnt isEqualTo _bdr3Pnt) exitWith {_shared = true};
			} forEach _bdr3;
		} forEach _bdrs3;
		// if point not shared, remove from border
		if (!_shared) then {_bdr1 deleteAt _k};
	};
};




/*

// iterate through _bdrs1 borders
{
	private _bdr = _x;
	// iterate through its points backwards to enable deletion
	for "_i" from ((count _bdr) - 1) to 0 step -1 do
	{
		private _pnt = _bdr select 0;
		private _shared = false;
		// iterate through bdrs 2 borders
		{
			// stop if already found a shared point
			if (_shared) exitWith {};
			private _bdr2 = _x;
			// iterate through this bdrs 2 points
			{
				// check if shared
				if (_pnt isEqualTo _x) exitWith {_shared = true};
			} forEach _bdr2;
		} forEach _bdrs2;
		// iterate through bdrs 3 borders
		{
			// stop if already found a shared point
			if (_shared) exitWith {};
			private _bdr3 = _x;
			// iterate through this bdrs 2 points
			{
				// check if shared
				if (_pnt isEqualTo _x) exitWith {_shared = true};
			} forEach _bdr3;
		} forEach _bdrs3;
		// if NOT shared, remove from bdr list
		if (!_shared) then {_bdr deleteAt _i};
	};
} forEach _bdrs1;

*/

/*

// iterate through bdr1 points
for "_i" from ((count _bdr1) - 1) to 0 step -1 do
{
	private _shared = false;
	// check against bdr2 points
	{
		if ((_bdr1 select _i) isEqualTo _x) exitWith {_shared = true};
	} forEach _bdr2;
	// check against bdr3 points
	{
		if ((_bdr1 select _i) isEqualTo _x) exitWith {_shared = true};
	} forEach _bdr3;
	// if not shared, delete point
	if (!_shared) then {_bdr1 deleteAt _i};
};
*/



/*
for "_i" from ((count _bdr1) - 1) to 0 step -1 do
{
	private _bluBdr = _bluBorders select _i;
	for "_k" from ((count _bluBdr) - 1) to 0 step -1 do
	{
		private _bluPnt = _bluBdr select _k;
		private _shared = false;
		// check against opf borders
		{
			if (_shared) exitWith {};
			private _opfBdr = _x;
			{
				private _opfPnt = _x;
				if (_bluPnt isEqualTo _opfPnt) exitWith {_shared = true};
			} forEach _opfBdr;
		} forEach _opfBorders;
		// check against ind borders
		{
			if (_shared) exitWith {};
			private _indBdr = _x;
			{
				private _indPnt = _x;
				if (_bluPnt isEqualTo _indPnt) exitWith {_shared = true};
			} forEach _indBdr;
		} forEach _indBorders;
		// if point not shared, remove from border
		if (!_shared) then {_bluBdr deleteAt _k};
	};
};
*/