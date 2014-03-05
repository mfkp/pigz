local R = {}

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

R.writeScore = writeScore

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

R.getScore = getScore

return R