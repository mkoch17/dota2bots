--util.lua
local X = {}
function X.GetHeroLevel()
	local bot = GetBot();
	local respawnTable = {8, 10, 12, 14, 16, 26, 28, 30, 32, 34, 36, 46, 48, 50, 52, 54, 56, 66, 70, 74, 78, 82, 86, 90, 100};
	local respawnTime = bot:GetRespawnTime() + 1;
	for k,v in pairs (respawnTable) do
		if v == respawnTime then
			return k
		end
	end
end

return X;