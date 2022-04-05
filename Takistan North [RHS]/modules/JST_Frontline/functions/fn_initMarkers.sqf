// draw generic (unowned) markers over AO

if (isNil "JST_AOB_poly") exitWith {systemChat "Error: JST_fnc_getAO was not run before JST_fnc_initFLMarkers!"};
for "_Gx" from 0 to worldSize step 100 do
{
	for "_Gy" from 0 to worldSize step 100 do
	{
		private _center = [_Gx + 50, _Gy + 50, 0];
		if (_center inPolygon JST_AOB_Poly) then
		{
			private _name = (str _Gx) + (str _Gy);
			createMarkerLocal [_name, _center];
			_name setMarkerShapeLocal "RECTANGLE";
			_name setMarkerSizeLocal [50, 50];
			_name setMarkerAlphaLocal 0;
			_name setMarkerColor "ColorCIV";
		};
	};
};