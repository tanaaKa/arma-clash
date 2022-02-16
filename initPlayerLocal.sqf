// Basic markers systems
[] call TNK_fnc_playerMarkers;

// Basic safezone system
call TNK_fnc_safeZone;

// Basic allowance system
call TNK_fnc_allowance;

// Add local event handlers to players
call TNK_fnc_localEHs;

// Set per-side markers
call TNK_fnc_createMarkers;

// Save base loadout for respawn
player setVariable ["tnk_loadout", getUnitLoadout player];