function love.load()
	socket = require "socket"
	-- the address and port of the server
	address, port = "localhost", 12345
	
	name = 'Blenderer'
	
	udp = socket.udp()
	udp:settimeout(0)
	udp:setpeername(address, port)
	
	dg = string.format("%s %s", 'connect', name)
	udp:send(dg)

end

function love.update(deltatime)
	
end


function love.draw()
	love.graphics.print(dg,300, 200);
end