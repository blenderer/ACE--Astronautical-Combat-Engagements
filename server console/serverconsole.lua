socket = require "socket"
-- the address and port of the server
address, port = "127.0.0.1", 12345

udp = socket.udp()
udp:settimeout(0)
udp:setpeername(address, port)

udp:setsockname(address, port)

udp:send("adminconnect")



running = true
while running == true do
	input = io.read()
	
	if input == 'quit' or input == 'end' or input == 'exit' then --check for quitting first
		break
	end
	if (input ~= nil) then
		udp:send("console " .. input)
	end
	
	print("DERP")
end