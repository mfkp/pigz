-----------------------------------------------------------------------------------------
--
-- splash.lua
--
-----------------------------------------------------------------------------------------
-- 

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local screenW, screenH = display.contentWidth, display.contentHeight

	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, screenW, screenH )
	bg.anchorX = 0
	bg.anchorY = 0
	local g = graphics.newGradient({ 0, 142/255, 1 }, { 0, 1, 1 }, "up" )
	bg:setFillColor( g )

	local gradient = display.newImage( "assets/spashGradient.png", screenW/2, screenH/2 )

	local clouds = display.newImage( "assets/clouds.png", screenW/2, 100 )

	local function goToIntro( event )
		local options =
		{
			effect = "fromBottom",
			time = 500
		}
		storyboard.gotoScene( "view1", options )
	end

	timer.performWithDelay( 2000, goToIntro)

	-- logo
	local logo = display.newImage( "assets/logo.png", screenW/2, screenH/2 )

	group:insert(bg)
	group:insert(gradient)
	group:insert(clouds)
	group:insert(logo)

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