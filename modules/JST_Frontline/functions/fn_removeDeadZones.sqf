// remove polys not occupied by friendlies that are surrounded by enemy territory

params ["_bluPolys", "_opfPolys", "_indPolys", "_occupiedBluPolys", "_occupiedOpfPolys", "_occupiedIndPolys", "_side"];

// set polys to evaluate and enemy sides based on input side
private _polys = switch (_side) do {case WEST: {_bluPolys}; case EAST: {_opfPolys}; case INDEPENDENT: {_indPolys}};
private _occupiedPolys = switch (_side) do {case WEST: {_occupiedBluPolys}; case EAST: {_occupiedOpfPolys}; case INDEPENDENT: {_occupiedIndPolys}};
private _enemy1 = switch (_side) do {case WEST: {1}; case EAST: {2}; case INDEPENDENT: {1}};
private _enemyPolys1 = switch (_side) do {case WEST: {_opfPolys}; case EAST: {_indPolys}; case INDEPENDENT: {_opfPolys}};
private _enemy2 = switch (_side) do {case WEST: {2}; case EAST: {0}; case INDEPENDENT: {0}};
private _enemyPolys2 = switch (_side) do {case WEST: {_indPolys}; case EAST: {_bluPolys}; case INDEPENDENT: {_bluPolys}};

// set main base pos based on side
private _basePos = switch (_side) do {case WEST: {markerPos JST_bluBaseMkrStr}; case EAST: {markerPos JST_opfBaseMkrStr}; case INDEPENDENT: {markerPos JST_indBaseMkrStr}};

// iterate through all polys of side
for "_i" from ((count _polys) - 1) to 0 step -1 do
{
	private _poly = _polys select _i;
	// skip if "main" territory... don't ever delete that xD
	if (_basePos inPolygon _poly) then {continue};
	// if this poly isn't occupied, and it touches enemy territory, absorb it into the enemy territory
	if !(_poly in _occupiedPolys) then
	{
		// go along border and find a square that borders an enemy territory, detect what enemy it is
		private _enemy = 4;
		{
			// find a point that's fully inside the poly; start with one on the poly
			private _pnt = _x;
			// get its square
			private _squareTest = str ((floor ((_pnt select 0)/100))*100) + str ((floor ((_pnt select 1)/100))*100);
			// test neighbors to find a square w/ centerpoint inside the poly
			private _nN = JST_hashMap get _squareTest select 3;
			private _nS = JST_hashMap get _squareTest select 4;
			private _nE = JST_hashMap get _squareTest select 5;
			private _nW = JST_hashMap get _squareTest select 6;
			private _squareIn = _squareTest;
			switch (true) do
			{
				case ((JST_hashMap get _nN select 1) inPolygon _poly):
				{
					_squareIn = _nN;
				};
				case ((JST_hashMap get _nS select 1) inPolygon _poly):
				{
					_squareIn = _nS;
				};
				case ((JST_hashMap get _nE select 1) inPolygon _poly):
				{
					_squareIn = _nE;
				};
				case ((JST_hashMap get _nW select 1) inPolygon _poly):
				{
					_squareIn = _nW;
				};
			};
			// get THAT square's neighbors
			_nN = JST_hashMap get _squareIn select 3;
			_nS = JST_hashMap get _squareIn select 4;
			_nE = JST_hashMap get _squareIn select 5;
			_nW = JST_hashMap get _squareIn select 6;
			// check north neighbor for enemy
			if ((JST_hashMap get _nN select 0) isEqualTo _enemy1) exitWith {_enemy = _enemy1};
			if ((JST_hashMap get _nN select 0) isEqualTo _enemy2) exitWith {_enemy = _enemy2};
			// check south neighbor for enemy
			if ((JST_hashMap get _nS select 0) isEqualTo _enemy1) exitWith {_enemy = _enemy1};
			if ((JST_hashMap get _nS select 0) isEqualTo _enemy2) exitWith {_enemy = _enemy2};
			// check east neighbor for enemy
			if ((JST_hashMap get _nE select 0) isEqualTo _enemy1) exitWith {_enemy = _enemy1};
			if ((JST_hashMap get _nE select 0) isEqualTo _enemy2) exitWith {_enemy = _enemy2};
			// check west neighbor for enemy
			if ((JST_hashMap get _nW select 0) isEqualTo _enemy1) exitWith {_enemy = _enemy1};
			if ((JST_hashMap get _nW select 0) isEqualTo _enemy2) exitWith {_enemy = _enemy2};
		} forEach _poly;
		// if enemy neighbor, make this poly an enemy poly of that enemy side
		switch (_enemy) do
		{
			case 0:
			{
				[_poly, WEST] call JST_fnc_setSideByPoly;
				_bluPolys deleteAt (_bluPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
				_opfPolys deleteAt (_opfPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
				_indPolys deleteAt (_indPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
			};
			case 1:
			{
				[_poly, EAST] call JST_fnc_setSideByPoly;
				_bluPolys deleteAt (_bluPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
				_opfPolys deleteAt (_opfPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
				_indPolys deleteAt (_indPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
			};
			case 2:
			{
				[_poly, INDEPENDENT] call JST_fnc_setSideByPoly;
				_bluPolys deleteAt (_bluPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
				_opfPolys deleteAt (_opfPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
				_indPolys deleteAt (_indPolys findIf {[_x, _poly] call JST_fnc_testIfSamePolys});
			};
		};
	};
};


/* OLD WAY THAT CHECKS IF INSIDE ENEMY POLYS (DOESN'T DETECT SURROUNDED POLYS TOUCHING SIDE OF MAP)
// iterate through all polys of side
for "_i" from ((count _polys) - 1) to 0 step -1 do
{
	private _poly = _polys select _i;
	// skip if "main" territory... don't ever delete that xD
	if (_basePos inPolygon _poly) then {continue};
	// if this poly isn't occupied...
	if !(_poly in _occupiedPolys) then
	{
		// find a point that's fully inside the poly; start with one on the poly
		private _pnt =_poly select 0;
		// get its square
		private _squareStr = str ((floor ((_pnt select 0)/100))*100) + str ((floor ((_pnt select 1)/100))*100);
		// test neighbors until a centerpoint is inside the poly
		private _nN = JST_hashMap get _squareStr select 3;
		private _nS = JST_hashMap get _squareStr select 4;
		private _nE = JST_hashMap get _squareStr select 5;
		private _nW = JST_hashMap get _squareStr select 6;
		switch (true) do
		{
			case ((JST_hashMap get _nN select 1) inPolygon _poly):
			{
				_pnt = JST_hashMap get _nN select 1;
			};
			case ((JST_hashMap get _nS select 1) inPolygon _poly):
			{
				_pnt = JST_hashMap get _nS select 1;
			};
			case ((JST_hashMap get _nE select 1) inPolygon _poly):
			{
				_pnt = JST_hashMap get _nE select 1;
			};
			case ((JST_hashMap get _nW select 1) inPolygon _poly):
			{
				_pnt = JST_hashMap get _nW select 1;
			};
		};
		// test if this centerpoint is inside any ENEMY polys, if yes, set all squares inside poly to that enemy side, remove poly from list
		private _inside1 = false;
		private _inside2 = false;
		{
			if (_pnt inPolygon _x) exitWith
			{
				[_poly, _enemy1] call JST_fnc_setSideByPoly;
				_polys deleteAt _i;
				_inside1 = true;
			};
		} forEach _enemyPolys1;
		if (!_inside1) then
		{
			{
				if (_pnt inPolygon _x) exitWith
				{
					[_poly, _enemy2] call JST_fnc_setSideByPoly;
					_polys deleteAt _i;
					_inside2 = true;
				};
			} forEach _enemyPolys2;
		};
	};
};
*/