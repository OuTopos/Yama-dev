local logic = {}

function logic.update(dt)
	-- body
end



-- PHYSICS
function logic.beginContact(a, b, contact)
	if a:getUserData() then
		if a:getUserData().callback then
			if a:getUserData().callback.beginContact then
				a:getUserData().callback.beginContact(a, b, contact)
			end
		end
	end
	if b:getUserData() then
		if b:getUserData().callback then
			if b:getUserData().callback.beginContact then
				b:getUserData().callback.beginContact(b, a, contact)
			end
		end
	end
end

function logic.endContact(a, b, contact)
	if a:getUserData() then
		if a:getUserData().callback then
			if a:getUserData().callback.endContact then
				a:getUserData().callback.endContact(a, b, contact)
			end
		end
	end
	if b:getUserData() then
		if b:getUserData().callback then
			if b:getUserData().callback.endContact then
				b:getUserData().callback.endContact(b, a, contact)
			end
		end
	end
end

function logic.preSolve(a, b, contact)
	if a:getUserData() then
		if a:getUserData().callback then
			if a:getUserData().callback.preSolve then
				a:getUserData().callback.preSolve(a, b, contact)
			end
		end
	end
	if b:getUserData() then
		if b:getUserData().callback then
			if b:getUserData().callback.preSolve then
				b:getUserData().callback.preSolve(b, a, contact)
			end
		end
	end
end

function logic.postSolve(a, b, contact)
	if a:getUserData() then
		if a:getUserData().entity then
			if a:getUserData().entity.postSolve then
				a:getUserData().entity.postSolve(a, b, contact)
			end
		end
	end
	if b:getUserData() then
		if b:getUserData().entity then
			if b:getUserData().entity.postSolve then
				b:getUserData().entity.postSolve(b, a, contact)
			end
		end
	end
end

return logic