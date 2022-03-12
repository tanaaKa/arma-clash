// Create a destroy action for said FOB
// Only engis and demolitions can destroy the FOB with a satchel in their inventory

params["_object"];

_condition = 
{
	(
		(
			(typeOf player isEqualTo "B_soldier_repair_F")
			or
			(typeOf player isEqualTo "O_soldier_repair_F")
			or
			(typeOf player isEqualTo "B_soldier_exp_F")
			or
			(typeOf player isEqualTo "O_soldier_exp_F")
		)
		and
		("SatchelCharge_Remote_Mag" in magazines player)
	)
};

_destroyFOBAction =
[
	"destroyFOB",
	"Place Charge on FOB",
	"",
	{
		player removeItem "SatchelCharge_Remote_Mag";
		call clash_fnc_destroyFOB;
	},
	_condition,
	{},
	[
		_object,
		(name player)
	],
	{
		[0,0,0]
	},
	5
] call ace_interact_menu_fnc_createAction;

[
	_object,
	0,
	[
		"ACE_MainActions"
	],
	_destroyFOBAction
] call ace_interact_menu_fnc_addActionToObject;