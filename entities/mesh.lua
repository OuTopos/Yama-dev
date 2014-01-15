local mesh = {}

function mesh.new()
	local self = {}
	self.buffer = {}

	self.x, self.y = 0, 0

	self.batches = {}

	-- Standard functions
	function self.update(dt)
		for k = 1, #self.batches do
			table.insert(self.buffer, self.batches)
		end
	end
	
	function self.addToBuffer(viewport)
		for k = 1, #self.batches do
			viewport.addToBuffer(self.batches[k])
		end
	end

	function self.destroy()
		self.destroyed = true
	end

	return self
end

return mesh