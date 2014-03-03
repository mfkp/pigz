local R = {}
 
 
local AppleURL
local AndroidURL
 
local setiTunesURL = function (id)
 
                AppleURL = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa"
                AppleURL = AppleURL .. "/wa/viewContentsUserReviews?"
                AppleURL = AppleURL .. "type=Purple+Software&id="
                AppleURL = AppleURL .. id
                
end
 
R.setiTunesURL = setiTunesURL
 
local setAndroidURL = function (id)
        
                AndroidURL = "market://details?id="
                AndroidURL = AndroidURL .. id
end
 
R.setAndroidURL = setAndroidURL
 
local openURL = function ()
        local platform = system.getInfo("platformName")
        
        if platform == "iPhone OS" then
                system.openURL(AppleURL)
        elseif platform == "Android" then
                system.openURL(AndroidURL)
        end
end
 
R.openURL = openURL
 
return R