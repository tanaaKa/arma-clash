// check and record square that a unit is in; if not owned by his side, add to list of squares to re-evaluate

params ["_pos", "_side", "_reValGrids", "_bluGrids", "_opfGrids", "_indGrids"];
// do nothing if unit is above ground level (flying)
if ((_pos select 2) > 2) exitWith {};
// find grid square he's in
private _squareStr = str ((floor ((_pos select 0)/100))*100) + str ((floor ((_pos select 1)/100))*100);
// do nothing if square center outside AO or square not in hash map at all or square is over water
private _squareCtr = 0;
private _square = JST_hashMap getOrDefault [_squareStr, 0];
if !(_square isEqualTo 0) then
{
	_squareCtr = _square select 1;
};
if (_squareCtr isEqualTo 0) exitWith {};
if (!(_squareCtr inPolygon JST_AO_poly) or (surfaceIsWater [(_squareCtr select 0), (_squareCtr select 1)])) exitWith {};
// record grid, check its side
private _num = 4;
switch (_side) do
{
	case WEST:
	{
		_num = 0;
		_bluGrids pushBack [_squareStr, _squareCtr];
	};
	case EAST:
	{
		_num = 1;
		_opfGrids pushBack [_squareStr, _squareCtr];
	};
	case INDEPENDENT:
	{
		_num = 2;
		_indGrids pushBack [_squareStr, _squareCtr];
	};
};
// if grid side not same as unit side, add grid to list of grids to re-evaluate
if !((JST_hashMap get _squareStr select 0) isEqualTo _num) then
{
	_reValGrids pushBack _squareStr;
};