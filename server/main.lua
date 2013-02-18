require 'middleclass'
require 'library/library'
require 'server_functions'
require 'classes/classes'

socket = require "socket"
udp = socket.udp()
udp:settimeout(0)

udp:setsockname('*', 12345)

this_server = Server:new("Eric's localhost Server")


running = true
while running do

	data, otherStuff, port = udp:receivefrom()
	
	if data == "adminconnect" then
		if check_console_ip(otherStuff) then
			this_server:addAdmin(otherStuff, port)
		end
	end
	
	if data ~= nil then
		command = {}
		for word in string.gmatch(data, "[^%s]+") do table.insert(command, word) end --accept input into word array
		
		
		if command[1] == "console" and check_console_ip(otherStuff) then
			table.remove(command, 1)
			admin_packet(command)
		elseif command[1] == "client" then
			table.remove(command, 1)
			client_packet(command)
		end
	end
	
end


