local socket = require "socket"
-- the address and port of the server
address, port = "127.0.0.1", 12345

udp = socket.udp()
udp:settimeout(0)
udp:setpeername(address, port)

udp:send("adminconnect")

function love.load()
	xstart, ystart = 5, 5
	
	userinput = ""
	
	select_all = false
	
	lines_n = 15

	lines = {}
	for i=1, lines_n do
		lines[i] = {}
		lines[i].text = ""
		lines[i].color = ""
		lines[i].y = 5 + 20*(i-1)
	end
	
	stime = love.timer.getTime() * 1000
	
	input = ""
end

function love.update(deltatime)
	data, msg = udp:receive()
	
	if data ~= nil then
		inserttext(data, "green")
	end

	if love.keyboard.isDown("backspace") then
		if love.timer.getTime() * 1000 - stime > 100 then
			userinput = string.sub(userinput, 1, -2)
			stime = love.timer.getTime() * 1000
		end
		
		if select_all then
			userinput = ""
			select_all = false
		end
	end 
	
	
	if input ~= "" then
		if input == 'quit' or input == 'end' or input == 'exit' then --check for quitting first
			love.event.quit()
		end
		if (input ~= nil) then
		udp:send("console " .. input)
		end
		
		input = ""
	end
end


function love.draw()
	for i=1, table.getn(lines) do
		if lines[i].color == "green" then
			love.graphics.setColor(56, 186, 56)
		elseif lines[i].color == "grey" then
			love.graphics.setColor(171, 171, 171)
		end
		love.graphics.print(lines[i].text, 5, lines[i].y)
	end
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(">  " .. userinput, 5, 15 + 20*(lines_n + 1 - 1), 0, 1.5, 1.5)
end

function inserttext(message, color)
	for i=1, table.getn(lines)  do
		if i ~= lines_n then
			lines[i].text = lines[i+1].text
			lines[i].color = lines[i+1].color
		end
	end
	lines[lines_n].text = message
	lines[lines_n].color = color
end

function love.keypressed(key, unicode)
	if unicode > 31 and unicode < 127 then
        userinput = userinput .. string.char(unicode)
    end
	
	if key == "return" or key == "kpenter" then
		if userinput ~= "" then
			inserttext(userinput, "grey")
			input = userinput
			userinput = ""
		end
	elseif key == "up" then
		userinput = lines[lines_n].text
	end
	
	if key == "a" and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		select_all = true
	end
end
