Server = class('Server')

function Server:initialize(servername)
	self.name = servername
	self.players = {}
	self.rooms = {}
	self.admins = {}
	
	print(servername .. " is now running.")
end

function Server:addAdmin(ipaddress, port)
	duplicate = false
	for i,admin in ipairs(self.admins) do
		if admin.ip == ipaddress then
			duplicate = true
		end
	end
	
	if not duplicate then
		table.insert(self.admins, {["ip"] = ipaddress, ["port"] = port})
		self:adminBroadcast("Admin: " .. ipaddress .. ":" .. port .. " has connected...")
	end
end

function Server:adminBroadcast(message)
	for i,admin in ipairs(self.admins) do
		udp:sendto(message, admin.ip,  admin.port)
	end
end

function Server:isGameType(unvalidated_type)
	return GAMETYPES[unvalidated_type]
end

function Server:playerJoin(roomname, playername)
	the_player = self:getPlayer(playername)
	the_room = self:getRoom(roomname)
	if the_player and the_room then
		the_room:addPlayer(the_player)
	else
		self:adminBroadcast("Could not join a player to a room, the player name or room name does not exist.")
	end
end

function Server:addPlayer(playername, ip)
	if not self:getPlayer(playername) then
		table.insert(self.players, Player:new(playername, ip, self))
		self:adminBroadcast("Player: \"" .. playername .. "\" has connected to the server.")
	else
		self:adminBroadcast("Player: \"" .. playername .. "\" could not connect to the server. Non Unique Name.")
	end
end

function Server:getPlayer(playername)
	
	unique_player = false
	
	for i,player in ipairs(self.players) do
		if playername == player:getName() then
			unique_player = player
			player_index = i
		end
	end
	
	return unique_player, player_index
end

function Server:kickPlayer(playername)
	player, playerid = self:getPlayer(playername)
	if (player) then
		for i,room in ipairs(self.rooms) do
			if room:getPlayer(playername) then
				room:removePlayer(playername)
			end
		end
		table.remove(self.players, playerid)
		self:adminBroadcast("Player: " .. playername .. " has been kicked from the server.")
	end
end

function Server:addRoom(roomname, gametype)
	if not self:getRoom(roomname) then
		if self:isGameType(gametype) then
			table.insert(self.rooms, Room:new(roomname, gametype, self))
			self:adminBroadcast("Room: \"" .. roomname .. "\" has been created with gametype: " .. gametype)
		else
			self:adminBroadcast("Room: \"" .. roomname .. "\" could not be created due to invalid gametype.")
		end
	else
		self:adminBroadcast("Room: \"" .. roomname .. "\" could not be created due to duplicate name.")
	end
end

function Server:listRooms()
	self:adminBroadcast("===Room List===")
	for i,room in ipairs(self.rooms) do
		self:adminBroadcast(room:getName() .. '(' .. room:getPlayerCount() .. '/' .. room:getPlayerLimit() .. ')')
	end
	self:adminBroadcast("===============")
end

function Server:listPlayers()
	self:adminBroadcast("===Player List===")
	for i,player in ipairs(self.players) do
		self:adminBroadcast(player:getName() .. '(' .. player:getStatus() .. ')')
	end
	self:adminBroadcast("=================")
end

function Server:getRoom(roomname)
	
	unique_room = false
	
	for i,room in ipairs(self.rooms) do
		if roomname == room:getName() then
			unique_room = room
		end
	end
	
	return unique_room
end
