local animations = {}

function animations.new()
	local self = {}

	self.frame = 1
	self.finished = false
	self.timescale = 1

	self.time = 0
	self.animation = nil

	self.delay = 1
	self.first = 1
	self.last = 1
	self.loop = true
	self.finish = false
	self.reverse = false

	function self.set(animation, force, loop, finish, reverse)
		if not self.finish or self.finished or force then
			self.time = 0
			self.animation = animations.list[animation]

			self.delay = self.animation.delay
			self.first = self.animation.first
			self.last = self.animation.last
			self.loop = loop or self.animation.loop
			self.finish = finish or self.animation.finish
			self.reverse = reverse or self.animation.reverse

			self.frame = self.first
			self.finished = false
		end
	end

	function self.update(dt, animation)
		if animation and animations.list[animation] ~= self.animation then
			self.set(animation)
		end
		
		self.time = self.time + dt * self.timescale

		if self.time > self.delay then
			self.time = self.time - self.delay
			
			if self.reverse then
				self.frame = self.frame - 1

				if self.frame < self.first and self.loop then
					self.frame = self.last
					self.finished = true
				elseif self.frame < self.first then
					self.frame = self.first
					self.finished = true
				elseif self.frame > self.last then
					self.frame = self.last
					self.finished = true
				end
				return true
			else
				self.frame = self.frame + 1

				if self.frame > self.last and self.loop then
					self.frame = self.first
					self.finished = true
				elseif self.frame > self.last then
					self.frame = self.last
					self.finished = true
				elseif self.frame < self.first then
					self.frame = self.first
					self.finished = true
				end
				return true

			end
		end

		return false
	end

	return self
end

-- List of all the animations
animations.list = {}

-- Humanoid
animations.list.humanoid_stand_left   = {delay = 0.08, first = 118, last = 118, loop = true, finish = false, reverse = false}
animations.list.humanoid_stand_right  = {delay = 0.08, first = 144, last = 144, loop = true, finish = false, reverse = false}
animations.list.humanoid_stand_up     = {delay = 0.08, first = 105, last = 105, loop = true, finish = false, reverse = false}
animations.list.humanoid_stand_down   = {delay = 0.08, first = 131, last = 131, loop = true, finish = false, reverse = false}

animations.list.humanoid_walk_left    = {delay = 0.08, first = 119, last = 126, loop = true, finish = false, reverse = false}
animations.list.humanoid_walk_right   = {delay = 0.08, first = 145, last = 152, loop = true, finish = false, reverse = false}
animations.list.humanoid_walk_up      = {delay = 0.08, first = 106, last = 113, loop = true, finish = false, reverse = false}
animations.list.humanoid_walk_down    = {delay = 0.08, first = 132, last = 139, loop = true, finish = false, reverse = false}

animations.list.humanoid_sword_left    = {delay = 0.04, first = 171, last = 175, loop = false, finish = true, reverse = false}
animations.list.humanoid_sword_right   = {delay = 0.04, first = 197, last = 201, loop = false, finish = true, reverse = false}
animations.list.humanoid_sword_up      = {delay = 0.04, first = 158, last = 162, loop = false, finish = true, reverse = false}
animations.list.humanoid_sword_down    = {delay = 0.04, first = 184, last = 188, loop = false, finish = true, reverse = false}


animations.list.humanoid_die          = {delay = 0.08, first = 261, last = 266, loop = false, finish = true, reverse = false}

-- Eyeball
animations.list.eyeball_walk_left   = {delay = 0.2, first = 4, last = 6, loop = true, finish = false, reverse = false}
animations.list.eyeball_walk_right  = {delay = 0.2, first = 10, last = 12, loop = true, finish = false, reverse = false}
animations.list.eyeball_walk_up     = {delay = 0.2, first = 1, last = 3, loop = true, finish = false, reverse = false}
animations.list.eyeball_walk_down   = {delay = 0.2, first = 7, last = 9, loop = true, finish = false, reverse = false}

animations.list.elisa_walk         = {delay = 0.08, first = 17, last = 24, loop = true, finish = false, reverse = false}
animations.list.elisa_jump         = {delay = 0.08, first = 106, last = 113, loop = true, finish = false, reverse = false}
animations.list.elisa_idle         = {delay = 0.20, first = 1, last = 3, loop = true, finish = false, reverse = false}

return animations