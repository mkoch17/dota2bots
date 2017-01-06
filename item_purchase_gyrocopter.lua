-- item_purchase_gyrocopter.lua

require( GetScriptDirectory().."\\item_manipulation_generic" )
local build = require( GetScriptDirectory().."\\Item_build_gyrocopter")
local util = require( GetScriptDirectory().."\\util")

local tableItemsToBuy = build["items"];
local skillsToLevel = build["skills"];

local function ThinkLvlupAbility(level)
	local bot = GetBot();
	if ( #skillsToLevel > (25 - util.GetHeroLevel() ) ) then
		local ability_name = skillsToLevel[1];
		if (ability_name ~= "-1") then
			local ability = bot:GetAbilityByName(ability_name);
			if ( ability:CanAbilityBeUpgraded() and ability:GetLevel() < ability:GetMaxLevel() ) then
				local currentlevel = ability:GetLevel();
				bot:Action_LevelAbility(skillsToLevel[1]);
				if ability:GetLevel() > currentlevel then
					--It worked
					table.remove(skillsToLevel, 1);
				end
			end
		end
	end
end

function ItemPurchaseThink() 
	local bot = GetBot();
	ThinkLvlupAbility();
	if ( #tableItemsToBuy == 0) then
		bot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local sNextItem = tableItemsToBuy[1];
	bot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	if ( bot:GetGold() >= GetItemCost( sNextItem ) ) then
		if (IsItemPurchasedFromSecretShop(sNextItem) and bot:DistanceFromSecretShop() > 0) then
			return;
		end
		if (IsItemPurchasedFromSideShop(sNextItem) and bot:DistanceFromSideShop() <= 6000 and bot:DistanceFromSideShop() > 0) then
			return;
		end
		local success = bot:Action_PurchaseItem( sNextItem );
		if ( success == PURCHASE_ITEM_SUCCESS ) then
			table.remove( tableItemsToBuy, 1 );
			if (sNextItem == "item_staff_of_wizardry") then
				bot:Action_Chat("New Meta", true);
			end
		end
	end
	
	CycleInventory();
end
