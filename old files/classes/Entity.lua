Entity = class('Entity')

function Entity:initialize()
	self.x = 0
	self.y = 0
	self.hp = 1
end

function Entity:getX()
	return self.x
end

function Entity:getY()
	return self.y
end

function Entity:setX(value)
	self.x = value
end

function Entity:setY(value)
	self.y = value
end

function Entity:getPos()
	return {self.x, self.y, x = self.x, y = self.y}
end

function Entity:setPos(x, y)
	self.x = x
	self.y = y
end

function Entity:getHP()
	return self.hp
end

function Entity:kill()
	self.hp = 0
end