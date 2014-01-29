--[[
GM:PlayerSpawn(Player ply)
Purpose: Called when player spawns
]]--

function GM:PlayerSpawn(ply)
	if (ply:Team() == TEAM_SPECTATOR || ply:Team() == TEAM_UNASSIGNED) then
		-- Defer spectators/newcomers to the base gamemode's functions
		GAMEMODE:PlayerSpawnAsSpectator(ply)
		return
	end

	--[[
	if (ply.FirstSpawn) then
		-- Make sure the player has all his affairs in order
		-- We want to mark him as "freelance" and "looking for team"
		Freelancers:append(ply)
		LFTeam:append(ply)
	end
	--]]
	
	player_manager.SetPlayerClass(ply, "player_betrayal")

	-- What follows is the usual bullshit from base gamemode.
	-- Stop observer mode
	pl:UnSpectate()

	player_manager.OnPlayerSpawn(ply)
	player_manager.RunClass(ply, "Spawn")

	-- Call item loadout function
	hook.Call("PlayerLoadout", GAMEMODE, ply)
	
	-- Set player model
	hook.Call("PlayerSetModel", GAMEMODE, ply)
end

--[[
GM:PlayerSelectSpawn(Player pl)
Purpose: Select a spawnpoint for the player
]]--
function GM:PlayerSelectSpawn( pl )

	-- Pretty much the only thing that separates this from the base gamemode is a lack of teamspawn redirecting code
	-- I marked this as a team game to allow spectators, that's it

	-- Save information about all of the spawn points
	-- in a team based game you'd split up the spawns
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then
	
		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_combine" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_rebel" ) )
		
		-- CS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )
		
		-- DOD Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_axis" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_allies" ) )

		-- (Old) GMod Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gmod_player_start" ) )
		
		-- TF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_teamspawn" ) )
		
		-- INS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "ins_spawnpoint" ) )  

		-- AOC Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "aoc_spawnpoint" ) )

		-- Dystopia Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "dys_spawn_point" ) )

		-- PVKII Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_pirate" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_viking" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_knight" ) )

		-- DIPRIP Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_blue" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_red" ) )
 
		-- OB Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_red" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_blue" ) )        
 
		-- SYN Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_coop" ) )
 
		-- ZPS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_human" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombie" ) )      
 
		-- ZM Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombiemaster" ) )  		

	end
	
	local Count = table.Count( self.SpawnPoints )
	
	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil
	end
	
	-- If any of the spawnpoints have a MASTER flag then only use that one.
	-- This is needed for single player maps.
	for k, v in pairs( self.SpawnPoints ) do
		
		if ( v:HasSpawnFlags( 1 ) ) then
			return v
		end
		
	end
	
	local ChosenSpawnPoint = nil
	
	-- Try to work out the best, random spawnpoint
	for i=0, Count do
	
		ChosenSpawnPoint = table.Random( self.SpawnPoints )

		if ( ChosenSpawnPoint &&
			ChosenSpawnPoint:IsValid() &&
			ChosenSpawnPoint:IsInWorld() &&
			ChosenSpawnPoint != pl:GetVar( "LastSpawnpoint" ) &&
			ChosenSpawnPoint != self.LastSpawnPoint ) then
			
			if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == Count ) ) then
			
				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint
			
			end
			
		end
			
	end
	
	return ChosenSpawnPoint
	
end

--[[
GM:OnPlayerChangedTeam(Player ply, Team old, Team new)
Purpose: React to the player changing teams
]]--
function GM:OnPlayerChangedTeam(ply, old, new)
	if (new == TEAM_SPECTATOR) then -- Player has become a spectator
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos(Pos)
		PrintMessage(HUD_PRINTTALK, Format("%s has decided to spectate", ply:Nick()))
	elseif (old == TEAM_SPECTATOR) then -- Player has stopped spectating and joined the game
		ply:Spawn()
		PrintMessage(HUD_PRINTTALK, Format("%s has entered the fight", ply:Nick()))
	elseif (new == old) then
		-- Player opened the team change dialog, then selected the team he's already on
		-- Probably changed his mind or something.
	else -- Something weird.
		PrintMessage(HUD_PRINTCONSOLE, Format("%s attempted to join team %s", ply:Nick(), team.GetName(new) or "[nameless]"))
		GAMEMODE:PlayerJoinTeam(ply, old) -- Let's put him back
	end
end

--[[
GM:PlayerSpray(Player ply)
Purpose: True = no sprays
]]--
function GM:PlayerSpray(ply)
	return false -- eventually this will be convar controlled
end
