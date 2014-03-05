local N = {}

local constants = require( "constants" )

-- numbers sprite
local options = { frames = require("numberFrames").frames, sheetContentWidth=250, sheetContentHeight=26 }
local numbersSheet = graphics.newImageSheet( "assets/numbers.png", options )
local spriteOptions = { name="numbers", start=1, count=10, time=1000 }
local ones = display.newSprite( numbersSheet, spriteOptions )
local tens = display.newSprite( numbersSheet, spriteOptions )
local hundreds = display.newSprite( numbersSheet, spriteOptions )
hundreds.anchorX, hundreds.anchorY, tens.anchorX, tens.anchorY, ones.anchorX, ones.anchorY = 0, 0, 0, 0, 0, 0
tens.isVisible = false
hundreds.isVisible = false
ones.y, tens.y, hundreds.y = 20, 20, 20
local onesPos = constants.screenW/2 - constants.NUMBER_WIDTH*1 + constants.NUMBER_WIDTH/2
local tensPos = constants.screenW/2 - constants.NUMBER_WIDTH*2 + constants.NUMBER_WIDTH/2
local hundredsPos =  constants.screenW/2 - constants.NUMBER_WIDTH*3 + constants.NUMBER_WIDTH/2
hundreds.x = hundredsPos
tens.x = tensPos
ones.x = onesPos

-- high score numbers sprite
local highOnes = display.newSprite( numbersSheet, spriteOptions )
local highTens = display.newSprite( numbersSheet, spriteOptions )
local highHundreds = display.newSprite( numbersSheet, spriteOptions )
highHundreds.anchorX, highHundreds.anchorY, highTens.anchorX, highTens.anchorY, highOnes.anchorX, highOnes.anchorY = 0, 0, 0, 0, 0, 0
highOnes.isVisible = false
highTens.isVisible = false
highHundreds.isVisible = false
highOnes.y, highTens.y, highHundreds.y = ones.y, tens.y, hundreds.y
highHundreds.x, highTens.x, highOnes.x = ones.x, tens.x, hundreds.x

N.ones = ones
N.tens = tens
N.hundreds = hundreds

N.highOnes = highOnes
N.highTens = highTens
N.highHundreds = highHundreds

N.onesPos = onesPos
N.tensPos = tensPos
N.hundredsPos = hundredsPos

return N