// set all squares inside given poly to a side

params ["_poly", "_side"];
if (isNil "_poly") exitWith {};
if !((count _poly) > 0) exitWith {};
if (isNil "JST_hashMap") exitWith {systemChat "Error: JST_fnc_setSideByPoly called without having the hash map yet!"};
// iterate through squares in poly and in AO and set side of squares per input
switch (_side) do
{
	case WEST:
	{
		{
			private _key = _x;
			private _val = JST_hashMap get _key;
			if (((_val select 1) inPolygon _poly) and ((_val select 1) inPolygon JST_AO_poly) and !(surfaceIsWater [(_val select 1 select 0), (_val select 1 select 1)])) then
			{
				JST_hashMap set [_key, [0, _val select 1, _val select 2, _val select 3, _val select 4, _val select 5, _val select 6, _val select 7, _val select 8, _val select 9, _val select 10]];
				_key setMarkerColorLocal "ColorBLUFOR";
				_key setMarkerAlpha JST_FL_shadingAlpha;
			};
		} forEach JST_hashMap;
	};
	case EAST:
	{
		{
			private _key = _x;
			private _val = JST_hashMap get _key;
			if (((_val select 1) inPolygon _poly) and ((_val select 1) inPolygon JST_AO_poly) and !(surfaceIsWater [(_val select 1 select 0), (_val select 1 select 1)])) then
			{
				JST_hashMap set [_key, [1, _val select 1, _val select 2, _val select 3, _val select 4, _val select 5, _val select 6, _val select 7, _val select 8, _val select 9, _val select 10]];
				_key setMarkerColorLocal "ColorOPFOR";
				_key setMarkerAlpha JST_FL_shadingAlpha;
			};
		} forEach JST_hashMap;
	};
	case INDEPENDENT:
	{
		{
			private _key = _x;
			private _val = JST_hashMap get _key;
			if (((_val select 1) inPolygon _poly) and ((_val select 1) inPolygon JST_AO_poly) and !(surfaceIsWater [(_val select 1 select 0), (_val select 1 select 1)])) then
			{
				JST_hashMap set [_key, [2, _val select 1, _val select 2, _val select 3, _val select 4, _val select 5, _val select 6, _val select 7, _val select 8, _val select 9, _val select 10]];
				_key setMarkerColorLocal "ColorINDEPENDENT";
				_key setMarkerAlpha JST_FL_shadingAlpha;
			};
		} forEach JST_hashMap;
	};
};