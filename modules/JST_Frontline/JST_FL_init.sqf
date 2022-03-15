////////////////////////////////////////////////////
// Frontline v2 by Jester
////////////////////////////////////////////////////

////////////////////////////////////////////////////
// User inputs
////////////////////////////////////////////////////

// cycle interval; recommend between 5 and 15 seconds depending on map size and playercount
JST_FL_int = 10;

// map draw delay - time in seconds between a square being "taken" and it actually changing colors
JST_FL_delay = 0;

// whether to shade territory (border lines are drawn regardless)
JST_FL_shading = true;
JST_FL_shadingAlpha = 0.1;

// border marker name prefixes; leave as "" if side not used
JST_FL_bluBorderStr = "blu_border_";
JST_FL_opfBorderStr = "opf_border_";
JST_FL_indBorderStr = "";

// main base marker names; leave as "" if side not used
JST_FL_bluBaseMkrStr = "respawn_west";
JST_FL_opfBaseMkrStr = "respawn_east";
JST_FL_indBaseMkrStr = "";

// cover map marker name; should be exact geometrical duplicate of actual cover map module
JST_FL_coverMapStr = "JST_coverMap";

// show debug hint
JST_FL_debug = false;

////////////////////////////////////////////////////
// Operations
////////////////////////////////////////////////////

// calculate required length of historical position data to save on units based on map draw delay
if (JST_FL_delay < 1) then {JST_FL_delay = 1};
JST_FL_historyLength = round (JST_FL_delay/JST_FL_int);
if (JST_FL_historyLength < 1) then {JST_FL_historyLength = 1};

// get AO data
[JST_FL_coverMapStr] call JST_fnc_getAO;

// build hash map data structure containing basic data about every single 100m^2 grid in the AO
[] call JST_fnc_initHashMap;

// draw 0 alpha (unowned) markers over AO
[] call JST_fnc_initMarkers;

// draw starting territories
[([JST_FL_bluBorderStr] call JST_fnc_findStartPoly), WEST] call JST_fnc_setSideByPoly;
[([JST_FL_opfBorderStr] call JST_fnc_findStartPoly), EAST] call JST_fnc_setSideByPoly;
[([JST_FL_indBorderStr] call JST_fnc_findStartPoly), INDEPENDENT] call JST_fnc_setSideByPoly;

if (JST_FL_debug) then {systemChat "Initial draw done."};

// start MAIN LOOP
JST_FL_thread = [] spawn
{
	while {UIsleep JST_FL_int; true} do
	{
	
		private _time0 = diag_tickTime;
		
		// iterate over all units and record their square; if in non-owned square, add to revalgrids
		private _reValGrids = [];
		private _bluGrids = [];
		private _opfGrids = [];
		private _indGrids = [];
		{
			// pull location history from unit
			private _history = _x getVariable ["JST_unitHistory", "NONE"];
			if (_history isEqualTo "NONE") then
			{
				_x setVariable ["JST_unitHistory", [getPos _x]];
			}
			else
			{
				// pull location history from historyLength ago, if available, otherwise just update it and move on
				if ((count _history) < JST_FL_historyLength) then
				{
					_history pushBack (getPos _x);
					_x setVariable ["JST_unitHistory", _history];
				}
				else
				{
					private _pos = _history select 0;
					_history deleteAt 0;
					_history pushBack (getPos _x);
					_x setVariable ["JST_unitHistory", _history];
					[_pos, (side _x), _reValGrids, _bluGrids, _opfGrids, _indGrids] call JST_fnc_checkSquare;
				};
			};
		} forEach allUnits;
		// remove duplicate items
		_reValGrids = _reValGrids arrayIntersect _reValGrids;
		// iterate through list of squares to re-evaluate, find which side has majority there, and change color accordingly
		{
			private _squareStr = _x;
			private _bluHere = {(_x select 0) isEqualTo _squareStr} count _bluGrids;
			private _opfHere = {(_x select 0) isEqualTo _squareStr} count _opfGrids;
			private _indHere = {(_x select 0) isEqualTo _squareStr} count _indGrids;
			[_squareStr, _bluHere, _opfHere, _indHere] call JST_fnc_evalSquareSide;
		} forEach _reValGrids;
		
		private _time1 = diag_tickTime;
		
		// iterate through all grids, look for grids with unowned neighbors, add them to BORDERS array
		// will add to lists in format [bordering midpoint, bordering corner 1, bordering corner 2, square's centerpoint, squareStr]
		// a BORDER is a complete poly around an owned territory; a FRONTLINE is a line running along where two opposing territories meet.
		// all frontlines should coincide with a part of a border
		private _pntsBluBdrs = [];
		private _pntsOpfBdrs = [];
		private _pntsIndBdrs = [];
		{
			// proceed only if owned square
			if ((_y select 0) < 3) then
			{
				private _bdrsHere = [];
				// list neighbors
				private _nN = _y select 3;
				private _nS = _y select 4;
				private _nE = _y select 5;
				private _nW = _y select 6;
				// if N neighbor is not same side
				if !((JST_hashMap get _nN select 0) isEqualTo (_y select 0)) then
				{
					_bdrsHere pushBack [_y select 7, _y select 2 select 2, _y select 2 select 3, _y select 1, _x];
				};
				// if S neighbor is not same side
				if !((JST_hashMap get _nS select 0) isEqualTo (_y select 0)) then
				{
					_bdrsHere pushBack [_y select 8, _y select 2 select 0, _y select 2 select 1, _y select 1, _x];
				};
				// if E neighbor is not same side
				if !((JST_hashMap get _nE select 0) isEqualTo (_y select 0)) then
				{
					_bdrsHere pushBack [_y select 9, _y select 2 select 1, _y select 2 select 2, _y select 1, _x];
				};
				// if W neighbor is not same side
				if !((JST_hashMap get _nW select 0) isEqualTo (_y select 0)) then
				{
					_bdrsHere pushBack [_y select 10, _y select 2 select 0, _y select 2 select 3, _y select 1, _x];
				};
				// add bordering data array to list per side
				switch (_y select 0) do
				{
					case 0: {_pntsBluBdrs append _bdrsHere};
					case 1: {_pntsOpfBdrs append _bdrsHere};
					case 2: {_pntsIndBdrs append _bdrsHere};
				};
			};
		} forEach JST_hashMap;
		
		private _time2 = diag_tickTime;
		
		// create master arrays of borders per side
		private _bluBorders = [];
		private _opfBorders = [];
		private _indBorders = [];
		
		// loop over border points to create closed polys until all points are used or 5 second timeout
		// function basically moves points from one array to the other as it builds continuous splines
		private _timeStop = time + 5;
		while {((count _pntsBluBdrs) > 0) and (time < _timeStop)} do
		{
			[_bluBorders, _pntsBluBdrs] call JST_fnc_orderPointsGrid;
		};
		_timeStop = time + 5;
		while {((count _pntsOpfBdrs) > 0) and (time < _timeStop)} do
		{
			[_opfBorders, _pntsOpfBdrs] call JST_fnc_orderPointsGrid;
		};
		_timeStop = time + 5;
		while {((count _pntsIndBdrs) > 0) and (time < _timeStop)} do
		{
			[_indBorders, _pntsIndBdrs] call JST_fnc_orderPointsGrid;
		};
		
		private _time3 = diag_tickTime;
		
		// remove any unoccupied areas by absorbing into adjacent enemy areas
		[_bluBorders, _opfBorders, _indBorders, _bluGrids, _opfGrids, _indGrids, 0] call JST_fnc_removeDeadZones_v3; // west
		[_bluBorders, _opfBorders, _indBorders, _bluGrids, _opfGrids, _indGrids, 1] call JST_fnc_removeDeadZones_v3; // east
		[_bluBorders, _opfBorders, _indBorders, _bluGrids, _opfGrids, _indGrids, 2] call JST_fnc_removeDeadZones_v3; // independent
		
		private _time4 = diag_tickTime;
		
		// reduce border arrays down to frontline points only
		[_bluBorders, _opfBorders, _indBorders] call JST_fnc_removeDuplicatePoints; // tests blu against opf and ind
		[_opfBorders, _bluBorders, _indBorders] call JST_fnc_removeDuplicatePoints;
		[_indBorders, _opfBorders, _bluBorders] call JST_fnc_removeDuplicatePoints;
		
		// remove duplicate frontlines by checking if a point is shared between remaining border arrays
		private _frontlines = [];
		[_bluBorders, _opfBorders, _indBorders, _frontlines] call JST_fnc_removeDuplicateArrays;
		[_opfBorders, _bluBorders, _indBorders, _frontlines] call JST_fnc_removeDuplicateArrays;
		[_indBorders, _bluBorders, _opfBorders, _frontlines] call JST_fnc_removeDuplicateArrays;
		
		// check and fix list of points starting/ending in their geographic middle
		{
			[_x] call JST_fnc_orderPointsSpline;
		} forEach _frontlines;
		
		private _time5 = diag_tickTime;
		
		// draw frontline splines
		if (isNil "JST_markerCountHighest") then {JST_markerCountHighest = 0};
		JST_markerCount = 0;
		{
			// find spline
			private _spline = [_x] call JST_fnc_findSpline;
			// find left/right orientation of bordering sides
			private _firstPnt = _x select 0;
			private _secondPnt = _x select 1;
			private _leftPnt = _firstPnt getPos [51, (_firstPnt getDir _secondPnt) + 315];
			private _rightPnt = _firstPnt getPos [51, (_firstPnt getDir _secondPnt) + 45];
			private _leftSquareStr = str ((floor ((_leftPnt select 0)/100))*100) + str ((floor ((_leftPnt select 1)/100))*100);
			private _rightSquareStr = str ((floor ((_rightPnt select 0)/100))*100) + str ((floor ((_rightPnt select 1)/100))*100);
			private _leftSide = JST_hashMap get _leftSquareStr select 0;
			private _rightSide = JST_hashMap get _rightSquareStr select 0;
			// draw spline
			[_spline, _leftSide, _rightSide] call JST_fnc_drawSpline;
		} forEach _frontlines;

		private _time6 = diag_tickTime;
		
		// clear extra unused markers
		if (JST_markerCount > JST_markerCountHighest) then
		{
			JST_markerCountHighest = JST_markerCount;
		}
		else
		{
			for "_i" from (JST_markerCount + 1) to JST_markerCountHighest do
			{
				private _markerStr = "splineMkr_" + str _i;
				_markerStr setMarkerAlpha 0;
			};
		};
		
		private _time7 = diag_tickTime;
		
		// debug reports
		if (JST_FL_debug) then
		{
			private _fps = diag_fps;
			hintSilent parseText format 
			[
			"<t align='left'>
			Scheduled timing in seconds*fps:
			<br/>
			%1 / Re-evaluate square owners
			<br/>
			%2 / Find border squares
			<br/>
			%3 / Remove duplicate border squares
			<br/>
			%4 / Sort points into actual borders
			<br/>
			%5 / Remove dead zones
			<br/>
			%6 / Draw borders
			<br/>
			%7 / Clear unused markers
			</t>",
			((_time1 - _time0)*_fps) toFixed 2,
			((_time2 - _time1)*_fps) toFixed 2,
			((_time3 - _time2)*_fps) toFixed 2,
			((_time4 - _time3)*_fps) toFixed 2,
			((_time5 - _time4)*_fps) toFixed 2,
			((_time6 - _time5)*_fps) toFixed 2,
			((_time7 - _time6)*_fps) toFixed 2
			];
		};
	};
};