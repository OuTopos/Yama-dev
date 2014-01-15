	function self.maps.new(path)

		if love.filesystem.isFile(yama.paths.capsule .. "/maps/" .. path .. ".lua") then
			-- DEBUG
			local debug = {}
			debug.start_time = os.clock()
			debug.tilesetcount = 0
			debug.tilelayercount = 0
			debug.tilecount = 0
			debug.vertexcount = 0



			local map = require(yama.paths.capsule .. "/maps/" .. path)




			-- Load tilesets
			local function loadTileset()
				for i,tileset in ipairs(map.tilesets) do
					tileset.image = string.match(tileset.image, "../../images/(.*).png") or string.match(tileset.image, "../images/(.*).png") 
					local pad = false
					if tileset.properties.pad == "true" then
						pad = true
					end
					yama.assets.loadTileset(tileset.name, tileset.image, tileset.tilewidth, tileset.tileheight, tileset.spacing, tileset.margin, pad)
				end
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

			function self.mergeMeshdata()
				-- body
			end

			local function createMeshes()
				local bobby = self.newEntity("mesh", {0, 0, 0})

				for depth, v in pairs(self.meshes) do
					local batch = yama.buffers.newBatch(0, 0, depth)
					for image, meshdata in pairs(v) do
						meshdata.mesh = love.graphics.newMesh(meshdata.vertices, image)
						meshdata.mesh:setVertexMap(meshdata.vertexmap)
						meshdata.mesh:setDrawMode("triangles")

						table.insert(batch.data, yama.assets.newDrawable(meshdata.mesh, 0, 0, depth))
						--for i = 1, #meshdata.tiles do
							--print(meshdata.tiles[i][1], meshdata.tiles[i][2], meshdata.tiles[i][3], meshdata.tiles[i][4])
						--	self.addToGrid(batch, meshdata.tiles[i][1], meshdata.tiles[i][2], meshdata.tiles[i][1]+meshdata.tiles[i][3], meshdata.tiles[i][2]+meshdata.tiles[i][4])
						--end

						debug.vertexcount = debug.vertexcount + #meshdata.vertices
					end

					table.insert(bobby.batches, batch)
					print("okej")
				end
			end

			function self.addMeshesToBuffer(vp)
				--for depth, v in pairs(self.meshes) do
				--	for image, meshdata in pairs(v) do
				--		vp.addToBuffer(meshdata.bufferobject)
				--	end
				--end
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
				i = #map.tilesets
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


		local function loadLayers()
			self.tiles = {}
			--self.spritebatches = {}

			self.spawns = {}
			self.patrols = {}


			-- Itirate over.
			debug.timeA1 = os.clock()
			for i = 1, #map.layers do

				local layer = map.layers[i]

				if layer.type == "tilelayer" then
					

					-- TILE LAYERS
					for i, gid in ipairs(layer.data) do
						if gid > 0 then
							local x, y = self.index2xy(i)
							local z = tonumber(layer.properties.z) or 0
							x, y, z = self.getSpritePosition(x, y, z)
							self.addToMeshes(x, y + map.tileheight, z, gid)

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
								z = z * map.tileheight
								self.addToMeshes(object.x, object.y, z, object.gid)

								debug.tilecount = debug.tilecount + 1
								
							elseif object.type and object.type ~= "" then
								object.z = tonumber(object.properties.z) or 1
								object.z = object.z * map.tileheight
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
							spawn.z = spawn.z * map.tileheight
							self.spawns[spawn.name] = spawn
						end
					end


				end
			end
		end



			-- Actual loading
			loadTileset()
			loadLayers()

			map.layercount = #map.layers

			debug.timeA2 = os.clock()

			createMeshes()
			debug.timeA3 = os.clock()






			self.maps.list[path] = map

			debug.end_time = os.clock()
			debug.load_time = debug.end_time - debug.start_time
			map.debug = debug
			return true
		end
	end