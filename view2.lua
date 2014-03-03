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

local isAndroid = system.getInfo( "platformName" ) == "Android"

local PIG_UPWARD_VELOCITY = -400
local ROTATION_RATIO = PIG_UPWARD_VELOCITY / -20
local FENCE_SPEED = 1
local CLOUD_SPEED = 0.3
local PITCHFORK_SPEED = 3
local ONE_OFFSET = 10 -- pixels offset for the "one" number

local currentScore = 0

local screenW, screenH = display.contentWidth, display.contentHeight

local Themes = {
	["Day"] = {
		["Colors"] = {
			["Sky"] = {
				r = 108/255,
				g = 233/255,
				b = 255/255
			},
			["Grass"] = {
				r = 51/255,
				g = 204/255,
				b = 102/255
			}
		}
	},
	["Night"] = {
		["Colors"] = {
			["Sky"] = {
				r = 16/255,
				g = 74/255,
				b = 183/255
			},
			["Grass"] = {
				r = 0/255,
				g = 142/255,
				b = 70/255
			}
		}
	}
}
local themeNames = {"Day", "Night"} -- kid cudi

-- initialization goes here (TODO: refactor)

local pigOptions = {
	width = 65,
	height = 44,
	numFrames = 4,
	sheetContentWidth = 260,
	sheetContentHeight = 44
}
local pigSheet = graphics.newImageSheet( "assets/pigs.png", pigOptions )
local pigSpriteOptions = { name="pig", start=1, count=4, time=250 }

-- Create a basic display group
local pigGroup = display.newGroup()
local deadPig = display.newImage( pigGroup, "assets/dead.png" )
local pig = display.newSprite( pigGroup, pigSheet, pigSpriteOptions )
pig:setFrame( 4 )
deadPig.isVisible = false

local origX = screenW / 4
local origY = screenH / 3

-- local pigShape = { 12,26, 26,10, 32,6, 32,-4, 16,-18, -6,-18, -16,-6, -10,16 }

local pitchforkOptions = {
    width = 54,
    height = 500,
    numFrames = 2,
    sheetContentWidth = 108, 
    sheetContentHeight = 500
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
local stars1, stars2, stars3

local flapSound = audio.loadSound( "assets/sounds/flap.mp3" )
-- local boingSound = audio.loadSound( "assets/sounds/boing.mp3" )
local oinkSound = audio.loadSound( "assets/sounds/oink.mp3" )
local coinSound = audio.loadSound( "assets/sounds/coin.mp3" )

-- numbers sprite
local options = { frames = require("numbers").frames, sheetContentWidth=250, sheetContentHeight=26 }
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
local scoreboardOptions = { frames = require("scoreboard").frames, sheetContentWidth=460, sheetContentHeight=171 }
local scoreboardSheet = graphics.newImageSheet( "assets/scoreboard.png", scoreboardOptions )
local scoreboardSpriteOptions = { name="scoreboard", start=1, count=2, time=500 }
local scoreboard = display.newSprite( scoreboardSheet, scoreboardSpriteOptions )
scoreboard.x, scoreboard.y = screenW/2, screenH/2 - 40
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
highscoreGroup.anchorX = 0
highscoreGroup.anchorY = 0
highscoreGroup.anchorChildren = true
highscoreGroup:insert( highOnes )
highscoreGroup:insert( highTens )
highscoreGroup:insert( highHundreds )

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
medals.x, medals.y = screenW/2 + 60, screenH/2 - 25
medals.isVisible = false

-- restart & share buttons
local playButton = display.newImage( "assets/btnPlay.png", 85, 380 )
playButton.isVisible = false
local shareButton = display.newImage( "assets/btnShare.png", 235, 380 )
shareButton.isVisible = false

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
tapToFly.x = screenW/2
tapToFly.y = screenH*2/3
tapToFly:play()

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

local bg, grass
local currentTheme = Themes.Day

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
	local colors = currentTheme.Colors
	
	-- create a white background to fill screen
	bg = display.newRect( 0, 0, screenW, screenH )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( colors.Sky.r, colors.Sky.g, colors.Sky.b )

	grass = display.newRect( 0, 470, screenW, 100 )
	grass.anchorX = 0
	grass.anchorY = 0
	grass:setFillColor( colors.Grass.r, colors.Grass.g, colors.Grass.b )

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
	clouds2.x = 400
	clouds2.y = 200

	clouds3 = display.newImage( "assets/clouds.png" )
	clouds3.anchorX = 0
	clouds3.anchorY = 0
	clouds3.x = 700
	clouds3.y = 50

	stars1 = display.newImage( "assets/stars.png" )
	stars1.anchorX = 0
	stars1.anchorY = 0
	stars1.x = 0
	stars1.y = 50

	stars2 = display.newImage( "assets/stars.png" )
	stars2.anchorX = 0
	stars2.anchorY = 0
	stars2.x = 150
	stars2.y = 25

	stars3 = display.newImage( "assets/stars.png" )
	stars3.anchorX = 0
	stars3.anchorY = 0
	stars3.x = 60
	stars3.y = 165

	stars1.isVisible = false
	stars2.isVisible = false
	stars3.isVisible = false

	group:insert( bg )
	group:insert( clouds1 )
	group:insert( clouds2 )
	group:insert( clouds3 )
	group:insert( stars1 )
	group:insert( stars2 )
	group:insert( stars3 )
	group:insert( fence1 )
	group:insert( fence2 )
	group:insert( fence3 )
	group:insert( pitchforkUp )
	group:insert( pitchforkDown )
	group:insert( pitchforkUp2 )
	group:insert( pitchforkDown2 )
	group:insert( grass )
	group:insert( tapToFly )

	physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	local started = false
	local gameOver = false

	local screenButton = display.newRect( 0, 0, screenW, screenH )
	screenButton.anchorX = 0
	screenButton.anchorY = 0
	screenButton:setFillColor( 1, 0.01 )

	physics.pause()

	local function resetPitchforks(upFork, downFork, startPos)
		downFork.x = startPos + screenW/2 + downFork.contentWidth
		upFork.x = downFork.x

		-- randomize the position
		downFork.y = math.random( -420, -220 ) -- 420 smoke a blunt
		upFork.y = downFork.y + 620
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
		if not started then
			return
		end

		-- move pitchforks
		pitchforkDown.x = pitchforkDown.x - PITCHFORK_SPEED
		pitchforkUp.x = pitchforkDown.x
		if ( pitchforkDown.x < 0 - pitchforkDown.contentWidth ) then
			resetPitchforks(pitchforkUp, pitchforkDown, pitchforkDown2.x)
		end

		pitchforkDown2.x = pitchforkDown2.x - PITCHFORK_SPEED
		pitchforkUp2.x = pitchforkDown2.x
		if ( pitchforkDown2.x < 0 - pitchforkDown2.contentWidth ) then
			resetPitchforks(pitchforkUp2, pitchforkDown2, pitchforkDown.x)
		end

		-- check for +1 score
		if ((pitchforkDown.x > origX-PITCHFORK_SPEED/2 and pitchforkDown.x <= origX+PITCHFORK_SPEED/2) or 
			(pitchforkDown2.x > origX-PITCHFORK_SPEED/2 and pitchforkDown2.x <= origX+PITCHFORK_SPEED/2)) then
			currentScore = math.min(999, currentScore + 1)
			setScore(currentScore, ones, tens, hundreds)
			audio.play( coinSound )
		end

		-- move fence
		fence1.x = fence1.x - FENCE_SPEED
		if ( fence1.x <= -fence1.width ) then
			fence1.x = fence1.width*2
		end
		fence2.x = fence2.x - FENCE_SPEED
		if ( fence2.x <= -fence1.width ) then
			fence2.x = fence2.width*2
		end
		fence3.x = fence3.x - FENCE_SPEED
		if ( fence3.x <= -fence1.width ) then
			fence3.x = fence3.width*2
		end

		-- move clouds
		clouds1.x = clouds1.x - CLOUD_SPEED
		if ( clouds1.x <= -clouds1.width ) then
			clouds1.x = clouds1.width*2
			clouds1.y = math.random( 50, 250 )
		end
		clouds2.x = clouds2.x - CLOUD_SPEED*2
		if ( clouds2.x <= -clouds2.width ) then
			clouds2.x = clouds2.width*2
			clouds2.y = math.random( 50, 250 )
		end
		clouds3.x = clouds3.x - CLOUD_SPEED*3
		if ( clouds3.x <= -clouds3.width ) then
			clouds3.x = clouds3.width*2
			clouds2.y = math.random( 50, 250 )
		end

		local vx, vy = pigGroup:getLinearVelocity()
		pigGroup.rotation = math.min( vy / ROTATION_RATIO - 10, 90 )

		if (pigGroup.y < 0) then
			pigGroup.y = 0
		end
		
	end

	local function shareButtonListener( event )
		-- local options = {
		-- 	service = "facebook",
		-- 	message = "Check out this photo!",
		-- 	listener = eventListener,
		-- 	image = {
		-- 		{ filename = "pic.jpg", baseDir = system.ResourceDirectory },
		-- 		{ filename = "pic2.jpg", baseDir = system.ResourceDirectory }
		-- 	},
		-- 	url = "http://coronalabs.com"
		-- }

		-- native.showPopup( "social", options )
	end

	-- local function playButtonListener( event )
	-- 	storyboard.purgeScene( "view2" )
	-- 	storyboard.gotoScene( "view1" )
	-- end

	local function screenTouchListener( event )
		if ( event.phase == "began" ) then
			if gameOver then
				gameOver = false
				resetPitchforks(pitchforkUp, pitchforkDown, screenW)
				resetPitchforks(pitchforkUp2, pitchforkDown2, pitchforkDown.x)
				currentScore = 0
				setScore(currentScore, ones, tens, hundreds)
				deadPig.isVisible = false
				pig.isVisible = true
				scoreGroup.anchorChildren = false
				scoreGroup.y = 0
				scoreGroup.x = 0
				scoreboard.isVisible = false
				highscoreGroup.isVisible = false
				medals.isVisible = false
				playButton.isVisible = false
				shareButton.isVisible = false
				storyboard.gotoScene( "view2" )
				tapToFly.isVisible = true
				pig:pause()
				pig:setFrame( 4 )
				pigGroup.rotation = 0
				-- pick random theme
				local newTheme = themeNames[ math.random( #themeNames ) ]
				currentTheme = Themes[ newTheme ]
				local colors = currentTheme.Colors
				bg:setFillColor( colors.Sky.r, colors.Sky.g, colors.Sky.b )
				grass:setFillColor( colors.Grass.r, colors.Grass.g, colors.Grass.b )
				local showClouds = (newTheme == "Day")
				local showStars = not showClouds
				stars1.isVisible, stars2.isVisible, stars3.isVisible = showStars, showStars, showStars
				clouds1.isVisible, clouds2.isVisible, clouds3.isVisible = showClouds, showClouds, showClouds
				return true
			end

			if started then
				if isAndroid then
					media.playSound( 'assets/sounds/flap.mp3' )
				else
					audio.play( flapSound )
				end
			else
				started = true
				physics.start()
				pig:play()
				tapToFly.isVisible = false
			end

			pigGroup:setLinearVelocity( 0, PIG_UPWARD_VELOCITY )
			
		end
		return true  --prevents touch propagation to underlying objects
	end

	local function onPigCollision( self, event )
		if ( event.phase == "began" ) then
			
			if not gameOver then

				gameOver = true
				started = false

				if isAndroid then
					media.playSound( 'assets/sounds/oink.mp3' )
				else
					audio.play( oinkSound )
				end
				
				-- swap out live pig for dead pig
				deadPig.isVisible = true
				pig.isVisible = false

				screenButton:removeEventListener( "touch", screenTouchListener )

				local function showScoreboard ()
					-- show the share/play buttons
					playButton.isVisible = true
					shareButton.isVisible = true
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
					scoreGroup.anchorX = 0
					scoreGroup.anchorY = 0
					scoreGroup.anchorChildren = true
					scoreGroup.y = screenH/2 - 37 - ones.y
					scoreGroup.x = 60
					if currentScore >= 100 and hundredsDigit ~= 1 then
						scoreGroup.x = scoreGroup.x + 2
					end
					if currentScore < 100 then
						scoreGroup.x = scoreGroup.x - NUMBER_WIDTH
					end
					if currentScore < 10 then
						scoreGroup.x = scoreGroup.x - NUMBER_WIDTH
					end

					

					-- show the high score
					setScore(highScore, highOnes, highTens, highHundreds)
					highscoreGroup.y = screenH/2 + 5
					highscoreGroup.x = 60
					highscoreGroup.isVisible = true
					if highScore >= 100 and hundredsDigit ~= 1 then
						highscoreGroup.x = highscoreGroup.x + 2
					end
					if highScore < 100 then
						highscoreGroup.x = highscoreGroup.x - NUMBER_WIDTH
					end
					if highScore < 10 then
						highscoreGroup.x = highscoreGroup.x - NUMBER_WIDTH
					end

					-- show the correct medal based on score
					medals:setFrame(math.min(5, math.max(1, math.ceil(currentScore/10))))
					medals.isVisible = true

					playButton:addEventListener( "touch", screenTouchListener )
					shareButton:addEventListener( "touch", shareButtonListener )
				end

				timer.performWithDelay( 1000, showScoreboard )
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

	screenButton:addEventListener( "touch", screenTouchListener )
	
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