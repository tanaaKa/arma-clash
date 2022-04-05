// reset any existing debug markers
if !(isNil "JST_debugPoints") then
{
	{
		deleteMarker _x;
	} forEach JST_debugPoints;
	JST_debugPoints = []
}
else
{
	JST_debugPoints = []
};