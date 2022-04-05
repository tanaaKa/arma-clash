// vehicle service markers

waitUntil {(side player isEqualTo WEST) or (side player isEqualTo EAST)};

if (side player isEqualTo WEST) then {
	_rearmMarker = createMarkerLocal ["brep", getMarkerPos "bmarkloc"];
	_rearmMarker setMarkerShapeLocal "ICON";
	_rearmMarker setmarkerTypeLocal "loc_Fuelstation";
	_rearmMarker setMarkerTextLocal "Vehicle Service";
	
	_medMarker = createMarkerLocal ["bmed", getPos medbox1];
	_medMarker setMarkerShapeLocal "ICON";
	_medMarker setmarkerTypeLocal "RedCrystal";
	_medMarker setMarkerTextLocal "Medical";
	
	_buyMarker = createMarkerLocal ["bbuy", getPos bPC];
	_buyMarker setMarkerShapeLocal "ICON";
	_buyMarker setmarkerTypeLocal "loc_Pick";
	_buyMarker setMarkerTextLocal "Buy Menu";
	
	
	_safeZone = createMarkerLocal ["bsz", position bsafezone];
	_safeZone setMarkerShapeLocal "RECTANGLE";
	_safeZone setMarkerSizeLocal [triggerArea bsafezone select 0, triggerArea bsafezone select 1];
	_safeZone setMarkerBrushLocal "SolidBorder";
	_safeZone setMarkerColorLocal "ColorBLUFOR";
	_safeZone setmarkerDirLocal ((triggerArea bsafezone) select 2);
	
} else {
	_rearmMarker = createMarkerLocal ["orep", getMarkerPos "omarkloc"];
	_rearmMarker setMarkerShapeLocal "ICON";
	_rearmMarker setmarkerTypeLocal "loc_Fuelstation";
	_rearmMarker setMarkerTextLocal "Vehicle Service";
	
	_medMarker = createMarkerLocal ["omed", getPos medbox2];
	_medMarker setMarkerShapeLocal "ICON";
	_medMarker setmarkerTypeLocal "RedCrystal";
	_medMarker setMarkerTextLocal "Medical";
	
	_buyMarker = createMarkerLocal ["bbuy", getPos oPC];
	_buyMarker setMarkerShapeLocal "ICON";
	_buyMarker setmarkerTypeLocal "loc_Pick";
	_buyMarker setMarkerTextLocal "Buy Menu";
	
	_safeZone = createMarkerLocal ["osz", position osafezone];
	_safeZone setMarkerShapeLocal "RECTANGLE";
	_safeZone setMarkerSizeLocal [triggerArea osafezone select 0, triggerArea osafezone select 1];
	_safeZone setMarkerBrushLocal "SolidBorder";
	_safeZone setMarkerColorLocal "ColorOPFOR";
	_safeZone setmarkerDirLocal ((triggerArea osafezone) select 2);
};