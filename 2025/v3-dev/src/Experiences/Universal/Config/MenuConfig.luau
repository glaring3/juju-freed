local MenuConfig = {
    mainWindow = {
        subTitle = "Universal",
        tabs = {
            {
                title = "Ragebot",
                image = "Scope",
                sections = {
                    {
                        image = "Target",
                        title = "General",
                        subsections = {
                            {
                                title = "General",
                                elements = {
                                    {
                                        title = "Enable Ragebot",
                                        element = "Toggle",
                                        elementProperties = {
                                            defaultValue = false,
                                            text = "Enable Ragebot",
                                            flag = "ragebot_enabled",
                                        },
                                    } :: any,
                                    {
                                        title = "Strafe Speed",
                                        element = "Slider",
                                        elementProperties = {
                                            defaultValue = 30,
                                            text = "Strafe Speed",
                                            flag = "strafe_speed",
                                            minimumValue = 10,
                                            maximumValue = 100,
                                            valueSuffix = "%"
                                        },
                                    } :: any,
                                    {
                                        title = "Strafe Style",
                                        element = "Dropdown",
                                        elementProperties = {
                                            defaultValue = "Smart",
                                            text = "Strafe Style",
                                            flag = "strafe_style",
                                            minimumSelected = 1,
                                            maximumSelected = 1,
                                            options = {"Smart", "Basic"}
                                        },
                                    } :: any,
                                }
                            },
                            {
                                title = "Targetting",
                                elements = {

                                }
                            }
                        }
                    }
                }
            },
            {
                title = "Visuals",
                image = "Sunrise",
                sections = {
                    {
                        image = "Globe",
                        title = "World",
                        subsections = {
                            {
                                title = "World",
                                elements = {

                                }
                            },
                            {
                                title = "Effects",
                                elements = {

                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

return MenuConfig