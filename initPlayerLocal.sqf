// Basic safezone system
[] spawn clash_fnc_safeZone;

// Basic allowance system
[] spawn clash_fnc_allowance;

// Add local event handlers to players
[] spawn clash_fnc_localEHs;

// Set per-side markers
[] spawn clash_fnc_createMarkers;

// Add heal boxes
[] spawn clash_fnc_addHealBoxes;

// Commander JIP support
[] spawn clash_fnc_commanderSupports;

// Save base loadout for respawn
player setVariable ["clash_loadout", getUnitLoadout player];

// Disable carrying of buy pcs
[bPC, false] call ace_dragging_fnc_setCarryable;
[oPC, false] call ace_dragging_fnc_setCarryable;
[bPC, false] call ace_dragging_fnc_setDraggable;
[oPC, false] call ace_dragging_fnc_setDraggable;