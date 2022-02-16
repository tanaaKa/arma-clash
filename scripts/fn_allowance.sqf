// Set default funds
[player,200] call grad_lbm_fnc_setFunds;

// Add money based on how long the mission file has been running
switch (true) do {
	case (serverTime > 1800):
	{
		[player,750] call grad_lbm_fnc_addFunds;
	};
	case (serverTime > 3600):
	{
		[player,1500] call grad_lbm_fnc_addFunds;
	};
	default {};
};

// Default 100 credit allowance every 10 minutes
[] spawn {
	while {true} do {
		uisleep 600;
		[player,100] call grad_lbm_fnc_addFunds;
		
		["<t color='#FFD500' font='PuristaBold' size = '0.6'>Allowance added (+100CR)</t>",-0.8,1.1,4,1,0.5,789] call BIS_fnc_dynamicText;
	};
};