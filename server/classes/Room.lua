Room = class('Room')

function Room:initialize(name, gametype, server)
	self.name = name
	self.gametype = gametype
	self.server = server
	
	self.gamestate = 'lobby'
	
	self.players = {}
	
	self.player_limit = GAMETYPES[gametype].max_players
end

function Room:getPlayerCount()
	return table.getn(self.players)
end

function Room:getGameState()
	return self.gamestate
end

function Room:getPlayerLimit()
	return self.player_limit
end

function Room:getName()
	return self.name
end

function Room:getPlayer(playername)
	
	unique_player = false
	
	for i,player in ipairs(self.players) do
		if playername == player:getName() then
			unique_player = player
			player_index = i
		end
	end
	
	return unique_player, player_index
end

function Room:addPlayer(player)
	if player:inLobby() then
		if self:getPlayerCount() < self:getPlayerLimit() then
			table.insert(self.players, player)
			player:inGame(true)
			self.server:adminBroadcast("Player: " .. player:getName() .. " has been added to Room: " .. self:getName() .. ".")
		else
			self.server:adminBroadcast("Room is full, cannot add player")
		end
	else
		self.server:adminBroadcast("Player is not available to join game")
	end
end

function Room:removePlayer(playerinput)
	player, player_index = self:getPlayer(playerinput)
	
	table.remove(self.players, player_index)
	player:inLobby(true)
	self.server:adminBroadcast("Player: " .. player:getName() .. " has been removed from Room: " .. self:getName() .. ".")
end