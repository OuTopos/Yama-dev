local joystick = {}
joystick.active = 1
--joystick.
--joystick.gamepad = love.joystick.open(0)

function joystick.update(dt)
	love.joystick.getHat( joystick, hat )
end


return joystick