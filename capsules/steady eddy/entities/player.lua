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
	local width, height = 128, 128
	local ox, oy = width/2, height/2
	local sx, sy = 1, 1
	local r = 0
	self.cx, self.cy = x - ox + width / 2, y - oy + height / 2
	self.radius = yama.tools.getDistance( self.cx, self.cy, x - ox, y - oy)
	self.type = "player"


	-- BUFFER BATCH
	self.bufferBatch = yama.buffers.newBatch(self.x, self.y, 0)
	--spriteJumper = yama.buffers.newDrawable(yama.assets.loadImage("jumper"),self.x, self.y, self.z, r, sx, sy, ox, oy )

	--local spritePlatform = yama.buffers.newDrawable(yama.assets.loadImage("platform"), self.x, self.y, 1, 1, sx, sy, 3, 3 )

	
	--table.insert( self.bufferBatch.data, spritePlatform )


	-- Physics

	function self.initialize( properties )
		self.refreshBufferBatch()
	end
	--[[ 
	self.fixtures.main = love.physics.newFixture(love.physics.newBody(  map.world, self.x, self.y, "dynamic"), love.physics.newRectangleShape(60,16), 1)
	self.fixtures.main:setGroupIndex( 1 )
	self.fixtures.main:setCategory( 1 )
	self.fixtures.main:setMask( 2 )
	self.fixtures.main:setUserData( self.bodyUserdata )
	self.fixtures.main:setRestitution( 0 )
	self.fixtures.main:getBody():setFixedRotation( true )
	self.fixtures.main:getBody():setLinearDamping( 1 )
	self.fixtures.main:getBody():setMass( 1 )
	self.fixtures.main:getBody():setInertia( 1 )
	self.fixtures.main:getBody():setGravityScale( 9 )
	self.fixtures.main:getBody():setBullet( true )
	]]

	function self.update( dt )
		self.x = x
		self.y = y
		self.z = z

	end
	
	function self.gamepadpressed( button )
		if button == "a" then
			self.beginJump()
		end
		if button == "y" then
			self.toggleWeapon()
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

	--	table.insert( self.bufferBatch.data, spritePlatform )
	end


	function self.updatePosition(xn, yn)		
		x = self.fixtures.main:getBody():getX()
		y = self.fixtures.main:getBody():getY()
		r = self.fixtures.main:getBody():getAngle()

		--spritePlatform.x = x
		--spritePlatform.y = y
		--spritePlatform.z = 0
		--spritePlatform.r = r

		self.bufferBatch.x = x
		self.bufferBatch.y = y
		self.bufferBatch.z = 0
		self.bufferBatch.r = r
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