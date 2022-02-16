// vehicle service markers
if (side player isEqualTo WEST) then {
	_rearmMarker = createMarkerLocal ["brep", getMarkerPos "bmarkloc"];
	_rearmMarker setMarkerShapeLocal "ICON";
	_rearmMarker setmarkerTypeLocal "loc_Fuelstation";
	_rearmMarker setMarkerTextLocal "Vehicle Service";
} else {
	_rearmMarker = createMarkerLocal ["orep", getMarkerPos "omarkloc"];
	_rearmMarker setMarkerShapeLocal "ICON";
	_rearmMarker setmarkerTypeLocal "loc_Fuelstation";
	_rearmMarker setMarkerTextLocal "Vehicle Service";
};