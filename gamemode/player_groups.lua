-- Teams table
-- This table contains data about each team
-- Each team should be a table with their current pot, followed by each player in it
Teams = []

-- Freelancers table
-- This table contains all the players who are not currently assigned to a team,
-- be they rogue or merely unassigned
Freelancers = []

-- LFTeam table
-- This table contains Freelancers who are currently not considered "rogue"
LFTeam = []

-- Rogues table
-- This table contains data about rogues
-- Each value should ideally be another table, with [player betrayer, player victim, table victeam, int score]
Rogues = []

-- function OnBetrayal(player betrayer, player victim, int score)
-- adds data to rogues table
function OnBetrayal(betrayer, victim, score)
	-- get the rest of the team
	victeam = []
	for _,team in pairs(Teams) do
		if victim in team then -- FIXME: Vim tells me "in" isn't valid here, research this. im bad at lua
			victeam = team
		end
	end

	-- remove betrayer, reset pot to 0
	victeam:remove(betrayer) -- I will be genuinely surprised if this is actually right
	victeam[1] = 0

	-- create data for rogues table, and add
	roguedata = [betrayer, victim, victeam, score]
	Rogues:append(roguedata)

	-- create a timer to remove from rogues and add to LFTeam after 30 seconds
	-- TODO: cvar for rogue time
	timer.Create("RemoveRogue" + betrayer:SteamID(), 30, 1, function
		Rogues:remove(roguedata)
		LFTeam:append(betrayer)
	end)
end
