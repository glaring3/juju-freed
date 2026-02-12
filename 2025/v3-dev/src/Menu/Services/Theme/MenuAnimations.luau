local Animation = require("@Shared/Utils/Animation")

local createStyle = Animation.createStyle

local MenuAnimations = {}

function MenuAnimations.init()
    -- Buttons
    
    createStyle("buttonHover", "quadOut", 0.11)
    createStyle("buttonLeave", "quadOut", 0.07)
    createStyle("buttonActivate", "quartOut", 0.16)
    createStyle("buttonDeactivate", "quadOut", 0.12)
    createStyle("tabSlide", "cubicOut", 0.09)
    createStyle("tabDrop", "backOut", 0.38)
    createStyle("sectionLine", "quartOut", 0.1)
    createStyle("elementSlide", "backOut", 0.28)
    createStyle("sliderSlide", "expoOut", 0.3)
    createStyle("secondaryDrop", "expoOut", 0.2)

end

return MenuAnimations