-- hero_selection.lua

local tableRadiantHeroes = {
	{ "npc_dota_hero_nevermore", 	LANE_MID },
	{ "npc_dota_hero_juggernaut", 	LANE_BOT },
	{ "npc_dota_hero_crystal_maiden", 	LANE_BOT },
	{ "npc_dota_hero_axe", 			LANE_TOP },
	{ "npc_dota_hero_lich",		LANE_TOP }
};

local tableDireHeroes = {
	{ "npc_dota_hero_gyrocopter", 	LANE_TOP },
	{ "npc_dota_hero_oracle", 	LANE_BOT },
	{ "npc_dota_hero_skywrath_mage", LANE_TOP },
	{ "npc_dota_hero_viper",		LANE_MID},
	{ "npc_dota_hero_bristleback", 	LANE_BOT }
};

local tableTeamHeroes = {};
tableTeamHeroes [ TEAM_RADIANT ] = tableRadiantHeroes;
tableTeamHeroes [ TEAM_DIRE ] = tableDireHeroes;

----------------------------------------------
-- Hero selection for bots
function Think()
	local tableHeroes = tableTeamHeroes[ GetTeam() ];
	local tablePlayers = GetTeamPlayers( GetTeam() );

	for i , iPlayer in ipairs( tablePlayers ) do
		if ( IsPlayerBot( iPlayer) ) then
			SelectHero( iPlayer, tableHeroes[i][1]);
		end
	end

end
---------------------------------------------
-- set lane assignments
function UpdateLaneAssignments()
	local tableHeroes = tableTeamHeroes[ GetTeam() ];
	local tableLaneAssignments = {};

	for i , tableHeroLane in ipairs( tableHeroes ) do
		tableLaneAssignments[i] = tableHeroLane[ 2 ];
	end

	return tableLaneAssignments
end
