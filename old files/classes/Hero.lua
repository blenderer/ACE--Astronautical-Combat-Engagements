Hero = class('Hero', Body)

function Hero:initialize(playername, class)
	Body:initialize()
	
	self.playername = playername
	self.class = class
end

function Hero:getPlayername()
	return self.playername
end

function getClass()
	return self.class
end