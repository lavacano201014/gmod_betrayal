GM.Name = "Betrayal"
GM.Author = "Nicholas \"Lavacano\" O'Connor"
GM.Email = "N/A"
GM.Website = "http://www.netswim.net"

GM.TeamBased = true

function GM:Initialize()
	print("ASSASSIN")
end

function GM:CreateTeams()

-- Don't do this if not teambased. But if it is teambased we
-- create a few teams here as an example. If you're making a teambased
-- gamemode you should override this function in your gamemode
if ( !GAMEMODE.TeamBased ) then return end

	TEAM_COMBATANT = 1
	team.SetUp( TEAM_COMBATANT, "Combatant", Color( 0, 0, 255 ) )

	team.SetSpawnPoint( TEAM_SPECTATOR, "worldspawn" )

end
