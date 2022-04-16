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
				// find crosshair position
				private _tgt = 
				if ((vehicle player) isEqualTo player) then
				{
					( 
						lineIntersectsSurfaces 
						[ 
							eyePos player, 
							eyePos player vectorAdd ((player weaponDirection currentWeapon player) vectorMultiply 2500), 
							player, 
							(vehicle player), 
							true, 
							1, 
							"VIEW", 
							"NONE" 
						] 
					) select 0 select 0
				}
				else
				{
					( 
						lineIntersectsSurfaces 
						[ 
							eyePos player,
							eyePos player vectorAdd ((vehicle player) weaponDirection ((vehicle player weaponsTurret (vehicle player unitTurret player)) select 0) vectorMultiply 2500), 
							player, 
							(vehicle player), 
							true, 
							1, 
							"VIEW", 
							"NONE" 
						] 
					) select 0 select 0		
				};
				// delete projectile if crosshair position inside safe zone
				if (_tgt inArea _x) then
				{
					deleteVehicle _projectile;
					hintSilent "Projectile deleted! No shooting at Safe Zones!";
				};
			};
		} forEach CLASH_safeZones;
	}
];