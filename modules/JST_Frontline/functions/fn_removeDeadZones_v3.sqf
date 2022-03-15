// remove polys not occupied by friendlies that are surrounded by enemy territory

params ["_bluBorders", "_opfBorders", "_indBorders", "_bluGrids", "_opfGrids", "_indGrids", "_side"];

// set borders to evaluate based on input side
private _borders = switch (_side) do {case 0: {_bluBorders}; case 1: {_opfBorders}; case 2: {_indBorders}};
// set friendly occupied grids based on input side
private _occupiedGrids = switch (_side) do {case 0: {_bluGrids}; case 1: {_opfGrids}; case 2: {_indGrids}};
// set enemies based on input side
private _enemy1 = switch (_side) do {case 0: {1}; case 1: {2}; case 2: {1}};
private _enemy1polys = switch (_enemy1) do {case 0: {_bluBorders}; case 1: {_opfBorders}; case 2: {_indBorders}};
private _enemy2 = switch (_side) do {case 0: {2}; case 1: {0}; case 2: {0}};
private _enemy2polys = switch (_enemy1) do {case 0: {_bluBorders}; case 1: {_opfBorders}; case 2: {_indBorders}};
// set main base pos based on square's side
private _basePos = switch (_side) do {case 0: {markerPos JST_bluBaseMkrStr}; case 1: {markerPos JST_opfBaseMkrStr}; case 2: {markerPos JST_indBaseMkrStr}};
	
// iterate through all borders
for "_i" from ((count _borders) - 1) to 0 step -1 do
{
	private _border = _borders select _i;
	// skip if "main" territory... don't ever delete that xD
	if (_basePos inPolygon _border) then {continue};
	// test if poly is actually occupied by its side
	private _occupied = false;
	{
		if ((_x select 1) inPolygon _border) exitWith {_occupied = true};
	} forEach _occupiedGrids;
	// if NOT occupied:
	if !(_occupied) then
	{
		// go along border and find a square that borders an enemy territory, detect what enemy it is
		private _enemy = 4;
		{
			if (_enemy < 4) exitWith {};
			// find a point that's fully inside the poly; start with one on the poly
			private _pnt = _x;
			// get its square
			private _squareStr = str ((floor ((_pnt select 0)/100))*100) + str ((floor ((_pnt select 1)/100))*100);
			// test neighbors to find a square w/ centerpoint inside the poly
			private _nN = JST_hashMap get _squareStr select 3;
			private _nS = JST_hashMap get _squareStr select 4;
			private _nE = JST_hashMap get _squareStr select 5;
			private _nW = JST_hashMap get _squareStr select 6;
			private _squareIn = _squareStr;
			{
				if ((JST_hashMap get _x select 1) inPolygon _border) exitWith {_squareIn = _x};
			} forEach [_nN, _nS, _nE, _nW];
			// test THAT square's neighbors for enemy
			_nN = JST_hashMap get _squareIn select 3;
			_nS = JST_hashMap get _squareIn select 4;
			_nE = JST_hashMap get _squareIn select 5;
			_nW = JST_hashMap get _squareIn select 6;
			{
				if ((JST_hashMap get _x select 0) isEqualTo _enemy1) exitWith {_enemy = _enemy1};
				if ((JST_hashMap get _x select 0) isEqualTo _enemy2) exitWith {_enemy = _enemy2};
			} forEach [_nN, _nS, _nE, _nW];
		} forEach _border;
		// if enemy neighbor found, set this territory to that enemy side and remove all conterminous border lists from other sides
		switch (_enemy) do
		{
			case 0:
			{
				[_border, WEST] call JST_fnc_setSideByPoly;
				_bluBorders deleteAt (_bluBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
				_opfBorders deleteAt (_opfBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
				_indBorders deleteAt (_indBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
			};
			case 1:
			{
				[_border, EAST] call JST_fnc_setSideByPoly;
				_bluBorders deleteAt (_bluBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
				_opfBorders deleteAt (_opfBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
				_indBorders deleteAt (_indBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
			};
			case 2:
			{
				[_border, INDEPENDENT] call JST_fnc_setSideByPoly;
				_bluBorders deleteAt (_bluBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
				_opfBorders deleteAt (_opfBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
				_indBorders deleteAt (_indBorders findIf {[_x, _border] call JST_fnc_testIfSamePoints});
			};
		};
	};
};