local R = {}

R.isAndroid = system.getInfo( "platformName" ) == "Android"
R.screenW = display.contentWidth
R.screenH = display.contentHeight
R.origX = R.screenW / 4
R.origY = R.screenH / 3

R.PIG_UPWARD_VELOCITY = -400
R.ROTATION_RATIO = R.PIG_UPWARD_VELOCITY / -20
R.FENCE_SPEED = 1
R.CLOUD_SPEED = 0.3
R.PITCHFORK_SPEED = 3
R.NUMBER_WIDTH = 26
R.ONE_OFFSET = 10 -- pixels offset for the "one" number

return R