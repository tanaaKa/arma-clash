// switch square side based on majority side inside it, IF it has a neigbor of that side as well (no independent squares)

params ["_squareStr", "_bluHere", "_opfHere", "_indHere"];
// set vars based on majority
private _side = 4;
private _mkrColorStr = "";
switch (true) do
{
	// blufor majority in square
	case ((_bluHere > _opfHere) and (_bluHere > _indHere)):
	{
		_side = 0;
		_mkrColorStr = "ColorBLUFOR";
	};
	// opfor majority in square
	case ((_opfHere > _bluHere) and (_opfHere > _indHere)):
	{
		_side = 1;
		_mkrColorStr = "ColorOPFOR";
	};
	// indfor majority in square
	case ((_indHere > _bluHere) and (_indHere > _opfHere)):
	{
		_side = 2;
		_mkrColorStr = "ColorINDEPENDENT";
	};
};
// proceed only if valid data found
if (_side < 3) then
{
	// get square data
	private _a = JST_hashMap get _squareStr;
	// check if at least one neighbor square is same side
	private _n = false;
	{
		if ((JST_hashMap get _x select 0) isEqualTo _side) then {_n = true};
	} forEach [_a select 3, _a select 4, _a select 5, _a select 6];
	// only proceed if yes
	if (_n) then
	{
		JST_hashMap set [_squareStr, [_side, _a select 1, _a select 2, _a select 3, _a select 4, _a select 5, _a select 6, _a select 7, _a select 8, _a select 9, _a select 10]];
		_squareStr setMarkerColorLocal _mkrColorStr;
		_squareStr setMarkerAlpha JST_FL_shadingAlpha;
	};
};