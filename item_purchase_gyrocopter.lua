-- item_purchase_gyrocopter.lua

require( GetScriptDirectory().."\\item_manipulation_generic" )

local tableItemsToBuy = {
	"item_tango",
	"item_flask",
	"item_circlet",
	"item_recipe_wraith_band",
	"item_slippers",
	"item_boots",
	"item_sobi_mask",
	"item_ring_of_protection",
	"item_blades_of_attack",
	"item_blades_of_attack",
	"item_point_booster",
	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_staff_of_wizardry",
	"item_gloves",
	"item_mithril_hammer",
	"item_recipe_maelstrom",
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",
	"item_lifesteal",
	"item_mithril_hammer",
	"item_recipe_satanic",
	"item_boots",
	"item_recipe_travel_boots",
	"item_ultimate_orb",
	"item_ultimate_orb",
	"item_point_booster",
	"item_orb_of_venom",
	"item_hyperstone",
	"item_recipe_mjollnir",
};

function ItemPurchaseThink() 
	local bot = GetBot();

	if ( #tableItemsToBuy == 0) then
		bot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local sNextItem = tableItemsToBuy[1];
	bot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	if ( bot:GetGold() >= GetItemCost( sNextItem ) ) then
		bot:Action_PurchaseItem( sNextItem );
		table.remove( tableItemsToBuy, 1 );
	end
	
	CycleInventory();
end
