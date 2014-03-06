-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------
-- 

local storyboard = require( "storyboard" )
local rateit = require( "rateit" )
rateit.setiTunesURL( "com.vibramedia.pigz" )
rateit.setAndroidURL( "com.vibramedia.pigz" )
local scene = storyboard.newScene()

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local screenW, screenH = display.contentWidth, display.contentHeight

	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, screenW, screenH )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 108/255, 233/255, 255/255 )

	local grass = display.newRect( 0, 470, screenW, 100 )
	grass.anchorX = 0
	grass.anchorY = 0
	grass:setFillColor( 51/255, 204/255, 102/255 )

	local gradient = display.newImage( "assets/spashGradient.png", screenW/2, screenH/2 )

	local fence = display.newImage( "assets/splashFence.png", screenW/2, 423 )

	local clouds = display.newImage( "assets/clouds.png", screenW/2, 100 )

	local pigOptions = {
		width = 65,
		height = 44,
		numFrames = 4,
		sheetContentWidth = 260,
		sheetContentHeight = 44
	}
	local pigSheet = graphics.newImageSheet( "assets/pigs.png", pigOptions )
	local pigSpriteOptions = { name="pig", start=1, count=4, time=250 }

	local pig = display.newSprite( pigSheet, pigSpriteOptions )
	origX, origY = screenW / 2, 100
	pig.x, pig.y = origX, origY
	pig.rotation = -11
	pig:play()

	-- make the pig float
	local function moveThePig()
		local moveTo = (pig.y > origY) and origY-10 or origY+10
		transition.moveTo( pig, {x=pig.x, y=moveTo, transition=easing.inOutQuad, time=1000} )
	end
	moveThePig()
	timer.performWithDelay( 1000, moveThePig, 0 )

	-- logo
	-- local logo = display.newImage( "assets/logo.png", screenW/2, screenH/3 )

	-- buttons
	-- local options = { frames = require("buttons").frames }
	-- local buttonsSheet = graphics.newImageSheet( "assets/buttons.png", options )
	-- local spriteOptions = { name="buttons", start=1, count=6, time=1000 }
	-- local buttons = display.newSprite( buttonsSheet, spriteOptions )
	-- buttons.x, buttons.y = screenW/2, screenH*2/3
	local playButton = display.newImage( "assets/btnPlay.png", screenW/2, 230 )
	local rateButton = display.newImage( "assets/btnRate.png", screenW/2, 310 )

	local function startGame( event )
		storyboard.purgeScene( "view1" )
		storyboard.gotoScene( "view2" )
	end
	playButton:addEventListener( "touch", startGame )

	local function rateApp ( event )
		rateit.openURL()
	end
	rateButton:addEventListener( "touch", rateApp )

	group:insert(bg)
	group:insert(gradient)
	group:insert(clouds)
	group:insert(grass)
	group:insert(fence)
	group:insert(pig)
	-- group:insert(logo)
	group:insert(playButton)
	group:insert(rateButton)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene