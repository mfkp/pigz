-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------
-- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local themes = require( "themes" )
local score = require( "score" )
local constants = require( "constants" )
local pitchfork = require( "pitchfork" )
local sounds = require( "sounds" )
local pigstuff = require( "pigstuff" )
local numbers = require( "numbers" )
local scoreboard = require( "scoreboard" )
local medals = require( "medals" )
local static = require( "static" )

local physics = require( "physics" )
physics.setScale( 90 )
-- physics.setDrawMode( "hybrid" )
physics.start()
physics.setGravity( 0, 15 )

physics.addBody( pitchfork.Down, "static", { friction=1, bounce=0.6 } )
physics.addBody( pitchfork.Up, "static", { friction=1, bounce=0.6 } )
physics.addBody( pitchfork.Down2, "static", { friction=1, bounce=0.6 } )
physics.addBody( pitchfork.Up2, "static", { friction=1, bounce=0.6 } )
physics.addBody( pigstuff.pigGroup, "dynamic", { radius=20, density=1.0, friction=1, bounce=0.4 } )

local currentScore = 0

-- restart & share buttons
local playButton = display.newImage( "assets/btnPlay.png", 85, 380 )
playButton.isVisible = false
local shareButton = display.newImage( "assets/btnShare.png", 235, 380 )
shareButton.isVisible = false

local currentTheme = themes.Themes.Day

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

	group:insert( static.bg )
	group:insert( static.clouds1 )
	group:insert( static.clouds2 )
	group:insert( static.clouds3 )
	group:insert( static.stars1 )
	group:insert( static.stars2 )
	group:insert( static.stars3 )
	group:insert( static.fence1 )
	group:insert( static.fence2 )
	group:insert( static.fence3 )
	group:insert( pitchfork.Up )
	group:insert( pitchfork.Down )
	group:insert( pitchfork.Up2 )
	group:insert( pitchfork.Down2 )
	group:insert( static.grass )
	group:insert( static.tapToFly )

	physics.addBody( static.grass, "static", { friction=0.5, bounce=0.3 } )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	local started = false
	local gameOver = false

	local screenButton = display.newRect( 0, 0, constants.screenW, constants.screenH )
	screenButton.anchorX = 0
	screenButton.anchorY = 0
	screenButton:setFillColor( 1, 0.01 )

	physics.pause()

	local function resetPitchforks(upFork, downFork, startPos)
		downFork.x = startPos + constants.screenW/2 + downFork.contentWidth
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
		ones.x = 		numbers.onesPos + 
						((score >= 10) and constants.NUMBER_WIDTH/2 or 0) + 
						((score >= 100) and constants.NUMBER_WIDTH/2 or 0)
		tens.x = 		numbers.tensPos + 
						((tensDigit == 1) and constants.ONE_OFFSET or 0) + 
						((score >= 10) and constants.NUMBER_WIDTH/2 or 0) + 
						((score >= 100) and constants.NUMBER_WIDTH/2 or 0)
		hundreds.x = 	numbers.hundredsPos + 
						((hundredsDigit == 1) and constants.ONE_OFFSET or 0) + 
						((tensDigit == 1) and constants.ONE_OFFSET or 0) + 
						((score >= 10) and constants.NUMBER_WIDTH/2 or 0) + 
						((score >= 100) and constants.NUMBER_WIDTH/2 or 0)
	end

	local function moveThePig()
		if not started then
			return
		end

		-- move pitchforks
		pitchfork.Down.x = pitchfork.Down.x - constants.PITCHFORK_SPEED
		pitchfork.Up.x = pitchfork.Down.x
		if ( pitchfork.Down.x < 0 - pitchfork.Down.contentWidth ) then
			resetPitchforks(pitchfork.Up, pitchfork.Down, pitchfork.Down2.x)
		end

		pitchfork.Down2.x = pitchfork.Down2.x - constants.PITCHFORK_SPEED
		pitchfork.Up2.x = pitchfork.Down2.x
		if ( pitchfork.Down2.x < 0 - pitchfork.Down2.contentWidth ) then
			resetPitchforks(pitchfork.Up2, pitchfork.Down2, pitchfork.Down.x)
		end

		-- check for +1 score
		if ((pitchfork.Down.x > constants.origX-constants.PITCHFORK_SPEED/2 and pitchfork.Down.x <= constants.origX+constants.PITCHFORK_SPEED/2) or 
			(pitchfork.Down2.x > constants.origX-constants.PITCHFORK_SPEED/2 and pitchfork.Down2.x <= constants.origX+constants.PITCHFORK_SPEED/2)) then
			currentScore = math.min(999, currentScore + 1)
			setScore(currentScore, numbers.ones, numbers.tens, numbers.hundreds)
			audio.play( sounds.coinSound )
		end

		-- move fence
		static.fence1.x = static.fence1.x - constants.FENCE_SPEED
		if ( static.fence1.x <= -static.fence1.width ) then
			static.fence1.x = static.fence1.width*2
		end
		static.fence2.x = static.fence2.x - constants.FENCE_SPEED
		if ( static.fence2.x <= -static.fence1.width ) then
			static.fence2.x = static.fence2.width*2
		end
		static.fence3.x = static.fence3.x - constants.FENCE_SPEED
		if ( static.fence3.x <= -static.fence1.width ) then
			static.fence3.x = static.fence3.width*2
		end

		-- move clouds
		static.clouds1.x = static.clouds1.x - constants.CLOUD_SPEED
		if ( static.clouds1.x <= -static.clouds1.width ) then
			static.clouds1.x = constants.screenW
			static.clouds1.y = math.random( 50, 250 )
		end
		static.clouds2.x = static.clouds2.x - constants.CLOUD_SPEED*2
		if ( static.clouds2.x <= -static.clouds2.width ) then
			static.clouds2.x = constants.screenW
			static.clouds2.y = math.random( 50, 250 )
		end
		static.clouds3.x = static.clouds3.x - constants.CLOUD_SPEED*3
		if ( static.clouds3.x <= -static.clouds3.width ) then
			static.clouds3.x = constants.screenW
			static.clouds2.y = math.random( 50, 250 )
		end

		local vx, vy = pigstuff.pigGroup:getLinearVelocity()
		pigstuff.pigGroup.rotation = math.min( vy / constants.ROTATION_RATIO - 10, 90 )

		if (pigstuff.pigGroup.y < 0) then
			pigstuff.pigGroup.y = 0
		end
		
	end

	local function screenTouchListener( event )
		if ( event.phase == "began" ) then
			if gameOver then
				gameOver = false
				resetPitchforks(pitchfork.Up, pitchfork.Down, constants.screenW)
				resetPitchforks(pitchfork.Up2, pitchfork.Down2, pitchfork.Down.x)
				currentScore = 0
				setScore(currentScore, numbers.ones, numbers.tens, numbers.hundreds)
				pigstuff.deadPig.isVisible = false
				pigstuff.pig.isVisible = true
				scoreboard.scoreGroup.anchorChildren = false
				scoreboard.scoreGroup.y = 0
				scoreboard.scoreGroup.x = 0
				scoreboard.scoreboard.isVisible = false
				scoreboard.highscoreGroup.isVisible = false
				medals.isVisible = false
				playButton.isVisible = false
				shareButton.isVisible = false
				storyboard.gotoScene( "view2" )
				static.tapToFly.isVisible = true
				pigstuff.pig:pause()
				pigstuff.pig:setFrame( 4 )
				pigstuff.pigGroup.rotation = 0
				-- pick random theme
				local newTheme = themes.themeNames[ math.random( #themes.themeNames ) ]
				currentTheme = themes.Themes[ newTheme ]
				local colors = currentTheme.Colors
				static.bg:setFillColor( colors.Sky.r, colors.Sky.g, colors.Sky.b )
				static.grass:setFillColor( colors.Grass.r, colors.Grass.g, colors.Grass.b )
				local showClouds = (newTheme ~= "Night")
				local showStars = not showClouds
				static.stars1.isVisible, static.stars2.isVisible, static.stars3.isVisible = showStars, showStars, showStars
				static.clouds1.isVisible, static.clouds2.isVisible, static.clouds3.isVisible = showClouds, showClouds, showClouds
				return true
			end

			if started then
				if constants.isAndroid then
					media.playSound( sounds.flapPath )
				else
					audio.play( sounds.flapSound )
				end
			else
				started = true
				physics.start()
				pigstuff.pig:play()
				static.tapToFly.isVisible = false
			end

			pigstuff.pigGroup:setLinearVelocity( 0, constants.PIG_UPWARD_VELOCITY )
			
		end
		return true  --prevents touch propagation to underlying objects
	end

	local function onPigCollision( self, event )
		if ( event.phase == "began" ) then
			
			if not gameOver then

				gameOver = true
				started = false

				if constants.isAndroid then
					media.playSound( sounds.oinkPath )
				else
					audio.play( sounds.oinkSound )
				end
				
				-- swap out live pigstuff.pig for dead pigstuff.pig
				pigstuff.deadPig.isVisible = true
				pigstuff.pig.isVisible = false

				screenButton:removeEventListener( "touch", screenTouchListener )

				local function showScoreboard ()
					-- show the share/play buttons
					playButton.isVisible = true
					shareButton.isVisible = true
					-- check for high score, set it if high #420
					local highScore = score.getScore()
					if currentScore > highScore then
						score.writeScore(currentScore)
						highScore = currentScore
						scoreboard.scoreboard:setFrame( 2 )
					else
						scoreboard.scoreboard:setFrame( 1 )
					end

					-- show the scoreboard and current score
					scoreboard.scoreboard.isVisible = true
					scoreboard.scoreGroup.anchorX = 0
					scoreboard.scoreGroup.anchorY = 0
					scoreboard.scoreGroup.anchorChildren = true
					scoreboard.scoreGroup.y = constants.screenH/2 - 37 - numbers.ones.y
					scoreboard.scoreGroup.x = 60
					if currentScore >= 100 and hundredsDigit ~= 1 then
						scoreboard.scoreGroup.x = scoreboard.scoreGroup.x + 2
					end
					if currentScore < 100 then
						scoreboard.scoreGroup.x = scoreboard.scoreGroup.x - constants.NUMBER_WIDTH
					end
					if currentScore < 10 then
						scoreboard.scoreGroup.x = scoreboard.scoreGroup.x - constants.NUMBER_WIDTH
					end

					

					-- show the high score
					setScore(highScore, numbers.highOnes, numbers.highTens, numbers.highHundreds)
					scoreboard.highscoreGroup.y = constants.screenH/2 + 5
					scoreboard.highscoreGroup.x = 60
					scoreboard.highscoreGroup.isVisible = true
					if highScore >= 100 and hundredsDigit ~= 1 then
						scoreboard.highscoreGroup.x = scoreboard.highscoreGroup.x + 2
					end
					if highScore < 100 then
						scoreboard.highscoreGroup.x = scoreboard.highscoreGroup.x - constants.NUMBER_WIDTH
					end
					if highScore < 10 then
						scoreboard.highscoreGroup.x = scoreboard.highscoreGroup.x - constants.NUMBER_WIDTH
					end

					-- show the correct medal based on score
					medals:setFrame(math.min(5, math.max(1, math.ceil(currentScore/10))))
					medals.isVisible = true

					playButton:addEventListener( "touch", screenTouchListener )
				end

				timer.performWithDelay( 1000, showScoreboard )
			end

			-- game over!
			Runtime:removeEventListener( "enterFrame", moveThePig )

		end
	end

	pigstuff.pigGroup.collision = onPigCollision
	pigstuff.pigGroup:addEventListener( "collision", pigstuff.pigGroup )

	pigstuff.pigGroup.x = constants.origX
	pigstuff.pigGroup.y = constants.origY
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