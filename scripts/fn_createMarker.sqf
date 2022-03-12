// Create fob markers

params["_object","_fobName","_fobMarker"];

_tempName = format ["FOB%1",count activeFOBs];
_fobMarker = createMarkerLocal [_tempName, _object];
_fobMarker setMarkerShapeLocal "ICON";
_fobMarker setmarkerTypeLocal "loc_CivilDefense";
_fobMarker setMarkerTextLocal format ["%1",_fobName];
_object setVariable ["fobMarker",_fobMarker]; // should this not be local
activeFOBs pushBackUnique _tempName; // Add to array - UNIQUE - not the most performant

_tempMarker = format ["100m%1", count activeFOBMarkers];
_100m = createMarkerLocal [_tempMarker, _object];
_100m setMarkerShapeLocal "ELLIPSE";
_100m setMarkerTypeLocal "ellipse";
_100m setMarkerSizeLocal [100,100];
_100m setMarkerBrushLocal "Border";
_object setVariable ["fobRadius",_100m]; // should this not be local
activeFOBMarkers pushBackUnique _tempMarker; // Add to array - UNIQUE - not the most performant