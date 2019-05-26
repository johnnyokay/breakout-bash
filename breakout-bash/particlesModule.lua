local prism = require("prism")
local CBE   = require("CBE.CBE")

local particlesModule = {}

particlesModule.Trail = function(x, y)
	local emitter = prism.newEmitter({
		particles = {
			type                 = "image",
			image                = "particle.png",
			width                = 50,
			height               = 50,
			color                = {{0.25, 0.25, 0.25}, {0.25, 0.25, 0.25}},
			blendMode            = "add",
			particlesPerEmission = 1,
			inTime               = 100,
			lifeTime             = 100,
			outTime              = 100,
			startProperties      = {xScale = 0.8, yScale = 0.8},
			endProperties        = {xScale = 0.05, yScale = 0.05}

		},

		position = {
			type = "point"
		},

		movement = {
			type           = "angular",
			angle          = "0-359",
			velocityRetain = .97,
			speed          = 1,
			yGravity       = -0.15
		}
	})

	emitter.emitX, emitter.emitY = x, y
	emitter:emit()
end

particlesModule.Explosion = function(x, y, color)
    local vent    = CBE.newVent({
		perEmit   = 10,
		emitDelay = 100,
		color     = {{color[1], color[3], color[3]}},
		emitX     = x,
		emitY     = y
	})

	vent.emit()
end

return particlesModule
