local P = {}

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
pitchforkDown.x = display.contentWidth
pitchforkDown.y = -300

local pitchforkUp = display.newImage( pitchforkSheet, 1 )
pitchforkUp.anchorX = 0
pitchforkUp.anchorY = 0
pitchforkUp.x = display.contentWidth
pitchforkUp.y = pitchforkDown.y + 620

local pitchforkDown2 = display.newImage( pitchforkSheet, 2 )
pitchforkDown2.anchorX = 0
pitchforkDown2.anchorY = 0
pitchforkDown2.x = pitchforkDown.x + (display.contentWidth / 2) + pitchforkDown2.contentWidth
pitchforkDown2.y = -300

local pitchforkUp2 = display.newImage( pitchforkSheet, 1 )
pitchforkUp2.anchorX = 0
pitchforkUp2.anchorY = 0
pitchforkUp2.x = pitchforkDown2.x
pitchforkUp2.y = pitchforkDown2.y + 620

P.Down = pitchforkDown
P.Up = pitchforkUp
P.Down2 = pitchforkDown2
P.Up2 = pitchforkUp2

return P