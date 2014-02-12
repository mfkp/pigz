-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------
-- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local physics = require( "physics" )

physics.setScale( 90 )
-- physics.setDrawMode( "hybrid" )
physics.start()
physics.setGravity( 0, 15 )
local PIG_UPWARD_VELOCITY = -400
local ROTATION_RATIO = PIG_UPWARD_VELOCITY / -20
local FENCE_SPEED = 1
local CLOUD_SPEED = 0.3
local PITCHFORK_SPEED = 5
local ONE_OFFSET = 10 -- pixels offset for the "one" number
local gameOver = false

local currentScore = 0

local screenW, screenH = display.contentWidth, display.contentHeight

local pigOptions = {
    width = 65,
    height = 44,
    numFrames = 4
}
local pigSheet = graphics.newImageSheet( "assets/pigs.png", pigOptions )
local pigSpriteOptions = { name="pig", start=1, count=4, time=250 }

-- Create a basic display group
local pigGroup = display.newGroup()
local deadPig = display.newImage( pigGroup, "assets/dead.png" )
local pig = display.newSprite( pigGroup, pigSheet, pigSpriteOptions )
pig:play()
deadPig.isVisible = false
pigGroup.whichPig = "alive"

local origX = screenW / 4
local origY = screenH / 2

-- local pigShape = { 12,26, 26,10, 32,6, 32,-4, 16,-18, -6,-18, -16,-6, -10,16 }

local pitchforkOptions = {
    width = 54,
    height = 500,
    numFrames = 2
}
local pitchforkSheet = graphics.newImageSheet( "assets/pitchfork.png", pitchforkOptions )

local pitchforkDown = display.newImage( pitchforkSheet, 2 )
pitchforkDown.anchorX = 0
pitchforkDown.anchorY = 0
pitchforkDown.x = screenW
pitchforkDown.y = -300

local pitchforkUp = display.newImage( pitchforkSheet, 1 )
pitchforkUp.anchorX = 0
pitchforkUp.anchorY = 0
pitchforkUp.x = screenW
pitchforkUp.y = pitchforkDown.y + 620

local pitchforkDown2 = display.newImage( pitchforkSheet, 2 )
pitchforkDown2.anchorX = 0
pitchforkDown2.anchorY = 0
pitchforkDown2.x = pitchforkDown.x + (screenW / 2) + pitchforkDown2.contentWidth
pitchforkDown2.y = -300

local pitchforkUp2 = display.newImage( pitchforkSheet, 1 )
pitchforkUp2.anchorX = 0
pitchforkUp2.anchorY = 0
pitchforkUp2.x = pitchforkDown2.x
pitchforkUp2.y = pitchforkDown2.y + 620

physics.addBody( pitchforkDown, "static", { friction=1, bounce=0.6 } )
physics.addBody( pitchforkUp, "static", { friction=1, bounce=0.6 } )
physics.addBody( pitchforkDown2, "static", { friction=1, bounce=0.6 } )
physics.addBody( pitchforkUp2, "static", { friction=1, bounce=0.6 } )
physics.addBody( pigGroup, "dynamic", { radius=20, density=1.0, friction=1, bounce=0.4 } )

local fence1, fence2, fence3, clouds1, clouds2, clouds3

local flapSound = audio.loadSound( "assets/sounds/flap.mp3" )
-- local boingSound = audio.loadSound( "assets/sounds/boing.mp3" )
local oinkSound = audio.loadSound( "assets/sounds/oink.mp3" )
local coinSound = audio.loadSound( "assets/sounds/coin.mp3" )

-- numbers sprite
local options = { frames = require("numbers").frames }
local numbersSheet = graphics.newImageSheet( "assets/numbers.png", options )
local spriteOptions = { name="numbers", start=1, count=10, time=1000 }
local ones = display.newSprite( numbersSheet, spriteOptions )
local tens = display.newSprite( numbersSheet, spriteOptions )
local hundreds = display.newSprite( numbersSheet, spriteOptions )
hundreds.anchorX, hundreds.anchorY, tens.anchorX, tens.anchorY, ones.anchorX, ones.anchorY = 0, 0, 0, 0, 0, 0
tens.isVisible = false
hundreds.isVisible = false
ones.y, tens.y, hundreds.y = 20, 20, 20
local NUMBER_WIDTH = 26
local onesPos = screenW/2 - NUMBER_WIDTH*1 + NUMBER_WIDTH/2
local tensPos = screenW/2 - NUMBER_WIDTH*2 + NUMBER_WIDTH/2
local hundredsPos =  screenW/2 - NUMBER_WIDTH*3 + NUMBER_WIDTH/2
hundreds.x = hundredsPos
tens.x = tensPos
ones.x = onesPos

-- scoreboard
local scoreboardOptions = { frames = require("scoreboard").frames }
local scoreboardSheet = graphics.newImageSheet( "assets/scoreboard.png", scoreboardOptions )
local scoreboardSpriteOptions = { name="scoreboard", start=1, count=2, time=500 }
local scoreboard = display.newSprite( scoreboardSheet, scoreboardSpriteOptions )
scoreboard.x, scoreboard.y = screenW/2, screenH/2
-- scoreboard:play()
scoreboard.isVisible = false

-- high score numbers sprite
local highOnes = display.newSprite( numbersSheet, spriteOptions )
local highTens = display.newSprite( numbersSheet, spriteOptions )
local highHundreds = display.newSprite( numbersSheet, spriteOptions )
highHundreds.anchorX, highHundreds.anchorY, highTens.anchorX, highTens.anchorY, highOnes.anchorX, highOnes.anchorY = 0, 0, 0, 0, 0, 0
highOnes.isVisible = false
highTens.isVisible = false
highHundreds.isVisible = false
-- local highHeight = screenH/2 + 37
highOnes.y, highTens.y, highHundreds.y = ones.y, tens.y, hundreds.y
-- local highWidth = screenW/2 - 60
highHundreds.x, highTens.x, highOnes.x = ones.x, tens.x, hundreds.x

-- score group
local scoreGroup = display.newGroup()
scoreGroup:insert( ones )
scoreGroup:insert( tens )
scoreGroup:insert( hundreds )

local highscoreGroup = display.newGroup()
highscoreGroup:insert( highOnes )
highscoreGroup:insert( highTens )
highscoreGroup:insert( highHundreds )


local function writeScore(score)
	local path = system.pathForFile( "highscore.txt", system.DocumentsDirectory )
	local file = io.open (path, "w" )
	if ( file ) then
		local contents = score
		file:write( contents )
		io.close( file )
		file = nil
		return true
	else
		print( "Error: could not read file" )
		return false
	end
end

local function getScore()
	local path = system.pathForFile( "highscore.txt", system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if ( file ) then
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		local score = tonumber( contents );
		io.close( file )
		file = nil
		return score
	else
		print( "Error: could not read scores from file." )
		writeScore( currentScore )
		return 0
	end
	return nil
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, screenW, screenH )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 108/255, 233/255, 255/255 )

	local grass = display.newRect( 0, 470, screenW, 100 )
	grass.anchorX = 0
	grass.anchorY = 0
	grass:setFillColor( 51/255, 204/255, 102/255 )

	fence1 = display.newImage( "assets/fence.png" )
	fence1.anchorX = 0
	fence1.anchorY = 0
	fence1.x = 0
	fence1.y = 438

	fence2 = display.newImage( "assets/fence.png" )
	fence2.anchorX = 0
	fence2.anchorY = 0
	fence2.x = 200
	fence2.y = 438

	fence3 = display.newImage( "assets/fence.png" )
	fence3.anchorX = 0
	fence3.anchorY = 0
	fence3.x = 400
	fence3.y = 438

	clouds1 = display.newImage( "assets/clouds.png" )
	clouds1.anchorX = 0
	clouds1.anchorY = 0
	clouds1.x = 0
	clouds1.y = 100

	clouds2 = display.newImage( "assets/clouds.png" )
	clouds2.anchorX = 0
	clouds2.anchorY = 0
	clouds2.x = 200
	clouds2.y = 200

	clouds3 = display.newImage( "assets/clouds.png" )
	clouds3.anchorX = 0
	clouds3.anchorY = 0
	clouds3.x = 400
	clouds3.y = 50

	group:insert( bg )
	group:insert( clouds1 )
	group:insert( clouds2 )
	group:insert( clouds3 )
	group:insert( fence1 )
	group:insert( fence2 )
	group:insert( fence3 )
	group:insert( pitchforkUp )
	group:insert( pitchforkDown )
	group:insert( pitchforkUp2 )
	group:insert( pitchforkDown2 )
	group:insert( grass )

	physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	local function resetPitchforks()
		pitchforkDown.x = pitchforkDown2.x + screenW/2 + pitchforkDown.contentWidth
		pitchforkUp.x = pitchforkDown.x

		-- randomize the position
		pitchforkDown.y = math.random( -420, -220 ) -- 420 smoke a blunt
		pitchforkUp.y = pitchforkDown.y + 620
	end

	local function resetPitchforks2()
		pitchforkDown2.x = pitchforkDown.x + screenW/2 + pitchforkDown2.contentWidth
		pitchforkUp2.x = pitchforkDown2.x

		-- randomize the position
		pitchforkDown2.y = math.random( -420, -220 ) -- 420 smoke a blunt
		pitchforkUp2.y = pitchforkDown2.y + 620
	end

	local function setScore(score, ones, tens, hundreds)
		local secondsDigit = score % 10
		local tensDigit = math.floor(score % 100 / 10)
		local hundredsDigit = math.floor(score % 1000 / 100)
		ones:setFrame( secondsDigit + 1 )
		tens:setFrame( tensDigit + 1 )
		hundreds:setFrame( hundredsDigit + 1 )
		ones.isVisible = (score >= 0)
		tens.isVisible = (score >= 10)
		hundreds.isVisible = (score >= 100)
		-- set positioning
		ones.x = 		onesPos + 
						((score >= 10) and NUMBER_WIDTH/2 or 0) + 
						((score >= 100) and NUMBER_WIDTH/2 or 0)
		tens.x = 		tensPos + 
						((tensDigit == 1) and ONE_OFFSET or 0) + 
						((score >= 10) and NUMBER_WIDTH/2 or 0) + 
						((score >= 100) and NUMBER_WIDTH/2 or 0)
		hundreds.x = 	hundredsPos + 
						((hundredsDigit == 1) and ONE_OFFSET or 0) + 
						((tensDigit == 1) and ONE_OFFSET or 0) + 
						((score >= 10) and NUMBER_WIDTH/2 or 0) + 
						((score >= 100) and NUMBER_WIDTH/2 or 0)
	end

	local function moveThePig()
		-- move pitchforks
		pitchforkDown.x = pitchforkDown.x - PITCHFORK_SPEED
		pitchforkUp.x = pitchforkDown.x
		if ( pitchforkDown.x < 0 - pitchforkDown.contentWidth ) then
			resetPitchforks()
		end

		pitchforkDown2.x = pitchforkDown2.x - PITCHFORK_SPEED
		pitchforkUp2.x = pitchforkDown2.x
		if ( pitchforkDown2.x < 0 - pitchforkDown2.contentWidth ) then
			resetPitchforks2()
		end

		-- check for +1 score
		if ((pitchforkDown.x > origX-PITCHFORK_SPEED/2 and pitchforkDown.x <= origX+PITCHFORK_SPEED/2) or 
			(pitchforkDown2.x > origX-PITCHFORK_SPEED/2 and pitchforkDown2.x <= origX+PITCHFORK_SPEED/2)) then
			currentScore = currentScore + 1
			setScore(currentScore, ones, tens, hundreds)
			audio.play( coinSound )
		end

		-- move fence
		fence1.x = fence1.x - FENCE_SPEED
		if ( fence1.x <= -200 ) then
			fence1.x = 400
		end
		fence2.x = fence2.x - FENCE_SPEED
		if ( fence2.x <= -200 ) then
			fence2.x = 400
		end
		fence3.x = fence3.x - FENCE_SPEED
		if ( fence3.x <= -200 ) then
			fence3.x = 400
		end

		-- move clouds
		clouds1.x = clouds1.x - CLOUD_SPEED
		if ( clouds1.x <= -200 ) then
			clouds1.x = 400
			clouds1.y = math.random( 50, 250 )
		end
		clouds2.x = clouds2.x - CLOUD_SPEED
		if ( clouds2.x <= -200 ) then
			clouds2.x = 400
			clouds2.y = math.random( 50, 250 )
		end
		clouds3.x = clouds3.x - CLOUD_SPEED
		if ( clouds3.x <= -200 ) then
			clouds3.x = 400
			clouds2.y = math.random( 50, 250 )
		end

		local vx, vy = pigGroup:getLinearVelocity()
		pigGroup.rotation = math.min( vy / ROTATION_RATIO - 10, 90 )

		if (pigGroup.y < 0) then
			pigGroup.y = 0
		end
		
	end

	local function screenTouchListener( event )
		if ( event.phase == "began" ) then
			if ( gameOver ) then
				gameOver = false
				resetPitchforks()
				resetPitchforks2()
				currentScore = 0
				setScore(currentScore, ones, tens, hundreds)
				deadPig.isVisible = false
				pig.isVisible = true
				scoreGroup.y = 0
				scoreGroup.x = 0
				scoreboard.isVisible = false
				highscoreGroup.isVisible = false
				storyboard.gotoScene( "view2" )
			end
			pigGroup:setLinearVelocity( 0, PIG_UPWARD_VELOCITY )
			audio.play( flapSound )
		end
		return true  --prevents touch propagation to underlying objects
	end

	local function onPigCollision( self, event )
		if ( event.phase == "began" ) then
			
			if ( not gameOver ) then
				gameOver = true
				audio.play( oinkSound )
				-- swap out live pig for dead pig
				deadPig.isVisible = true
				pig.isVisible = false
				-- check for high score, set it if high #420
				local highScore = getScore()
				if currentScore > highScore then
					writeScore(currentScore)
					highScore = currentScore
					scoreboard:setFrame( 2 )
				else
					scoreboard:setFrame( 1 )
				end

				-- show the scoreboard and current score
				scoreboard.isVisible = true
				scoreGroup.y = screenH/2 - 33 - ones.y
				scoreGroup.x = -30

				-- show the high score
				setScore(highScore, highOnes, highTens, highHundreds)
				highscoreGroup.y = screenH/2 + 5
				highscoreGroup.x = -30
				highscoreGroup.isVisible = true
			end

			-- game over!
			Runtime:removeEventListener( "enterFrame", moveThePig )
		end
	end

	pigGroup.collision = onPigCollision
	pigGroup:addEventListener( "collision", pigGroup )

	pigGroup.x = origX
	pigGroup.y = origY
	Runtime:addEventListener( "enterFrame", moveThePig )

	local screenButton = display.newRect( 0, 0, screenW, screenH )
	screenButton.anchorX = 0
	screenButton.anchorY = 0
	screenButton:setFillColor( 1, 0.01 )
	screenButton:addEventListener( "touch", screenTouchListener )  --add a "touch" listener to the object
	
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