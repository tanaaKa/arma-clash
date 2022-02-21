// Basic safezone system
[] spawn TNK_fnc_safeZone;

// Basic allowance system
[] spawn TNK_fnc_allowance;

// Add local event handlers to players
[] spawn TNK_fnc_localEHs;

// Set per-side markers
[] spawn TNK_fnc_createMarkers;

// Add heal boxes
[] spawn TNK_fnc_addHealBoxes;

// Commander JIP support
[] spawn TNK_fnc_commanderSupports;

// Save base loadout for respawn
player setVariable ["tnk_loadout", getUnitLoadout player];

// Disable carrying of buy pcs
[bPC, false] call ace_dragging_fnc_setCarryable;
[oPC, false] call ace_dragging_fnc_setCarryable;
[bPC, false] call ace_dragging_fnc_setDraggable;
[oPC, false] call ace_dragging_fnc_setDraggable;