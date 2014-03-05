local constants = require( "constants" )

local scoreboardOptions = { frames = require("scoreboardFrames").frames, sheetContentWidth=460, sheetContentHeight=171 }
local scoreboardSheet = graphics.newImageSheet( "assets/scoreboard.png", scoreboardOptions )
local scoreboardSpriteOptions = { name="scoreboard", start=1, count=2, time=500 }
local scoreboard = display.newSprite( scoreboardSheet, scoreboardSpriteOptions )
scoreboard.x, scoreboard.y = constants.screenW/2, constants.screenH/2 - 40
scoreboard.isVisible = false

return scoreboard