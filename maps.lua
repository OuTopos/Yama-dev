local maps = {}
maps.list = {}

function maps.load(path)
	if maps.list[path] then
		info(path .. " already loaded.")
	else
		if maps.new(path) then
			info(path .. " successfully loaded in " .. maps.list[path].debug.load_time .. " seconds.")
			info(maps.list[path].debug.tilecount .. " tiles, " .. #maps.list[path].bufferbatches .. " meshes.")
		end
	end

	return maps.list[path]
end

function maps.new(path)
	if love.filesystem.isFile(yama.paths.capsule .. "/maps/" .. path .. ".lua") then
		local self = {}

		-- DEBUG
		self.debug = {}
		self.debug.start_time = os.clock()
		self.debug.tilesetcount = 0
		self.debug.tilelayercount = 0
		self.debug.tilecount = 0
		self.debug.vertexcount = 0

		-- LOADING MAP DATA FILE
		self.data = require(yama.paths.capsule .. "/maps/" .. path)

		-- PHYSICS
		function self.loadPhysics()
			if self.data.properties.physics ~= "false" then
				self.data.properties.xg = self.data.properties.xg or 0
				self.data.properties.yg = self.data.properties.yg or 0
				self.data.properties.meter = self.data.properties.meter or self.data.tileheight

				self.callbacks = {}
				function self.callbacks.beginContact(a, b, contact)
					if a:getUserData() then
						if a:getUserData().callbacks then
							if a:getUserData().callbacks.beginContact then
								a:getUserData().callbacks.beginContact(a, b, contact)
							end
						end
					end
					if b:getUserData() then
						if b:getUserData().callbacks then
							if b:getUserData().callbacks.beginContact then
								b:getUserData().callbacks.beginContact(b, a, contact)
							end
						end
					end
				end

				function self.callbacks.endContact(a, b, contact)
					if a:getUserData() then
						if a:getUserData().callbacks then
							if a:getUserData().callbacks.endContact then
								a:getUserData().callbacks.endContact(a, b, contact)
							end
						end
					end
					if b:getUserData() then
						if b:getUserData().callbacks then
							if b:getUserData().callbacks.endContact then
								b:getUserData().callbacks.endContact(b, a, contact)
							end§
						end
					end
				end

				function self.callbacks.preSolve(a, b, contact)
					if a:getUserData() then
						if a:getUserData().callbacks then
							if a:getUserData().callbacks.preSolve then
								a:getUserData().callbacks.preSolve(a, b, contact)
							end
						end
					end
					if b:getUserData() then
						if b:getUserData().callbacks then
							if b:getUserData().callbacks.preSolve then
								b:getUserData().callbacks.preSolve(b, a, contact)
							end
						end
					end
				end

				function self.callbacks.postSolve(a, b, contact)
					if a:getUserData() then
						if a:getUserData().callbacks then
							if a:getUserData().callbacks.postSolve then
								a:getUserData().callbacks.postSolve(a, b, contact)
							end
						end
					end
					if b:getUserData() then
						if b:getUserData().callbacks then
							if b:getUserData().callbacks.postSolve then
								b:getUserData().callbacks.postSolve(b, a, contact)
							end
						end
					end
				end

				self.world = love.physics.newWorld()
				self.world:setGravity(self.data.properties.xg * self.data.properties.meter, self.data.properties.yg * self.data.properties.meter)
				self.world:setCallbacks(self.callbacks.beginContact, self.callbacks.endContact, self.callbacks.preSolve, self.callbacks.postSolve)
				love.physics.setMeter(self.data.properties.meter)
			end
		end

		-- ENTITIES
		self.entities = {}
		self.entities.list = {}

		function self.entities.update(dt)
			for key=#self.entities.list, 1, -1 do
				local entity = self.entities.list[key]

				if entity.destroyed then
					table.remove(self.entities.list, key)
				else
					entity.update(dt)
					for i=1, #self.viewports do
						local vp = self.viewports[i]
						if vp.isEntityInside(entity) then
							entity.addToBuffer(vp)
						end
					end
				end
			end
		end

		function self.spawn(type, spawn, properties)
			if self.spawns[spawn] then
				if yama.entities[type] then
					local entity = yama.entities[type].new(self, self.spawns[spawn].x, self.spawns[spawn].y, self.spawns[spawn].z)
					if entity.initialize then
						entity.initialize(properties)
					end
					table.insert(self.entities.list, entity)	
					return entity
				else
					print("ERROR: MAPS -> Entity type " .. type .. " not found. Nothing spawned.")
					return nil
				end
			else
				print("ERROR: MAPS -> Spawn location " .. spawn .. " not found. Nothing spawned.")
				return nil
			end
		end

		function self.spawnXYZ(type, x, y, z, properties)
			if yama.entities[type] then
				local entity = yama.entities[type].new(self, x, y, z)
				if entity.initialize then
					entity.initialize(properties)
				end
				table.insert(self.entities.list, entity)	
				return entity
			else
				print("ERROR: MAPS -> Entity type " .. type .. " not found. Nothing spawned.")
				return nil
			end
		end


		-- VIEWPORTS
		self.viewports = {}

		function self.connectViewport(vp)
			-- Set the map sort mode on the viewport.
			vp.setDepthMode(self.depthmode)
			print("depthmode set to "..self.depthmode)

			-- Set camera boundaries for the viewport.
			if self.data.properties.boundaries == "false" then
				vp.boundaries.x = 0
				vp.boundaries.x = 0
				vp.boundaries.width = 0
				vp.boundaries.height = 0
			else
				vp.boundaries.x = 0
				vp.boundaries.x = 0
				vp.boundaries.width = self.data.width * self.data.tilewidth
				vp.boundaries.height = self.data.height * self.data.tileheight
			end

			-- Insert the viewport in the viewports table.
			table.insert(self.viewports, vp)
		end

		function self.disconnectViewport(vp)
			for i=#self.viewports, 1, -1 do
				if self.viewports[i] == vp then
					table.remove(self.viewports, i)
				end
			end
		end

		-- MISC
		self.cooldown = 0

		-- LOAD - Tilesets
		function self.loadTilesets()
			for i,tileset in ipairs(self.data.tilesets) do
				tileset.image = string.match(tileset.image, "../../images/(.*).png") or string.match(tileset.image, "../images/(.*).png") 
				local pad = false
				if tileset.properties.pad == "true" then
					pad = true
				end
				yama.assets.loadTileset(tileset.name, tileset.image, tileset.tilewidth, tileset.tileheight, tileset.spacing, tileset.margin, pad)
			end
		end

		-- DEPTH
		self.depthmode = "yz"
		self.getDepth = {}

		function self.getDepth.z(x, y, z)
			return z
		end
		function self.getDepth.y(x, y, z)
			return y
		end
		function self.getDepth.yz(x, y, z)
			return y + z
		end

		-- MESHES
		self.meshes = {}
		self.bufferbatches = {}


		function self.addToMeshes(x, y, z, gid)
			if gid then
				if gid > 0 then
					local tileset = yama.assets.tilesets[self.getTileset(gid).name]
					local tile = tileset.vertices[self.getTileKey(gid)]
					local depth = self.getDepth[self.depthmode](x, y, z)
					local image = tileset.image

					if not self.meshes[depth] then
						self.meshes[depth] = {}
					end

					if not self.meshes[depth][image] then
						self.meshes[depth][image] = {}
						self.meshes[depth][image].vertexmap = {}
						self.meshes[depth][image].vertices = {}
						self.meshes[depth][image].tiles = {}
					end

					table.insert(self.meshes[depth][image].vertexmap, #self.meshes[depth][image].vertices + 1)
					table.insert(self.meshes[depth][image].vertexmap, #self.meshes[depth][image].vertices + 2)
					table.insert(self.meshes[depth][image].vertexmap, #self.meshes[depth][image].vertices + 3)
					table.insert(self.meshes[depth][image].vertexmap, #self.meshes[depth][image].vertices + 1)
					table.insert(self.meshes[depth][image].vertexmap, #self.meshes[depth][image].vertices + 3)
					table.insert(self.meshes[depth][image].vertexmap, #self.meshes[depth][image].vertices + 4)

					local x1, y1, u1, v1, r1, g1, b1, a1 = tile[1][1], tile[1][2], tile[1][3], tile[1][4], tile[1][5], tile[1][6], tile[1][7], tile[1][8]
					local x2, y2, u2, v2, r2, g2, b2, a2 = tile[2][1], tile[2][2], tile[2][3], tile[2][4], tile[2][5], tile[2][6], tile[2][7], tile[2][8]
					local x3, y3, u3, v3, r3, g3, b3, a3 = tile[3][1], tile[3][2], tile[3][3], tile[3][4], tile[3][5], tile[3][6], tile[3][7], tile[3][8]
					local x4, y4, u4, v4, r4, g4, b4, a4 = tile[4][1], tile[4][2], tile[4][3], tile[4][4], tile[4][5], tile[4][6], tile[4][7], tile[4][8]

					x1 = x1 + x
					y1 = y1 + y
					x2 = x2 + x
					y2 = y2 + y
					x3 = x3 + x
					y3 = y3 + y
					x4 = x4 + x
					y4 = y4 + y

					table.insert(self.meshes[depth][image].vertices, {x1, y1, u1, v1, r1, g1, b1, a1})
					table.insert(self.meshes[depth][image].vertices, {x2, y2, u2, v2, r2, g2, b2, a2})
					table.insert(self.meshes[depth][image].vertices, {x3, y3, u3, v3, r3, g3, b3, a3})
					table.insert(self.meshes[depth][image].vertices, {x4, y4, u4, v4, r4, g4, b4, a4})

					--self.meshes[depth][image].tiles =

					--self.addToGrid()
					table.insert(self.meshes[depth][image].tiles, {self.getTiles(x1, y1, x2-x1, y3-y1)})

					--print( tiles[1], tiles[2])
					--print(self.getTiles(x1, y1, x2-x1, y3-y1))



					-- have to add to the grid
				end
			end
		end

		function self.generateMeshes()
			for depth, v in pairs(self.meshes) do
				local batch = yama.buffers.newBatch(0, 0, depth)
				for image, meshdata in pairs(v) do
					meshdata.mesh = love.graphics.newMesh(meshdata.vertices, image)
					meshdata.mesh:setVertexMap(meshdata.vertexmap)
					meshdata.mesh:setDrawMode("triangles")

					table.insert(batch.data, yama.buffers.newDrawable(meshdata.mesh, 0, 0, depth))
					--for i = 1, #meshdata.tiles do
						--print(meshdata.tiles[i][1], meshdata.tiles[i][2], meshdata.tiles[i][3], meshdata.tiles[i][4])
					--	self.addToGrid(batch, meshdata.tiles[i][1], meshdata.tiles[i][2], meshdata.tiles[i][1]+meshdata.tiles[i][3], meshdata.tiles[i][2]+meshdata.tiles[i][4])
					--end

					self.debug.vertexcount = self.debug.vertexcount + #meshdata.vertices
				end

				table.insert(self.bufferbatches, batch)
			end
		end

		function self.addMeshesToBuffer(vp)
			--for depth, v in pairs(self.meshes) do
			--	for image, meshdata in pairs(v) do
			--		vp.addToBuffer(meshdata.bufferobject)
			--	end
			--end
		end


		-- LOAD - Layers
		function self.loadLayers()
			self.tiles = {}
			--self.spritebatches = {}

			self.spawns = {}
			self.patrols = {}


			-- Itirate over.
			for i = 1, #self.data.layers do

				local layer = self.data.layers[i]

				if layer.type == "tilelayer" then
					

					-- TILE LAYERS
					for i, gid in ipairs(layer.data) do
						if gid > 0 then
							local x, y = self.index2xy(i)
							local z = tonumber(layer.properties.z) or 0
							x, y, z = self.getSpritePosition(x, y, z)
							self.addToMeshes(x, y + self.data.tileheight, z, gid)

							self.debug.tilecount = self.debug.tilecount + 1
						end
					end


				elseif layer.type == "objectgroup" then


					-- OBJECT GROUPS
					if layer.properties.type == "collision" then


						--COLLISION
						-- Block add to physics.
						for i, object in ipairs(layer.objects) do
							-- Creating a fixture from the object.
							local fixture = self.createFixture(object, "static")

							-- And setting the userdata from the object.
							fixture:setUserData({name = object.name, type = object.type, properties = object.properties})

							-- Setting filter data from object properties. (category, mask, groupindex)
							if object.properties.category then
								local category = {}
								for x in string.gmatch(object.properties.category, "%P+") do
									x = tonumber(string.match(x, "%S+"))
									if x then
										table.insert(category, x)
									end
								end
								fixture:setCategory(unpack(category))
							end
							if object.properties.mask then
								local mask = {}
								for x in string.gmatch(object.properties.mask, "%P+") do
									x = tonumber(string.match(x, "%S+"))
									if x then
										table.insert(mask, x)
									end
								end
								fixture:setMask(unpack(mask))
							end
							if object.properties.groupindex then
								fixture:setGroupIndex(tonumber(object.properties.groupindex))
							end
						end


					elseif layer.properties.type == "entities" then


						-- ENTITIES
						-- Spawning entities.
						for i, object in ipairs(layer.objects) do
							if object.type == "" then
								-- STATIC TILE
								local z = tonumber(object.properties.z) or 1
								z = z * self.data.tileheight
								self.addToMeshes(object.x, object.y, z, object.gid)

								self.debug.tilecount = self.debug.tilecount + 1
								
							elseif object.type and object.type ~= "" then
								object.z = tonumber(object.properties.z) or 1
								object.z = object.z * self.data.tileheight
								object.properties.z = nil
								self.spawnXYZ(object.type, object.x + object.width / 2, object.y + object.height / 2, object.z, object)
							end
						end


					elseif layer.properties.type == "patrols" then


						-- PATROLS
						-- Adding patrols to the patrols table.
						for i, object in ipairs(layer.objects) do
							if object.shape == "polyline" then
								local patrol = {}
								patrol.name = object.name
								patrol.type = object.type
								patrol.properties = object.properties
								patrol.points = {}
								for k, vertice in ipairs(object.polyline) do
									table.insert(patrol.points, {x = object.polyline[k].x+object.x, y = object.polyline[k].y+object.y})
								end
								self.patrols[patrol.name] = patrol
							end
						end


					elseif layer.properties.type == "portals" then


						-- PORTALS
						-- Creating portal fixtures.
						for i, object in ipairs(layer.objects) do
							local fixture = self.createFixture(object, static)
							fixture:setUserData({name = object.name, type = "portal", properties = object.properties})
							fixture:setSensor(true)
						end


					elseif layer.properties.type == "spawns" then


						-- SPAWNS
						-- Adding spawns to the spawns list
						for i, object in ipairs(layer.objects) do
							local spawn = {}
							spawn.name = object.name
							spawn.type = object.type
							spawn.properties = object.properties

							spawn.x = object.x + object.width / 2
							spawn.y = object.y + object.height / 2
							spawn.z = tonumber(object.properties.z) or 1
							spawn.z = spawn.z * self.data.tileheight
							self.spawns[spawn.name] = spawn
						end
					end


				end
			end
			self.data.layercount = #self.data.layers

		end

		function self.load()
			-- PROPERTIES
			if self.data.properties.sortmode then
				self.depthmode = self.data.properties.sortmode
			else
				self.depthmode = "z"
			end

			self.sx = tonumber(self.data.properties.sx) or 1
			self.sy = tonumber(self.data.properties.sy) or 1

			self.loadPhysics()
			self.loadTilesets()
			self.loadLayers()
			self.generateMeshes()
			
			-- Create Boundaries
			if self.data.properties.boundaries ~= "false" then
				self.data.boundaries = love.physics.newFixture(love.physics.newBody(self.world, 0, 0, "static"), love.physics.newChainShape(true, -1, -1, self.data.width * self.data.tilewidth + 1, -1, self.data.width * self.data.tilewidth + 1, self.data.height * self.data.tileheight + 1, -1, self.data.height * self.data.tileheight))
			end
		end

		function self.getTiles(x, y, width, height)
			x1 = math.floor( x / self.data.tilewidth)
			x2 = math.ceil( ( x + width ) / self.data.tilewidth)
			y1 = math.floor( y / self.data.tileheight )
			y2 = math.ceil( ( y + height ) / self.data.tileheight )
			return x1, y1, x2-x1, y2-y1
		end

		function self.getQuad(gid)
			local tileset = self.getTileset(gid)
			local quad = yama.assets.tilesets[tileset.name].tiles[gid - (tileset.firstgid - 1)]
			return quad
		end

		function self.getTileKey(gid)
			local tileset = self.getTileset(gid)
			return gid - (tileset.firstgid - 1)
		end

		function self.getTileSprite(gid, x, y, z)
			x, y, z = self.getSpritePosition(x, y, z)
			local sprite, width, height = self.getSprite(gid, x, y, z, true)
			sprite.y = sprite.y + self.data.tileheight
			sprite.oy = height
			return sprite
		end

		function self.getSprite(gid, x, y, z, returnsize)
			local tileset = self.getTileset(gid)
			local image = yama.assets.tilesets[tileset.name].image
			local quad = yama.assets.tilesets[tileset.name].tiles[gid - (tileset.firstgid - 1)]
			local sprite = yama.buffers.newSprite(image, quad, x, y, z)
			if returnsize then
				return sprite, tileset.tilewidth, tileset.tileheight
			else
				return sprite
			end

		end
		function self.getTileset(gid)
			i = #self.data.tilesets
			while self.data.tilesets[i] and gid < self.data.tilesets[i].firstgid do
				i = i - 1
			end
			return self.data.tilesets[i]
		end

		function self.defog(x, y, radius)
			
		end

		function self.update(dt)

			if #self.viewports > 0 then
				self.cooldown = 10
			end
			
			if self.cooldown > 0 then
				self.cooldown = self.cooldown - dt

				-- Update physics world
				self.world:update(dt)

				-- Update entities.
				self.entities.update(dt)

				-- Update all connected viewports
				for i=1, #self.viewports do
					self.viewports[i].update(dt)

					for ii = 1, #self.bufferbatches do
						self.viewports[i].addToBuffer(self.bufferbatches[ii])
					end
				end
			end
		end

		function self.draw()
			for i=1, #self.viewports do
				-- Draw the viewport.
				self.viewports[i].draw()
			end
		end

		function self.xy2index(x, y)
			return y*self.data.width+x+1
		end

		function self.index2xy(index)
			local x = (index-1) % self.data.width
			local y = math.floor((index-1) / self.data.width)
			return x, y
		end

		function self.getSpritePosition(x, y, z)
			-- This function gives you a pixel position from a tile position.
			if self.data.orientation == "orthogonal" then
				return x * self.data.tilewidth, y * self.data.tileheight, z * self.data.tileheight
			elseif self.data.orientation == "isometric" then
				x, y = self.translatePosition(x * self.data.tileheight, y * self.data.tileheight)
				return x, y, z
			end
		end

		function self.translatePosition(x, y)
			if self.data.orientation == "orthogonal" then
				return x, y
			elseif self.data.orientation == "isometric" then
				return x - y, (y + x) * self.data.tileheight / self.data.tilewidth
			end
		end

		function self.getXYZ(x, y, z)
			if self.data.orientation == "orthogonal" then
				return self.getX(x), self.getY(y), self.getZ(z)
			elseif self.data.orientation == "isometric" then
				nx = (x - y) * (self.data.tilewidth / 2)
				ny = (y + x) * (self.data.tileheight / 2)
				nz = z

				return nx, ny, nz
			end
		end
		--[[
		self.getPosition = {}

		function self.getPosition.orthogonal(x, y, z)
			return self.getX(x), self.getY(y), self.getZ(z)
			--if self.data.orientation == "orthogonal" then
			--	nx = 
			--	ny = 
			--	nz = 
			--elseif self.data.orientation == "isometric" then
			--	nx = (x - y) * (self.data.tilewidth / 2)
			--	ny = (y + x) * (self.data.tileheight / 2)
			--	nz = z
			--end

			--return nx, ny, nz
		end

		function self.getPosition.isometric(x, y, z)
			nx = (x - y) * (self.data.tilewidth / 2)
			ny = (y + x) * (self.data.tileheight / 2)
			nz = z

			return nx, ny, nz

		end

		function self.getX(x)
			return x * self.data.tilewidth
		end
		function self.getY(y)
			return y * self.data.tileheight
		end
		function self.getZ(z)
			return z * self.data.tileheight
		end
		--]]

		function self.index2X(x)
			return x * self.data.tilewidth
		end
		function self.index2Y(y)
			return y * self.data.tileheight
		end





		function self.shape(object)
			if object.shape == "rectangle" then
				--Rectangle or Tile
				if object.gid then
					--Tile
					local body = love.physics.newBody(self.world, object.x, object.y-self.data.tileheight, "static")
					local shape = love.physics.newRectangleShape(self.data.tilewidth/2, self.data.tileheight/2, self.data.tilewidth, self.data.tileheight)
					return love.physics.newFixture(body, shape)
				else
					--Rectangle
					local body = love.physics.newBody(self.world, object.x, object.y, "static")
					local shape = love.physics.newRectangleShape(object.width/2, object.height/2, object.width, object.height)
					return love.physics.newFixture(body, shape)
				end
			elseif object.shape == "ellipse" then
				--Ellipse
				local body = love.physics.newBody(self.world, object.x+object.width/2, object.y+object.height/2, "static")
				local shape = love.physics.newCircleShape( (object.width + object.height) / 4 )
				return love.physics.newFixture(body, shape)
			elseif object.shape == "polygon" then
				--Polygon
				local vertices = {}
				for i,vertix in ipairs(object.polygon) do
					table.insert(vertices, vertix.x)
					table.insert(vertices, vertix.y)
				end
				local body = love.physics.newBody(self.world, object.x, object.y, "static")
				local shape = love.physics.newPolygonShape(unpack(vertices))
				return love.physics.newFixture(body, shape)
			elseif object.shape == "polyline" then
				--Polyline
				local vertices = {}
				for i,vertix in ipairs(object.polyline) do
					table.insert(vertices, vertix.x)
					table.insert(vertices, vertix.y)
				end
				local body = love.physics.newBody(self.world, object.x, object.y, "static")
				local shape = love.physics.newChainShape(false, unpack(vertices))
				return love.physics.newFixture(body, shape)
			else
				return nil
			end
		end

		function self.createFixture(object, bodyType)
			if object.shape == "rectangle" then
				--Rectangle or Tile
				if object.gid then
					--Tile
					local body = love.physics.newBody(self.world, object.x, object.y-self.data.tileheight, bodyType)
					local shape = love.physics.newRectangleShape(self.data.tilewidth/2, self.data.tileheight/2, self.data.tilewidth, self.data.tileheight)
					return love.physics.newFixture(body, shape)
				else
					--Rectangle
					local body = love.physics.newBody(self.world, object.x, object.y, bodyType)
					local shape = love.physics.newRectangleShape(object.width/2, object.height/2, object.width, object.height)
					return love.physics.newFixture(body, shape)
				end
			elseif object.shape == "ellipse" then
				--Ellipse
				local body = love.physics.newBody(self.world, object.x+object.width/2, object.y+object.height/2, bodyType)
				local shape = love.physics.newCircleShape( (object.width + object.height) / 4 )
				return love.physics.newFixture(body, shape)
			elseif object.shape == "polygon" then
				--Polygon
				local vertices = {}
				for i,vertix in ipairs(object.polygon) do
					table.insert(vertices, vertix.x)
					table.insert(vertices, vertix.y)
				end
				local body = love.physics.newBody(self.world, object.x, object.y, bodyType)
				local shape = love.physics.newPolygonShape(unpack(vertices))
				return love.physics.newFixture(body, shape)
			elseif object.shape == "polyline" then
				--Polyline
				local vertices = {}
				for i,vertix in ipairs(object.polyline) do
					table.insert(vertices, vertix.x)
					table.insert(vertices, vertix.y)
				end
				local body = love.physics.newBody(self.world, object.x, object.y, bodyType)
				local shape = love.physics.newChainShape(false, unpack(vertices))
				return love.physics.newFixture(body, shape)
			else
				return nil
			end
		end

		-- function self.getTilewidth()
		-- 	return self.data.tilewidth
		-- end

		-- function self.getTileheight()
		-- 	return self.data.tileheight
		-- end

		-- function self.getData()
		-- 	return self.data
		-- end

		-- function self.getWorld()
		-- 	return self.world
		-- end

		-- function self.getSwarm()
		-- 	return self.swarm
		-- end

		-- function self.getViewports()
		-- 	return self.viewports
		-- end

		self.load()

		maps.list[path] = self

		self.debug.end_time = os.clock()
		self.debug.load_time = self.debug.end_time - self.debug.start_time
		return self
	else
		error(path .. " not found. Map not loaded." )
	end
end

function maps.update(dt)
	for key, map in pairs(maps.list) do
		map.update(dt)
	end
end

function maps.draw()
	for key, map in pairs(maps.list) do
		map.draw()
	end
end

return maps