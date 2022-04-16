// this is not called by anything, it's just a scratchpad for copy/pasting into Eden

// obj 1 trigger
obj1Trigger
// obj 2 trigger
obj2Trigger
// obj 3 trigger
obj3Trigger
// obj 4 trigger
obj4Trigger

// sector 1 expression
if ((_this select 1) isEqualTo WEST) then
{
	obj2Trigger enableSimulationGlobal true;
	{
		if !(side _x isEqualTo WEST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj1Trigger);
};
if ((_this select 1) isEqualTo EAST) then
{
	obj2Trigger enableSimulationGlobal false;
	{
		if !(side _x isEqualTo EAST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj1Trigger);
};

// sector 2 expression
if ((_this select 1) isEqualTo WEST) then
{
	obj1Trigger enableSimulationGlobal false;
	obj3Trigger enableSimulationGlobal true;
	{
		if !(side _x isEqualTo WEST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj2Trigger);
};
if ((_this select 1) isEqualTo EAST) then
{
	obj3Trigger enableSimulationGlobal false;
	obj1Trigger enableSimulationGlobal true;
	{
		if !(side _x isEqualTo EAST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj2Trigger);
};

// sector 3 expression
if ((_this select 1) isEqualTo WEST) then
{
	obj2Trigger enableSimulationGlobal false;
	obj4Trigger enableSimulationGlobal true;
	{
		if !(side _x isEqualTo WEST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj3Trigger);
};
if ((_this select 1) isEqualTo EAST) then
{
	obj4Trigger enableSimulationGlobal false;
	obj2Trigger enableSimulationGlobal true;
	{
		if !(side _x isEqualTo EAST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj3Trigger);
};

// sector 4 expression
if ((_this select 1) isEqualTo WEST) then
{
	obj3Trigger enableSimulationGlobal false;
	{
		if !(side _x isEqualTo WEST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj4Trigger);
};
if ((_this select 1) isEqualTo EAST) then
{
	obj3Trigger enableSimulationGlobal true;
	{
		if !(side _x isEqualTo EAST) then {continue};
		[_x, 500] call grad_lbm_fnc_addFunds;
		[
			format  
			[ 
				"<t color='#FFD500' font='PuristaBold' size = '0.6' shadow='1'>500 credits awarded for sector capture!</t>"
			],-0.8,1.1,4,1,0.25,789
		] remoteExec ["BIS_fnc_dynamicText", _x];
	} forEach (allPlayers inAreaArray obj4Trigger);
};