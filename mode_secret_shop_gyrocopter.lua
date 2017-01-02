--mode_secret_shop_gyrocopter.lua

local build = require( GetScriptDirectory().."\\item_build_gyrocopter" )

local tableItemsToBuy = build["items"];

function GetDesire()
	local bot = GetBot();
	local desire = 0;
	local sNextItem = tableItemsToBuy[1];
	if ( bot:GetGold() >= GetItemCost( sNextItem ) ) then
		if ( sNextItem == "item_point_booster" or sNextItem == "item_ultimate_orb" ) then
			desire = BOT_ACTION_DESIRE_VERYHIGH;
		end
	else
		desire = BOT_ACTION_DESIRE_NONE;
	end
	return desire;
end
