// build hash map data structure containing basic data about every single 100m^2 grid in the AO

if !(isNil "JST_hashMap") then {JST_hashMap = nil};
JST_hashMap = createHashMap;
for "_Gx" from -1000 to (worldSize + 1000) step 100 do
{
	for "_Gy" from -1000 to (worldSize + 1000) step 100 do
	{
		private _center = [_Gx + 50, _Gy + 50, 0];
		if (_center inPolygon JST_AOB_poly) then
		{
			// use key which is a string of the bottom-left grid corner location
			private _name = (str _Gx) + (str _Gy);
			// save polygon shape
			private _poly =
			[
				[_Gx, _Gy, 0],
				[(_Gx + 100), _Gy, 0],
				[(_Gx + 100), (_Gy + 100), 0],
				[_Gx, _Gy + 100, 0],
				[_Gx, _Gy, 0]
			];
			// save neighbor string references N,S,E,W
			private _nN = (str _Gx) + (str (_Gy + 100));
			private _nS = (str _Gx) + (str (_Gy - 100));
			private _nE = (str (_Gx + 100)) + (str _Gy);
			private _nW = (str (_Gx - 100)) + (str _Gy);
			
			/*// save midpoints of edges N,S,E,W --- NOT DETERMINISTICALLY RANDOMIZED
			private _mN = [(_Gx + 50), (_gY + 100), 0];
			private _mS = [(_Gx + 50), _gY, 0];
			private _mE = [(_Gx + 100), (_gY + 50), 0];
			private _mW = [_Gx, (_Gy + 50), 0];*/
			
			// save midpoints of edges N,S,E,W --- DETERMINISTICALLY RANDOMIZED
			// north/south to up/down and east/west to left right
			// up to limit in meters below
			private _limit = 15;
			
			// north midpoint
			private _mN = [(_Gx + 50), (_gY + 100), 0];
			private _mN_num = parseNumber ((str (_mN select 0)) + (str (_mN select 1)));
			private _r = _mN_num random 1;
			private _u = _mN_num+1 random 1;
			private _y = _mN select 1;
			private _dis = linearConversion [0, 1, _r, 0, _limit, true];
			if (_u > 0.5) then
			{
				_y = _y + _dis;
			}
			else
			{
				_y = _y - _dis;
			};
			_mN = [_mN select 0, _y, 0];
			
			// south midpoint
			private _mS = [(_Gx + 50), _gY, 0];
			private _mS_num = parseNumber ((str (_mS select 0)) + (str (_mS select 1)));
			private _r = _mS_num random 1;
			private _u = _mS_num+1 random 1;
			private _y = _mS select 1;
			private _dis = linearConversion [0, 1, _r, 0, _limit, true];
			if (_u > 0.5) then
			{
				_y = _y + _dis;
			}
			else
			{
				_y = _y - _dis;
			};
			_mS = [_mS select 0, _y, 0];
			
			// east midpoint
			private _mE = [(_Gx + 100), (_gY + 50), 0];
			private _mE_num = parseNumber ((str (_mE select 0)) + (str (_mE select 1)));
			private _r = _mE_num random 1;
			private _u = _mE_num+1 random 1;
			private _xV = _mE select 0;
			private _dis = linearConversion [0, 1, _r, 0, _limit, true];
			if (_u > 0.5) then
			{
				_xV = _xV + _dis;
			}
			else
			{
				_xV = _xV - _dis;
			};
			_mE = [_xV, _mE select 1, 0];
			
			// west midpoint
			private _mW = [_Gx, (_Gy + 50), 0];
			private _mW_num = parseNumber ((str (_mW select 0)) + (str (_mW select 1)));
			private _r = _mW_num random 1;
			private _u = _mW_num+1 random 1;
			private _xV = _mW select 0;
			private _dis = linearConversion [0, 1, _r, 0, _limit, true];
			if (_u > 0.5) then
			{
				_xV = _xV + _dis;
			}
			else
			{
				_xV = _xV - _dis;
			};
			_mW = [_xV, _mW select 1, 0];

			// set initial owner to unowned
			private _owner = 4;
			// save array into hash map
			JST_hashMap set [_name, [_owner, _center, _poly, _nN, _nS, _nE, _nW, _mN, _mS, _mE, _mW]];
		};
	};
};