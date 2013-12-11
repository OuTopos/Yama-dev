
local ai = {}

function ai.new()
	local public = {}
	local private = {}


	public.direction = 0
	public.speed = 0

	local behaviours = {attack = false, patrol = true, guard = false}

	local behaviour = {}
	behaviour.current = nil


	local goal = nil
	local aim = 0

	-- UPDATE
	function public.update(x, y)
		if behaviour.current then
			public[behaviour.current].update(x, y)
			goal = public[behaviour.current].goal
			public.speed = public[behaviour.current].speed
		else
			goal = nil
		end

		--if behaviours.attack then
			--public.updateAttack()
		--elseif behaviours.patrol then
		--	public.patrol.update(x, y)
		--	goal = public.patrol.goal
		--	public.speed = public.patrol.public.speed
		--elseif behaviours.guard then
			--public.updateGuard()
		--end

		if goal then
			public.direction = math.atan2(goal[2]-y, goal[1]-x)
			public.speed = 1
		end
	end

	-- BEHAVRIOURS


	-- BEHAVIOUR: PATROL
	--dofile("yama_ai_patrol.lua")
	public.patrol = yama.ai.patrols.new()

function public.patrol.getPoint()
	return public.patrol.v.x, public.patrol.v.y
end

function public.patrol.isActive()
	if public.patrol.v then
		return truepatrol
	else
		return false
	end
end
	

	-- INPUT
	function public.setBehaviour(aBehaviour)
		if public[aBehaviour] then
			behaviour.current = aBehaviour
		end
	end

	-- OUTPUT
	function public.getDirection()
		return public.direction
	end
	function public.getSpeed()
		return public.speed
	end

	return public
end

return ai