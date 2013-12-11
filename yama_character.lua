character = {}

function character.new()
	local self = {}

	self.name = "Unnamed Character"
	self.age = 25
	self.race = "human"
	self.gender = "female"

	self.level = 1

	self.strength = 1
	self.speed = 1
	self.magic = 1

	self.hpmax = 100
	self.hp = self.hpmax
	self.mpmax = 100
	self.mp = self.mpmax
	self.spmax = 100
	self.sp = self.spmax

	-- Inventory

	--[[
	
	Sword attacks
	Ranged attacks
	Magic attacks

	Power attacks/combos


	--]]

	

	return self
end

return character