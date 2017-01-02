--item_build_gyrocopter.lua
X = {}
-- Set up item build
X["items"] = {
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

--Set up skill build
local SKILL_Q = "gyrocopter_rocket_barrage";
local SKILL_W = "gyrocopter_homing_missile";
local SKILL_E = "gyrocopter_flak_cannon";
local SKILL_R = "gyrocopter_call_down";

local ABILITY1 = "special_bonus_hp_150";
local ABILITY2 = "special_bonus_spell_amplify_6";
local ABILITY3 = "special_bonus_attack_damage_30";
local ABILITY4 = "special_bonus_magic_resistance_10";
local ABILITY5 = "special_bonus_cooldown_reduction_20";
local ABILITY6 = "special_bonus_movement_speed_25";
local ABILITY7 = "special_bonus_unique_gyrocopter_1";
local ABILITY8 = "special_bonus_unique_gyrocopter_1";

X["skills"] = {
	SKILL_Q, SKILL_E, SKILL_Q, SKILL_W, SKILL_Q,
	SKILL_R, SKILL_Q, SKILL_E, SKILL_E, SKILL_E,
	SKILL_W, SKILL_R, SKILL_W, SKILL_W, "-1",
	"-1",	 "-1",	  SKILL_R, ABILITY1, ABILITY3,
	ABILITY6, "-1",	  "-1",		"-1",	 ABILITY7
};

return X