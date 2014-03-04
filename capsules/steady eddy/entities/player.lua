local player = {}

function player.new( map, x, y, z )
	local self = {}
	self.fixtures = {}

	self.x = x
	self.y = y
	self.z = z

	self.bodyUserdata = {}
	self.bodyUserdata.name = "Unnamed"
	self.bodyUserdata.type = "player"
	self.bodyUserdata.properties = {}
	self.bodyUserdata.callbacks = {}

	-- Common variables
	self.mx, self.my = self.x, self.y

	local width, height = 180, 10
	local ox, oy = width/2, height/2
	local sx, sy = 1, 1
	local r = 0
	self.cx, self.cy = x - ox + width / 2, y - oy + height / 2
	self.radius = yama.tools.getDistance( self.cx, self.cy, x - ox, y - oy)
	self.type = "player"

	self.cursor = nil
	self.distance = nil




	-- BUFFER BATCH
	self.bufferBatch = yama.buffers.newBatch(self.x, self.y, 1)
	local spritePlatform = yama.buffers.newDrawable(yama.assets.loadImage("platform"),self.x, self.y, self.z, 1, 1, 1, ox, oy )
	local spriteBall = yama.buffers.newDrawable(yama.assets.loadImage("ball"),self.x, self.y, self.z, 1, 1, 1, 20, 20 )
	
	table.insert( self.bufferBatch.data, spritePlatform )
	table.insert( self.bufferBatch.data, spriteBall )

	--love.mouse.setPosition( x, y )
	-- Physics

	function self.initialize( properties )

		self.cursor = properties.cursor
	end
	---[[ 
	self.fixtures.main = love.physics.newFixture(love.physics.newBody(  map.world, self.x, self.y, "dynamic"), love.physics.newRectangleShape(180,10), 1)
	self.fixtures.main:setGroupIndex( 1 )
	self.fixtures.main:setCategory( 1 )
	self.fixtures.main:setMask( 2 )
	self.fixtures.main:setUserData( self.bodyUserdata )
	self.fixtures.main:setRestitution( 0.7 )
	self.fixtures.main:getBody():setFixedRotation( true )
	self.fixtures.main:getBody():setLinearDamping( 1 )
	self.fixtures.main:getBody():setMass( 1 )
	self.fixtures.main:getBody():setInertia( 0.01 )
	self.fixtures.main:getBody():setGravityScale( 1 )
	self.fixtures.main:getBody():setBullet( true )

	
	self.fixtures.ball = love.physics.newFixture(love.physics.newBody(  map.world, self.x, self.y, "dynamic"), love.physics.newCircleShape(20))
	self.fixtures.ball:getBody():setMass( 0.3 )
	self.fixtures.ball:getBody():setGravityScale( 5 )
	--self.fixtures.ball:setSensor( true )

	self.platformGrabberJoint = love.physics.newMouseJoint( self.fixtures.main:getBody(), self.x, self.y )

	--]]

	function self.update( dt )
		--love.mouse.setPosition( self.x, self.y )
		--self.mx, self.my = love.mouse.getPosition( )
		--self.fixtures.main:getBody():setPosition(self.cursor.x, self.cursor.y)
		--self.fixtures.grabber:getBody():setPosition(self.cursor.x, self.cursor.y)

		self.platformGrabberJoint:setTarget(self.cursor.x, self.cursor.y )

		self.updatePosition()
	end

	function self.mouseWheel( button )
		if button == "wu" then
			self.fixtures.main:getBody():setAngle( self.fixtures.main:getBody():getAngle() -0.25 )
		end
		if button == "wd" then
			print("DSFSDS")
			self.fixtures.main:getBody():setAngle( self.fixtures.main:getBody():getAngle() +0.25 )
		end
	end
	
	function self.gamepadpressed( button )
		if button == "a" then
			
		end
		if button == "y" then
		end
	end

	function self.bodyUserdata.callbacks.beginContact( a, b, contact )
		local userdata = a:getUserData()
		local userdata2 = b:getUserData()
	end

	function self.bodyUserdata.callbacks.endContact( a, b, contact )
		local userdata = a:getUserData()
		local userdata2 = b:getUserData()
	end

	function self.refreshBufferBatch()

		self.bufferBatch = yama.buffers.newBatch(x, y, z)

		table.insert( self.bufferBatch.data, spritePlatform )
		table.insert( self.bufferBatch.data, spriteBall )
	end


	function self.updatePosition(xn, yn)		
		self.x = self.fixtures.main:getBody():getX()
		self.y = self.fixtures.main:getBody():getY()
		self.r = self.fixtures.main:getBody():getAngle()

		spriteBall.x = self.fixtures.ball:getBody():getX()
		spriteBall.y = self.fixtures.ball:getBody():getY()
		--spriteBall.z = self.0
		spriteBall.r = self.fixtures.ball:getBody():getAngle()

		spritePlatform.x = self.x
		spritePlatform.y = self.y
		--spritePlatform.z = self.0
		spritePlatform.r = self.r

		self.bufferBatch.x = self.x
		self.bufferBatch.y = self.y
		--self.bufferBatch.z = 0
		self.bufferBatch.r = self.r
	end

	function self.draw( )
		love.graphics.setColorMode( "modulate" )
		love.graphics.setColor( 255, 255, 255, 255 );
		love.graphics.setBlendMode( "alpha" )
		if hud.enabled then
			physics.draw( self.fixtures.main, { 0, 255, 0, 102 } )
		end
	end

	function self.addToBuffer( vp )
		vp.addToBuffer( self.bufferBatch )
	end
	-- Basic functions
	function self.setPosition( x, y )
		self.fixtures.main.body:setPosition( x, y )
		self.fixtures.main.body:setLinearVelocity( 0, 0 )
	end

	function self.destroy( )
		self.fixtures.main:getBody():destroy()
		self.destroyed = true
	end

	-- GET
	function self.getType()
		return type
	end
	function self.getPosition()
		return self.x, self.y, self.z
	end
	function self.getBoundingBox()
		local bx = x - ox * sx
		local by = y - oy * sy

		return bx, by, width * sx, height * sy
	end
	function self.setBoundingBox()
		--print('before'..self.boundingbox.x )
		self.boundingbox.x = x - ox * sx
		self.boundingbox.y = y - oy * sy

		self.boundingbox.width = width * sx
		self.boundingbox.height = height * sy
	end
	return self
end

return player