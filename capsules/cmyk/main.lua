local capsule = {}

function capsule.load()
	love.window.setTitle("Mattias CMYK")
	love.window.setMode(400, 400, {
		fullscreen = false,
		fullscreentype = "desktop",
		vsync = false,
		fsaa = 0,
		resizable = true,
		borderless = false,
		centered = true,
	})
end

function capsule.update(dt)
end

return capsule