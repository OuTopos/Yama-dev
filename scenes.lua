local scenes = {}
scenes.list = {}

function scenes.new()
	local self = {}

	-- CALLBACKS
	self.callbacks = {}

	-- LOCATIONS & PATHS 
	self.locations = {}
	self.paths = {}

	--BOUNDING VOLUME
	self.boundingbox = {}
	self.boundingbox.x = 0
	self.boundingbox.y = 0
	self.boundingbox.width = 0
	self.boundingbox.height = 0

	-- VIEWPORTS
	self.viewports = {}

	function self.connectViewport(vp)
		-- Set the sort mode on the viewport.
		vp.setDepthMode(self.depthmode)

		-- Set camera boundaries for the viewport.
		if self.boundaries == "false" then
			vp.boundaries.x = 0
			vp.boundaries.x = 0
			vp.boundaries.width = 0
			vp.boundaries.height = 0
		else
			vp.boundaries.x = self.boundingbox.x
			vp.boundaries.x = self.boundingbox.y
			vp.boundaries.width = self.boundingbox.width --map.width * map.tilewidth
			vp.boundaries.height = self.boundingbox.height --map.height * map.tileheight
		end

		-- Insert the viewport in the viewports table.
		table.insert(self.viewports, vp)
	end

	function self.disconnectViewport(vp)
		for i = #self.viewports, 1, -1 do
			if self.viewports[i] == vp then
				table.remove(self.viewports, i)
			end
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
					vp = nil
				end
			end
			entity = nil
		end
	end

	function self.newEntity(enitytype, position, properties)
		local x, y, z = 0, 0, 0
		if type(position) == "string" then
			if self.locations[position] then
				x = self.locations[position].x
				y = self.locations[position].y
				z = self.locations[position].z
			end
		elseif type(position) == "table" then
			x = tonumber(position[1]) or 0
			y = tonumber(position[2]) or 0
			z = tonumber(position[3]) or 0
		end
		local entity = yama.entities[enitytype].new(self, x, y, z)
		if entity.initialize then
			entity.initialize(properties)
		end
		table.insert(self.entities.list, entity)
		return entity
	end

	function self.spawn(enitytype, spawn, data)
		if self.spawns[spawn] then
			local entity = yama.entities[enitytype].new(self, self.spawns[spawn].x, self.spawns[spawn].y, self.spawns[spawn].z)
			if entity.initialize then
				entity.initialize(data)
			end
			table.insert(self.entities.list, entity)	
			return entity
		else
			print("Spawn ["..spawn.."] not found. Nothing spawned.")
			return nil
		end
	end

	-- PHYSICS
	function self.enablePhysics()

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
					end
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
		self.world:setCallbacks(self.callbacks.beginContact, self.callbacks.endContact, self.callbacks.preSolve, self.callbacks.postSolve)
	end

	-- For creating physics fixture, body and shape from a Tile object.
	function self.createFixture(object, bodyType)
		if self.world then
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
		else
			return nil
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

	-- MAPS - For loading Tiled maps
	self.maps = {}
	self.maps.list = {}

	function self.loadMap(path, offset)
		--if self.maps.list[path] then
		--	info(path .. " already loaded.")
		--else
			--if self.maps.new(path) then
				--[[
				info("Successfully loaded map \"" .. path .. "\" in " .. self.maps.list[path].debug.load_time .. " seconds.")
				print("Pre stuff " .. self.maps.list[path].debug.pre)
				print("loadTilesets() " .. self.maps.list[path].debug.loadTilesets)
				print("loadLayers() " .. self.maps.list[path].debug.loadLayers)
				print("createMeshes() " .. self.maps.list[path].debug.createMeshes)
				print("post stuff " .. self.maps.list[path].debug.post)
				print("sum: " .. self.maps.list[path].debug.pre + self.maps.list[path].debug.loadTilesets + self.maps.list[path].debug.loadLayers + self.maps.list[path].debug.createMeshes + self.maps.list[path].debug.post)

				--info(self.maps.list[path].debug.tilecount .. " tiles, " .. #self.maps.list[path].bufferbatches .. " meshes.")
				--]]
			--end
		--end

		--return self.maps.list[path]
		self.maps.new(path)
	end

	function self.maps.new(path)

		if love.filesystem.isFile(yama.paths.capsule .. "/maps/" .. path .. ".lua") then
			
			-- DEBUG
			local debug = {}
			debug.start_time = os.clock()
			debug.tilesetcount = 0
			debug.tilelayercount = 0
			debug.tilecount = 0
			debug.vertexcount = 0


			-- MESHES
			local meshData = {}

			local function addToMeshes(x, y, z, gid)
				if gid then
					if gid > 0 then
						local tileset = yama.assets.tilesets[self.getTileset(gid).name]
						local tile = tileset.vertices[self.getTileKey(gid)]
						local depth = self.getDepth[self.depthmode](x, y, z)
						local image = tileset.image

						if not meshData[depth] then
							meshData[depth] = {}
						end

						if not meshData[depth][image] then
							meshData[depth][image] = {}
							meshData[depth][image].vertexmap = {}
							meshData[depth][image].vertices = {}
							meshData[depth][image].tiles = {}
						end

						table.insert(meshData[depth][image].vertexmap, #meshData[depth][image].vertices + 1)
						table.insert(meshData[depth][image].vertexmap, #meshData[depth][image].vertices + 2)
						table.insert(meshData[depth][image].vertexmap, #meshData[depth][image].vertices + 3)
						table.insert(meshData[depth][image].vertexmap, #meshData[depth][image].vertices + 1)
						table.insert(meshData[depth][image].vertexmap, #meshData[depth][image].vertices + 3)
						table.insert(meshData[depth][image].vertexmap, #meshData[depth][image].vertices + 4)

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

						table.insert(meshData[depth][image].vertices, {x1, y1, u1, v1, r1, g1, b1, a1})
						table.insert(meshData[depth][image].vertices, {x2, y2, u2, v2, r2, g2, b2, a2})
						table.insert(meshData[depth][image].vertices, {x3, y3, u3, v3, r3, g3, b3, a3})
						table.insert(meshData[depth][image].vertices, {x4, y4, u4, v4, r4, g4, b4, a4})

						--meshData[depth][image].tiles =

						--self.addToGrid()
						--table.insert(meshData[depth][image].tiles, {self.getTiles(x1, y1, x2-x1, y3-y1)})

						--print( tiles[1], tiles[2])
						--print(self.getTiles(x1, y1, x2-x1, y3-y1))



						-- have to add to the grid
						tileset = nil
						tile = nil
						depth = nil
						image = nil
					end
				end
			end











			local map = require(yama.paths.capsule .. "/maps/" .. path)

			-- DEPTH
			if map.properties.sortmode then
				self.depthmode = map.properties.sortmode
			else
				self.depthmode = "z"
			end



			-- Load tilesets into the asset handler.
			local function loadTilesets()
				for i,tileset in ipairs(map.tilesets) do
					tileset.image = string.match(tileset.image, "../../images/(.*).png") or string.match(tileset.image, "../images/(.*).png") 
					local pad = false
					if tileset.properties.pad == "true" then
						pad = true
					end
					yama.assets.loadTileset(tileset.name, tileset.image, tileset.tilewidth, tileset.tileheight, tileset.spacing, tileset.margin, pad)
				end
			end

			-- Load layers
			local function loadLayers()
				for i = 1, #map.layers do
					local layer = map.layers[i]

					if layer.type == "tilelayer" then
						
						-- TILE LAYERS
						for i, gid in ipairs(layer.data) do
							if gid > 0 then
								local x, y = self.index2xy(i)
								local z = tonumber(layer.properties.z) or 0
								x, y, z = self.getSpritePosition(x, y, z)
								addToMeshes(x, y + map.tileheight, z, gid)

								debug.tilecount = debug.tilecount + 1
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

								if fixture then
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
								else
									warning("Physics not enabled. No fixture created.")
								end
							end


						elseif layer.properties.type == "entities" then


							-- ENTITIES
							-- Spawning entities.
							for _, object in ipairs(layer.objects) do
								if object.type == "" then
									-- STATIC TILE
									local z = tonumber(object.properties.z) or 1
									z = z * map.tileheight
									addToMeshes(object.x, object.y, z, object.gid)

									debug.tilecount = debug.tilecount + 1

									z = nil
									
								elseif object.type and object.type ~= "" then
									object.z = tonumber(object.properties.z) or 1
									object.z = object.z * map.tileheight
									object.properties.z = nil
									self.spawnXYZ(object.type, object.x + object.width / 2, object.y + object.height / 2, object.z, object)
								end
							end


						elseif layer.properties.type == "paths" then

							-- PATHS
							-- Adding paths to the patrols table.
							for i, object in ipairs(layer.objects) do
								if object.shape == "polyline" then
									local path = {}
									path.name = object.name
									path.type = object.type
									path.properties = object.properties
									path.vertices = {}
									for k, vertex in ipairs(object.polyline) do
										table.insert(path.vertices, {x = object.polyline[k].x+object.x, y = object.polyline[k].y+object.y})
									end
									self.paths[path.name] = path
								end
							end


						elseif layer.properties.type == "portals" then


							-- PORTALS
							-- Creating portal fixtures.
							for i, object in ipairs(layer.objects) do
								local fixture = self.createFixture(object, "static")
								if fixture then
									fixture:setUserData({name = object.name, type = "portal", properties = object.properties})
									fixture:setSensor(true)
								end
							end


						elseif layer.properties.type == "locations" then


							-- LOCATIONS
							-- Adding locations to the location list
							for i, object in ipairs(layer.objects) do
								local location = {}
								location.name = object.name
								location.type = object.type
								location.properties = object.properties

								location.x = object.x + object.width / 2
								location.y = object.y + object.height / 2
								location.z = tonumber(object.properties.z) or 0
								--location.z = spawn.z * map.tileheight
								self.locations[location.name] = location
							end
						end


					end
				end
			end




			local function createMeshes()
				local entity = self.newEntity("mesh", {0, 0, 0})

				for depth, v in pairs(meshData) do
					local batch = yama.buffers.newBatch(0, 0, depth)

					for image, meshdata in pairs(v) do
						local mesh = love.graphics.newMesh(meshdata.vertices, image)
						mesh:setVertexMap(meshdata.vertexmap)
						mesh:setDrawMode("triangles")

						table.insert(batch.data, yama.buffers.newDrawable(mesh, 0, 0, depth))
						--for i = 1, #meshdata.tiles do
							--print(meshdata.tiles[i][1], meshdata.tiles[i][2], meshdata.tiles[i][3], meshdata.tiles[i][4])
						--	self.addToGrid(batch, meshdata.tiles[i][1], meshdata.tiles[i][2], meshdata.tiles[i][1]+meshdata.tiles[i][3], meshdata.tiles[i][2]+meshdata.tiles[i][4])
						--end

						debug.vertexcount = debug.vertexcount + #meshdata.vertices

						mesh = nil
					end

					table.insert(entity.batches, batch)
					batch = nil
				end
				entity = nil
			end

			function self.index2xy(index)
				local x = (index-1) % map.width
				local y = math.floor((index-1) / map.width)
				return x, y
			end

			function self.getSpritePosition(x, y, z)
				-- This function gives you a pixel position from a tile position.
				if map.orientation == "orthogonal" then
					return x * map.tilewidth, y * map.tileheight, z * map.tileheight
				elseif map.orientation == "isometric" then
					x, y = self.translatePosition(x * map.tileheight, y * map.tileheight)
					return x, y, z
				end
			end

			function self.getTileset(gid)
				local i = #map.tilesets
				while map.tilesets[i] and gid < map.tilesets[i].firstgid do
					i = i - 1
				end
				return map.tilesets[i]
			end

			function self.getTileKey(gid)
				local tileset = self.getTileset(gid)
				return gid - (tileset.firstgid - 1)
			end

			function self.getTiles(x, y, width, height)
				x1 = math.floor( x / map.tilewidth)
				x2 = math.ceil( ( x + width ) / map.tilewidth)
				y1 = math.floor( y / map.tileheight )
				y2 = math.ceil( ( y + height ) / map.tileheight )
				return x1, y1, x2-x1, y2-y1
			end


		



			-- Actual loading
			debug.timestamp1 = os.clock()

			loadTilesets()

			debug.timestamp2 = os.clock()

			loadLayers()

			debug.timestamp3 = os.clock()

			createMeshes()

			debug.timestamp4 = os.clock()


			--self.maps.list[path] = map

			--if map.properties == "false" then
				self.boundingbox.x = 0
				self.boundingbox.y = 0
				self.boundingbox.width = map.width * map.tilewidth
				self.boundingbox.height = map.height * map.tileheight
			--end

			debug.end_time = os.clock()
			debug.load_time = debug.end_time - debug.start_time
			debug.pre = debug.timestamp1 - debug.start_time
			debug.loadTilesets = debug.timestamp2 - debug.timestamp1
			debug.loadLayers = debug.timestamp3 - debug.timestamp2
			debug.createMeshes = debug.timestamp4 - debug.timestamp3
			debug.post = debug.end_time - debug.timestamp4
			map.debug = debug
			map = nil

			collectgarbage()
			return true
		end
	end

	function self.updateThread()
		--local err = self.thread:getError()
		--if err then
		--	print("Thread error:\n" .. err)
		--end
		local rand = math.random(1, 1000)
		local v = self.channel:pop()
		if v then
			print(rand, v)
		end
		v = self.channel:pop()
		if v then
			print(rand, v)
		end
	end

	self.maps.queue = {}

	function self.maps.enqueue(mappath)
		local data = {}
		data.mappath = mappath
		data.thread = love.thread.newThread("scenes_maps_load_thread.lua")
		data.channel = love.thread.newChannel()
		table.insert(self.maps.queue, data)

		data.thread:start()
		data.channel:push(mappath)

		local channel = love.thread.getChannel("scenes_maps_load_thread")
		channel:supply(data.channel)
	end

	function self.updateLoad(dt)
		if #self.maps.queue > 0 then
			for k = #self.maps.queue, 1, -1 do
				local channel = self.maps.queue[k].channel

				local value = channel:pop()

				if type(value) == table then
					print("okej det var ett bord")
					if value.meshes then
						for i = 1, value.length do

						end
					end
				elseif value then
					--print("något annat, jaha", type(value), value)
				end

			end
		end
	end


	function self.update(dt)
		-- Update physics world
		if self.world then
			self.world:update(dt)
		end

		-- Update entities.
		self.entities.update(dt)
	end

	table.insert(scenes.list, self)
	return self
end

function scenes.update(dt)
	for k = #scenes.list, 1, -1 do
		scenes.list[k].update(dt)

		-- Make destroy function
	end
end

return scenes