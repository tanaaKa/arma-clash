// delete projectiles fired by player that enter the safe zones

// remove existing firedMan eventHandlers, if any
player removeAllEventHandlers "firedMan";

// add firedMan eventHandler
player addEventHandler
[
	"firedMan",
	{
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
		{
			// delete projectile if player inside a safe zone
			if (player inArea _x) then
			{
				deleteVehicle _projectile;
				hintSilent "Projectile deleted! No shooting in Safe Zones!";
			}
			else
			{
				// find cursor position with an actually reliable method
				private _tgt =
				(
					lineIntersectsSurfaces
					[
						AGLToASL positionCameraToWorld [0,0,0],
						AGLToASL positionCameraToWorld [0,0,2500],
						player,
						objNull,
						true,
						1,
						"GEOM",
						"NONE"
					]
				) select 0 select 0;
				// delete projectile if cursor position inside safe zone
				if (_tgt inArea _x) then
				{
					deleteVehicle _projectile;
					hintSilent "Projectile deleted! No shooting at Safe Zones!";
				};
			};
		} forEach CLASH_safeZones;
	}
];