patrols = {}

function patrols.new()
	local public = {}
	local private = {}

	-- Public
	public.goal = nil
	public.speed = 0


	-- Private
	private.current = nil

	private.k, private.v = nil, nil
	private.loop = true
	private.radius = 32
	private.order = nil


	-- Public Functions
	function public.set(name, map)
		if map.patrols[name] then
			private.current = map.patrols[name]
			private.k = 0
			public.next()
		end
	end

	function public.setLoop(loop)
		private.loop = loop
	end

	function public.setRadius(radius)
		private.radius = radius
	end

	function public.update(x, y)
		if private.v then
			if yama.g.getDistance(x, y, private.v.x, private.v.y) < private.radius then
				public.next()
			end

			if private.v then
				public.goal = {private.v.x, private.v.y}
				public.speed = 1
			else
				public.goal = nil
				public.speed = 0
			end
		end
	end

	function public.next()
		if private.order == "random" then
			private.k = math.random(1, #private.current.points)
			private.v = private.current.points[private.k]
		elseif private.order == "reverse" then
			private.k = private.k - 1
		else
			private.k = private.k + 1
		end

		if private.current.points[private.k] then
			private.v = private.current.points[private.k]
		elseif private.loop and private.order == "reverse" then
			private.k = #private.current.points
			private.v = private.current.points[private.k]
		elseif private.loop then
			private.k = 1
			private.v = private.current.points[private.k]
		else
			private.v = nil

		end
	end

	function public.getPoint()
		return private.v.x, private.v.y
	end

	function public.isActive()
		if private.v then
			return truepatrol
		else
			return false
		end
	end

	return public
end

return patrols