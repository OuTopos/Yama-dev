local physics = {}

function physics.draw(world)
	if world then
		for i, body in ipairs(world:getBodyList()) do
			--fixtures = body:getFixtureList()
			for i, fixture in ipairs(body:getFixtureList()) do
				physics.drawFixture(fixture)
			end
		end
	end
end

function physics.drawFixture(fixture)
	local r, g, b, a = 0, 0, 0, 0


	if fixture:getBody():getType() == "static" then
		r, g = 255, 0
	else
		r, g = 0, 255
	end

	if fixture:isSensor() then
		b = 255
	else
		b = 0
	end

	if fixture:getBody():isActive() then
		a = 102
	else
		a = 51
	end

	if not fixture:getUserData() then
		a = 255
	end
	love.graphics.setColor(r, g, b, a)

	if fixture:getShape():getType() == "circle" then
		love.graphics.circle("fill", fixture:getBody():getX(), fixture:getBody():getY(), fixture:getShape():getRadius())
	elseif fixture:getShape():getType() == "polygon" then
		love.graphics.polygon("fill", fixture:getBody():getWorldPoints(fixture:getShape():getPoints()))
	elseif fixture:getShape():getType() == "edge" then
		love.graphics.line(fixture:getBody():getWorldPoints(fixture:getShape():getPoints()))
	elseif fixture:getShape():getType() == "chain" then
		love.graphics.line(fixture:getBody():getWorldPoints(fixture:getShape():getPoints()))
	end
	love.graphics.setColor(255, 255, 255, 255)
end

return physics