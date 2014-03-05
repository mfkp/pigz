local constants = require( "constants" )

-- medals sprite
local medalsOptions = {
	width = 64,
	height = 90,
	numFrames = 5,
	sheetContentWidth = 320, 
	sheetContentHeight = 90
}
local medalsSheet = graphics.newImageSheet( "assets/medals.png", medalsOptions )
local medalsSpriteOptions = { name="medals", start=1, count=5, time=500 }
local medals = display.newSprite( medalsSheet, medalsSpriteOptions )
medals.x, medals.y = constants.screenW/2 + 60, constants.screenH/2 - 25
medals.isVisible = false

return medals