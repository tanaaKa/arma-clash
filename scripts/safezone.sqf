[] spawn {
  while {true} do {
   uisleep 2;
   {
     if !(_x getVariable ["MGIttd",false]) then {
       _x setVariable ["MGIttd",true];
       _x addEventHandler ["firedman", 
        { 
          _shooter = _this select 0; 
          _projectile = _this select 6;
          _target = if (isplayer _shooter) then [{cursorTarget},{ assignedTarget _shooter}];
          call {
            if (_projectile inArea bsafezone or _projectile inArea osafezone) exitWith {
              deleteVehicle _projectile;
              if (isPlayer _shooter) then {
					"Don't fire inside the base!" remoteExec ["hintC",_shooter]
              }
            };
            if (_target inArea bsafezone or _target inArea osafezone) exitWith {
              deleteVehicle _projectile;
              if (isPlayer _shooter) then {
					"Don't fire inside the base" remoteExec ["hintC",_shooter]
              }
            };
            [_shooter,_projectile] spawn {
              params ["_shooter","_projectile"];
              waitUntil {_projectile inArea bsafezone or _projectile inArea osafezone or isNull _projectile};
              if (!isNull _projectile) then {
                deleteVehicle _projectile;
                if (isPlayer _shooter) then {
					"Shooting at MAIN is disabled" remoteExec ["hintC",_shooter]
                }
              };
            };
          };  
       }]
      }
    } forEach allUnits;
  }
};