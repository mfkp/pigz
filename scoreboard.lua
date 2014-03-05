local S = {}

local constants = require( "constants" )
local numbers = require( "numbers" )

local scoreboardOptions = { frames = require("scoreboardFrames").frames, sheetContentWidth=460, sheetContentHeight=171 }
local scoreboardSheet = graphics.newImageSheet( "assets/scoreboard.png", scoreboardOptions )
local scoreboardSpriteOptions = { name="scoreboard", start=1, count=2, time=500 }
local scoreboard = display.newSprite( scoreboardSheet, scoreboardSpriteOptions )
scoreboard.x, scoreboard.y = constants.screenW/2, constants.screenH/2 - 40
scoreboard.isVisible = false

-- score group
local scoreGroup = display.newGroup()
scoreGroup:insert( numbers.ones )
scoreGroup:insert( numbers.tens )
scoreGroup:insert( numbers.hundreds )

-- highscore group
local highscoreGroup = display.newGroup()
highscoreGroup.anchorX = 0
highscoreGroup.anchorY = 0
highscoreGroup.anchorChildren = true
highscoreGroup:insert( numbers.highOnes )
highscoreGroup:insert( numbers.highTens )
highscoreGroup:insert( numbers.highHundreds )

-- restart & share buttons
local playButton = display.newImage( "assets/btnPlay.png", 85, 380 )
playButton.isVisible = false
local shareButton = display.newImage( "assets/btnShare.png", 235, 380 )
shareButton.isVisible = false

S.scoreboard = scoreboard
S.scoreGroup = scoreGroup
S.highscoreGroup = highscoreGroup
S.playButton = playButton
S.shareButton = shareButton

return S