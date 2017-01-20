--ability_item_usage_gyrocopter.lua

castRBDesire = 0;
castHMDesire = 0;
castFCDesire = 0;
castCDDesire = 0;

function AbilityUsageThink()

	local bot = GetBot();

	if ( bot:IsUsingAbility() ) then
		return;
	end

	abilityRB = bot:GetAbilityByName( "gyrocopter_rocket_barrage" );
	abilityHM = bot:GetAbilityByName( "gyrocopter_homing_missile" );
	abilityFC = bot:GetAbilityByName( "gyrocopter_flak_cannon" );
	abilityCD = bot:GetAbilityByName( "gyrocopter_call_down" );

	castRBDesire = ConsiderRocketBarrage();
	castFKDesire = ConsiderFlakCannon();
	castCDDesire, castCDLocation = ConsiderCallDown();
	castHMDesire, castHMTarget = ConsiderHomingMissle();

	if ( castCDDesire > 0 ) then
		bot:Action_UseAbilityOnLocation( abilityCD, castCDLocation );
		return;
	end

	if ( castRBDesire > 0 ) then
		bot:Action_UseAbility( abilityRB );
		return;
	end

	if ( castFKDesire > 0 ) then
		bot:Action_UseAbility( abilityFC );
		return;
	end

	if ( castHMDesire > 0) then
		bot:ActionAbilityOnEntity( abilityHM, castHMTarget );
		return;
	end
end
--------------------------------------------------------------------------

function CanCastHomingMissleOnTarget( target )
	return target:CanBeSeen() and not target:IsMagicImmune() and not target:IsInvulnerable();
end

--------------------------------------------------------------------------

function ConsiderHomingMissle()
	bot = GetBot();
	if ( not abilityHM:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	-- Make Homing Missle last priority
	if ( castRBDesire > 0 or castCDDesire > 0 or castFKDesire > 0 ) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	local castRange = abilityHM:GetCastRange();
	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( castRange + 200, true, BOT_MODE_NONE );
	local minHP = 500;
	local minHPEnemy;
	for _,enemy in pairs( tableNearbyEnemyHeroes ) do
		if ( enemy:IsChanneling() and CanCastHomingMissleOnTarget( enemy ) ) then
			return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation();
		else
			if ( enemy:GetHealth() < minHP ) then
				minHPEnemy = enemy;
				minHP = enemy:GetHealth();
			end
		end
	end
	if ( not minHPEnemy == nil and CanCastHomingMissleOnTarget( minHPEnemy ) ) then
		return BOT_ACTION_DESIRE_MODERATE, minHPEnemy:GetLocation();
	else
		return BOT_ACTION_DESIRE_NONE, 0;
	end
end

----------------------------------------------------------------------------

function ConsiderFlakCannon()
	local bot = GetBot();

	if ( not abilityFC:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE;
	end

	local radius = abilityFC:GetSpecialValueInt( "radius" );
	local castRange = abilityFC:GetCastRange();

	---------------------------------
	-- Mode based usage
	---------------------------------
	if ( bot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAOE = bot:FindAoELocation( true, false, bot:GetLocation(), 0, radius, 0, 2000);

		if ( locationAOE.count >= 3 ) then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or
		 bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) 
	then
		local locationAOE = bot:FindAoELocation( true, false, bot:GetLocation(), 0, radius, 0, 0);
		
		if ( locationAOE.count >= 4 ) then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end

	local locationAOE = bot:FindAoELocation( false, true, bot:GetLocation(), 0, radius, 0, 0);
	if ( locationAOE.count >= 3 ) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	return BOT_ACTION_DESIRE_NONE;
end

------------------------------------------------------------------------

function ConsiderRocketBarrage()
	local bot = GetBot();

	if ( not abilityRB:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE;
	end

	local radius = abilityRB:GetSpecialValueInt( "radius" );
	local damage = abilityRB:GetAbilityDamage();


	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( radius, true, BOT_MODE_NONE );
	for _, enemy in pairs ( tableNearbyEnemyHeroes ) do
		if (not enemy:IsMagicImmune() and not enemy:IsInvulnerable() ) then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end

	--------------------------------
	-- Mode based usage
	--------------------------------

	-- if farming and the damage is useful
	if ( bot:GetActiveMode() == BOT_MODE_FARM ) then
		local locationAOE = bot:FindAoELocation( true, false, bot:GetLocation(), 0, radius, 0, damage + 200 );

		if ( locationAOE.count >= 1 and bot:GetMana() > 300 ) then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_ROAM or
		 bot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 bot:GetActiveMode() == BOT_MODE_GANK or
		 bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) 
	then
		local target = bot:GetTarget();
		if ( target ~= nil ) then
			if ( GetUnitToUnitDistance(bot, target) < radius ) then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end

	--if generally there is a low life hero nearby
	local locationAOE = bot:FindAoELocation( false, true, bot:GetLocation(), 0, radius, 0, damage * 2 );
	if ( locationAOE.count >= 1 ) then
		return BOT_ACTION_DESIRE_HIGH;
	end

	return BOT_ACTION_DESIRE_NONE;
end

-------------------------------------------------------------------------

function ConsiderCallDown()
	local bot = GetBot();

	if ( not abilityCD:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	local radius = abilityCD:GetSpecialValueInt( "radius" );
	local castRange = abilityCD:GetCastRange();

	if ( not bot:GetActiveMode() == BOT_MODE_RETREAT ) then
		local locationAoE = bot:FindAoELocation( false, true, bot:GetLocation(), CastRange, Radius, 0, 0 );
		if ( locationAOE.count >= 3 ) then
			return BOT_ACTION_DESIRE_MODERATE, locationAOE.targetloc;
		end
	end


	-------------------------------
	-- Mode Based usage
	-------------------------------
	if ( bot:GetActiveMode() == BOT_MODE_ROAM or
		 bot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 bot:GetActiveMode() == BOT_MODE_GANK or
		 bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY ) then
		local target = bot:GetTarget();
		if ( target ~= nil ) then
			if ( not target:IsInvulnerable() and not target:IsMagicImmune() ) then
				return BOT_ACTION_DESIRE_MODERATE, target:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end
