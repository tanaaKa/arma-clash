// Basic safezone system
[] spawn TNK_fnc_safeZone;

// Basic allowance system
[] spawn TNK_fnc_allowance;

// Add local event handlers to players
[] spawn TNK_fnc_localEHs;

// Set per-side markers
[] spawn TNK_fnc_createMarkers;

// Save base loadout for respawn
player setVariable ["tnk_loadout", getUnitLoadout player];