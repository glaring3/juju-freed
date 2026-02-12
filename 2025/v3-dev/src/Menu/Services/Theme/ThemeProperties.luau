local color3FromRGB = Color3.fromRGB

type PropertyDefinition = {string | Color3}
type ThemePropertiesType = {[string]: PropertyDefinition}

local ThemeProperties: ThemePropertiesType = {
    -- Window Styles

    WindowBorder = {"Color", color3FromRGB(30, 30, 35)},
    WindowShadow = {"ImageColor3", color3FromRGB(0, 0, 0)},
    WindowBackground = {"BackgroundColor3", color3FromRGB(19, 19, 23)},
    WindowTopDivider = {"BackgroundColor3", color3FromRGB(30, 30, 36)},
    WindowSubTitle = {"TextColor3", color3FromRGB(154, 154, 165)},
    WindowTitle = {"TextColor3", color3FromRGB(220, 220, 245)},
    WindowHeaderDivider = {"BackgroundColor3", color3FromRGB(70, 70, 78)},
    WindowHeaderBorder = {"BackgroundColor3", color3FromRGB(70, 70, 85)},
    WindowHeaderBackground = {"BackgroundColor3", color3FromRGB(50, 50, 62)},
    WindowRightHeaderBorder = {"Color", color3FromRGB(35, 35, 42)},
    WindowRightHeaderBackground = {"BackgroundColor3", color3FromRGB(23, 23, 29)},

    -- Tab Button Styles
    TabButtonBackground = {"BackgroundColor3", color3FromRGB(50, 50, 62)},
    TabButtonBorder = {"Color", color3FromRGB(70, 70, 85)},
    TabButtonImageSelected = {"ImageColor3", color3FromRGB(130, 130, 144)},
    TabButtonImageUnselected = {"ImageColor3", color3FromRGB(49, 49, 57)},
    TabButtonTextSelected = {"TextColor3", color3FromRGB(220, 220, 245)},
    TabButtonTextUnselected = {"TextColor3", color3FromRGB(61, 61, 71)},
    TabButtonTextHover = {"TextColor3", color3FromRGB(200, 200, 220)},
    TabButtonImageHover = {"ImageColor3", color3FromRGB(100, 100, 112)},
    TabButtonSlideBackground = {"BackgroundColor3", color3FromRGB(50, 50, 62)},
    TabButtonSlideBorder = {"Color", color3FromRGB(70, 70, 85)},

    -- Section Styles

    SectionBorder = {"BackgroundColor3", color3FromRGB(35, 35, 42)},
    SectionBackground = {"BackgroundColor3", color3FromRGB(21, 21, 24)},
    SectionHeaderBackground = {"BackgroundColor3", color3FromRGB(26, 26, 31)},
    SectionHeaderTextSelected = {"TextColor3", color3FromRGB(194, 194, 207)},
    SectionHeaderTextUnselected = {"TextColor3", color3FromRGB(110, 110, 117)},
    SectionHeaderTextHover = {"TextColor3", color3FromRGB(150, 150, 160)},
    SectionHeaderLine = {"BackgroundColor3", color3FromRGB(168, 168, 180)},
    SectionHeaderImage = {"ImageColor3", color3FromRGB(168, 168, 180)},

    -- Element Styles

    ElementTextUnselected = {"TextColor3", color3FromRGB(80, 80, 85)},
    ElementTextHover = {"TextColor3", color3FromRGB(150, 150, 160)},
    ElementTextSelectedHover = {"TextColor3", color3FromRGB(166, 166, 188)},
    ElementTextSelected = {"TextColor3", color3FromRGB(216, 216, 235)},
    ElementBackgroundSelected = {"BackgroundColor3", color3FromRGB(95, 95, 113)},
    ElementBackgroundUnselected = {"BackgroundColor3", color3FromRGB(29, 29, 34)},
    ElementBorderUnselected = {"Color", color3FromRGB(37, 37, 43)},
    ElementBorderSelected = {"Color", color3FromRGB(113, 113, 134)},
    ElementBorderHover = {"Color", color3FromRGB(42, 42, 49)},
    
    -- Toggle Styles

    ToggleCircleSelected = {"BackgroundColor3", color3FromRGB(184, 184, 212)},
    ToggleCircleUnselected = {"BackgroundColor3", color3FromRGB(59, 59, 68)},
    ToggleCircleBorderSelected = {"Color", color3FromRGB(114, 114, 132)},
    ToggleCircleBorderUnselected = {"Color", color3FromRGB(43, 43, 50)},
    
    -- Slider Styles

    SliderBarFill = {"BackgroundColor3", color3FromRGB(95, 95, 113)},
    SliderBarFillBorder = {"Color", color3FromRGB(113, 113, 134)},

    SliderCircleHover = {"BackgroundColor3", color3FromRGB(121, 121, 144)},
    SliderCircleSelected = {"BackgroundColor3", color3FromRGB(184, 184, 212)},
    SliderCircleUnselected = {"BackgroundColor3", color3FromRGB(59, 59, 68)},
    SliderCircleBorderSelected = {"Color", color3FromRGB(114, 114, 132)},
    SliderCircleBorderUnselected = {"Color", color3FromRGB(43, 43, 50)},
    
    SliderValueBoxBackgroundSelected = {"BackgroundColor3", color3FromRGB(95, 95, 113)},
    SliderValueBoxBackgroundUnselected = {"BackgroundColor3", color3FromRGB(29, 29, 34)},
    SliderValueBoxBorderSelected = {"Color", color3FromRGB(115, 115, 136)},
    SliderValueBoxBorderUnselected = {"Color", color3FromRGB(37, 37, 43)},
    SliderValueTextUnselected = {"TextColor3", color3FromRGB(69, 69, 81)},
    SliderValueTextSelected = {"TextColor3", color3FromRGB(198, 198, 221)},

    -- Dropdown Styles

    DropdownBoxTextUnselected = {"TextColor3", color3FromRGB(69, 69, 81)},
    DropdownBoxTextSelected = {"TextColor3", color3FromRGB(198, 198, 221)},
    DropdownDividerUnselected = {"BackgroundColor3", color3FromRGB(37, 37, 43)},
    DropdownDividerSelected = {"BackgroundColor3", color3FromRGB(116, 116, 134)},
    DropdownImageUnselected = {"ImageColor3", color3FromRGB(59, 59, 68)},
    DropdownImageSelected = {"ImageColor3", color3FromRGB(184, 184, 212)},
    DropdownOptionTextSelected = {"TextColor3", color3FromRGB(195, 195, 213)},
    DropdownOptionTextUnselected = {"TextColor3", color3FromRGB(83, 83, 89)},
    DropdownOptionTextHover = {"TextColor3", color3FromRGB(150, 150, 160)},
    DropdownOptionImage = {"ImageColor3", color3FromRGB(216, 216, 235)},
    DropdownOptionDivider = {"BackgroundColor3", color3FromRGB(54, 54, 63)},
    DropdownOptionBackground = {"BackgroundColor3", color3FromRGB(33, 33, 39)},
    DropdownOptionBorder = {"Color", color3FromRGB(46, 46, 54)},
    DropdownOptionScrollBar = {"ScrollbarImageColor3", color3FromRGB(129, 129, 150)}
}

return ThemeProperties