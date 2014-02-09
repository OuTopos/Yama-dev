local capsule = {}

function capsule.load()
	love.window.setTitle("Mattias CMYK")
	love.window.setMode(1200, 800, {
		fullscreen = false,
		fullscreentype = "desktop",
		vsync = true,
		fsaa = 0,
		resizable = true,
		borderless = false,
		centered = true,
	})
	capsule.scene = yama.scenes.new()
	capsule.scene.enablePhysics()
	
	capsule.scene.world:setGravity( 0, 320 )
	love.physics.setMeter(32)
	capsule.scene.loadMap("test/gravityfall")
	capsule.p1 = capsule.scene.newEntity("player", "start", {id = 1})
	--capsule.cam1 = capsule.map.spawn("camera", "start")
	--capsule.cam1.follow(capsule.p1)
	capsule.vp1 = yama.viewports.new()
	capsule.vp1.connect(capsule.scene, capsule.p1)

	function love.gamepadpressed(joystick, button)
		if button == "a" then
			capsule.p1.gamepadpressed( button )
		end
	end

	function love.gamepadreleased(joystick, button)
		if button == "a" then
			capsule.p1.gamepadreleased( button )
		end
	end

	function love.keypressed(key)
		if key == "escape" then
			love.event.push("quit")
		end
		if key == "h" then
			if yama.hud.enabled then
				yama.hud.enabled = false
			else
				yama.hud.enabled = true
			end
		end
		if key == "q" then
			capsule.p1.setWeapon( 'bouncer')
		end
		if key == "e" then
			capsule.p1.setWeapon( 'shotgun')
		end
		if key == "r" then
			capsule.p1.setWeapon( 'rpg')
		end
		if key == "j" then
			if yama.hud.physics then
				yama.hud.physics = false
			else
				yama.hud.physics = true
			end
		end

		if key == "p" then
			if yama.g.paused then
				yama.g.paused = false
			else
				yama.g.paused = true
			end
		end

		if key == "n" then
			capsule.vp1.camera.r = capsule.vp1.camera.r + 0.1
		end

		if key == "m" then
			capsule.vp1.camera.r = capsule.vp1.camera.r - 0.1
		end
		if key == "k" then
			if capsule.vp1.parallax.enabled then
				capsule.vp1.parallax.enabled = false
			else
				capsule.vp1.parallax.enabled = true
			end
		end
		if key == "z" then
			capsule.p2 = capsule.scene.newEntity("player", "start2", {id = 2})
			capsule.p2.playerId = 2
			capsule.vp2 = yama.viewports.new()
			capsule.vp2.connect(capsule.scene, capsule.p2)

			--vp2.setScale(4, 4)

			capsule.vp1.resize(love.window.getWidth() / 2, love.window.getHeight())
			capsule.vp2.resize(love.window.getWidth() / 2, love.window.getHeight())
			capsule.vp2.x = love.window.getWidth() / 2
			capsule.p2.joystick = love.joystick.getJoysticks()[2]

		end
		if key == "1" then
			capsule.vp1.zoom(1)
		end

		if key == "2" then
			capsule.vp1.zoom(2)
		end

		if key == "3" then
			capsule.vp1.zoom(3)
		end

		if key == "4" then
			capsule.vp1.zoom(4)
		end

		if key == "5" then
			capsule.vp1.zoom(0.5)
		end

		if key == "6" then
			capsule.vp1.zoom(0.25)
		end

		if key == "0" then
			local scale = capsule.vp1.camera.sx + 1
			if scale > 5 then
				scale = 1
			end
			capsule.vp1.camera.zoom(scale)
		end

		if key == "+" then
			if capsule.vp1.camera.round then
				capsule.vp1.camera.round = false
			else
				capsule.vp1.camera.round = true
			end
		end
	end

	function capsule.resize(w, h)
		if capsule.vp1 and capsule.vp2 then
			capsule.vp1.resize(w/2, h)
			capsule.vp2.resize(w/2, h)
			capsule.vp2.x = w/2
		elseif capsule.vp1 then
			capsule.vp1.resize(w, h)
		end
	end

end

function capsule.weaponSetup()

	self.weaponList.bouncer.name = 'bouncer'
	self.weaponList.bouncer.rps = 0.09
	self.weaponList.bouncer.damageBody = 6
	self.weaponList.bouncer.damageShield = 17
	self.weaponList.bouncer.impulseForce = 900
	self.weaponList.bouncer.nrBulletsPerShot = 1
	self.weaponList.bouncer.magCapacity = 50
	self.weaponList.bouncer.spread = 5
	self.weaponList.bouncer.nrBounces = 2
	self.weaponList.bouncer.blastRadius = 1
	self.weaponList.bouncer.blastDamageFallof = 1
	self.weaponList.bouncer.lifetime = 7
	self.weaponList.bouncer.bulletTravelDistance = 200000

	self.weaponList.shotgun.name = 'shotgun'
	self.weaponList.shotgun.rps = 0.4
	self.weaponList.shotgun.damageBody = 12
	self.weaponList.shotgun.damageShield = 12
	self.weaponList.shotgun.impulseForce = 900
	self.weaponList.shotgun.nrBulletsPerShot = 20
	self.weaponList.shotgun.magCapacity = 50
	self.weaponList.shotgun.spread = 50
	self.weaponList.shotgun.nrBounces = 0
	self.weaponList.shotgun.blastRadius = 0
	self.weaponList.shotgun.blastDamageFallof = 0
	self.weaponList.shotgun.lifetime = 0.2
	self.weaponList.shotgun.bulletTravelDistance = 200

	self.weaponList.rpg.name = 'rpg'
	self.weaponList.rpg.rps = 0.2
	self.weaponList.rpg.damageBody = 50
	self.weaponList.rpg.damageShield = 50
	self.weaponList.rpg.impulseForce = 700
	self.weaponList.rpg.nrBulletsPerShot = 1
	self.weaponList.rpg.magCapacity = 1
	self.weaponList.rpg.spread = 0
	self.weaponList.rpg.nrBounces = 0
	self.weaponList.rpg.blastRadius = 20
	self.weaponList.rpg.blastDamageFallof = 1
	self.weaponList.rpg.lifetime = 7
	self.weaponList.rpg.bulletTravelDistance = 200000
end


function capsule.update(dt)
end

return capsule