// Get AO poly from input string name (with quotes) of marker in Eden that is a geometrical duplicate of the cover map module

params ["_mkrStr"];
// get AO dimensions from cover map marker
private _AO_pos = getMarkerPos _mkrStr;
private _AO_dir = markerDir _mkrStr;
private _AO_size = markerSize _mkrStr;
private _AOB_size = [(_AO_size select 0) + 200, (_AO_size select 1) + 200];
// get corners of AO (exact size)
private _AO_TR = (_AO_pos getPos [_AO_size select 0, (_AO_dir + 90)]) getPos [_AO_size select 1, _AO_dir];
private _AO_TL = (_AO_pos getPos [_AO_size select 1, _AO_dir]) getPos [_AO_size select 0, (_AO_dir + 270)];
private _AO_BR = _AO_TR getPos [((_AO_size select 1) * 2), (_AO_dir + 180)];
private _AO_BL = _AO_TL getPos [((_AO_size select 1) * 2), (_AO_dir + 180)];
// get corners of AO (slightly oversized)
private _AOB_TR = (_AO_pos getPos [_AOB_size select 0, (_AO_dir + 90)]) getPos [_AOB_size select 1, _AO_dir];
private _AOB_TL = (_AO_pos getPos [_AOB_size select 1, _AO_dir]) getPos [_AOB_size select 0, (_AO_dir + 270)];
private _AOB_BR = _AOB_TR getPos [((_AOB_size select 1) * 2), (_AO_dir + 180)];
private _AOB_BL = _AOB_TL getPos [((_AOB_size select 1) * 2), (_AO_dir + 180)];
// save corners into polygon array
JST_AO_poly = [_AO_TR, _AO_TL, _AO_BL, _AO_BR, _AO_TR];
JST_AOB_poly = [_AOB_TR, _AOB_TL, _AOB_BL, _AOB_BR, _AOB_TR];
