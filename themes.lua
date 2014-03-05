local R = {}

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
				r = 0/255,
				g = 52/255,
				b = 102/255
			},
			["Grass"] = {
				r = 0/255,
				g = 142/255,
				b = 70/255
			}
		}
	},
	["Sunset"] = {
		["Colors"] = {
			["Sky"] = {
				r = 241/255,
				g = 90/255,
				b = 36/255
			},
			["Grass"] = {
				r = 103/255,
				g = 204/255,
				b = 20/255
			}
		}
	}
}

R.Themes = Themes

local themeNames = {"Day", "Night", "Sunset"} -- kid cudi

R.themeNames = themeNames

return R