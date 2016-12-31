--item_manipulation_generic.lua
_G._savedEvn = getfenv()
module( "item_manipulation_generic", package.seeall )

function CanSell() 
	local bot = GetBot();
	if ( bot:DistanceFromFountain() == 0 or bot:DistanceFromSideShop() == 0 or bot:DistanceFromSecretShop() == 0 ) then 
		return true;
	end

	return false;
end

function CurrentHP() 
	local bot = GetBot();
	return ( bot:GetHealth() );
end

function CurrentMP() 
	local bot = GetBot();
	return ( bot:GetMana() );
end

function ItemRotation() 
	local bot = GetBot();
	local slotNum = 11;

	for i=0,8 do
		local curItem = bot:GetItemInSlot( i );
		if ( curItem ~= nil ) then
			if ( curItem:GetName() == "item_clarity" ) then
				npcBot:Action_SellItem( CurItem );
				return
			end
			if ( curItem:GetName() == "item_flying_courier" ) then 
				bot:Action_SellItem( curItem );
				return;
			end
			if ( ( i == 6 or i == 7 or i == 8 ) and ( curItem:GetName() == "item_tpscroll" or curItem:GetName() == "item_clarity" or curItem:GetName() == "item_flask" ) ) then
				bot:Action_SellItem( curItem );
				return;
			end
			if ( curItem:GetName() == "item_tango" ) then
				slotNum = i;
			elseif ( curItem:GetName() == "item_faerie_fire" ) then
				if (slotNum > 10) then
					slotNum = i;
				else
					local item bot:GetItemInSlot( slotNum );
					if ( item:GetName() == "item_tango" ) then
						--do nothing
					else
						slotNum = i;
					end
				end
			elseif ( curItem:GetName() == "item_flask" ) then
				if (slotNum > 10) then
					slotNum = i;
				else
					local item bot:GetItemInSlot( slotNum );
					if ( item:GetName() == "item_tango" or item:GetName() == "item_faerie_fire") then
						--do nothing
					else
						slotNum = i;
					end
				end
			elseif ( curItem:GetName() == "item_enchanted_mango" ) then
				if (slotNum > 10) then
					slotNum = i;
				else
					local item bot:GetItemInSlot( slotNum );
					if ( item:GetName() == "item_tango" or item:GetName() == "item_faerie_fire" or item:GetName() == "item_flask") then
						--do nothing
					else
						slotNum = i;
					end
				end
			elseif ( curItem:GetName() == "item_stout_shield" or curItem:GetName() == "item_poor_mans_shield" ) then
				if ( slotNum > 10 ) then
					slotNum = i;
				else
					--do nothing
				end
			end
		end
	end

	if ( slotNum < 10 ) then
		local item = bot:GetItemInSlot( slotNum );
		bot:Action_SellItem( item );
	end
end

function TPBuy() 
	local bot = GetBot();
	for i=0,8 do
		local curItem = bot:GetItemInSlot( i );
		if (curItem ~= nil ) then
			if ( curItem:GetName() == "item_tpscroll" or curItem:GetName() == "item_recipe_travel_boots" or curItem:GetName() == "item_travel_boots" ) then
				return;
			end
			if ( ( i == 6 or i == 7 or i == 8 ) and ( curItem:GetName() == "item_tpscroll" and CanSell() ) ) then
				bot:Action_SellItem( curItem );
				return;
			end
		end
	end
	if ( bot:GetGold() >= GetItemCost( "item_tpscroll" ) ) then
		if ( bot:DistanceFromFountain() == 0 and GameTime() > 60 ) then
			if ( HasSpareSlot() ) then
				bot:Action_PurchaseItem( "item_tpscroll" );
				return;
			end
		end
		if ( GameTime() < 600 ) then
			return;
		elseif ( HasSpareSlot() and ( bot:DistanceFromFountain() == 0 or bot:DistanceFromSideShop() == 0 or bot:DistanceFromSecretShop() == 0 ) ) then
			bot:Action_PurchaseItem( "item_tpscroll" );
		end
	end
end

function UseItemByName( itemName ) 
	bot = GetBot();
	if not ( bot:IsUsingAbility() or bot:IsChanneling() ) then
		for i=0,5 do
			local curItem = bot:GetItemInSlot( i );
			if ( curItem ~= nil ) then
				if ( curItem:GetName() == itemName ) then
					bot:Action_UseAbility( curItem );
					bot:Action_UseAbilityOnEntity( curItem, bot );
				end
			end
		end
	end
end

function CycleInventory() 
	if ( CurrentHP() < 100 ) then
		UseItemByName( "item_faerie_fire" );
	end

	if ( CurrentHP() < 200 and TimeSinceDamagedByAnyHero() > 5) then
		UseItemByName( "item_flask" );
	end

	if ( CurrentMP() < 121 ) then
		UseItemByName( "item_enchanted_mango" );
	end

	if ( ( CanSell() and GameTime() > 750 ) and not HasSpareSlot() ) then
		ItemRotation();
	end

	TPBuy();
end
