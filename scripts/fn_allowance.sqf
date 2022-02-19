// conversion rate from seconds of pre-existing gametime in seconds to funds for JIPs
private _funds = serverTime * 0.4;

// ensure base funds for players at mission start
if (_funds < 200) then {_funds = 200};

// add funds based on elapsed time since server mission start (retroactive allowance)
[player, _funds] call grad_lbm_fnc_addFunds;

// Save funds just in case
profileNamespace setVariable ["tnk_aas_money",_funds];

// Default 100 credit allowance every 10 minutes
while {true} do {
	uisleep 600;
	[player,100] call grad_lbm_fnc_addFunds;
	
	["<t color='#FFD500' font='PuristaBold' size = '0.6'>Allowance added (+100CR)</t>",-0.8,1.1,4,1,0.5,789] call BIS_fnc_dynamicText;
	if (JST_debug) then {systemChat "Allowance cycle."};
};