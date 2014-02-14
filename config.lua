application = {
	content = {
		width = 320,
		height = 320 * display.pixelHeight/display.pixelWidth,
        scale = "letterBox",
		fps = 60,
		

        imageSuffix = {
		    ["@2x"] = 2,
		}
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
