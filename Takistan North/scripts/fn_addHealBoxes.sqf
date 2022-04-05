{
	[  
		_x,  
		"Heal Yourself",  
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",  
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",  
		"(_this distance _target < 3)",  
		"(_caller distance _target < 3)",  
		{},  
		{},
		{[player] call clash_fnc_heal},
		{},  
		[],
		1,  
		996,  
		false,  
		false  
	] call BIS_fnc_holdActionAdd;
}forEach [medbox1,medbox2];

// disable carrying of box
[medbox1, false] call ace_dragging_fnc_setCarryable;
[medbox2, false] call ace_dragging_fnc_setCarryable;
[medbox1, false] call ace_dragging_fnc_setDraggable;
[medbox2, false] call ace_dragging_fnc_setDraggable;