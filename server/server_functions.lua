function check_console_ip(ip)
	fh = io.open("adminwhitelist.txt","r")
	match = false
	while match == false do
		line = fh.read(fh)
		if not line then 
			break
		else
			if line == ip then
				match = true
			else
				print(line, " ", ip)
			end
		end
		
	end
	
	io.close()
	return match
end

function room_packet(command)
	if command[1] == 'create' then
		if command[2] and command[3] then --if we have 2 parameters to pass to initilialize room
			this_server:addRoom(command[2], command[3])
		else
			this_server:adminBroadcast("room attempted to create, but failed due to not enough parameters")
		end
	elseif command[1] == 'list' then
		this_server:listRooms()
	end
end

function player_packet(command)
	if command[1] == 'add' then
		if command[2] and command[3] then --if we have 2 parameters to pass to initilialize room
			this_server:addPlayer(command[2], command[3])
		else
			this_server:adminBroadcast("Attempted to add player to server, but failed due to not enough parameters")
		end
	elseif command[1] == 'remove' then
		if command[2] and command[3] then --if we have 2 parameters to pass to initilialize room
			the_room = this_server:getRoom(command[2])
			the_room:removePlayer(command[3])
		else
			this_server:adminBroadcast("Attempted to remove player from room, but failed due to not enough parameters")
		end
	elseif command[1] == 'join' then
		if command[2] and command[3] then
			this_server:playerJoin(command[2], command[3]) --room name, player name,
		else
			this_server:adminBroadcast("Attempted to player to join room, but failed due to not enough parameters")
		end
	elseif command[1] == 'kick' then
		if command[2] then
			this_server:kickPlayer(command[2])
		else
			this_server:adminBroadcast("Attempted to kick player from server, but failed due to not enough parameters")
		end
	elseif command[1] == 'list' then
		this_server:listPlayers()
	end
end

function admin_packet(command)
	if command[1] == 'sexit' then --command "serverclose"
		running = false
	elseif command[1] == 'room' then --"room" command
		table.remove(command, 1)
		room_packet(command)
	elseif command[1] == 'player' then
		table.remove(command, 1)
		player_packet(command)
	else --not any above commands
		client_packet(command)
	end
end

function client_packet(command)
	
end
