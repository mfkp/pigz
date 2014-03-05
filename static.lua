local S = {}

local constants = require( "constants" )
local themes = require( "themes" )
local colors = themes.Themes.Day.Colors

-- create a white background to fill screen
local bg = display.newRect( 0, 0, constants.screenW, constants.screenH )
bg.anchorX = 0
bg.anchorY = 0
bg:setFillColor( colors.Sky.r, colors.Sky.g, colors.Sky.b )

local grass = display.newRect( 0, 470, constants.screenW, 100 )
grass.anchorX = 0
grass.anchorY = 0
grass:setFillColor( colors.Grass.r, colors.Grass.g, colors.Grass.b )

local fence1 = display.newImage( "assets/fence.png" )
fence1.anchorX = 0
fence1.anchorY = 0
fence1.x = 0
fence1.y = 438

local fence2 = display.newImage( "assets/fence.png" )
fence2.anchorX = 0
fence2.anchorY = 0
fence2.x = 200
fence2.y = 438

local fence3 = display.newImage( "assets/fence.png" )
fence3.anchorX = 0
fence3.anchorY = 0
fence3.x = 400
fence3.y = 438

local clouds1 = display.newImage( "assets/clouds.png" )
clouds1.anchorX = 0
clouds1.anchorY = 0
clouds1.x = 0
clouds1.y = 100

local clouds2 = display.newImage( "assets/clouds.png" )
clouds2.anchorX = 0
clouds2.anchorY = 0
clouds2.x = 400
clouds2.y = 200

local clouds3 = display.newImage( "assets/clouds.png" )
clouds3.anchorX = 0
clouds3.anchorY = 0
clouds3.x = 700
clouds3.y = 50

local stars1 = display.newImage( "assets/stars.png" )
stars1.anchorX = 0
stars1.anchorY = 0
stars1.x = 0
stars1.y = 50

local stars2 = display.newImage( "assets/stars.png" )
stars2.anchorX = 0
stars2.anchorY = 0
stars2.x = 160
stars2.y = 25

local stars3 = display.newImage( "assets/stars.png" )
stars3.anchorX = 0
stars3.anchorY = 0
stars3.x = 60
stars3.y = 165

local tapToFlyOptions = {
	width = 109,
	height = 90,
	numFrames = 2,
	sheetContentWidth = 218,
	sheetContentHeight = 90
}
local tapToFlySheet = graphics.newImageSheet( "assets/tooltip.png", tapToFlyOptions )
local tapToFlySpriteOptions = { name="tapToFly", start=1, count=2, time=500 }
local tapToFly = display.newSprite( tapToFlySheet, tapToFlySpriteOptions )
tapToFly.x = constants.screenW/2
tapToFly.y = constants.screenH*2/3
tapToFly:play()

stars1.isVisible, stars2.isVisible, stars3.isVisible = false, false, false
stars1.alpha, stars2.alpha, stars3.alpha = 0.5, 0.5, 0.5

S.bg = bg
S.grass = grass
S.fence1 = fence1
S.fence2 = fence2
S.fence3 = fence3
S.clouds1 = clouds1
S.clouds2 = clouds2
S.clouds3 = clouds3
S.stars1 = stars1
S.stars2 = stars2
S.stars3 = stars3
S.tapToFly = tapToFly

return S