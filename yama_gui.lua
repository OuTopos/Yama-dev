local gui = {}
gui.list = {}

function gui.load()
	--[[
	imagefont2 = love.graphics.newImage("images/imagefont2.png")
	font2 = love.graphics.newImageFont(imagefont2,
	" abcdefghijklmnopqrstuvwxyz" ..
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
	"123456789.,!?-+/():;%&`'*#=[]\"")
	--]]
	--imagefont = love.graphics.newImage("images/font.png")


	
	--gui.images = {}
	--gui.images.hp = love.graphics.newImage("images/gui/bar_hp_mp.png")
	--gui.images.test = love.graphics.newImage("images/gui/confirm_bg.png")


	--table.insert(gui.list, gui.newHealthBar())
end
function gui.draw(vp)
	local left = vp.x
	local right = vp.x + vp.width
	local top = vp.y
	local bottom = vp.y + vp.height
	
	--local camera = vp.getCamera()
	--local map = vp.getMap()
	--local buffer = vp.getBuffer()
	--local entities = map.getEntities()
	--local world = map.getWorld()


	--yama.assets.loadImage("gui/healthbar")
	--love.graphics.draw(yama.assets.loadImage("debug"), left,  top, 0, 1, 1)
	--love.graphics.draw(yama.assets.tilesets["body"].tiles[3], right-256,  top+256, 0, 1, 1)
	

	--love.graphics.setColor(0, 0, 0, 255)
	--love.graphics.print("FPS: "..love.timer.getFPS(), camera.x + camera.width - 39, camera.y + 3)
	--love.graphics.print("Skeleton: HELLO", camera.x + 12 + 1, camera.y + camera.height - 55 +1)
	--love.graphics.print("Princess: Aahh!", camera.x + 12 + 1, camera.y + camera.height - 45 +1)

	--love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.print("FPS: "..love.timer.getFPS(), camera.x + camera.width - 39, camera.y + 2)
	--love.graphics.print("Skeleton: HELLO", camera.x + 12, camera.y + camera.height - 55)
	--love.graphics.print("Princess: Aahh!", camera.x + 12, camera.y + camera.height - 45)

	if yama.v.paused then
		love.graphics.setColor(0, 0, 0, 234)
		love.graphics.rectangle("fill", left, top, vp.width, vp.height)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("- PAUSE -", left + vp.width/2 - 20, top + vp.height/2 - 4)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("- PAUSE -", left + vp.width/2 - 21, top + vp.height/2 - 5)
	end

	--gui.list[1].draw(vp)
end



-- OBJECTS

function gui.newHealthBar()
	local self = {}

	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0

	self.background = ""


	self.hpmax = 1000
	self.hp = 100

	local tileset = "LPC/body/male/light"
	images.quads.add(tileset, self.width, self.height)
	local sprite = yama.buffers.newSprite(images.load(tileset), images.quads.data[tileset][131], self.x + self.aox, self.y + self.aoy, self.z, self.r, self.sx, self.sy, self.ox, self.oy)



	local background = yama.assets.image("gui/healthbar"), self.x, self.y, 10000

	function self.hide()

	end

	function self.show()
		
	end

	function self.draw()
		love.graphics.draw(yama.assets.image("gui/healthbar"), self.x, self.y)
	end

	return self
end
return gui