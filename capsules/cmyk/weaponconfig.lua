local weapons = {}


weapons.bouncer = {}
weapons.shotgun = {}
weapons.rpg = {}
weapons.mg = {}
-- BOUNCER --
weapons.bouncer.name = 'bouncer'
weapons.bouncer.rps = 0.2
weapons.bouncer.damageBody = 6
weapons.bouncer.damageShield = 17
weapons.bouncer.impulseForce = 900
weapons.bouncer.nrBulletsPerShot = 1
weapons.bouncer.magCapacity = 50
weapons.bouncer.spread = 1.5
weapons.bouncer.nrBounces = 2
weapons.bouncer.blastRadius = 0
weapons.bouncer.lifetime = 2000
weapons.bouncer.bulletTravelDistance = false
weapons.bouncer.bulletWeight = 0.4
weapons.bouncer.sizeX = 1
weapons.bouncer.linearDamping = 0.5
weapons.bouncer.inertia = 0.2
weapons.bouncer.gravityScale = 1

weapons.bouncer.ptclSpriteSizes = { 1,3 }
weapons.bouncer.ptclEmissionRate = 900
weapons.bouncer.ptclEmitterLifetime = 200
weapons.bouncer.ptclBufferSize = 9000
weapons.bouncer.ptclSpeed = {20, 40}
weapons.bouncer.ptclLinearAcceleration = { 0,0,0,0 }
weapons.bouncer.ptclSpriteLifetime = 0.9
weapons.bouncer.ptclTangentialAcceleration = 0.1
weapons.bouncer.ptclRadialAcceleration = { 0, 0 } -- Set the radial acceleration (away from the emitter).
weapons.bouncer.ptclAreaSpread = { 'normal', 1, 1} -- TYPE, The maximum spawn distance X, The maximum spawn distance Y
                                                   -- Sets area-based spawn parameters for the particles. 
                                                   -- Newly created particles will spawn in an area around the emitter based on the parameters to this function
weapons.bouncer.ptclSpread =  0.01 -- The amount of spread (radians)
weapons.bouncer.ptclSpin = {0.2, 1, 0.3}
weapons.bouncer.ptclColors = {180, 180, 180, 190,
							180, 180, 180, 100,
							180, 180, 180, 0}


-- SHOTGUN --
weapons.shotgun.name = 'shotgun'
weapons.shotgun.rps = 0.3
weapons.shotgun.damageBody = 12
weapons.shotgun.damageShield = 12
weapons.shotgun.impulseForce = 900
weapons.shotgun.nrBulletsPerShot = 20
weapons.shotgun.magCapacity = 50
weapons.shotgun.spread = 50
weapons.shotgun.nrBounces = 0
weapons.shotgun.blastRadius = 0
weapons.shotgun.lifetime = 2000
weapons.shotgun.bulletTravelDistance = 200
weapons.shotgun.bulletWeight = 0.4
weapons.shotgun.sizeX = 0.5
weapons.shotgun.linearDamping = 0.03
weapons.shotgun.inertia = 0.2
weapons.shotgun.gravityScale = 1

weapons.shotgun.ptclSpriteSizes = {0.8,2}
weapons.shotgun.ptclEmissionRate = 1200
weapons.shotgun.ptclEmitterLifetime = 200
weapons.shotgun.ptclBufferSize = 50000
weapons.shotgun.ptclSpeed = {25, 45}
weapons.shotgun.ptclLinearAcceleration = { 0,0,0,0 }
weapons.shotgun.ptclSpriteLifetime = 0.9
weapons.shotgun.ptclTangentialAcceleration = 0.1
weapons.shotgun.ptclRadialAcceleration = { 0.5, 0.9 } -- Set the radial acceleration (away from the emitter).
weapons.shotgun.ptclAreaSpread = { 'normal', 1, 1} -- TYPE, The maximum spawn distance X, The maximum spawn distance Y
                                                   -- Sets area-based spawn parameters for the particles. 
                                                   -- Newly created particles will spawn in an area around the emitter based on the parameters to this function
weapons.shotgun.ptclSpread =  0.01 -- The amount of spread (radians)
weapons.shotgun.ptclSpin = {0.2, 1, 0.3}
weapons.shotgun.ptclColors ={180, 180, 180, 190,
							180, 180, 180, 100,
							180, 180, 180, 0}


-- RPG --
weapons.rpg.name = 'rpg'
weapons.rpg.rps = 0.4
weapons.rpg.damageBody = 500
weapons.rpg.damageShield = 500
weapons.rpg.impulseForce = 3000
weapons.rpg.maxVel = 1110
weapons.rpg.nrBulletsPerShot = 1
weapons.rpg.magCapacity = 1
weapons.rpg.spread = 0
weapons.rpg.nrBounces = 0
weapons.rpg.blastRadius = 70
weapons.rpg.lifetime = 10
weapons.rpg.bulletTravelDistance = false
weapons.rpg.bulletWeight = 4
weapons.rpg.sizeX = 2
weapons.rpg.linearDamping = 0.0001
weapons.rpg.inertia = 500
weapons.rpg.gravityScale = 0.001

weapons.rpg.ptclSpriteSizes = {1,3}
weapons.rpg.ptclEmissionRate = 300
weapons.rpg.ptclEmitterLifetime = 200
weapons.rpg.ptclBufferSize = 50000
weapons.rpg.ptclSpeed = {30, 60}
weapons.rpg.ptclLinearAcceleration = { 0,0,0,0 }
weapons.rpg.ptclSpriteLifetime = 2.5
weapons.rpg.ptclTangentialAcceleration = 0.4
weapons.rpg.ptclRadialAcceleration = { 0.1, 0.4 } -- Set the radial acceleration (away from the emitter).
weapons.rpg.ptclAreaSpread = { 'normal', 2, 2} -- TYPE, The maximum spawn distance X, The maximum spawn distance Y
                                                   -- Sets area-based spawn parameters for the particles. 
                                                   -- Newly created particles will spawn in an area around the emitter based on the parameters to this function
weapons.rpg.ptclSpread =  0.01 -- The amount of spread (radians)
weapons.rpg.ptclSpin = {0.2, 1, 0.3}
weapons.rpg.ptclColors = {255, 255, 120, 170,
							255, 255, 0, 170,
							255, 128, 128, 160,
							0, 0, 0, 130, 
							0, 0, 0, 70, 
							10, 10, 10, 15, 
							175, 175, 175, 10, 
							255, 255, 255, 0
							}

-- MG --
weapons.mg.name = 'mg'
weapons.mg.rps = 0.03
weapons.mg.damageBody = 3
weapons.mg.damageShield = 9
weapons.mg.impulseForce = 500
weapons.mg.nrBulletsPerShot = 1
weapons.mg.magCapacity = 500
weapons.mg.spread = 10
weapons.mg.nrBounces = 0
weapons.mg.blastRadius = 0
weapons.mg.lifetime = 2000
weapons.mg.bulletTravelDistance = false
weapons.mg.bulletWeight = 0.2		
weapons.mg.sizeX = 1.5
weapons.mg.linearDamping = 0.01
weapons.mg.inertia = 0.2
weapons.mg.gravityScale = 0.01

weapons.mg.ptclSpriteSizes = {0.5,1}
weapons.mg.ptclEmissionRate = 2000
weapons.mg.ptclEmitterLifetime = 200
weapons.mg.ptclBufferSize = 50000
weapons.mg.ptclSpeed = {3, 6}
weapons.mg.ptclLinearAcceleration = { 0,0,0,0 }
weapons.mg.ptclSpriteLifetime = 0.2
weapons.mg.ptclTangentialAcceleration = 0.4
weapons.mg.ptclRadialAcceleration = { 0.01, 0.04 } -- Set the radial acceleration (away from the emitter).
weapons.mg.ptclAreaSpread = { 'normal', 0, 0} -- TYPE, The maximum spawn distance X, The maximum spawn distance Y
                                                   -- Sets area-based spawn parameters for the particles. 
                                                   -- Newly created particles will spawn in an area around the emitter based on the parameters to this function
weapons.mg.ptclSpread =  0.01 -- The amount of spread (radians)
weapons.mg.ptclSpin = {0.2, 1, 0.3}
weapons.mg.ptclColors = {255, 255, 255, 170, 
							128, 128, 128, 0
							}

return weapons