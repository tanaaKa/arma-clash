// draw poly with markers

params ["_poly", "_side"];
for "_i" from 0 to (count _poly) step 1 do
{
	if (_i > ((count _poly) - 2)) exitWith {};
	private _pnt1 = _poly select _i;
	private _pnt2 = _poly select (_i + 1);
	[_pnt1, _pnt2, _side, _i] call JST_fnc_drawLine;
};