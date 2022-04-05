// test if two given set of points are conterminous irrespective of order, return true or false
// point lists come in format [bordering midpoint, bordering corner 1, bordering corner 2, square's centerpoint, squareStr]

params ["_pnts1", "_pnts2"];

// if they're not the same size, they're not the same set
if !((count _pnts1) isEqualTo (count _pnts2)) exitWith {false};

// otherwise, we must check the midpoints and see if each midpoint from one is in the other
private _count = 0;
{
	private _midPnt1 = _x select 0;
	{
		private _midPnt2 = _x select 0;
		if (_midPnt1 isEqualTo _midPnt2) then {_count = _count + 1; continue};
	} forEach _pnts2;
} forEach _pnts1;

if (_count isEqualTo (count _pnts1)) exitWith {true};

// default to returning false
false