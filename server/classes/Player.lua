Player = class('Player')

function Player:initialize(name, ip, server)
	self.name = name
	self.ip = ip
	self.server = server
	
	self.status = 'lobby'
end

function Player:inGame(change)
	ingame = change or false --default value is false
	
	if ingame then
		self.status = 'game'
	elseif self.status == 'game' then
		ingame = true
	end
	
	return ingame
end

function Player:getStatus()
	return self.status
end

function Player:inLobby(change)
	inlobby = change or false
	
	if inlobby then
		self.status = 'lobby'
	elseif self.status == 'lobby' then
		inlobby = true
	end
	
	return inlobby
end

function Player:getName()
	return self.name
end

function Player:getIp()
	return self.ip
end