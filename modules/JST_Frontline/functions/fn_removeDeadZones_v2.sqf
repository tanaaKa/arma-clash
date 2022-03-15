// remove polys not occupied by friendlies that are surrounded by enemy territory

params ["_polys", "_borders", "_bluGrids", "_opfGrids", "_indGrids", "_side"];

// set variables based on input side
private _friendly = switch (_side) do {case WEST: {0}; case EAST: {1}; case INDEPENDENT: {2}};
private _friendlyGrids = switch (_side) do {case WEST: {_bluGrids}; case EAST: {_opfGrids}; case INDEPENDENT: {_indGrids}};
private _enemy1 = switch (_side) do {case WEST: {1}; case EAST: {2}; case INDEPENDENT: {1}};
private _enemy2 = switch (_side) do {case WEST: {2}; case EAST: {0}; case INDEPENDENT: {0}};

// set main base pos based on side
private _basePos = switch (_side) do {case WEST: {markerPos JST_bluBaseMkrStr}; case EAST: {markerPos JST_opfBaseMkrStr}; case INDEPENDENT: {markerPos JST_indBaseMkrStr}};

// iterate through all polys of side
for "_i" from ((count _polys) - 1) to 0 step -1 do
{
	private _poly = _polys select _i;
	// skip if "main" territory... don't ever delete that xD
	if (_basePos inPolygon _poly) then {continue};
	// find a point that's fully inside the poly; start with one on the poly
	private _pnt = _poly select 0;
	// get its square
	private _squareStr = str ((floor ((_pnt select 0)/100))*100) + str ((floor ((_pnt select 1)/100))*100);
	// test neighbors to find a square w/ centerpoint inside the poly
	private _nN = JST_hashMap get _squareStr select 3;
	private _nS = JST_hashMap get _squareStr select 4;
	private _nE = JST_hashMap get _squareStr select 5;
	private _nW = JST_hashMap get _squareStr select 6;
	private _squareIn = _squareStr;
	{
		if ((JST_hashMap get _x select 1) inPolygon _poly) exitWith {_squareIn = _x};
	} forEach [_nN, _nS, _nE, _nW];
	// get square's side
	private _squareSide = JST_hashMap get _squareIn select 0;
	// test if poly is actually occupied by its side
	private _occupied = false;
	switch (_squareSide) do
	{
		// blufor square, check blufor grids
		case 0:
		{
			{
				if ((_x select 1) inPolygon _poly) exitWith {_occupied = true};
			} forEach _bluGrids;
		};
		// opfor square, check opfor grids
		case 1:
		{
			{
				if ((_x select 1) inPolygon _poly) exitWith {_occupied = true};
			} forEach _opfGrids;
		};
		// independent square, check independent grids
		case 2:
		{
			{
				if ((_x select 1) inPolygon _poly) exitWith {_occupied = true};
			} forEach _indGrids;
		};
	};
	// if NOT occupied:
	if !(_occupied) then
	{
		// test neighbors for enemy; first get inside square's neighbors, then check for enemy
		_nN = JST_hashMap get _squareIn select 3;
		_nS = JST_hashMap get _squareIn select 4;
		_nE = JST_hashMap get _squareIn select 5;
		_nW = JST_hashMap get _squareIn select 6;
		private _enemy = 4;
		{
			if ((JST_hashMap get _x select 0) isEqualTo _enemy1) exitWith {_enemy = _enemy1};
			if ((JST_hashMap get _x select 0) isEqualTo _enemy2) exitWith {_enemy = _enemy2};
		} forEach [_nN, _nS, _nE, _nW];
		// if enemy neighbor found, make this poly an enemy poly of that enemy side and remove from list of borders
		switch (_enemy) do
		{
			case 0:
			{
				[_poly, WEST] call JST_fnc_setSideByPoly;
				_borders deleteAt (_borders findIf {_x isEqualTo _poly});
			};
			case 1:
			{
				[_poly, EAST] call JST_fnc_setSideByPoly;
				_borders deleteAt (_borders findIf {_x isEqualTo _poly});
			};
			case 2:
			{
				[_poly, INDEPENDENT] call JST_fnc_setSideByPoly;
				_borders deleteAt (_borders findIf {_x isEqualTo _poly});
			};
		};
	};
};