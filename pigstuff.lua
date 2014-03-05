local P = {}

local pigOptions = {
	width = 65,
	height = 44,
	numFrames = 4,
	sheetContentWidth = 260,
	sheetContentHeight = 44
}
local pigSheet = graphics.newImageSheet( "assets/pigs.png", pigOptions )
local pigSpriteOptions = { name="pig", start=1, count=4, time=250 }

local pigGroup = display.newGroup()
local deadPig = display.newImage( pigGroup, "assets/dead.png" )
local pig = display.newSprite( pigGroup, pigSheet, pigSpriteOptions )
pig:setFrame( 4 )
deadPig.isVisible = false

-- local pigShape = { 12,26, 26,10, 32,6, 32,-4, 16,-18, -6,-18, -16,-6, -10,16 }

P.pigGroup = pigGroup
P.pig = pig
P.deadPig = deadPig

return P